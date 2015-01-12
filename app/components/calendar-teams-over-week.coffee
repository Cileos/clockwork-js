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

Structure = Ember.Object.extend
  initRows: (->
    @set 'rows', Ember.A()
  ).on('init')

Row = Ember.Object.extend
  value: null
  structure: null
  cells: null # array

  initCells: (->
    cells = Ember.A()
    @get('structure.xValues').each (x)->
      cell = Cell.create()
      cells.pushObject cell
    @set 'cells', cells
  ).on('init')

Cell = Ember.Object.extend
  items: null
  initItems: (->
    @set 'items', Ember.A()
  ).on('init')

createOrFindRow = (row, structure, index)->
  rowKey = "row_#{row}" # OPTIMIZE can all objects toString()?
  unless row = index[rowKey]
    row = Row.create
      structure: structure
      value: row
    index[rowKey] = row
    structure.get('rows').pushObject(row)

  row

createOrFindCell = (row, column, structure, index)->
  cellKey = "row_#{row}_col_#{column}" # OPTIMIZE can all objects toString()?

  # TODO cases TEST THIS spike
  # 1) completely new, no row, no cell
  # 2) row already exists, but no cell
  # 3) row and cell exists

  row = createOrFindRow(row, structure, index)

  if cell = index[cellKey]
    cell
  else
    cell = Cell.create()
    index[cellKey] = cell
    row.get('cells').pushObject(cell)
    cell


Component = Ember.Component.extend
  tagName: 'table'
  content: Ember.A()
  decoratedContent: Ember.computed.map 'content', (item, index)->
    Wrap.create content: item

  xValues: Ember.computed.alias 'days'
  days: null # iterate from monday

  ySorting: ['name']
  nonUniqueTeams: Ember.computed.mapProperty 'content', 'team'
  unsortedTeams: Ember.computed.uniq 'nonUniqueTeams'
  teams: Ember.computed.sort 'unsortedTeams', 'ySorting'

  structure: Ember.reduceComputed 'decoratedContent',
    'decoratedContent.@each.team',
    'decoratedContent.@each.startsAt',
    initialValue: -> Structure.create()
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

