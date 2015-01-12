`import tablearized from 'clockwork/utils/tablearized'`

module 'tablearized'

# Replace this with your real tests.
test 'it works', ->
  result = tablearized 'content',
    x: ['startsAt', (v)-> moment(v).format('dd')], # weekday
    y: ['team', 'name'],
  ok result

  # rest tested in integration with component for now
