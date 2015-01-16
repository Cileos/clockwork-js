`import DS from 'ember-data'`

Employee = DS.Model.extend {
  name: DS.attr 'string'
  account: DS.belongsTo('account')
}

`export default Employee`
