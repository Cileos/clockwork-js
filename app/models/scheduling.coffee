`import DS from 'ember-data'`

Scheduling = DS.Model.extend {
  team: DS.belongsTo 'team'
  startsAt: DS.attr('string')
  endsAt: DS.attr('string')
  allDay: DS.attr 'boolean'
  employee: DS.belongsTo 'employee'
}

`export default Scheduling`
