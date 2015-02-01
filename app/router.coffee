`import Ember from 'ember'`
`import config from './config/environment'`
 
Router = Ember.Router.extend
  location: config.locationType

Router.map ->
  @route 'dashboard', ->
    @resource 'scheduling', path: 'scheduling/:scheduling_id', ->
      @route 'edit'

`export default Router`
