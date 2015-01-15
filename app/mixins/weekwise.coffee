`import Ember from 'ember'`

now = moment()

WeekwiseMixin = Ember.Mixin.create
  queryParams: ['year', 'week']
  year: now.year()
  week: now.isoWeek()
  monday: Ember.computed 'year', 'week', ->
    moment("#{@get 'year'}-W#{@get 'week'}-1")

  actions:
    previousWeek: (e) ->
      @transitionToWeek( @get('monday').clone().subtract(1, 'week') )

    nextWeek: (e) ->
      @transitionToWeek( @get('monday').clone().add(1, 'week') )

  transitionToWeek: (target)->
    target = target.startOf('week')
    @transitionToRoute queryParams:
      year: target.year()
      week: target.isoWeek()

`export default WeekwiseMixin`
