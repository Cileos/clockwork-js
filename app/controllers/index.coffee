`import Ember from 'ember'`
`import WeekwiseMixin from 'clockwork/mixins/weekwise'`

IndexController = Ember.Controller.extend WeekwiseMixin,
  upcomingSchedulings: Ember.computed 'monday', ->
    @get('store').findQuery 'scheduling', cwyear: @get('year'), week: @get('week')

  # Only contains the teams loaded on the side, for
  # example by being included in /schedulings
  loadedTeams: Ember.computed 'store', ->
    @get('store').filter 'team', -> true

`export default IndexController`
