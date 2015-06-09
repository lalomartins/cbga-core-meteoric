class CBGA.Component extends CBGA._DbModelBase
    # A Component is defined as something that can be moved in the game.
    # In most games, that means cards, tokens, player markers, meeples,
    # and so on. Boards, character sheets *don't* need to be Components.
    constructor: (game, container) ->
        unless container? and game?
            throw new Error 'Component needs a game and a container'
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

    moveTo: (container, properties) ->
        properties ?= {}
        properties._container = container._toDb()
        for name, value of properties
            @[name] = value
        @emit 'changed', $set: properties


class CBGA.Container
    # A Container is a “place” where Components can be.
    # Containers are *NOT* real database objects; they're represented
    # by a [type, id, name] triplet, where name is an arbitrary string
    # (e.g. 'hand') and type is 'game' or 'player'.

    # Note, if you create Containers in your _setupTransients, you MUST
    # pass in the owner object; if you pass @_id, there will be an infinite
    # loop trying to wrap it at the end.
    constructor: ([@type, @ownerId, @name]) ->
        unless Match.test @type, Match.OneOf 'game', 'player'
            throw new Error "invalid container type #{@type}"

        if typeof @ownerId is 'object'
            @owner = @ownerId
            @ownerId = @owner._id
            if @type is 'game' and @owner instanceof CBGA.Player
                throw new Error "type is game but owner is player"
            if @type is 'player' and @owner instanceof CBGA.Game
                throw new Error "type is player but owner is game"
        else
            # Right… so first we need to get the owner from the db, then if
            # it's a player get the game, and only then we can get the rules,
            # which we need to wrap.
            # XXX: maybe a Rules.newContainer helper?
            collection = if @type is 'game'
                    CBGA.Games
                else
                    CBGA.Players
            @owner = collection.findOne @ownerId
        rulesName = if @type is 'game'
            @owner.rules
        else
            @owner.game().rules
        @rules = CBGA.getGameRules rulesName
        unless @owner instanceof CBGA._DbModelBase
            rulesName = if @type is 'game'
                @owner = @rules.wrapGame @owner
            else
                @owner = @rules.wrapPlayer @owner

    @_wrap: (triplet) ->
        if triplet?
            new @ triplet

    _toDb: ->
        [@type, @ownerId, @name]

    find: (selector, options) ->
        if typeof selector isnt 'string'
            selector._container = @_toDb()
        @rules.findComponents selector, options
