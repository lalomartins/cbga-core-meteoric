# XXX: this is kind of hacky, refactor
coreMoveComponent = CBGA.ui.Controller::doMoveComponent
CBGA.ui.Controller::doMoveComponent = (component, owner, oldContainer) ->
  type = component.typeInfo ? @rules.getComponentType component.type
  if component.provider or type.isCounter
    IonPopup.prompt
      title: if component.provider
        'Draw'
      else
        'Move stack'
      template: 'How many?'
      inputType: 'number'
      inputPlaceholder: '1'
      onOk: (event, count) =>
        if count is ''
          count = 1
        else
          count = Number count
        coreMoveComponent.call @, component, owner, oldContainer, count
  else
    coreMoveComponent.call @, component, owner, oldContainer
