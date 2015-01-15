`import { test, moduleForModel } from 'ember-qunit'`

moduleForModel 'scheduling', 'Scheduling', {
  # Specify the other units that are required for this test.
  needs: ['model:team', 'model:employee']
}

test 'it exists', ->
  model = @subject()
  # store = @store()
  ok !!model
