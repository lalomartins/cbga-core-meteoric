Template.home.helpers
    games: ->
        CBGA.Games.find {}, transform: CBGA.Game.wrap

    isOwner: ->
        @_owner is Meteor.userId()
