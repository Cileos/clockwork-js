`import tablearized from 'clockwork/utils/tablearized'`

module 'tablearized'

obj = Ember.Object.create
blueTeam = obj name: 'Blue'

# Replace this with your real tests.
test 'it works', ->
  result = tablearized 'content',
    x: ['startsAt', (v)-> moment(v).format('dd')], # weekday
    y: ['team', 'name'],
  ok result

  # rest tested in integration with component for now

test 'it puts object into its cell', ->
  Thing = Ember.Object.extend
    beginningOfWeek: '2014-12-15'
    content: []
    table: tablearized 'content',
      scope: ['beginningOfWeek', 'isoWeek', 7, 'days']
      x: ['startsAt', (v)-> moment(v).format('dd')]
      y: ['team', 'name'],
  thing = Thing.create(content: [])
  list = thing.get('content')

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


  #test 'it complains when no monday was set before pushing objects'
  #test 'it puts multiple objects into the same cell when they match', ->
  #test 'it moves object to new cell when x property changes', ->
  #test 'it moves object to new cell when y property changes', ->
  #test 'it removes object from cell when it is destroyed', ->
  #test '??? it removes rows with it contains no more objects'
  #test 'it leaves out objects not in scope'
  #test 'it rebuilds structure if scope changes'

