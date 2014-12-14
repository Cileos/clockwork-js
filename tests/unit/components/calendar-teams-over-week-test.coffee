`import {
  moduleForComponent,
  test
} from 'ember-qunit'`

moduleForComponent('calendar-teams-over-week', 'CalendarTeamsOverWeekComponent', {
  # specify the other units that are required for this test
  # needs: ['component:foo', 'helper:bar']
})

test 'it renders', ->
  expect(3)

  # creates the component instance
  component = this.subject()
  equal(component._state, 'preRender')

  # appends the component to the page
  this.append()
  equal(component._state, 'inDOM')

  content = component.$().text()
  equal(content.indexOf('fnord'), 0, 'does not render the right template')
