Template.gameSetup.helpers
    'owner': ->
        Meteor.users.findOne @owner

    'isOwner': ->
        @owner is Meteor.userId()

    'players': ->
        rules = CBGA.getGameRules @rules
        rules.findPlayers _game: @_id,
            sort: joined: 1

Template.gameSetup.events
    'click .remove-player': ->
        Meteor.call 'game.removePlayer', @_id
