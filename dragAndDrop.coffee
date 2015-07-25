# XXX: this is kind of hacky, refactor
CBGA.ui.PanelContainerController::doMoveComponent = (component, owner, oldContainer) ->
  console.log 'move component, meteoric way'
  type = @rules.getComponentType component.type
  if type.isCounter
    IonPopup.prompt
      title: 'Move stack'
      template: 'How many?'
      inputType: 'number'
      inputPlaceholder: '1'
      onOk: (event, count) =>
        if count is ''
          count = 1
        else
          count = Number count
        selector = type: component.type
        if type.stackProperty?
          selector[type.stackProperty] = component[type.stackProperty]
        component.container().find selector, limit: count
        .forEach (eachComponent) =>
          eachComponent.moveTo @getContainer owner
          oldContainer?.componentRemoved?(eachComponent)
  else
    component.moveTo @getContainer owner
    oldContainer?.componentRemoved?(component)
