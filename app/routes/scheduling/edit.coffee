`import Ember from 'ember'`

SchedulingEditRoute = Ember.Route.extend
  renderTemplate: ->
    @render
      outlet: 'modal'

  actions:
    closeModal: ->
      # TODO generic parentRoute
      @transitionTo 'dashboard'

  deactivate: ->
    @disconnectOutlet 'modal'

`export default SchedulingEditRoute`
