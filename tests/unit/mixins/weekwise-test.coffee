`import Ember from 'ember'`
`import WeekwiseMixin from 'clockwork/mixins/weekwise'`

module 'WeekwiseMixin'

# Replace this with your real tests.
test 'it works', ->
  WeekwiseObject = Ember.Object.extend WeekwiseMixin
  subject = WeekwiseObject.create()
  ok subject
