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
		@.menu = document.querySelector "menu"

	addListeners: ->

		@.nextButton.addEventListener "click", => @.step 1
		@.previousButton.addEventListener "click", => @.step -1
		@.menuButton.addEventListener "click", @.toggleMenu

		if window.ontouchstart is null
			document.querySelector("html").classList.add "is-touch"

	toggleMenu: =>

		if @.menu.classList.contains( "open" ) then @.closeMenu()
		else @.openMenu()

	openMenu: ->

		if @.menu.classList.contains( "open" ) isnt true
			clearTimeout @.closeTimer
			@.menu.classList.add "open"
			if window.innerWidth <= 500
				@.root.background.setGlobalAcceleration 0, -9
			else
				@.root.background.setGlobalAcceleration 9, 0

	closeMenu: ->

		if @.menu.classList.contains( "open" ) is true
			@.menu.classList.remove "open"
			if window.innerWidth <= 500
				@.root.background.setGlobalAcceleration 0, 9
			else
				@.root.background.setGlobalAcceleration -9, 0

	step: ( direction ) ->

		current = document.querySelector "section.visible"
		index = 0

		for page, i in @.pages
			if page is current then index = i
		index += direction
		i = index

		if index > @.pages.length - 1 then index = @.pages.length - 1
		if index < 0 then index = 0

		if i is index then @.root.background.setGlobalAcceleration 8 * -direction, 0

		hash = @.pages[index].getAttribute "data-route"
		window.location.hash = hash