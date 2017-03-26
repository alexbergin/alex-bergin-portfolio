"use strict"

PIXI = require "pixi.js"

module.exports =

	box: ( fill, density ) ->

		if density > 1 then density *= 0.75

		scale = 500 / ( 1.5 * ( density ))
		graphics = new PIXI.Graphics()

		graphics.beginFill 0xffffff
		graphics.drawRect -0.125 * scale, -0.5 * scale, 0.25 * scale, 1 * scale
		graphics.endFill()
		graphics.tint = fill

		container = new PIXI.Container
		container.addChild graphics

		return container

	circle: ( fill, density ) ->

		if density > 1 then density *= 0.75

		scale = 150 / ( 1.5 * ( density ))
		graphics = new PIXI.Graphics()

		graphics.beginFill 0xffffff
		graphics.drawCircle 0, 0, 1 * scale
		graphics.endFill()
		graphics.tint = fill

		container = new PIXI.Container
		container.addChild graphics

		return container

	cross: ( fill, density ) ->

		if density > 1 then density *= 0.75

		scale = 400 / ( 1.5 * ( density ))
		graphics = new PIXI.Graphics()

		graphics.beginFill 0xffffff
		graphics.drawRect -0.4 * scale, -0.125 * scale, 0.8 * scale, 0.25 * scale
		graphics.drawRect -0.125 * scale, -0.4 * scale, 0.25 * scale, 0.8 * scale
		graphics.endFill()
		graphics.tint = fill

		container = new PIXI.Container
		container.addChild graphics

		return container

	triangle: ( fill, density ) ->

		if density > 1 then density *= 0.75

		scale = 175 / ( 1.5 * ( density ))
		graphics = new PIXI.Graphics()
		p = 0
		t = 3
		while p < t
			angle = 360 / t * p * ( Math.PI / 180 )
			radius = scale
			x = Math.sin( angle ) * radius
			y = Math.cos( angle ) * radius
			if p is 0
				graphics.moveTo x, y
				graphics.beginFill 0xffffff
			else graphics.lineTo x, y
			p++
		graphics.closePath()
		graphics.endFill()
		graphics.tint = fill

		container = new PIXI.Container
		container.addChild graphics

		return container