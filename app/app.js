import Ember from 'ember';
import Resolver from 'ember/resolver';
import loadInitializers from 'ember/load-initializers';
import config from './config/environment';

Ember.MODEL_FACTORY_INJECTIONS = true;

var App = Ember.Application.extend({
  modulePrefix: config.modulePrefix,
  podModulePrefix: config.podModulePrefix,
  Resolver: Resolver
});

loadInitializers(App, config.modulePrefix);

export default App;

/*
* Routes
*
* / => dashboard, with 1) team week of own schedulings 2) switchable to month
* /month/:year/:month => my schedulings for <month> <year>
* /week/teams/:cwyear/:week => my schedulings for calendar week <week> in <cwyear> in teams view
* /week/organizations/:cwyear/:week => my schedulings for calendar week <week> in <cwyear> with Org as y
* /week/plans/:cwyear/:week => my schedulings for calendar week <week> in <cwyear> with Plan (+Org) as y
* /organization/:organiation_id/ => ?
* /organization/:organiation_id/month/:year/:month => schedulings of Org I may see (or edit)
* /organization/:organiation_id/week/teams/:cwyear/:week => schedulings of Org I may see (or edit) in teams view
* /organization/:organiation_id/week/employees/:cwyear/:week => schedulings of Org I may see (or edit) in employees view
*
* scoped to plan
* /organization/:organiation_id/plan/:plan_id/month/:year/:month
* etc
*
* in any of the above calendar scopes
* /month/:year/:month/schedulings/:scheduling_id/edit that uses SchedulingsEditRoute when @resource('schedulings', ->..) is used
* < ModalRoute to open a modal. We can link-to 'edit', scheduling to this and return to parent later
*
* How should we implement the time-scoping params (:year, :week, :month, :cwyear)?
*
*   1) As route params and outlet based rendering
*   Pro
*     * the ember way (less HACKery)
*     * fetching/filtering possible in route/controller
*     * "loading" state right build in if wanted
*     * slideIn/Out may be very easy with Route#willTransition etc
*   Contra
*     * calendar is re-inserted even when just changing weeks
*     * switching away from dashboard may feel awkward because other widgets might disappear
*     * if we want "loading" for the fetch, we have to wait for the new component to appear
*     * when loading here, fast flicking would not be possible
*       (expect when querying the cache in Route#model and fetch in the background when length>1
*
*   Implementation Help
*
*     * Route#viewName/templateName/controllerName to easily reuse/inherit routes
*
*   2) As query params
*   Pro
*     * the calendar component can react to the changes of time-scope
*     * easier to link to the same week but other view (not really, just feels nicer, I guess)
*     * a component is independent of its surroundings (except the params)
*     * can also be reacted to by routes thx to option refreshModel
*
*   Contra
*     * polluting the route with query params (ugly)
*     * fetching&filtering would be easier to put into components (may be Pro)
*
*
*  GOOGLE How do queryParams behave to same-named route params?
*
*
*  GOOGLE Howto Modal?
*  * details/edit scheduling
*  * read/write comments
*  * show/edit milestone
*  * etc.
*
*    extra outlet?
*      * no route for it :/
*      * yes, we can have a ModalRoute to inherit from that renders into that outlet
*      * give the outlet a view
*         {{outlet view='modalContainer'}}
*      * which has a layout containing all the modal div-crap
*      * knows the view/outlet that it was rendered/disconnected to run the extra JS to show/hide?
*        * didInsertElement, willRemoveElement
*      * we are in route. so no problem to transitionTo $parentRoute #hope when `save` action is called
*      * so there should be a SchedulingsEditRoute that is used several times. can we specify the route class?
*         * nope. so we just stub-inherit.
*         * we just use @resource instead of route to reuse the route and everything else
*
*  GOOGLE HowTo cursor? where?
*    * queryParams for state (or URI) with replaceRoute
*    * must go through DOM???
*    * or traverse through tablearized (must be loaded)
*    * aremovements actions?
*    * where to "store"? global/in any controller?
*
*  Flicking through calendar from the header?
*  Naah, then cursor must be allowed in there (is this bad?)
*  This way we could also navigate to day-view by focussing the day header + [ENTER]/other keypress
*  For now, ctrl + pageUp/pageDown from cursor
*
*
*  What about beautyful URLs?
*  Two organizations must be allowed to use the same name for each one of their plans
*  Store does not scope ids by parent (org)
*
*  TODO do not use historylocation to avoid having to respond with ember(beta) from all URIs in Rails
*  TODO i18n from rails?
*  TODO no root div (application) to make the div-hating designer happy?
*/
