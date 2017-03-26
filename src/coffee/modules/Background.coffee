"use strict"

Colors = require "../utilities/Colors"
Shapes = require "../utilities/Shapes"
SubClass = require "../utilities/SubClass"
PIXI = require "pixi.js"
Promise = require "promise-polyfill"
anime = require "animejs"

if not window.Promise? then window.Promise = Promise
PIXI.utils.skipHello()

module.exports = class Background extends SubClass

	width: window.innerWidth
	height: window.innerHeight
	density: window.devicePixelRatio or 1
	colors: [ Colors.red, Colors.green, Colors.blue, Colors.yellow ]
	options:
		shapes: 16
		scale: 1

	init: ->

		@.makeApp()
		@.makeShapes()
		@.addListeners()
		@.onResize()
		@.render()

	makeApp: ->

		canvas = document.querySelector "canvas"
		@.globalVel =
			x: 0
			y: 0
		@.app = new PIXI.Application @.width, @.height,
			view: canvas
			resolution: @.density
		@.app.renderer.backgroundColor = Colors.white

	makeShapes: ->

		types = []

		for shape of Shapes
			types.push shape

		@.shapes = []
		while @.shapes.length < @.options.shapes
			type = types[ Math.floor( Math.random() * types.length )]
			fill = @.colors[ Math.floor( Math.random() * @.colors.length )]
			shape = Shapes[type] fill, @.density
			@.app.stage.addChild shape
			angle = Math.random() * 360 * ( Math.PI / 180 )
			power = 0.5 + Math.random()
			shape.velocity =
				x: Math.sin( angle ) * power
				y: Math.cos( angle ) * power
				r: Math.random() * 0.05 - 0.025
			shape.position.x = ( @.width + 1000 ) * Math.random() - 500
			shape.position.y = ( @.height + 1000 ) * Math.random() - 500
			@.shapes.push shape

	addListeners: ->

		window.addEventListener "resize", @.onResize

	onResize: =>

		@.width = window.innerWidth
		@.height = window.innerHeight

		@.app.renderer.resize @.width, @.height

		@.app.renderer.view.setAttribute "width", @.width * @.density
		@.app.renderer.view.setAttribute "height", @.height * @.density

		@.app.renderer.view.style.width = "#{@.width * @.density}px"
		@.app.renderer.view.style.height = "#{@.height * @.density}px"

		for prefix in [ "webkitTransform", "mozTransform", "msTransform", "transform" ]
			@.app.renderer.view.style[prefix + "Origin"] = "top left"
			@.app.renderer.view.style[prefix] = "scale(#{1/@.density})"

	setGlobalAcceleration: ( x, y ) =>

		@.globalVel.x += x
		@.globalVel.y += y
		
	render: =>

		requestAnimationFrame @.render
		@.physicis()
		@.app.render()

	randomizeColor: ( shape ) ->

		color = @.colors[ Math.floor( Math.random() * @.colors.length )]

		for graphic in shape.children
			graphic.tint = color

	physicis: ->

		for shape in @.shapes

			shape.position.x += shape.velocity.x + @.globalVel.x
			shape.position.y += shape.velocity.y + @.globalVel.y
			shape.children[0].rotation += shape.velocity.r

			if shape.children[0].rotation > 360 then shape.children[0].rotation -= 360
			if shape.children[0].rotation < 0 then shape.children[0].rotation += 360

			wrapped = false

			if shape.position.x < -200
				shape.position.x = @.width + 200
				wrapped = true

			if shape.position.x > @.width + 200
				shape.position.x = -200
				wrapped = true
				
			if shape.position.y < -200
				shape.position.y = @.height + 200
				wrapped = true
				
			if shape.position.y > @.height + 200 
				shape.position.y = -200
				wrapped = true
				
			if wrapped then @.randomizeColor shape

		if Math.abs( @.globalVel.x ) > 0.01
			@.globalVel.x *= 0.97
		else @.globalVel.x = 0

		if Math.abs( @.globalVel.y ) > 0.01
			@.globalVel.y *= 0.97
		else @.globalVel.y = 0
