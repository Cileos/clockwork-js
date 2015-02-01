`import Ember from 'ember'`
`import WeekwiseMixin from 'clockwork/mixins/weekwise'`

DashboardController = Ember.Controller.extend WeekwiseMixin,
  needs: ['application']
  upcomingSchedulings: Ember.computed 'monday', ->
    @get('store').findQuery 'scheduling', cwyear: @get('year'), week: @get('week')

`export default DashboardController`
