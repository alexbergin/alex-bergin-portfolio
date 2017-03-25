"use strict"

Background = require "./modules/Background"
Navigation = require "./modules/Navigation"
Router = require "./modules/Router"

class Site

	constructor: ->

		@.router = new Router @
		@.navigation = new Navigation @
		@.background = new Background @

window.Site = new Site