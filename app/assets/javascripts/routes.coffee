App.Router.reopen
  location: 'history'
  rootURL: '/'

App.Router.map ->
  @resource 'users', ->
    @route 'new'


App.IndexRoute = Ember.Route.extend
  setupController: (controller, model) ->
    @controllerFor('application').set('currentRoute', 'home')

App.UsersIndexRoute = Ember.Route.extend
  model: ->
    App.User.find()
  setupController: (controller, model) ->
    @controllerFor('application').set('currentRoute', 'users')