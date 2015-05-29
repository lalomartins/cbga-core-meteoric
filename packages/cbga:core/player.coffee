class CBGA.Player extends EventEmitter
    constructor: (game, @user) ->
        super
        @_game = game._id

    @_wrap: (doc) ->
        gameDoc = Games.findOne doc.game
        unless gameDoc?
            throw new CBGA.GameError "Couldn't find game '#{doc.game}'"
        rules = CBGA.getGameRules gameDoc.rules
        unless rules?
            throw new CBGA.GameError "Couldn't find rules for '#{gameDoc.rules}'"
        rules.wrapPlayer doc

    @game: -> Games.findOne @_game
