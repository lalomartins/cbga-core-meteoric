# Have to keep this separately, because Jade at the moment doesn't allow
# passing arguments

Template.registerHelper 'space', -> ' '

getParamNames = (fn) ->
    source = fn.toString()
    source.match(/\(.*?\)/)[0].replace(/[()]/gi,'').replace(/\s/gi,'').split(',')

@TemplateHelpers =
    add: (name, fn) ->
        if typeof name is 'object'
            many = name
            for name, fn of many
                TemplateHelpers.add name, fn
        else
            TemplateHelpers[name] = fn
            paramNames = getParamNames fn
            if paramNames.length > 0
                Template.registerHelper name, ->
                    if arguments.length is 0
                        fn.call @, @
                    else if arguments.length is 1 and arguments[0] instanceof Spacebars.kw
                        hash = arguments[0].hash
                        args = (hash[param] for param in paramNames)
                        fn.apply @, args
                    else
                        fn.apply @, arguments
            else
                Template.registerHelper name, fn

TemplateHelpers.add
    displayDateFull: (date) ->
        moment(date).format('dddd, YYYY-MM-DD h:mma Z')

    displayDateShort: (date) ->
        moment(date).fromNow()

    pluralize: (number, singular, plural) ->
        # single point so it's easier to internationalize later
        if number is 1
            singular
        else
            plural

    avatarUrl: (user) ->
        user.profile?.avatarUrl ? user.defaultAvatar ? '/default-avatar.jpg'

    displayName: (user) ->
        return 'nobody' unless user?
        # you *can* pass a profile, but then there's no username fallback
        profile = user.profile ? user
        assembled = if profile.first and profile.last
            "#{profile.first} #{profile.last}"
        profile.displayName ? profile.name ? assembled ? user.username

    makeRows: (list, columns = 3) ->
        # XXX actually implement this
        # (need a test dataset wide enough)
        if list instanceof Meteor.Collection.Cursor
            nRows = Math.ceil list.count() / columns
            for i in [0..nRows]
                cur = Object.create Meteor.Collection.Cursor.prototype
                _.extend cur, list
                cur.limit = columns
                cur.skip = i * columns
                index: i, total: nRows, columns: cur
        else
            nRows = Math.ceil list.count() / columns
            for i in [0..nRows]
                start = i * columns
                end = start + columns
                index: i, total: nRows, columns: list.slice(start, end)

    debug: ->
        debugger

Template::bindDateDisplay = ->
    @.events
        'touchend .date-display': (event) ->
            if event.currentTarget.title
                alert event.currentTarget.title
