Template.GirlsWar_game.helpers
  thisPlayer: ->
    GirlsWar.rules.findPlayers
      _game: @_id
      _user: Meteor.userId()
    , limit: 1
    .fetch()[0]

  cardHasSpecials: ->
    @action or @charmPoint or @ability or @specialAbility or @reaction
