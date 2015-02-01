`import Ember from 'ember'`

ModalContainerView = Ember.ContainerView.extend
  tagName: 'div'
  elementId: 'modal'

  childViewsDidChange: (views, idx, removed, added)->
    @_super(views, idx, removed, added)
    if added > 0
      console?.debug "inserted"
      Ember.run.scheduleOnce 'afterRender', this, ->
        @$().dialog
          close: (event, ui)=>
            @get('controller').send 'closeModal'
    if removed > 0
      console?.debug "removed"
      @$().dialog('destroy')

`export default ModalContainerView`
