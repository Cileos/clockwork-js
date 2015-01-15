`import Ember from 'ember'`

PaginatonBaseComponent = Ember.Component.extend
  tagName: 'button',
  classNames: 'btn btn-default'.w(),
  attributeBindings: ['disabled'],
  # the enabled property will easily toggle the disabled attribute for the element
  # in case there's no target to jump to
  enabled: true,
  disabled: Ember.computed.not('enabled'),
  action: null,
  click: ->
    @sendAction()

`export default PaginatonBaseComponent`
