`import Ember from 'ember'`

Wrap = Ember.ObjectProxy.extend
  startHour: Ember.computed 'startsAt', ->
    moment( @get('startsAt') ).hour()
  endHour: Ember.computed 'endsAt', ->
    moment( @get('endsAt') ).hour()
  startDow: Ember.computed 'startsAt', ->
    moment( @get('startsAt') ).day()
  shortPeriod: Ember.computed 'startHour', 'endHour', ->
    "#{@get('startHour')}-#{@get('endHour')}"

createOrFindCell = (row, column, structure, index)->
  rowKey = "row_#{row}" # OPTIMIZE can all objects toString()?
  cellKey = "row_#{row}_col_#{column}" # OPTIMIZE can all objects toString()?

  # TODO cases TEST THIS spike
  # 1) completely new, no row, no cell
  # 2) row already exists, but no cell
  # 3) row and cell exists

  unless row = index[rowKey]
    row = Ember.Object.create
      head: row
      cells: Ember.A()
    index[rowKey] = row
    structure.get('rows').pushObject(row)


  if cell = index[cellKey]
    cell
  else
    cell = Ember.Object.create
      items: Ember.A()
    index[cellKey] = cell
    row.get('cells').pushObject(cell)
    cell


Component = Ember.Component.extend
  tagName: 'table'
  content: Ember.A()
  decoratedContent: Ember.computed.map 'content', (item, index)->
    Wrap.create content: item

  ySorting: ['name']
  nonUniqueTeams: Ember.computed.mapProperty 'content', 'team'
  unsortedTeams: Ember.computed.uniq 'nonUniqueTeams'
  teams: Ember.computed.sort 'unsortedTeams', 'ySorting'

  structure: Ember.reduceComputed 'decoratedContent',
    'decoratedContent.@each.team',
    'decoratedContent.@each.startsAt',
    initialValue: ->
      return Ember.Object.create
        rows: []
    initialize: (accu, changeMeta, instanceMeta)->
      instanceMeta.index = {} # faster than ember objects?

    addedItem: (accu, item, changeMeta, instanceMeta)->
      r = item.get('team')
      c = item.get('startDow')
      cell = createOrFindCell(r, c, accu, instanceMeta.index) # hash lookup, must prepare items array deep in accu
      cell.get('items').pushObject(item)
      accu
    removedItem: (accu, item, changeMeta, instanceMeta)->
      console.debug 'removed', item
      accu

`export default Component`

