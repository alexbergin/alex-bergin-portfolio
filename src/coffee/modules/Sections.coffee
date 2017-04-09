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
			page.onHidden = ->
				self.onHidden @

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

		frames = page.querySelectorAll ".iframe-element"
		for frame in frames
			if frame.classList.contains( "frame-created" ) isnt true

				desktopOnly = frame.getAttribute "desktop-only"
				frame.classList.add "frame-created"

				canMake = true
				if desktopOnly is "true" and typeof window.ontouchstart isnt "undefined"
					canMake = false

				if canMake
					element = document.createElement "iframe"
					
					width = frame.getAttribute "data-width"
					height = frame.getAttribute "data-height"

					ratio = "#{height / width * 100}%"
					frame.style.paddingBottom = ratio

					element.setAttribute "width", width
					element.setAttribute "height", height
					element.setAttribute "frameborder", 0
					element.setAttribute "scrolling", "no"

					frame.appendChild element
					element.setAttribute "src", frame.getAttribute "data-src"

	onHidden: ( page ) =>

		frames = page.querySelectorAll ".iframe-element"
		for frame in frames
			frame.classList.remove "frame-created"
			element = frame.querySelector "iframe"
			element?.parentNode.removeChild element

	onResize: =>

		elements = document.querySelectorAll ".full-height"
		for element in elements
			element.style.height = "#{window.innerHeight}px"