`import Ember from 'ember'`
`import tablearized from 'clockwork/utils/tablearized'`

Wrap = Ember.ObjectProxy.extend
  startHour: Ember.computed 'startsAt', ->
    moment( @get('startsAt') ).hour()
  endHour: Ember.computed 'endsAt', ->
    moment( @get('endsAt') ).clone().add(1, 'second').hour()
  shortPeriod: Ember.computed 'startHour', 'endHour', ->
    "#{@get('startHour')}-#{@get('endHour')}"

Component = Ember.Component.extend
  tagName: 'table'
  content: Ember.A()
  decoratedContent: Ember.computed.map 'content', (item, index)->
    Wrap.create content: item

  monday: moment()
  xValues: Ember.computed.alias 'days'
  days: Ember.computed 'monday', ->
    monday = moment( @get('monday') ).clone().startOf('isoWeek')
    monday.clone().add(x, 'days') for x in [0,1,2,3,4,5,6]

  structure: tablearized 'decoratedContent',
    x: ['startsAt', (v)-> moment(v).format('dd')], # weekday
    y: ['team', 'name'],

  # TODO respect locale for weekday names

`export default Component`

