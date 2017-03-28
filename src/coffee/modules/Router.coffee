"use strict"

SubClass = require "../utilities/SubClass"

module.exports = class Router extends SubClass

	init: ->

		@.getElements()
		@.addListeners()

		requestAnimationFrame =>
			@.render()

	getElements: ->

		@.sections = document.querySelectorAll "section"
		@.links = document.querySelectorAll "menu a"
		@.wrapper = document.querySelector "main"

	addListeners: ->

		window.addEventListener "hashchange", @.render

	render: =>

		route = window.location.hash
		rendered = false

		if route is "" then route = "#/"
		index = null

		for section, i in @.sections
			if route is section.getAttribute "data-route"
				rendered = section
				index = i
			else
				@.hide section

		for link in @.links
			if route is link.getAttribute "href"
				link.classList.add "selected"
			else
				link.classList.remove "selected"

		@.wrapper.classList.remove "first-page-visible"
		@.wrapper.classList.remove "last-page-visible"

		if index is 0 then @.wrapper.classList.add "first-page-visible"
		if index is @.sections.length - 1 then @.wrapper.classList.add "last-page-visible"

		if rendered is false then window.location.hash = ""
		else @.show rendered

		if @.root.navigation?
			clearTimeout @.root.navigation.closeTimer
			@.root.navigation.closeTimer = setTimeout =>
				@.root.navigation.closeMenu()
			, 350

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