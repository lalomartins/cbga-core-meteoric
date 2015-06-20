Template.gameView.helpers
  getTemplate: ->
    rules = CBGA.getGameRules @rules
    rules.uiTemplate ? 'gameViewDefault'
