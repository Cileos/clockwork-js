`import Ember from 'ember'`

now = moment()

WeekwiseMixin = Ember.Mixin.create
  queryParams: ['year', 'week']
  year: moment().year()
  week: moment().isoWeek()
  monday: Ember.computed 'year', 'week', ->
    moment().year(@get 'year').isoWeek(@get 'week').isoWeekday(1).startOf('day')

  actions:
    previousWeek: (e) ->
      @transitionToWeek( @get('monday').clone().subtract(1, 'week') )

    nextWeek: (e) ->
      @transitionToWeek( @get('monday').clone().add(1, 'week') )

  transitionToWeek: (target)->
    target = target.startOf('isoWeek')
    @transitionToRoute queryParams:
      year: target.year()
      week: target.isoWeek()

`export default WeekwiseMixin`
