The Card and Board Game App
===========================

A web and Cordova app to play card and board games.

This app contains view-related code, which you can easily override, fork, or
entirely replace. For the core API and functionality, look at
https://github.com/lalomartins/cbga-core.

At some point before 1.0 (in fact, before 0.8), this will all be refactored
into packages; cbga:default-app will have routes, publishes, etc,
cbga:core-meteoric will have the Meteoric/Ionic views and layout, and any
game-specific game views will go to cbga:${game}-meteoric. There will be an API
for game-specific view packages to provide templates which game-neutral code
(your app, or cbga:core-meteoric) can look up via cbga:core, e.g.,
`{{> CBGA.view 'game'}}`.
