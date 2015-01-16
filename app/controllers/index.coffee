`import Ember from 'ember'`
`import WeekwiseMixin from 'clockwork/mixins/weekwise'`

IndexController = Ember.Controller.extend WeekwiseMixin,
  upcomingSchedulings: Ember.computed 'monday', ->
    @get('store').findQuery 'scheduling', cwyear: @get('year'), week: @get('week')

`export default IndexController`
