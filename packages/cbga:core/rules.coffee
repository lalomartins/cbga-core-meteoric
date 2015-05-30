gameRules = {}

class CBGA.GameRules
    constructor: (@name) ->

    gameClass: null

    newGame: ->
        if @gameClass?
            game = new @gameClass()
            game._bindCollection CBGA.Games
            game
        else
            throw new Error 'You must override either gameClass, or newGame + wrapGame.'

    wrapGame: (gameDoc) ->
        if @gameClass?
            game = Object.create @gameClass.prototype
            game._load gameDoc
            game._bindCollection CBGA.Games
            game
        else
            throw new Error 'You must override either gameClass, or newGame + wrapGame.'

    playerClass: null

    newPlayer: ->
        if @playerClass?
            player = new @playerClass()
            player._bindCollection CBGA.Players
            player
        else
            throw new Error 'You must override either playerClass, or newPlayer + wrapPlayer.'

    wrapPlayer: (playerDoc) ->
        if @playerClass?
            player = Object.create @playerClass.prototype
            player._load playerDoc
            player._bindCollection CBGA.Players
            player
        else
            throw new Error 'You must override either playerClass, or newPlayer + wrapPlayer.'

CBGA.registerGameRules = (rules) ->
    if gameRules[rules.name]?
        throw new Error "There are already rules with the name '#{rules.name}'."
    gameRules[rules.name] = rules
    @

CBGA.getGameRules = (name) ->
    gameRules[name]
