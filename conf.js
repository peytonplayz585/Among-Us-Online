jsproxy_config({
  // Currently configured version (logged for troubleshooting)
//Each time the configuration is modified, the value needs to be increased or it will not take effect.
//Automatically download configurations every 5 minutes by default and can be accessed in privacy mode if you want to validate them now.
  ver: '100',

  // Accelerating Static Resources for Commonly Used Websites via CDN (in Lab)
  static_boost: {
    enable: true,
    ver: 62
  },

  // Node configuration
  node_map: {
   'Peytons Website Unblocker': {
      label: 'Local',
      lines: {
        [location.host]: 1,
      }
    }
  },

  /**
   * Default node
   */
  node_default: 'Peytons Website Unblocker',
  // node_default: /jsproxy-demo\.\w+$/.test(location.host) ? 'demo-hk' : 'Peytons Website Unblocker',

  /**
   * Acceleration node
   */
  node_acc: 'cfworker',

  /**
   * Static Resource CDN Address
* For accelerating resource access in the 'assets' directory
   */
  // assets_cdn: 'https://cdn.jsdelivr.net/gh/zjcqoo/zjcqoo.github.io@master/assets/',

  // Open when testing locally, otherwise accessed online
  assets_cdn: 'assets/',

  // Home Path
  index_path: 'index_v3.html',

  // List of CORS-enabled sites (in lab...)
  direct_host_list: 'cors_v1.txt',

  /**
   * Customize the HTML of the injected page
   */
  inject_html: '<Peytons Website Unblocker>',

  /**
   * URL Custom Processing (In Design)
   */
  url_handler: {
    'https://www.baidu.com/img/baidu_resultlogo@2.png': {
      replace: 'https://www.google.com/images/branding/googlelogo/2x/googlelogo_color_92x30dp.png'
    },
    'https://www.pornhub.com/': {
      redir: 'https://www.pornhub.com/'
    },
    'https://haha.com/': {
      content: 'Ha Ha very Funny Tommy'
    },
  }
})
