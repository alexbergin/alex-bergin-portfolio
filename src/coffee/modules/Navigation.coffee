"use strict"

SubClass = require "../utilities/SubClass"

module.exports = class Navigation extends SubClass

	init: ->

		@.getElements()
		@.addListeners()

	getElements: ->

		@.nextButton = document.querySelector "button.next-page"
		@.previousButton = document.querySelector "button.previous-page"
		@.menuButton = document.querySelector "button.toggle-menu"
		@.pages = document.querySelectorAll "section"

	addListeners: ->

		@.nextButton.addEventListener "click", => @.step 1
		@.previousButton.addEventListener "click", => @.step -1
		@.menuButton.addEventListener "click", =>
			document.querySelector("menu").classList.toggle "open"

	step: ( direction ) ->

		current = document.querySelector "section.visible"
		index = 0

		for page, i in @.pages
			if page is current then index = i
		index += direction

		if index > @.pages.length - 1 then index = @.pages.length - 1
		if index < 0 then index = 0

		hash = @.pages[index].getAttribute "data-route"
		window.location.hash = hash