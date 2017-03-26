"use strict"

SubClass = require "../utilities/SubClass"

module.exports = class Sections extends SubClass

	init: ->

		@.lastDetection = new Date().getTime()
		@.getElements()
		@.addListeners()

	getElements: ->

		@.pages = document.querySelectorAll "section"

	addListeners: ->

		for page in @.pages
			page.addEventListener "scroll", @.onScroll
			page.lastScroll = page.scrollTop

	onScroll: ( e ) =>

		now = new Date().getTime()
		if now - @.lastDetection > 10
			page = e.target
			@.lastDetection = now
			distance = page.scrollTop - page.lastScroll
			page.lastScroll = page.scrollTop
			vel = -distance / 25
			if vel > 0 then vel = Math.min( vel, 6 )
			else vel = Math.max( vel, -6 )
			@.root.background.setGlobalAcceleration 0, vel

