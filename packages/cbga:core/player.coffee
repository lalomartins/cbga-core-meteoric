class CBGA.Player extends CBGA._DbModelBase
    constructor: (game, user) ->
        super
        @_user = user._id ? user
        @_game = game._id ? game

    @_wrap: (doc) ->
        gameDoc = CBGA.Games.findOne doc._game
        unless gameDoc?
            throw new CBGA.GameError "Couldn't find game '#{doc.game}'"
        rules = CBGA.getGameRules gameDoc.rules
        unless rules?
            throw new CBGA.GameError "Couldn't find rules for '#{gameDoc.rules}'"
        rules.wrapPlayer doc

    game: -> CBGA.Games.findOne @_game

    components: (container) ->
        if container?
            CBGA.Components.find
                _container: ['player', @_id, container]
        else
            CBGA.Components.find
                '_container.0': 'player'
                '_container.1': @_id
