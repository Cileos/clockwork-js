`import Ember from 'ember'`
`import WeekwiseMixin from 'clockwork/mixins/weekwise'`

IndexController = Ember.Controller.extend WeekwiseMixin,
  upcomingSchedulings: Ember.computed 'monday', ->
    @get('store').findAll 'scheduling'

`export default IndexController`
