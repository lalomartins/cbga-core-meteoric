Router.map ->
    @configure
        trackPageView: true
        layoutTemplate: 'layout'
        notFoundTemplate: 'notFound'

    @route '/',
        name: 'home'
        fastRender: true

    @route 'profile',
        fastRender: true

        data: ->
            Meteor.user()

    @route '/u/:username',
        fastRender: true
        template: 'profile'

        data: ->
            Meteor.users.findOne username: @params.username

    @route 'game/:_id',
        data: ->
            CBGA.Games.findOne @params._id, transform: CBGA.Game._wrap

        subscriptions: ->
            [
                Meteor.subscribe 'cbga-components-for-game', this.params._id
                Meteor.subscribe 'cbga-container-counts-for-game', this.params._id
            ]

        action: ->
            if @data()?.started?
                @render 'gameView'
            else
                @render 'gameSetup'

    @plugin 'ensureSignedIn',
        except: ['atForgotPassword', 'about']

    @plugin 'dataNotFound'
