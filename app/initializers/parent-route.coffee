# Takes two parameters: container and app
initialize = () ->
  Ember.Route.reopen
    parentRoute: Em.computed ->
      r = @router.router
      if r.currentTransition
        handlerInfos = r.currentTransition.state.handlerInfos
      else
        handlerInfos = r.state.handlerInfos

      handlerInfos = this.router.router.state.handlerInfos
      return unless handlerInfos

      parent = @
      for info in handlerInfos
        break if info.handler == @
        parent = info.handler
      parent

    parentRouteName: Em.computed.alias('parentRoute.routeName')

    parentController: ->
      @controllerFor @get('parentRouteName')

    parentModel: ->
      @modelFor @get('parentRouteName')

  # app.register 'route', 'foo', 'service:foo'

ParentRouteInitializer =
  name: 'parent-route'
  initialize: initialize

`export {initialize}`
`export default ParentRouteInitializer`
