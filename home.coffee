Template.home.helpers
    games: ->
        CBGA.Games.find {}, transform: CBGA.Game._wrap

    isOwner: ->
        @_owner is Meteor.userId()
