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
    for panel in rules.uiDefs.panels \
        when panel.owner is 'player' and panel.visibility is 'public'
      id: "player-#{@_id}-#{panel.id}"
      panelClass: "panel-player-#{panel.id}"
      titleAttribution: "#{name}'s "
      icon: getIcon panel.icon
      panel: panel
      owner: @
      controller: rules.getController 'panel', panel.id

  panelsGame: ->
    rules = CBGA.getGameRules @rules
    for panel in rules.uiDefs.panels when panel.owner is 'game'
      id: "game-#{panel.id}"
      panelClass: "panel-game-#{panel.id}"
      icon: getIcon panel.icon
      panel: panel
      owner: @
      controller: rules.getController 'panel', panel.id

  panelsOwn: ->
    rules = CBGA.getGameRules @rules
    player = rules.findPlayers
      _game: @_id
      _user: Meteor.userId()
    , limit: 1
    .fetch()[0]
    for panel in rules.uiDefs.panels when panel.owner is 'player'
      id: "own-player-#{panel.id}"
      panelClass: "panel-player-#{panel.id}"
      titleAttribution: 'Your '
      icon: getIcon panel.icon
      panel: panel
      owner: player
      controller: rules.getController 'panel', panel.id
