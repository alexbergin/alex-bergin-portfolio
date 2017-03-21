Router = require "./modules/Router"

class Site

	constructor: ->

		@.router = new Router @

new Site