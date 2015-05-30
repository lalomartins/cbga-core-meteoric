class CBGA.Game extends CBGA._DbModelBase
    # these seem like common defaults
    @MIN_PLAYERS = 2
    @MAX_PLAYERS = 4

    constructor: ->
        super
        # pattern: hardcode @rules = 'foo' for your ruleset
        @rules = null
        @expansions = []
        @created = new Date()
        @log = []

    @_wrap: (doc) ->
        rules = CBGA.getGameRules doc.rules
        unless rules?
            throw new CBGA.GameError "Couldn't find rules for '#{doc.rules}'"
        rules.wrapGame doc

    _determineFirstPlayer: (rules, players) ->
        Random.choice players

    # called before _setupPlayer (build deck, etc)
    _setup1: (rules, players) ->

    # called for each player in order (deal cards, etc)
    _setupPlayer: (rules, player) ->

    # called after _setupPlayer (build lineup, etc)
    _setup2: (rules, players) ->

    # you *usually* don't want to override this one, instead customize
    # it via the methods above
    start: ->
        rules: CBGA.getGameRules @rules
        players = Players.find
            _game: @_id
        ,
            sort: joined: 1
            transform: rules.wrapPlayer
        .fetch()
        if players.length < @constructor.MIN_PLAYERS
            throw new CBGA.GameError 'Not enough players to start the game'
        if players.length > @constructor.MAX_PLAYERS
            throw new CBGA.GameError 'Too many players to start the game'
        @firstPlayer = @_determineFirstPlayer rules, players
        # reorder players…
        before = []
        after = []
        for player in players
            switch
                when after.length
                    after.push player
                when player._id is @firstPlayer._id
                    after.push player
                else
                    before.push player
        players = after.concat before
        @_setup1 rules, players
        for player in players
            @_setupPlayer rules, player
        @_setup2 rules, players
