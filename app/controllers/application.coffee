`import Ember from 'ember'`

ApplicationController = Ember.Controller.extend
  # keep the beta param that rails needs to present the ember app to the user.
  # Will be ignored by us.
  queryParams: ['beta']
  beta: null

`export default ApplicationController`
