"use strict"

Background = require "./modules/Background"
Navigation = require "./modules/Navigation"
Router = require "./modules/Router"
Sections = require "./modules/Sections"

class Site

	constructor: ->

		@.router = new Router @
		@.navigation = new Navigation @
		@.background = new Background @
		@.sections = new Sections @

window.Site = new Site