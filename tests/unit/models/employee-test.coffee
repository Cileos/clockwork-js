`import { test, moduleForModel } from 'ember-qunit'`

moduleForModel 'employee', 'Employee', {
  # Specify the other units that are required for this test.
  needs: [
    'model:account'
  ]
}

test 'it exists', ->
  model = @subject()
  # store = @store()
  ok !!model
