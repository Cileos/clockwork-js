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

  structure: null

  setupStructure: (->
    # TODO observe content, group into rows
    # TODO group rows into columns
    # TODO structure.rows => row
    # TODO row.head => team
    # TODO row.cells => cell
    # TODO cell.head => weekday
    # TODO cell.items => array of items
  ).on('initialize')

`export default Component`

