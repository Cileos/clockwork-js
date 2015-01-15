`import DS from 'ember-data'`

Scheduling = DS.Model.extend {
  team: DS.belongsTo 'team'
  startsAt: DS.attr('moment')
  endsAt: DS.attr('moment')
  allDay: DS.attr 'boolean'
  employee: DS.belongsTo 'employee'
}

`export default Scheduling`
