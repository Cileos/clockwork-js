`import tablearized from 'clockwork/utils/tablearized'`

Thing = thing = list = null

module 'tablearized',
  setup: ->
    Thing = Ember.Object.extend
      beginningOfWeek: '2014-12-15'
      content: []
      table: tablearized 'content',
        scope: ['beginningOfWeek', 'isoWeek', 7, 'days']
        x: ['startsAt', (v)-> moment(v).format('dd')]
        y: ['team', 'name'],
    thing = Thing.create(content: [])
    list = thing.get('content')

obj = (x)-> Ember.Object.create(x)
blueTeam = obj name: 'Blue'
redTeam = obj name: 'Red'


test 'it puts object into its cell', ->
  Ember.run ->
    list.pushObject obj
      team: blueTeam
      startsAt: '2014-12-15T08:00:00.000'
      name: 'TheOne'

  rows = thing.get('table.sortedRows')
  equal rows.get('length'),
    1, 'row was not created'
  equal rows.get('firstObject.cells.length'),
    7, 'no cells for row created'
  equal rows.get('firstObject.cells.firstObject.itemsByTime.length'),
    1, 'cell is empty'
  equal rows.get('firstObject.cells.firstObject.itemsByTime.firstObject.name'),
    'TheOne', 'incorrect object'


test 'it complains when no monday was set before pushing objects', ->
  Ember.run ->
    thing.set 'table.beginningOfWeek', null
    throws ->
      list.pushObject obj
        team: blueTeam
        startsAt: '2014-12-15T08:00:00.000'
    , /please set .*beginningOfWeek/
    , 'ignores undefined beginning of week'

test 'it puts multiple objects into the same cell when they match', ->
  Ember.run ->
    # sunday (21.12.) is last day of the isoWeek
    list.pushObject obj
      team: blueTeam
      startsAt: '2014-12-21T08:00:00.000'
      name: 'TheOne'
    list.pushObject obj
      team: blueTeam
      startsAt: '2014-12-21T09:00:00.000'
      name: 'TheOther'

  rows = thing.get('table.sortedRows')
  equal rows.get('length'),
    1, 'row was not created'
  equal rows.get('firstObject.cells.length'),
    7, 'no cells for row created'
  equal rows.get('firstObject.cells.lastObject.itemsByTime.length'),
    2, 'cell is empty'
  equal rows.get('firstObject.cells.lastObject.itemsByTime.firstObject.name'),
    'TheOne', 'TheOne should be first'
  equal rows.get('firstObject.cells.lastObject.itemsByTime.lastObject.name'),
    'TheOther', 'TheOther should be last'

test 'it moves object to new cell when x property changes', ->
  # move from sunday (21.12.) to monday
  o = obj
    team: blueTeam
    startsAt: '2014-12-21T08:00:00.000'
    name: 'TheOne'
  Ember.run -> list.pushObject o
  cellsOfFirstRow = thing.get('table.sortedRows.firstObject.cells')

  equal cellsOfFirstRow.get('lastObject.itemsByTime.length'),
    1, 'source cell should not be empty'
  equal cellsOfFirstRow.get('firstObject.itemsByTime.length'),
    0, 'target cell should be empty'

  Ember.run -> o.set 'startsAt', '2014-12-15T08:00'

  equal cellsOfFirstRow.get('lastObject.itemsByTime.length'),
    0, 'source cell still contains item'
  equal cellsOfFirstRow.get('firstObject.itemsByTime.length'),
    1, 'target cell should contain one object'
  equal cellsOfFirstRow.get('firstObject.itemsByTime.firstObject.name'),
    'TheOne', 'target cell should contain the changed object'

test 'it moves object to new cell when y property changes', ->
  # move from team blue to team red
  o = obj
    team: blueTeam
    startsAt: '2014-12-21T08:00:00.000'
    name: 'TheOne'
  Ember.run -> list.pushObject o

  cellsOfFirstRow = thing.get('table.sortedRows.firstObject.cells')
  equal cellsOfFirstRow.get('lastObject.itemsByTime.length'),
    1, 'source cell should not be empty'
  equal cellsOfFirstRow.get('firstObject.itemsByTime.length'),
    0, 'target cell should be empty'

  Ember.run -> o.set 'team', redTeam

  # assuming empty row is not removed
  equal thing.get('table.sortedRows.length'),
    2, 'no extra row was created or the old one was removed'
  cellsOfLastRow = thing.get('table.sortedRows.lastObject.cells')
  equal cellsOfLastRow.get('lastObject.itemsByTime.length'),
    1, 'source cell should not be empty'
  equal cellsOfLastRow.get('firstObject.itemsByTime.length'),
    0, 'target cell should be empty'

test 'it removes object from cell when it is removed from original list', ->
  o = obj
    team: blueTeam
    startsAt: '2014-12-21T08:00:00.000'
    name: 'TheOne'
  Ember.run -> list.pushObject o

  cellsOfFirstRow = thing.get('table.sortedRows.firstObject.cells')
  equal cellsOfFirstRow.get('lastObject.itemsByTime.length'),
    1, 'cell should not be empty before removal'

  Ember.run -> list.removeObject o
  equal cellsOfFirstRow.get('lastObject.itemsByTime.length'),
    0, 'cell should be empty after removal'

  #test '??? it removes rows with it contains no more objects'
  #test 'it leaves out objects not in scope'
  #test 'it rebuilds structure if scope changes'
  #test 'it ignores objects with bad properties (malformed startsAt)'

