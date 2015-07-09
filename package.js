Package.describe({
  name: 'cbga:core-meteoric',
  version: '0.0.1',
  summary: 'Card and Board Game App core UI, with Meteoric',
  git: 'https://github.com/lalomartins/cbga-core.git',
  documentation: 'README.md',
});

Package.onUse(function(api) {
  api.versionsFrom('1.1.0.2');
  api.use([
    'accounts-password',
    'blaze',
    'check',
    'coffeescript',
    'mongo',
    'random',
    'templating',
    'underscore',

    'bengott:avatar',
    'fortawesome:fontawesome',
    'iron:router',
    'koolaid1551:ionicons-stylus',
    'koolaid1551:ionic-stylus',
    'meteorhacks:fast-render',
    'meteoric:ionic',
    'momentjs:moment',
    'mondora:connect-with',
    'mquandalle:jade',
    'mquandalle:stylus',
    'raix:eventemitter',
    'splendido:accounts-meld',
    'useraccounts:ionic',

    'lalomartins:template-helpers',

    'cbga:core',
  ]);
  api.imply([
    'cbga:core',
  ]);
  api.addFiles([
    'routes.coffee',
  ]);
  api.addFiles([
    'default-avatar.jpg',
    'main.styl',
    'main.coffee',
    'parts.jade',
    'accountWrappers.jade',
    'accountWrappers.coffee',
    'componentDefaultSummary.tpl.jade',
    'componentDefaultSummary.coffee',
    'gameSetup.tpl.jade',
    'gameSetup.coffee',
    'gameView.tpl.jade',
    'gameView.coffee',
    'gameViewDefault.tpl.jade',
    'gameViewDefault.coffee',
    'head.tpl.jade',
    'home.tpl.jade',
    'home.coffee',
    'landing.tpl.jade',
    'layout.tpl.jade',
    'notFound.tpl.jade',
    'panelFull.tpl.jade',
    'panelMini.tpl.jade',
    'profileCard.tpl.jade',
    'profile.tpl.jade',
    'profile.coffee',
    'profileEdit.tpl.jade',
    'profileEdit.coffee',
  ], 'client');
  api.addFiles([
  ], 'server');
  api.addFiles([
  ], 'web.cordova');
});
