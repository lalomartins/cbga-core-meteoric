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
      id = panel.name.replace /\s/g, '-'
      (=>
        panelClass = "panel-player-#{id} panel-visibility-#{panel.visibility}"
        unless panel.private
          panelClass += ' zoomable'
        zoomed = false
        zoomedDep = new Tracker.Dependency
        id: "player-#{@_id}-#{id}"
        panelClass: ->
          if @zoomed()
            panelClass + ' zoomed'
          else
            panelClass
        titleAttribution: "#{name}'s "
        icon: getIcon panel.icon
        panel: panel
        owner: @
        controller: rules.getController 'panel', panel.name
        hidden: panel.private
        zoomed: ->
          zoomedDep.depend()
          zoomed
        toggleZoom: ->
          zoomed = not zoomed
          zoomedDep.changed()
      )()

  panelsGame: ->
    rules = CBGA.getGameRules @rules
    for panel in rules.uiDefs.panels when panel.owner is 'game'
      id = panel.name.replace /\s/g, '-'
      (=>
        panelClass = "panel-player-#{id} panel-visibility-#{panel.visibility}"
        zoomed = false
        zoomedDep = new Tracker.Dependency
        id: "game-#{id}"
        panelClass: ->
          if @zoomed()
            panelClass + ' zoomed'
          else
            panelClass
        icon: getIcon panel.icon
        panel: panel
        owner: @
        controller: rules.getController 'panel', panel.name
        hidden: panel.private
        zoomed: ->
          zoomedDep.depend()
          zoomed
        toggleZoom: ->
          zoomed = not zoomed
          zoomedDep.changed()
      )()

  panelsOwn: ->
    rules = CBGA.getGameRules @rules
    player = rules.findPlayers
      _game: @_id
      _user: Meteor.userId()
    , limit: 1
    .fetch()[0]
    for panel in rules.uiDefs.panels when panel.owner is 'player'
      id = panel.name.replace /\s/g, '-'
      (=>
        panelClass = "panel-player-#{id} panel-visibility-#{panel.visibility}"
        zoomed = false
        zoomedDep = new Tracker.Dependency
        id: "own-player-#{id}"
        panelClass: ->
          if @zoomed()
            panelClass + ' zoomed'
          else
            panelClass
        titleAttribution: 'Your '
        icon: getIcon panel.icon
        panel: panel
        owner: player
        controller: rules.getController 'panel', panel.name
        hidden: panel.private is 'all'
        zoomed: ->
          zoomedDep.depend()
          zoomed
        toggleZoom: ->
          zoomed = not zoomed
          zoomedDep.changed()
      )()

Template.gameViewDefault.events
  'click .game-panel .panel-label': (event) ->
    $(event.currentTarget.parentElement).toggleClass 'collapsed'

  'click .game-panel.zoomable, click .game-panel.panel-visibility-stack': (event) ->
    event.preventDefault()
    event.stopImmediatePropagation()
    @toggleZoom()
