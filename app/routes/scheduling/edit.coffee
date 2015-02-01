`import Ember from 'ember'`

SchedulingEditRoute = Ember.Route.extend
  renderTemplate: ->
    @render
      outlet: 'modal'

  actions:
    closeModal: ->
      @transitionTo @get('parentRoute.parentRouteName')

  deactivate: ->
    @disconnectOutlet 'modal'

`export default SchedulingEditRoute`
