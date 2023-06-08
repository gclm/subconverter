window.config = {
  siteName: 'Subconverter Web',
  apiUrl: 'http://127.0.0.1:25500',
  menuItem: [
    {
      title: '首页',
      link: '/',
      target: '',
    },
    {
      title: 'GitHub',
      link: 'https://github.com/gclm/subconverter',
      target: '_blank',
    },
  ],
  remoteConfigList: [
    {
      title: 'ACL-默认',
      url: 'https://raw.githubusercontent.com/ACL4SSR/ACL4SSR/master/Clash/config/ACL4SSR.ini',
    },
    {
      title: 'ACL-全分组',
      url: 'https://raw.githubusercontent.com/ACL4SSR/ACL4SSR/master/Clash/config/ACL4SSR_Online_Full_AdblockPlus.ini',
    },
    {
      title: '墨鱼-Clash配置',
      url: 'https://raw.githubusercontent.com/ddgksf2013/Profile/master/ClashforWindows.yaml',
    },
    {
      title: '自定义远程配置地址',
      url: 'manual',
    },
  ],
};
