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
  index: null
  initIndex: (->
    @set 'index', {} # faster than ember objects?
  ).on('init')
  xValues: []
  formattedXValues: Ember.computed.map 'xValues', (mom)->
    # TODO respect locale for weekday names
    mom.format('dd')

  initRows: (->
    @set 'rows', Ember.A()
  ).on('init')

  createOrFindRow: (rowValue)->
    index = @get('index')
    rowKey = "row_#{rowValue}" # OPTIMIZE can all objects toString()?
    unless row = index[rowKey]
      cells = @get('xValues').map (mom)->
        c = Cell.create structure: this, value: mom
        cellKey = "row_#{rowValue}_col_#{mom}" # OPTIMIZE can all objects toString()?
        c
      row = Row.create
        structure: this
        value: rowValue
        cells: cells
      index[rowKey] = row
      @get('rows').pushObject(row)

    row

  createOrFindCell: (rowValue, columnValue)->
    index = @get('index')
    cellKey = "row_#{rowValue}_col_#{columnValue}" # OPTIMIZE can all objects toString()?

    # TODO cases TEST THIS spike
    # 1) completely new, no row, no cell
    # 2) row already exists, but no cell
    # 3) row and cell exists

    row = @createOrFindRow(rowValue)

    if cell = index[cellKey]
      cell
    else
      cell = Cell.create()
      index[cellKey] = cell
      row.get('cells').pushObject(cell)
      cell



Row = Ember.Object.extend
  value: null
  structure: null
  cells: []

Cell = Ember.Object.extend
  items: null
  initItems: (->
    @set 'items', Ember.A()
  ).on('init')


Component = Ember.Component.extend
  tagName: 'table'
  content: Ember.A()
  decoratedContent: Ember.computed.map 'content', (item, index)->
    Wrap.create content: item

  xValues: Ember.computed.alias 'days'
  days: Ember.computed ->
    # count up from monday
    moment("2014-12-15T00:00:00.000+01:00").add(x, 'days') for x in [0,1,2,3,4,5,6]

  ySorting: ['name']
  nonUniqueTeams: Ember.computed.mapProperty 'content', 'team'
  unsortedTeams: Ember.computed.uniq 'nonUniqueTeams'
  teams: Ember.computed.sort 'unsortedTeams', 'ySorting'

  structure: Ember.reduceComputed 'decoratedContent',
    'decoratedContent.@each.team',
    'decoratedContent.@each.startsAt',
    initialValue: -> Structure.create()
    initialize: (accu, changeMeta, _instanceMeta)->
      accu.set('xValues', @get('xValues')) # OPTIMIZE still static

    addedItem: (accu, item, changeMeta, _instanceMeta)->
      r = item.get('team')
      c = item.get('startDow')
      cell = accu.createOrFindCell(r, c) # hash lookup, must prepare items array deep in accu
      cell.get('items').pushObject(item)
      accu
    removedItem: (accu, item, changeMeta, _instanceMeta)->
      console.debug 'removed', item
      accu

`export default Component`

