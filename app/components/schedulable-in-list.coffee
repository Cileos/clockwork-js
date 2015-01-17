`import Ember from 'ember'`

SchedulableInListComponent = Ember.Component.extend
  content: null
  tagName: 'li'
  classNames: ['scheduling']
  classNameBindings: ['teamColorClass']
  teamColorClass: Ember.computed 'content.team', ->
    "team_#{@get 'content.team.id'}"

`export default SchedulableInListComponent`
