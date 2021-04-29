module.exports = function (environment) {
  var ENV = {
    hinting: true,
    modulePrefix: 'ngs-ui-m1',
    environment: environment,
    rootURL: '/',
    locationType: 'auto',
    recaptchaKey: '',
    
    // corporateIdentity: {
    //   company: 'Enginsight GmbH',
    //   companySlug: 'Enginsight',
    //   about: '',
    //   website: '',
    //   logo: '<svg...'
    // },

    // legal: {
    //   dataProcessingAgreement: "https://...",
    //   privacyPolicy: "https://...",
    //   imprint: "https://...",
    //   terms: "https://..."
    // },

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
