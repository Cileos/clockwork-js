`import Ember from 'ember'`

ApplicationController = Ember.Controller.extend
  # keep the beta param that rails needs to present the ember app to the user.
  # Will be ignored by us.
  queryParams: ['beta']
  beta: null

  # Only contains the teams loaded on the side, for
  # example by being included in /schedulings
  loadedTeams: Ember.computed 'store', ->
    @get('store').all 'team'

`export default ApplicationController`
