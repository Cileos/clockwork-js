`import Ember from 'ember'`

IndexController = Ember.Controller.extend
  # TODO year & week from queryParams
  year: 2015
  monday: Ember.computed 'year', -> moment()
  upcomingSchedulings: Ember.computed 'monday', ->
    tb = Ember.Object.create name: 'Blue'
    tr = Ember.Object.create name: 'Red'
    [
      Ember.Object.create
        team: tb
        startsAt: '2015-01-17T08:00'
        endsAt:   '2015-01-17T16:30'
      Ember.Object.create
        team: tr
        startsAt: '2015-01-17T10:00'
        endsAt:   '2015-01-18T15:45'
    ]

`export default IndexController`
