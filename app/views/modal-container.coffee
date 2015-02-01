`import Ember from 'ember'`

ModalContainerView = Ember.ContainerView.extend
  tagName: 'div'
  elementId: 'modal'

  openModal: ->
    Ember.run.scheduleOnce 'afterRender', this, ->
      @$().dialog
        close: (event, ui)=>
          @get('controller').send 'closeModal'

  closeModal: ->
    @$()?.dialog('destroy')

  observeViews: (->
    cw = @get('currentView')
    if cw
      @openModal()
    else
      @closeModal()
  ).observes('currentView').on('init')

`export default ModalContainerView`
