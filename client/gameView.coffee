Template.gameView.helpers
  getTemplate: ->
    rules = CBGA.getGameRules @rules
    rules.uiTemplate ? 'gameViewDefault'

Template.gameView.events
  'dragstart .component[draggable]': (event, ti) ->
    CBGA.ui.DragAndDropService.start event
    true
