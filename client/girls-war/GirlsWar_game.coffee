Template.GirlsWar_game.helpers
  thisPlayer: ->
    GirlsWar.rules.findPlayers
      _game: @_id
      _user: Meteor.userId()
    , limit: 1
    .fetch()[0]
