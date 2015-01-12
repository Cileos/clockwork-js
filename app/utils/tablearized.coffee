`import Ember from 'ember'`

tablearized = (dependentKey, opts)->

  xProperty  = opts.x[0]
  xFormatter = opts.x[1]
  yProperty  = opts.y[0]
  yFormatter = opts.y[1]

  Structure = Ember.Object.extend
    index: null
    initIndex: (->
      @set 'index', {} # faster than ember objects?
    ).on('init')
    xValues: []
    formattedXValues: Ember.computed.map 'xValues', xFormatter

    rows: []
    initRows: (->
      @set 'rows', Ember.A()
    ).on('init')
    rowSorting: ["value.#{yFormatter}"]
    sortedRows: Ember.computed.sort 'rows', 'rowSorting'

    rowKey: (row)->
      "row_#{row}" # OPTIMIZE can all objects toString()?

    cellKey: (row, column)->
      if typeof(xFormatter) is 'function'
        column = xFormatter( column )
      "row_#{row}_col_#{column}" # OPTIMIZE can all objects toString()?


    createOrFindRow: (rowValue)->
      index = @get('index')
      rowKey = @rowKey(rowValue)
      unless row = index[rowKey]
        cells = @get('xValues').map (mom)=>
          c = Cell.create structure: this, value: mom
          index[@cellKey(rowValue, mom)] = c
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
      cellKey = @cellKey(rowValue, columnValue)
      # TODO cases TEST THIS spike
      # 1) completely new, no row, no cell
      # 2) row already exists, but no cell
      # 3) row and cell exists

      if cell = index[cellKey]
        cell
      else
        @createOrFindRow(rowValue)
        index[cellKey]

  Row = Ember.Object.extend
    value: null
    formattedValue: Ember.computed.alias "value.#{yFormatter}"
    structure: null
    cells: []

  Cell = Ember.Object.extend
    items: []
    initItems: (->
      @set 'items', Ember.A()
    ).on('init')
    sorting: ['startsAt'] # sounds good in general
    itemsByTime: Ember.computed.sort 'items', 'sorting'


  options =
    initialValue: -> Structure.create()
    initialize: (accu, changeMeta, _instanceMeta)->
      # FIXME make this a binding or similar non-static
      accu.set('xValues', @get('xValues'))

    addedItem: (accu, item, changeMeta, _instanceMeta)->
      r = item.get(yProperty)
      # TODO deal more eloquent with time components
      c = moment(item.get(xProperty))
      cell = accu.createOrFindCell(r, c) # hash lookup, must prepare items array deep in accu
      cell.get('items').pushObject(item)
      accu
    removedItem: (accu, item, changeMeta, _instanceMeta)->
      console.debug 'removed', item
      accu

  Ember.reduceComputed dependentKey,
    "#{dependentKey}.@each.#{yProperty}",
    "#{dependentKey}.@each.#{xProperty}",
    options

`export default tablearized`
