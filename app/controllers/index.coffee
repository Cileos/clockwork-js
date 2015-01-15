`import Ember from 'ember'`

IndexController = Ember.Controller.extend
  # TODO year & week from queryParams
  year: 2015
  monday: Ember.computed 'year', -> moment()
  upcomingSchedulings: Ember.computed 'monday', ->
    @get('store').findAll 'scheduling'

`export default IndexController`
