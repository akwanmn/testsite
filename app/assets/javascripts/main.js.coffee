#main.coffee

#= require modernizr
#= require jquery
#= require handlebars
#= require ember
#= require ember-data
#= require bootstrap
#= require_self
#= require ./v1/lounge
#= require ./v1/routes
#= require_tree ./v1/controllers
#= require_tree ./v1/models
#= require_tree ./v1/templates
#= require_tree ./v1/views

window.App = Ember.Application.create()