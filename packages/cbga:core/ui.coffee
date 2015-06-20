ui = CBGA.ui = {}

class ui.Panel
  constructor: ({@id, @title, @owner, @visibility, @icon, slots} = {}) ->
    check @id, String
    @owner ?= 'game'
    @visibility ?= 'public'
    @slots = {}
    for slot in slots ? []
      if slot instanceof ui.Slot
        @slots[slot.id] = slot
        slot.panel = @
      else if typeof slot is 'string'
        @slots[slot] = new ui.Slot id: slot, panel: @
      else if typeof slot is 'object'
        @slots[slot.id] = new ui.Slot id: slot.id, title: slot.title, panel: @

# Slots are really later on in the backlog, but here's the API anyway
class ui.Slot
  constructor: ({@id, @title, @panel} = {}) ->
    check @id, String
    check @panel, ui.Panel

class ui.ComponentType
  constructor: ({@name, @width, @height, @isCounter, @stackProperty, @stackAfter,
                 @displayNameSingular, @displayNamePlural, @template} = {}) ->
    check @name, String
    check @width, Match.Optional Number
    check @height, Match.Optional Number
    @isCounter ?= false
    check @isCounter, Boolean
    if @isCounter
      check @stackProperty, Match.Optional String
      @stackAfter ?= 2
      check @stackAfter, Number
    else
      check @stackProperty, undefined
      check @stackAfter, undefined
    @displayNameSingular ?= @name
    check @displayNameSingular, String
    @displayNamePlural ?= @displayNameSingular
    check @displayNamePlural, String
    check @template, Match.Optional String

  render: (component) ->
    new Blaze.Template =>
      component ?= Template.currentData().component
      template = if @template
        Template[@template]
      else
        rules = component.game().rules
        Template["#{rules.replace /\s/g, ''}ComponentView"] ? Template.componentDefaultView
      Blaze.With component, -> template

  summary: (count) ->
    if count is 1
      "1 #{@displayNameSingular}"
    else
      "#{count} #{@displayNamePlural}"

class ui.Controller extends EventEmitter
  # does nothing for now, but can be used for instanceof

class ui.PanelContainerContoller extends ui.Controller
  constructor: ({@rules, @panel, @container} = {}) ->
    @widget = 'panel'
    if typeof @rules is 'string'
      @rules = CBGA.getGameRules @rules
    check @rules, CBGA.GameRules
    if typeof @panel is 'string'
      @panel = _.find @rules.uiDefs.panels, (panel) -> panel.id is @panel
    check @panel, ui.Panel
    @id = @panel.id
    check @container, Match.Optional String
    @container ?= @panel.id

  componentsFor: (owner) ->
    CBGA.Components.find _container: [@panel.owner, owner._id, @container],
      sort: type: 1, position: 1
      transform: (doc) =>
        component: @rules.wrapComponent doc
        type: @rules.getComponentType doc.type

  renderAll: (owner) ->
    new Blaze.Template =>
      owner ?= Template.currentData().owner
      Blaze.Each (=> @componentsFor owner), ->
        data = Template.currentData()
        data.type.render()

  summary: (owner) ->
    owner ?= Template.currentData().owner
    counts = {}
    CBGA.Components.find _container: [@panel.owner, owner._id, @container],
      fields: type: 1
    .forEach (doc) ->
      counts[doc.type] ?= 0
      counts[doc.type] += 1
    for type, count of counts
      @rules.getComponentType(type).summary(count)
