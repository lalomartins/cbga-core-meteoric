pendingEdits = null
editTimer = null
state = 'clear'

queueEdits = (fields) ->
    if editTimer?
        Meteor.clearTimeout editTimer
    pendingEdits ?= {}
    for field, value of fields
        pendingEdits[field] = value
    if state is 'clear'
        editTimer = Meteor.setTimeout saveEdits, 1000

saveEdits = ->
    editTimer = null
    return unless state is 'clear'
    state = 'saving'
    edits = _.clone pendingEdits
    pendingEdits = null
    Meteor.users.update Meteor.userId(), $set: edits, (error) ->
        if error?
            state = 'error'
            IonPopup.alert
                title: 'Unable to save'
                template: error.reason
                okText: 'Oh bummer…'
                onOk: -> state = 'clear'
        else
            state = 'clear'
            if pendingEdits?
                editTimer = Meteor.setTimeout saveEdits, 1000

Template.profileEdit.helpers
    firstEmail: ->
        @emails[0]?.address ? 'unset'

Template.profileEdit.events
    'keyup #profile-edit-name, input #profile-edit-name': (event) ->
        queueEdits 'profile.name': event.currentTarget.value

    'keyup #profile-edit-username, input #profile-edit-username': (event) ->
        queueEdits 'username': event.currentTarget.value

    'change #profile-edit-show-usernames': (event) ->
        queueEdits 'profile.showUsernames': event.currentTarget.checked

Template.profileEdit.onRendered ->
    @$('#profile-edit-name').select()
