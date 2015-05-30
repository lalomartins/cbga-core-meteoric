class CBGA.Component extends CBGA._DbModelBase
    # A Component is defined as something that can be moved in the game.
    # In most games, that means cards, tokens, player markers, meeples,
    # and so on. Boards, character sheets *don't* need to be Components.
    constructor: (game, container) ->
        super
        @_game = game._id ? game
        @_container = container?._toDb?() ? container

    @_wrap: (doc) ->
        gameDoc = CBGA.Games.findOne doc._game
        unless gameDoc?
            throw new CBGA.GameError "Couldn't find game '#{doc.game}'"
        rules = CBGA.getGameRules gameDoc.rules
        unless rules?
            throw new CBGA.GameError "Couldn't find rules for '#{gameDoc.rules}'"
        rules.wrapComponent doc

    game: -> CBGA.Games.findOne @_game
    container: -> CBGA.Container._wrap @_container


class CBGA.Container
    # A Container is a “place” where Components can be.
    # Containers are *NOT* real database objects; they're represented
    # by a [type, id, name] triplet, where name is an arbitrary string
    # (e.g. 'hand') and type is 'game' or 'player'.
    constructor: (triplet) ->
        [@type, @ownerId, @name] = triplet
        collection = switch
            when @type is 'game'
                CBGA.Games
            when @type is 'player'
                CBGA.Players
            else
                throw new Error "invalid container type #{@type}"
        @owner = collection.findOne @ownerId

    @_wrap: (triplet) ->
        if triplet?
            new @ triplet

    _toDb: ->
        [@type, @ownerId, @name]
