CBGA = {}

class CBGA._DbModelBase extends EventEmitter
    constructor: ->
        super
        @_setupTransients()

    _setupTransients: ->
        EventEmitter.call @

    _load: (doc) ->
        _.extend @, doc
        @_setupTransients()

    _toDb: ->
        tmp = new EventEmitter
        doc = {}
        for own field, value of @
            unless field of tmp or value instanceof CBGA._DbModelBase or field.match /^__/
                doc[field] = value
        doc

    _bindCollection: (collection) ->
        @on 'changed', (update) ->
            collection.update @_id, update

digits64 = _.toArray '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ-.'

CBGA._str64 = (number) ->
    digits = []
    oct = number.toString 8
    if oct.length % 2
        oct = '0' + oct
    while oct
        head = oct.substr 0, 2
        oct = oct.substr 2
        digits.push digits64[Number.parseInt head, 8]
    digits.join ''

CBGA._parse64 = (str) ->
    number = 0
    for digit in _.toArray str
        number *= 64
        dv = digits64.indexOf digit
        if dv is -1
            throw new TypeError 'Value is not a 64-base number'
        number += dv
    number

CBGA._shortId = (length = 7) ->
    if window?.crypto?.getRandomValues?
        array = new Uint32Array 1
        generator = ->
            window.crypto.getRandomValues array
            array[0]
    else
        generator = ->
            Math.floor Random.fraction() * 0xffffffff
    id = CBGA._str64 new Date().valueOf() % 262143
    while id.length < length
        n = CBGA._str64 generator()
        while n.length < 4
            n = '0' + n
        id += n
    id.substr 0, length

CBGA._shortIdCaseInsensitive = (length = 10) ->
    if window?.crypto?.getRandomValues?
        array = new Uint32Array 1
        generator = ->
            window.crypto.getRandomValues array
            array[0]
    else
        generator = ->
            Math.floor Random.fraction() * 0xffffffff
    id = (new Date().valueOf() % 1679615).toString 36
    while id.length < length
        n = generator().toString 36
        while n.length < 5
            n = '0' + n
        id += n
    id.substr 0, length


class CBGA.GameError extends Error
    constructor: (@message) ->
        @name = 'GameError'
        if Error.captureStackTrace?
            Error.captureStackTrace @, @constructor
        else
            # IE only sets the stack property on throw. I'm surprised to praise IE,
            # but that's obviously the correct behaviour in this case.
            # V8 has captureStackTrace which correctly ignores this method.
            # Firefox has a \n-separated string.
            stack = (new Error).stack
            if typeof stack is 'string'
                stack = stack.split '\n'
                loop
                    first = stack.shift()
                    if first.match new RegExp "^#{@constructor.name}"
                        break
                caller = stack[0].match /.*@(.*?):(\d+)(?::(\d+))?$/
                if caller?
                    @fileName = caller[1]
                    @lineNumber = caller[2]
                    @columnNumber = caller[3]
                @stack = stack.join '\n'

CBGA.findGame = (selector) ->
    doc = CBGA.Games.findOne selector
    unless doc?
        throw new CBGA.GameError "Couldn't find game '#{selector}'"
    rules = CBGA.getGameRules doc.rules
    unless rules?
        throw new CBGA.GameError "Couldn't find rules for '#{doc.rules}'"
    rules.wrapGame doc

CBGA.options = {}

CBGA.setupCollections = ->
    CBGA.Games = new Meteor.Collection CBGA.options?.names?.games ? 'games'
    CBGA.Players = new Meteor.Collection CBGA.options?.names?.players ? 'players'
    CBGA.Components = new Meteor.Collection CBGA.options?.names?.components ? 'components'
    @
