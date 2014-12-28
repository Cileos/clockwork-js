`import Ember from 'ember'`

Wrap = Ember.ObjectProxy.extend
  startHour: Ember.computed 'startsAt', ->
    moment( @get('startsAt') ).hour()

Component = Ember.Component.extend
  tagName: 'table'
  content: []
  decoratedContent: Ember.computed.map 'content', (item, index)->
    Wrap.create content: item

  ySorting: ['name']
  nonUniqueTeams: Ember.computed.mapProperty 'content', 'team'
  unsortedTeams: Ember.computed.uniq 'nonUniqueTeams'
  teams: Ember.computed.sort 'unsortedTeams', 'ySorting'

`export default Component`

