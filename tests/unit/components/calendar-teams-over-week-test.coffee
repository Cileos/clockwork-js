`import {
  moduleForComponent,
  test
} from 'ember-qunit'`
#`import matchesTable from '../../../tests/helpers/matches-table';`

moduleForComponent('calendar-teams-over-week', 'CalendarTeamsOverWeekComponent', {
  # specify the other units that are required for this test
  # needs: ['component:foo', 'helper:bar']
})

matchesTable = ($ele, line_sel, col_sel, stringy_expected)->
  expected = for line in stringy_expected.split("\n")
    for col in line.trim().replace(/^\|/,'').replace(/\|$/,'').split('|')
      col.trim()
  # TODO validate that table is well-formed (all lines equal length)

  actual = for line in $ele.find(line_sel).toArray()
    for col in $(line).find(col_sel).toArray()
      if $(col).find('li').length > 0
        $(col).find('li').map (index, li)-> $(li).text().trim()
                         .toArray()
                         .join(' ')
      else
        $(col).text().trim()

  equal actual.length, expected.length, 'number of rows does not match'
  deepEqual actual, expected, 'items do not match'

test 'it renders', ->
  expect(3)

  # creates the component instance
  component = this.subject()
  equal(component._state, 'preRender')

  # appends the component to the page
  this.append()
  equal(component._state, 'inDOM')

  content = component.$().text()
  equal(content.indexOf('Teams'), 0, 'does not render the right template')


test 'it renders items grouped in table', ->
  c = this.subject()
  blue  = Ember.Object.create name: 'Blue'
  red   = Ember.Object.create name: 'Red'
  green = Ember.Object.create name: 'Green'
  content = c.get 'content'
  Ember.run ->
    c.set 'monday', "2014-12-15T00:00:00.000"
    content.pushObject Ember.Object.create
      team: blue
      startsAt: '2014-12-16T09:00:00.000'
      endsAt:   '2014-12-16T12:59:59.999'
    content.pushObject Ember.Object.create
      team:     red
      startsAt: '2014-12-15T08:00:00.000'
      endsAt:   '2014-12-15T11:59:59.999'
    content.pushObject Ember.Object.create
      team:     green
      startsAt: '2014-12-18T14:00:00.000'
      endsAt:   '2014-12-18T17:59:59.999'
    content.pushObject Ember.Object.create
      team:     green
      startsAt: '2014-12-18T08:00:00.000'
      endsAt:   '2014-12-18T11:59:59.999'
  this.append()

  #equal Object.keys(c.get('structure.index')), 'inspect this'
  equal c.get('structure.sortedRows.length'), 3
  equal c.get('structure.sortedRows.lastObject.cells.length'), 7
  equal c.get('structure.sortedRows.lastObject.cells.firstObject.itemsByTime.length'), 1
  equal c.get('structure.sortedRows.lastObject.cells.firstObject.itemsByTime.firstObject.team.name'), 'Red', 'is not grouped'

  matchesTable c.$(), 'tr', 'th,td', """
    | Teams | Mo   | Tu   | We | Th         | Fr | Sa | Su |
    | Blue  |      | 9-13 |    |            |    |    |    |
    | Green |      |      |    | 8-12 14-18 |    |    |    |
    | Red   | 8-12 |      |    |            |    |    |    |
  """

test 'it decorates each given content item to calculate needed properties without having to change the original class', ->
  c = this.subject()
  source = Ember.Object.create
    startsAt: '2014-12-15T08:00:00.000'
  c.set 'content', [source]

  equal c.get('decoratedContent.firstObject.startHour'), 8

  source.set 'startsAt', '2014-12-15T14:00:00.000'
  equal c.get('decoratedContent.firstObject.startHour'), 14
