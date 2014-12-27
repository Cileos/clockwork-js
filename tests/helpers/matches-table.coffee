# this only works when using start-app, but not in component tests :(
# meanwhile. we develop it in calendar-teams-over-week-test
customHelper = Ember.Test.registerHelper 'matchesTable', ($ele, line_sel, col_sel, stringy_expected)->
  equal "foo", "bar", "foo is not bar"

`export default customHelper;`
