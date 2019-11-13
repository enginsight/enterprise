module.exports = function (environment) {
  var ENV = {
    hinting: true,
    modulePrefix: 'ngs-ui-m1',
    environment: environment,
    rootURL: '/',
    locationType: 'auto',
    recaptchaKey: '',

    EmberENV: {
      FEATURES: {}
    },

    APP: {}
  };

  ENV.apiDomain = '%%API_URL%%';
  ENV.onpremise = {
    version: 1
  };

  return ENV;
};
