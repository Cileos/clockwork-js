import {
  moduleForComponent,
  test
} from 'ember-qunit';

moduleForComponent('calendar-teams-over-week', 'CalendarTeamsOverWeekComponent', {
  // specify the other units that are required for this test
  // needs: ['component:foo', 'helper:bar']
});

test('it renders', function() {
  expect(3);

  // creates the component instance
  var component = this.subject();
  equal(component._state, 'preRender');

  // appends the component to the page
  this.append();
  equal(component._state, 'inDOM');

  var content = component.$().text();
  equal(content.indexOf('fnord'), 0, 'does not render the right template');
});
