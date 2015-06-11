Template.GirlsWar_game.helpers
  thisPlayer: ->
    GirlsWar.rules.findPlayers
      _game: @_id
      _user: Meteor.userId()
    , limit: 1
    .fetch()[0]

  cardTypeToClass: ->
    'game-card-' + @cardType.toLowerCase().replace(/\W/g, '-').replace(/--+/g, '-')

  cardHasSpecials: ->
    @action or @charmPoint or @ability or @specialAbility or @reaction
