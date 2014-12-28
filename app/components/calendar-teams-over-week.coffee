`import Ember from 'ember'`

Wrap = Ember.ObjectProxy.extend
  startHour: Ember.computed 'startsAt', ->
    moment( @get('startsAt') ).hour()

Component = Ember.Component.extend
  tagName: 'table'
  content: []
  decoratedContent: Ember.computed.map 'content', (item, index)->
    Wrap.create content: item

`export default Component`

