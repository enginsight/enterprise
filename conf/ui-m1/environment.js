module.exports = function (environment) {
  var ENV = {
    hinting: true,
    modulePrefix: 'ngs-ui-m1',
    environment: environment,
    rootURL: '/',
    locationType: 'auto',

    stripePublishableKey: '',
    recaptchaKey: '',

    EmberENV: {
      FEATURES: {}
    },

    APP: {}
  };

  ENV.apiDomain = 'https://api.enginsight.com';
  ENV.cookieDomain = '.enginsight.com';
  ENV.stripePublishableKey = '';

  return ENV;
};
