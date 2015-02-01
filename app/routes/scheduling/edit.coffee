`import Ember from 'ember'`

SchedulingEditRoute = Ember.Route.extend
  renderTemplate: ->
    @render
      outlet: 'modal'

`export default SchedulingEditRoute`
