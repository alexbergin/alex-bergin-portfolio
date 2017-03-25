"use strict"

SubClass = require "../utilities/SubClass"
PIXI = require "pixi.js"
Promise = require "promise-polyfill"

if not window.Promise? then window.Promise = Promise
PIXI.utils.skipHello()

module.exports = class Background extends SubClass

	init: -> return