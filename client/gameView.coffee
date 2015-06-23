Template.gameView.helpers
  getTemplate: ->
    rules = CBGA.getGameRules @rules
    rules.uiTemplate ? 'gameViewDefault'

CBGA.ui.DragAndDropService.installHandlers Template.gameView
