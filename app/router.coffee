`import Ember from 'ember'`
`import config from './config/environment'`
 
Router = Ember.Router.extend
  location: config.locationType

Router.map ->
  @resource 'scheduling', path: 'scheduling/:scheduling_id', ->
    @route 'edit'

`export default Router`
