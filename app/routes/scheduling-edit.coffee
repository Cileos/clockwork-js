`import Ember from 'ember'`

SchedulingEditRoute = Ember.Route.extend
  renderTemplate: ->
    @render
      outlet: 'modal'
      template: 'scheduling/edit'

`export default SchedulingEditRoute`
