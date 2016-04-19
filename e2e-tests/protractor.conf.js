exports.config = {
  allScriptsTimeout: 11000,

  specs: [
    '../.e2e-tests/**/*[Ss]pec.js'
  ],

  capabilities: {
    'browserName': 'firefox'
  },

  baseUrl: 'http://localhost:3000/',

  framework: 'jasmine',

  jasmineNodeOpts: {
    defaultTimeoutInterval: 30000
  }
};
