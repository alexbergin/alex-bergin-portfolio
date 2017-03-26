"use strict"

PIXI = require "pixi.js"

module.exports =

	box: ( fill, density ) ->

		if density > 1 then density *= 0.75
		
		scale = 500 / ( 1.5 * ( density ))
		graphics = new PIXI.Graphics()

		graphics.beginFill fill
		graphics.drawRect -0.125 * scale, -0.5 * scale, 0.25 * scale, 1 * scale
		graphics.endFill()

		container = new PIXI.Container
		container.addChild graphics

		return container

	circle: ( fill, density ) ->

		if density > 1 then density *= 0.75

		scale = 150 / ( 1.5 * ( density ))
		graphics = new PIXI.Graphics()

		graphics.beginFill fill
		graphics.drawCircle 0, 0, 1 * scale
		graphics.endFill()

		container = new PIXI.Container
		container.addChild graphics

		return container

	cross: ( fill, density ) ->

		if density > 1 then density *= 0.75

		scale = 400 / ( 1.5 * ( density ))
		graphics = new PIXI.Graphics()

		graphics.beginFill fill
		graphics.drawRect -0.4 * scale, -0.125 * scale, 0.8 * scale, 0.25 * scale
		graphics.drawRect -0.125 * scale, -0.4 * scale, 0.25 * scale, 0.8 * scale
		graphics.endFill()

		container = new PIXI.Container
		container.addChild graphics

		return container