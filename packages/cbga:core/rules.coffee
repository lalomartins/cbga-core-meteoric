gameRules = {}

# There are two ways to define your own rules:
# 1: Instantiate GameRules, passing a name, and assign to gameClass,
# playerClass, and componentClass. This is easier.
# 2: Subclass it, overriding the class properties. This is more flexible,
# and necessary if you need to override methods.

class CBGA.GameRules
    constructor: (@name) ->

    gameClass: null

    newGame: ->
        if @gameClass?
            game = Object.create @gameClass.prototype
            @gameClass.apply game, arguments
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

    findGames: (selector, options) ->
        selector ?= {}
        selector.rules ?= @name
        options ?= {}
        options.transform = _.bind @wrapGame, @
        CBGA.Games.find selector, options

    playerClass: null

    newPlayer: ->
        if @playerClass?
            player = Object.create @playerClass.prototype
            @playerClass.apply player, arguments
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

    findPlayers: (selector, options) ->
        options ?= {}
        options.transform = _.bind @wrapPlayer, @
        CBGA.Players.find selector, options

    componentClass: null

    newComponent: ->
        if @componentClass?
            component = Object.create @componentClass.prototype
            @componentClass.apply component, arguments
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

    findComponents: (selector, options) ->
        options ?= {}
        options.transform = _.bind @wrapComponent, @
        CBGA.Components.find selector, options

CBGA.registerGameRules = (rules) ->
    if gameRules[rules.name]?
        throw new Error "There are already rules with the name '#{rules.name}'."
    gameRules[rules.name] = rules
    @

CBGA.getGameRules = (name) ->
    gameRules[name]
