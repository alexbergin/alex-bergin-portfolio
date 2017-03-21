"use strict"

# extend this class to pass the app context along to @.root
# send any extra data needed when initializing in
# the second parameter

module.exports = class SubClass

	constructor: ( parent , data ) ->

		# save context
		@.parent = parent

		if @.parent.root? then @.root = @.parent.root 
		else @.root = @.parent

		# tell the subclass to setup with init if this
		# funtion is available
		@.init? data