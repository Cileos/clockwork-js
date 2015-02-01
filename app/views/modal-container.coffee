`import Ember from 'ember'`

ModalContainerView = Ember.ContainerView.extend
  tagName: 'div'
  elementId: 'modal'
  didInsertElement: ->
    console?.debug "inserted"
    @_super()
    Ember.run.scheduleOnce 'afterRender', this, ->
      @$().dialog()

  willRemoveElement: ->
    console?.debug "will remove"
    @$().dialog('destroy')

`export default ModalContainerView`
