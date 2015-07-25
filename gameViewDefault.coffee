getIcon = (icon) ->
  if icon
    if icon.indexOf('.') >= 0
      # It's an URL. Not really supported yet.
      icon
    else switch icon
      when 'hand'
        'ion-android-hand'
      when 'search'
        'ion-search'
      when 'stats'
        'ion-stats-bars'

Template.gameViewDefault.helpers
  otherPlayers: ->
    rules = CBGA.getGameRules @rules
    rules.findPlayers
      _game: @_id
      _user: $ne: Meteor.userId()
    , sort: joined: 1

  panelsOther: ->
    game = Template.parentData()
    rules = CBGA.getGameRules game.rules
    name = TemplateHelpers.h.playerName @
    for panel in rules.uiDefs.panels when panel.owner is 'player'
      id = panel.id.replace /\s/g, '-'
      id: "player-#{@_id}-#{id}"
      panelClass: "panel-player-#{id} panel-visibility-#{panel.visibility}"
      titleAttribution: "#{name}'s "
      icon: getIcon panel.icon
      panel: panel
      owner: @
      controller: rules.getController 'panel', panel.id
      hidden: panel.private

  panelsGame: ->
    rules = CBGA.getGameRules @rules
    for panel in rules.uiDefs.panels when panel.owner is 'game'
      id = panel.id.replace /\s/g, '-'
      id: "game-#{id}"
      panelClass: "panel-game-#{id} panel-visibility-#{panel.visibility}"
      icon: getIcon panel.icon
      panel: panel
      owner: @
      controller: rules.getController 'panel', panel.id
      hidden: panel.private

  panelsOwn: ->
    rules = CBGA.getGameRules @rules
    player = rules.findPlayers
      _game: @_id
      _user: Meteor.userId()
    , limit: 1
    .fetch()[0]
    for panel in rules.uiDefs.panels when panel.owner is 'player'
      id = panel.id.replace /\s/g, '-'
      id: "own-player-#{id}"
      panelClass: "panel-player-#{id} panel-visibility-#{panel.visibility}"
      titleAttribution: 'Your '
      icon: getIcon panel.icon
      panel: panel
      owner: player
      controller: rules.getController 'panel', panel.id
      hidden: panel.private is 'all'

Template.gameViewDefault.events
  'click .game-panel .panel-label': (event) ->
    $(event.currentTarget.parentElement).toggleClass 'collapsed'
