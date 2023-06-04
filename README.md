# subconverter

## 简介
该项目是subconverter项目一站式服务项目，包括后台subconverter服务和提供了一个前端UI界面，方便用户快速生成各平台的订阅链接.

[![GitHub license](https://img.shields.io/github/license/gclm/subconverter?style=plastic)](https://github.com/gclm/nas-tools/blob/master/LICENSE.md)
[![Platform](https://img.shields.io/badge/platform-amd64/arm64-pink?style=plastic)](https://hub.docker.com/r/gclm/subconverter)

## 项目地址
- GitHub [gclm/subconverter](https://github.com/gclm/subconverter)  
- Docker [gclmit/subconverter](https://hub.docker.com/r/gclmit/subconverter)

## 使用教程

### 基础使用教程
```shell
docker run -d --name subconverter --restart always \
  -p 18080:80 \
  gclmit/subconverter:latest
```

### 自定义配置
 复制配置文件，到指点目录，配置文件实例：[config.js](public/conf/config.js)
```shell
docker run -d --name subconverter --restart always \
  -p 18080:80 \
  -v /PATH/subweb/conf:/usr/share/nginx/html/conf \
  gclmit/subconverter:latest
```
