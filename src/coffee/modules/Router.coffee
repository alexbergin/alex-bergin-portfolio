"use strict"

SubClass = require "../utilities/SubClass"

module.exports = class Router extends SubClass

	init: ->

		@.getElements()
		@.addListeners()
		@.render()

	getElements: ->

		@.sections = document.querySelectorAll "section"

	addListeners: ->

		window.addEventListener "hashchange", @.render

	render: =>

		route = window.location.hash
		rendered = false

		if route is "" then route = "#/"

		for section in @.sections
			if route is section.getAttribute "data-route"
				rendered = true
				@.show section
			else
				@.hide section

		if not rendered then window.location.hash = ""

	show: ( section ) ->

		section.classList.add "displayed"
		section.onShow? section

		clearTimeout section.renderTimer
		section.renderTimer = setTimeout =>
			section.classList.add "visible"
		, 30


	hide: ( section ) ->

		section.classList.remove "visible"
		section.onHide? section

		clearTimeout section.renderTimer
		section.renderTimer = setTimeout =>
			section.onHidden? section
			section.scrollTop = 0
			section.classList.remove "displayed"
		, 250