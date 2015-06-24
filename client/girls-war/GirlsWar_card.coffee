Template.GirlsWar_card.helpers
  cardTypeToClass: ->
    'game-card-' + @cardType.toLowerCase().replace(/\W/g, '-').replace(/--+/g, '-')

  hasTraitsOrSkills: ->
    @singing or @dancing or @comedy or @charisma or @acting or \
    @kawaii or @genki or @cool or @rebel or @pure

  hasSpecials: ->
    @action or @charmPoint or @ability or @specialAbility or @reaction
