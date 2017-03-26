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
				rendered = section
			else
				@.hide section

		if rendered is false then window.location.hash = ""
		else @.show rendered

	show: ( section ) ->

		clearTimeout section.renderTimer
		section.renderTimer = null
		section.classList.remove "not-visible"
		section.onShow? section
		requestAnimationFrame => section.classList.add "visible"


	hide: ( section ) ->

		section.classList.remove "visible"
		section.onHide? section

		if section.renderTimer is null
			section.renderTimer = setTimeout =>
				section.renderTimer = null
				section.onHidden? section
				section.lastScroll = 0
				section.scrollTop = 0
				section.classList.add "not-visible"
			, 400