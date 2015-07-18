# XXX: this is kind of hacky, refactor
CBGA.ui.PanelContainerContoller::doMoveComponent = (component, owner, oldContainer) ->
  console.log 'move component, meteoric way'
  if component instanceof CBGA.ui.ComponentStack
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
        if component.stack?
          selector[component.uiType.stackProperty] = component.stack
        component.container.find selector, limit: count
        .forEach (eachComponent) =>
          eachComponent.moveTo @getContainer owner
          oldContainer?.componentRemoved?(eachComponent)
  else
    component.moveTo @getContainer owner
    oldContainer?.componentRemoved?(component)
