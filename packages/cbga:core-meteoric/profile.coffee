Template.profile.helpers
    canEdit: ->
        @_id is Meteor.userId()
