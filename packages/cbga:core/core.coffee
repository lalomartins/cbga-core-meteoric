CBGA = {}

class CBGA._DbModelBase extends EventEmitter
    constructor: ->
        super

    _load: (doc) ->
        _.extend @, doc

    @_bindCollection: (collection) ->
        @on 'changed', (update) ->
            collection.update @_id, update

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
