"use strict"

SubClass = require "../utilities/SubClass"

module.exports = class Sections extends SubClass

	init: ->

		@.lastDetection = new Date().getTime()
		@.getElements()
		@.addListeners()
		@.onShow @.pages[0]

	getElements: ->

		@.pages = document.querySelectorAll "section"

	addListeners: ->

		self = @

		for page in @.pages
			page.addEventListener "scroll", @.onScroll
			page.lastScroll = page.scrollTop
			page.onShow = ->
				self.onShow @

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

	onShow: ( page ) =>

		images = page.querySelectorAll ".image-element"
		for image in images
			if image.classList.contains( "image-created" ) isnt true
				image.classList.add "image-created"
				img = document.createElement "img"
				img.setAttribute "width", image.getAttribute "data-width"
				img.setAttribute "height", image.getAttribute "data-height"
				img.onload = ->
					@.parentNode.classList.add "image-loaded"
				image.appendChild img
				img.setAttribute "src", image.getAttribute "data-src"