<template>
  <div class="box">
    <form method="post" action="#">
      <div class="row gtr-uniform gtr-50">
        <div class="col-12">
          <textarea
            id="message"
            v-model.trim="urls"
            placeholder="多订阅链接或节点请确保每行一条，支持手动使用|分割多链接或节点"
            rows="3"
          ></textarea>
        </div>
        <div
          class="col-5 col-12-mobilep list"
          style="text-align: center; padding-top: 20px"
        >
          <select v-model="targetType" @change="selectTarget($event)">
            <option
              v-for="option in targetTypes"
              :key="option"
              :value="option.value"
            >
              {{ option.text }}
            </option>
          </select>
        </div>
        <div
          class="col-5 col-8-mobilep list"
          style="text-align: center; padding-top: 20px"
        >
          <select id="selectApi" v-model="api" @change="selectApi($event)">
            <option v-for="option in apis" :key="option" :value="option.value">
              {{ option.text }}
            </option>
          </select>
        </div>
        <div
          class="col-2 col-4-mobilep"
          style="text-align: center; padding-top: 20px"
        >
          <ul class="actions">
            <li>
              <input
                type="button"
                value="配置"
                class="alt"
                @click="showMoreConfig()"
              />
            </li>
          </ul>
        </div>
        <div
          v-show="isShowManualApiUrl"
          class="col-12"
          style="text-align: center; padding-top: 20px"
        >
          <input
            v-model="manualApiUrl"
            type="text"
            placeholder="示例：https://sub.gclmit.club"
          />
        </div>
        <div
          v-show="isShowMoreConfig"
          class="col-12"
          style="text-align: center; padding-top: 0px"
        >
          <div class="col-12" style="text-align: center; padding-top: 20px">
            <input
              type="text"
              :placeholder="'Include：可选'"
              v-model="moreConfig.include"
            />
          </div>
          <div class="col-12" style="text-align: center; padding-top: 20px">
            <input
              type="text"
              :placeholder="'Exclude：可选'"
              v-model="moreConfig.exclude"
            />
          </div>
          <div class="col-12" style="text-align: center; padding-top: 20px">
            <select
              id="selectRemoteConfig"
              v-model="remoteConfig"
              @change="selectRemoteConfig($event)"
            >
              <option
                v-for="option in remoteConfigs"
                :key="option"
                :value="option.url"
              >
                {{ option.title }}
              </option>
            </select>
            <div
              v-show="isShowManualRemoteConfig"
              class="col-12"
              style="text-align: center; padding-top: 20px"
            >
              <input
                v-model="manualRemoteConfig"
                type="text"
                placeholder="请输入远程配置地址"
              />
            </div>
          </div>
          <div
            class="col-12 col-12-narrower"
            style="text-align: center; padding-top: 20px"
          >
            <input type="checkbox" id="emoji" v-model="moreConfig.emoji" />
            <label for="emoji">Emoji</label>
            <input type="checkbox" id="udp" v-model="moreConfig.udp" />
            <label for="udp">开启UDP</label>
            <input type="checkbox" id="sort" v-model="moreConfig.sort" />
            <label for="sort">排序节点</label>
            <input type="checkbox" id="scv" v-model="moreConfig.scv" />
            <label for="scv">关闭证书检查</label>
            <input type="checkbox" id="nodelist" v-model="moreConfig.list" />
            <label for="nodelist">Node List</label>
          </div>
        </div>
        <div
          class="col-10 col-8-mobilep"
          style="text-align: center; padding-top: 20px"
        >
          <input
            type="text"
            readOnly="true"
            placeholder="订阅链接链接地址"
            v-model.trim="returnUrl"
          />
        </div>
        <div
          class="col-2 col-4-mobilep"
          style="text-align: center; padding-top: 20px"
        >
          <ul class="actions">
            <li>
              <input type="button" value="复制" @click="copySubUrl()" />
            </li>
          </ul>
        </div>
        <div
          class="col-2  col-3-mobilep"
          style="text-align: center; padding-top: 20px"
        >
          <ul class="actions">
            <li>
              <input type="button" value="解析订阅链接" @click="dialogLoadConfigVisible = true" />
            </li>
          </ul>
        </div>
        <div
          class="col-2 off-2 col-3-mobilep"
          style="text-align: center; padding-top: 20px"
        >
          <ul class="actions">
            <li>
              <input type="button" value="生成订阅链接" @click="getSubUrl()" />
            </li>
          </ul>
        </div>
        <div
          class="col-2 off-2 col-3-mobilep"
          style="text-align: center; padding-top: 20px"
        >
          <ul class="actions">
            <li>
              <input
                type="button"
                value="一键导入Clash"
                @click="importClash()"
              />
            </li>
          </ul>
        </div>
      </div>
    </form>
    <el-dialog v-model="dialogLoadConfigVisible" title="订阅链接解析" width="500">
      <el-form label-position="left">
        <el-form-item prop="uploadConfig">
          <el-input
            v-model="analyzeSubUrlUrl"
            type="textarea"
            :autosize="{ minRows: 15, maxRows: 15}"
            maxlength="5000"
            show-word-limit
          ></el-input>
        </el-form-item>
      </el-form>
      <template #footer>
        <div class="dialog-footer">
          <el-button @click="analyzeSubUrlUrl = ''; dialogLoadConfigVisible = false">取消</el-button>
          <el-button type="primary" :disabled="analyzeSubUrlUrl.length === 0" @click="parseSubUrl()">
            确 定
          </el-button>
        </div>
      </template>
    </el-dialog>
  </div>
</template>

<script>
import links from "@/utils/links.js";
import dialogOut from "components/common/dialog";


export default {
  name: "HomeForm",
  setup() {
    const ENV = {
      DEFAULT_MORE_CONFIG: {
        include: "",
        exclude: "",
        remoteConfig: "",
        emoji: true,
        udp: true,
        sort: false,
        scv: false,
        list: false
      }
    };
    return {
      ENV
    };
  },
  data() {
    return {
      moreConfig: {},
      isShowMoreConfig: false,
      dialogLoadConfigVisible: false,
      analyzeSubUrlUrl: "",
      urls: "",
      returnUrl: "",
      returnShortUrl: "",
      apiUrl: window.config.apiUrl,
      shortUrl: window.config.shortUrl,
      manualApiUrl: "",
      isShowManualApiUrl: false,
      api: "default",
      apis: [
        { value: "default", text: window.config.apiUrl },
        { value: "manual", text: "自定义后端 API 地址" }
      ],
      manualRemoteConfig: "",
      isShowManualRemoteConfig: false,
      remoteConfig: window.config.remoteConfigList[0].url,
      remoteConfigs: window.config.remoteConfigList,
      targetType: "clash",
      targetTypes: [
        { value: "clash", text: "Clash" },
        { value: "clashr", text: "ClashR" },
        { value: "v2ray", text: "V2Ray" },
        { value: "quan", text: "Quantumult" },
        { value: "quanx", text: "Quantumult X" },
        { value: "surge&ver=2", text: "SurgeV2" },
        { value: "surge&ver=3", text: "SurgeV3" },
        { value: "surge&ver=4", text: "SurgeV4" },
        { value: "surfboard", text: "Surfboard" },
        { value: "ss", text: "SS (SIP002)" },
        { value: "sssub", text: "SS Android" },
        { value: "ssd", text: "SSD" },
        { value: "ssr", text: "SSR" },
        { value: "loon", text: "Loon" }
      ]
    };
  },
  created() {
    this.moreConfig = this.ENV.DEFAULT_MORE_CONFIG;
  },
  methods: {
    showMoreConfig() {
      this.isShowMoreConfig = !this.isShowMoreConfig;
    },
    showDialog(Msg) {
      dialogOut(this, Msg);
    },
    selectApi(event) {
      this.isShowManualApiUrl = event.target.value === "manual";
    },
    selectRemoteConfig(event) {
      this.isShowManualRemoteConfig = event.target.value === "manual";
    },
    selectTarget(event) {
      this.targetType = event.target.value;
    },
    toCopy(url, title) {
      if (!url) {
        this.showDialog("复制失败 内容为空");
      } else {
        let copyInput = document.createElement("input");
        copyInput.setAttribute("value", url);
        document.body.appendChild(copyInput);
        copyInput.select();
        try {
          let copyed = document.execCommand("copy");
          if (copyed) {
            document.body.removeChild(copyInput);
            this.showDialog(title + " 复制成功");
          }
        } catch {
          this.showDialog("复制失败 请检查浏览器兼容");
        }
      }
    },
    parseSubUrl() {
      if (this.analyzeSubUrlUrl.trim() === "" || !this.analyzeSubUrlUrl.trim().includes("http")) {
        this.showDialog("待解析的订阅链接不合法");
        return false;
      }
      (async () => {
        let url;
        try {
          url = new URL(this.analyzeSubUrlUrl);
        } catch (error) {
          this.showDialog("请输入正确的订阅地址!");
          return;
        }
        let param = new URLSearchParams(url.search);
        if (param.get("url")) {
          this.urls = param.get("url");
        }
        if (param.get("exclude")) {
          this.moreConfig.exclude = param.get("exclude");
        }
        if (param.get("include")) {
          this.moreConfig.include = param.get("include");
        }
        this.dialogLoadConfigVisible = false;
        this.isShowMoreConfig = true;
        this.showDialog("长/短链接已成功解析为订阅信息");
      })();
    },
    checkApi() {
      let apiSelect = document.getElementById("selectApi");
      let i = apiSelect.selectedIndex;
      if (apiSelect.options[i].value === "manual") {
        this.apiUrl = this.manualApiUrl;
        if (!links.regexCheck(this.apiUrl)) {
          this.showDialog("请填写正确的 API 地址");
          return false;
        } else if (this.apiUrl.split("").slice(-1) === "/") {
          this.apiUrl = this.apiUrl.substr(0, this.apiUrl.length - 1);
          return true;
        } else {
          return true;
        }
      } else {
        this.apiUrl = apiSelect.options[i].text;
        return true;
      }
    },
    checkRemoteConfig() {
      let remoteConfigSelect = document.getElementById("selectRemoteConfig");
      let i = remoteConfigSelect.selectedIndex;
      // console.log("checkRemoteConfig1",remoteConfigSelect);
      // console.log("checkRemoteConfig2",remoteConfigSelect.options[i]);
      if (remoteConfigSelect.options[i].value === "manual") {
        this.moreConfig.remoteConfig = this.manualRemoteConfig;
        if (!links.regexCheck(this.moreConfig.remoteConfig)) {
          this.showDialog("请填写正确的 远程配置 地址");
          return false;
        } else {
          return true;
        }
      } else {
        this.moreConfig.remoteConfig = remoteConfigSelect.options[i].value;
        return true;
      }
    },
    getFinalUrl() {
      this.returnUrl = links.getSubLink(
        this.urls,
        this.apiUrl,
        this.targetType,
        this.isShowMoreConfig,
        this.moreConfig
      );
    },
    getSubUrl() {
      if (this.urls === "") {
        this.showDialog("请填写正确的订阅地址");
        return false;
      }
      // console.log("xxxx",this.checkApi(),this.checkRemoteConfig());
      if (this.checkApi() && this.checkRemoteConfig()) {
        this.getFinalUrl();
      }
    },
    copySubUrl() {
      if (this.returnUrl === "") {
        this.showDialog("请先填写必填项，生成订阅链接");
      } else {
        this.toCopy(this.returnUrl, "订阅链接");
      }
    },
    importClash() {
      if (this.returnUrl === "") {
        this.showDialog("请先填写必填项，生成订阅链接");
        return false;
      } else {
        const url = "clash://install-config?url=";
        window.open(url + encodeURIComponent(this.returnUrl));
      }
    }
  }
};
</script>
