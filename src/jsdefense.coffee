# Nick Arnold
# 1.7.2013
#
# jsdefense.coffee

class Renderable

	load : (game) ->
		game.register(this.getId(), this)

	render : ->
		console.log("render base!")

	raise : (msg) ->
		throw new Error(msg)

	getId : ->		
		@raise("getId is abstract on Renderable")

	draw : ->
		false

	update : ->
		false

# Tile Class
class Tile extends Renderable
	constructor : ({@x, @y, @color, @entrance, @exit, @cls}) ->
		@id = this.getId()

	clickHandle : ->
		if (@cls == 'grass')
			@getEl().removeClass(@cls)
			@cls = 'hole'
			@getEl().addClass(@cls)

	render : (el, append)->
		fn = (err, out) ->
			el.innerHTML += out
			@el = document.getElementById()					
			console.log(this)
			if (!document.getElementById(this.getId()))
				console.log("failed")

	getEl : ->
		$('#' + @getId())

	getId : ->
		@x + '_' + @y

	loadEl : (el) ->
		@el = el
		this.onRender()

	update : ->
		false

	draw : ->
		false

	onRender : () ->
		if (@el)
			me = this
			@el.addEventListener("click", (p) -> me.clickHandle())

	isEntrance : ->
		@entrance

	isExit : ->
		@exit

class Map extends Renderable
	constructor : ->
		this.tiles = new Array(0)

	getTileDefinitions : ->
		@raise("getTileDefinitions is abstract on Map")

	getId : ->
		@raise("getId is abstract on Map")

	load : (game) ->
		for i in this.getTileDefinitions()
			for j in i
				j.x = _j
				j.y = _i
				t = new Tile(j)

				# initialize entrance/exit
				if (t.isEntrance())
					console.log('entrance set')
					@entrance = t
				else if (t.isExit())
					@exit = t

				t.load(game)	
				@tiles.push(t)
		super game

	render : (el) ->
		me = this
		fn = (err, out) ->
			el.innerHTML += out
			for t in me.tiles
				t.loadEl(document.getElementById(t.getId()))			
		dust.render("map", {tiles:@tiles}, fn)

	getEntrance : ->
		@entrance

	getExit : ->
		@exit

class BasicMap extends Map
	getTileDefinitions : ->
		MAPS.Basic.tiles

	getId : ->
		'map.basic'

class Creep extends Renderable
	constructor : ({@name, @velocity}) ->
		if (!@velocity)
			@velocity = 0.5
		@left = 0#152-24
		@top = 0#144
		@el = $("#creepcave") # just a place for them to spawn		

	render : () ->

		if (@getEl().length) 
			@getEl().offset({ top : this.top, left : this.left })		
		else
			self = this
			fn = (err, out) ->
				self.el[0].innerHTML += out

			this.id = @getId()
			dust.render("creep", this, fn)

	load : (game, map) ->
		if (map.getEntrance())
			pos = map.getEntrance().getEl().position()
			@left = pos.left
			@top  = pos.top	
		super game

	getEl : ->
		$('#' + @getId())

	getId : ->
		return 'creep_' + @name

	update : ->
		@left += @velocity

	draw : ->
		@render()

class CreepFactory

	breed : (options)->
		console.log('Created creep with name: ' + options.name)
		new Creep(options)

class Game
	constructor : (@elID) ->
		this.fps = 60
		this.renderables = {}

	initialize : ->

		# Debug
		window.Game = this

		# Initialize a Map
		@map = new BasicMap()
		@map.load(this)
		@map.render(document.getElementById(@elID))		

		@cf = new CreepFactory()

		# Instantiate our special Creep Hank
		hank = @cf.breed({name : 'Hank'})
		hank.load(this, @map)	

		console.log("Plays best at 200% zoom.")

	register : (id, renderable) ->
		@renderables[id] = renderable

	unregister : (id) ->
		if (@renderables[id])
			@renderables[id] = undefined

	spawn : ->
		c = @cf.breed({name : this.genID()})
		c.load(this, @map)
		c

	draw : ->
		for own k,v of @renderables
			if (v.draw)
				v.draw()

	update : ->
		for own k,v of @renderables
			if (v.update)
				v.update()

	genID : ->
		text = ""
		set = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"

		for i in [0..5]
			text += set.charAt(Math.floor(Math.random() * set.length))

		text

	start : ->
		if (@_intervalId)
			return

		self = this

		spawn = ->
			c = self.cf.breed({name : self.genID()})
			c.load(self, self.map)

		run = ((game) ->
			loops = 0
			skipTicks = (1000 / game.fps)
			nextGameTick = (new Date).getTime()

			->
				loops = 0
				while ((new Date).getTime() > nextGameTick)
					game.update()
					nextGameTick += skipTicks
					loops++

				game.draw()
		)(this)

		console.log("Starting game")
		@_intervalId = setInterval(run, 0)
		@_spawnId = setInterval(spawn, 500)

	pause : ->

	save : ->

	stop : ->
		if (this._intervalId)
			console.log("Stopping game")
			clearInterval(this._intervalId)
			this._intervalId = null
		if (this._spawnId)
			clearInterval(this._spawnId)
			this._spawnId = null

$(document).ready(-> 
	game = new Game('battlefield')
	game.initialize()
)