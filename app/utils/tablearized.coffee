`import Ember from 'ember'`

tablearized = (dependentKey, opts)->

  # The Property of listed objects used for columns
  xProperty  = opts.x[0]
  # A function allowing to format the column headers and values to group by.
  # Should return distinct values for each column (d'oh)
  xFormatter = opts.x[1]
  # The Property of listed objects used for rows (for example 'team')
  yProperty  = opts.y[0]
  # The Property of the row objects (for example 'name')
  yFormatter = opts.y[1]

  # Property of the owning object to define the range to show
  scopeStartProperty = opts.scope?[0] or 'monday'
  # The range which is shown. uses moment.js `startOf()` and similars
  scopeRange         = opts.scope?[1] or 'isoWeek'
  # The number of steps respect
  scopeStepCount     = opts.scope?[2] or 7
  # The size of each step, uses moment.js `add()` with scopeStepCount
  scopeStepWidth     = opts.scope?[3] or 'days'


  Structure = Ember.Object.extend
    index: null
    initIndex: (->
      @set 'index', {} # faster than ember objects?
    ).on('init')
    xValues: Ember.computed scopeStartProperty, ->
      start = moment( @get(scopeStartProperty) ).clone().startOf(scopeRange)
      unless start.isValid()
        throw "cannot build headers without a start, please set `#{scopeStartProperty}`"
      start.clone().add(x, scopeStepWidth) for x in [0..scopeStepCount-1]
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


    addItemAt: (item, column, row)->
      if cell = @createOrFindCell(row, column)
        cell.get('items').pushObject(item)

    removeItemAt: (item, column, row)->
      console?.debug 'removeItemAt', column.format('YYYY-MM-DD'), row.get('name')
      if cell = @createOrFindCell(row, column)
        cell.get('items').removeObject(item)


    createOrFindRow: (rowValue)->
      index = @get('index')
      rowKey = @rowKey(rowValue)
      unless row = index[rowKey]
        headers = @get('xValues')
        if !headers? or headers.length < scopeStepCount
          throw "could not calculate headers, must set #{scopeStartProperty} or point to other property with `scopeStart: '2012-05-13'`"
        cells = headers.map (mom)=>
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
      return unless @columnIsValid(columnValue)
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

    columnIsValid: (columnValue)->
      mine = @get('xValues')
      min = mine.get('firstObject')
      max = mine.get('lastObject').clone().endOf(scopeRange)
      columnValue.isBefore(max) and columnValue.isAfter(min)


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
      # FIXME make this a binding or similar non-static and handle re-building of structure
      accu.set(scopeStartProperty, @get(scopeStartProperty))

    addedItem: (accu, item, changeMeta, _instanceMeta)->
      # TODO deal more eloquent with time components
      accu.addItemAt item,
        moment( item.get(xProperty) ),
        item.get(yProperty)
      accu

    # called by ember when an item is removed or changed
    removedItem: (accu, item, changeMeta, _instanceMeta)->
      console?.debug 'removed', item, changeMeta
      prev = changeMeta.previousValues
      accu.removeItemAt item,
        moment( prev?[xProperty] || item.get(xProperty) ),
        prev?[yProperty] || item.get(yProperty)
      accu

  Ember.reduceComputed dependentKey,
    scopeStartProperty,
    "#{dependentKey}.@each.#{yProperty}",
    "#{dependentKey}.@each.#{xProperty}",
    options

`export default tablearized`
