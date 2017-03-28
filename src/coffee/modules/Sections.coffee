"use strict"

SubClass = require "../utilities/SubClass"

module.exports = class Sections extends SubClass

	init: ->

		@.getElements()
		@.addListeners()

	getElements: ->

		@.pages = document.querySelectorAll "section"

	addListeners: ->

		self = @

		for page in @.pages
			page.onShow = ->
				self.onShow @

		window.addEventListener "resize", @.onResize
		@.onResize()

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

	onResize: =>

		elements = document.querySelectorAll ".full-height"
		for element in elements
			element.style.height = "#{window.innerHeight}px"