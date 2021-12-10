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
   'mysite': {
      label: 'Local',
      lines: {
        [location.host]: 1,
      }
    },
    'demo-hk': {
      label: 'Demo - Hongkong',
      lines: {
        // hosts: weights
        'node-aliyun-hk-1.etherdream.com:8443': 1,
        'node-aliyun-hk-2.etherdream.com:8443': 2,
      }
    },
    'demo-sg': {
      label: 'Demo - Singapore',
      lines: {
        'node-aliyun-sg.etherdream.com:8443': 1,
      }
    },
    // This node is used to load a large volume of static resources
    'cfworker': {
      label: '',
      hidden: true,
      lines: {
        // Fee Edition (High Weight)
        'node-cfworker-2.etherdream.com': 4,

        // Free Edition (Low Weight, Cost Sharing)
//100,000 free requests per account per day, with frequency restrictions
        'b.007.workers.dev': 1,
        'b.hehe.workers.dev': 1,
        'b.lulu.workers.dev': 1,
        'b.jsproxy.workers.dev': 1,
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
  inject_html: '<!Peytons Website Unblocker>',

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
    'http://haha.com/': {
      content: 'Ha Ha very Funny'
    },
  }
})
