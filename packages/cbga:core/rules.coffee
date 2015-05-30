gameRules = {}

class CBGA.GameRules
    constructor: (@name) ->

    gameClass: null

    newGame: ->
        if @gameClass?
            game = new @gameClass arguments
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

    findGame: (selector, options) ->
        selector ?= {}
        selector.rules ?= @name
        options ?= {}
        options.transform = @wrapGame
        CBGA.Games.find selector, options

    playerClass: null

    newPlayer: ->
        if @playerClass?
            player = new @playerClass arguments
            player._bindCollection CBGA.Players
            player
        else
            throw new Error 'You must override either playerClass, or newPlayer + wrapPlayer.'

    wrapPlayer: (playerDoc) ->
        if @playerClass?
            player = Object.create @playerClass.prototype
            player._load playerDoc
            player._bindCollection CBGA.Players
            check player.game().rules, @name
            player
        else
            throw new Error 'You must override either playerClass, or newPlayer + wrapPlayer.'

    findPlayer: (selector, options) ->
        options ?= {}
        options.transform = @wrapPlayer
        CBGA.Players.find selector, options

    componentClass: null

    newComponent: ->
        if @componentClass?
            component = new @componentClass arguments
            component._bindCollection CBGA.Components
            component
        else
            throw new Error 'You must override either componentClass, or newComponent + wrapComponent.'

    wrapComponent: (componentDoc) ->
        if @componentClass?
            component = Object.create @componentClass.prototype
            component._load componentDoc
            component._bindCollection CBGA.Components
            check component.game().rules, @name
            component
        else
            throw new Error 'You must override either componentClass, or newComponent + wrapComponent.'

    findComponent: (selector, options) ->
        options ?= {}
        options.transform = @wrapComponent
        CBGA.Components.find selector, options

CBGA.registerGameRules = (rules) ->
    if gameRules[rules.name]?
        throw new Error "There are already rules with the name '#{rules.name}'."
    gameRules[rules.name] = rules
    @

CBGA.getGameRules = (name) ->
    gameRules[name]
