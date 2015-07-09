Template.atSignupLink.events
    'click #at-signUp': ->
        IonModal.close()
        IonModal.open 'register'

Template.atSigninLink.events
    'click #at-signIn': ->
        IonModal.close()
        IonModal.open 'login'

AccountsTemplates.configure
    showAddRemoveServices: true
    showForgotPasswordLink: true
    onSubmitHook: (error, state)->
        unless error?
            IonModal.close()

pwd = AccountsTemplates.removeField 'password'
AccountsTemplates.removeField 'email'
AccountsTemplates.addFields [
    _id: "username",
    type: "text",
    displayName: "username",
    required: true,
    minLength: 5,
,
    _id: 'email',
    type: 'email',
    required: true,
    displayName: "email",
    re: /.+@(.+){2,}\.(.+){2,}/,
    errStr: 'Invalid email',
,
    pwd
]

AccountsTemplates.configureRoute 'ensureSignedIn',
    template: 'landing'
