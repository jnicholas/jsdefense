# Nick Arnold
# 1.7.2013
#
# jsdefense.coffee

class Renderable

	load : (game) ->
		game.register(@getId(), this)
		@game = game

	unload : ->
		if (@game)
			@game.unregister(@getId())

	render : ->
		console.log("render base!")

	raise : (msg) ->
		throw new Error(msg)

	getId : ->		
		@raise("getId is abstract on Renderable")

	draw : false

	update : false

class Tile extends Renderable

	constructor : ({@x, @y, @color, @entrance, @exit, @cls}) ->
		@id = this.getId()

	clickHandle : ->
		if (@cls == 'grass')
			@getEl().removeClass(@cls)
			@cls = 'hole'
			@getEl().addClass(@cls)

	getEl : ->
		$('#' + @getId())

	getId : ->
		@x + '_' + @y

	loadEl : (el) ->
		@el = el
		this.onRender()

	update : false

	draw : false

	onRender : ->
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
					@entrance = t
				else if (t.isExit())
					@exit = t

				t.load(game)	
				@tiles.push(t)

		super game

	render : (el) ->
		fn = (err, out) =>
			el.innerHTML += out
			for t in @tiles
				t.loadEl(document.getElementById(t.getId()))			
		dust.render("map", {tiles:@tiles}, fn)
		@bindDragEvents(@game.elID)

	getEntrance : ->
		@entrance

	getExit : ->
		@exit

	addTower : (options) ->
		@game.tf.create(options);

	bindDragEvents : (id) =>
		# I have to define all of the drag callbacks here with fat arrows otherwise they 
		# dont seem to have the correct scope. I think there's a better solution.
		preventDefaults = (e) =>
			e.stopPropagation()
			e.preventDefault()

		dragStartEvent = (e) =>
			e.originalEvent.dataTransfer.setData('tower', e.target.id)

		dragEnterOrLeaveEvent = (e) =>
			# Only prevent defaults if the cell isn't an entrance or exit, this
			# disables the from being able to place towers on them.
			if(e.target.id != @getExit().id && e.target.id != @getEntrance().id)
				preventDefaults e

		dragOverEvent = (e) =>
			# Only prevent defaults if the cell isn't an entrance or exit, this
			# disables the from being able to place towers on them.
			if(e.target.id != @getExit().id && e.target.id != @getEntrance().id)
				preventDefaults e

		dropEvent = (e) =>
			preventDefaults e
			towerType = e.originalEvent.dataTransfer.getData('tower')
			targetTile = e.target.id
			@addTower {type: towerType, target: targetTile}

		mapEl = $('#' + id);
		cells = mapEl.find('td .grass');
		menuTowers = $('.tower-menu .tower')
			
		menuTowers.bind 'dragstart', dragStartEvent
		cells.bind 'drop', dropEvent
		cells.bind 'dragenter dragleave', dragEnterOrLeaveEvent
		cells.bind 'dragover', dragOverEvent


class BasicMap extends Map

	getTileDefinitions : ->
		MAPS.Basic.tiles

	getId : ->
		'map.basic'

class Tower extends Renderable

	constructor : (@tileX, @tileY) ->

	render : ->
		if(@getEl().length == 0)
			afterRender = (err, out) =>
				if(err)
					@raise(err)
				else
					@el[0].innerHTML += out
					@getEl().bind('click', ->
						console.log 'tower clicked'
					)

			@id = @getId()

			dust.render("tower", this, afterRender)

	getEl : ->
		$('#' + @getId())

	getId : ->
		'tower_' + @name

	hasTarget : ->
		return !(@target == null)

	findTarget : ->
		console.log 'Finding target to attack'

	attackTarget : ->
		if(@target)
			console.log "attacking target " + @target
		else
			console.log "no target to attack :("

class GunTower extends Tower

class FreezeTower extends Tower

class RocketTower extends Tower

class TeleportTower extends Tower

class TowerFactory

	create : (options) ->
		if(options.type)
			if(options.type == 'gunTower')
				return new GunTower(options)
			if(options.type == 'freezeTower')
				return new FreezeTower(options)
			if(options.type == 'rocketTower')
				return new RocketTower(options)
			if(options.type == 'teleportTower')
				return new TeleportTower(options)

class Creep extends Renderable

	constructor : ({@name, @velocity}) ->
		if (!@velocity)
			@velocity = 0.5
		@left = 0
		if (!@top)
			@top = 0
		@el = $("#creepcave") # just a place for them to spawn		

	render : ->
		if (@getEl().length) 
			@getEl().offset({ top : this.top, left : this.left })	
		else
			fn = (err, out) =>
				@el[0].innerHTML += out
				@getEl().live('click', =>
					@kill()
				)

			this.id = @getId()
			dust.render("creep", this, fn)

	load : (game, map) ->
		if (map.getEntrance())
			pos = map.getEntrance().getEl().position()
			@left = pos.left
			@leftstart = @left
			@top  += pos.top	
		super game

	kill : ->
		@unload()
		@getEl().die()
		@getEl().remove() # remove from dom
		@getEl().empty() # jquery caching
		delete this

	getEl : ->
		$('#' + @getId())

	getId : ->
		'creep_' + @name

	update : ->
		if ((@left + @velocity) > (@leftstart + (24*20))) # need to check for exit
			@kill()
		else
 			@left += @velocity		

	draw : ->
		@render()

class Soldier extends Creep

	constructor : ({@name}) ->
		@velocity = 0.8
		@cls = 'soldier'
		super this

class Tank extends Creep

	constructor : ({@name}) ->
		@velocity = 0.5
		@cls = 'tank'
		super this

class Plane extends Creep

	constructor : ({@name}) ->
		@velocity = 2
		@top = -8
		@cls = 'plane'

		super this		

class CreepFactory

	breed : (options)->
		if (options.type)
			if (options.type == 'plane')
				return new Plane(options)
			if (options.type == 'tank')
				return new Tank(options)
			if (options.type == 'soldier')
				return new Soldier(options)

		# make soldier the default for now
		new Soldier(options)

class Game

	constructor : (@elID) ->
		this.fps = 60
		@_spawntime = 500
		this.renderables = {}

	initialize : ->

		# Debug
		window.Game = this

		# Initialize a Map
		@map = new BasicMap()
		@map.load(this)
		@map.render(document.getElementById(@elID))

		@cf = new CreepFactory()
		@tf = new TowerFactory()

		# Instantiate our special Creep Hank
		hank = @cf.breed({name : 'Hank', type : 'soldier'})
		hank.load(this, @map)

	register : (id, renderable) ->
		@renderables[id] = renderable

	unregister : (id) ->
		if (@renderables[id])
			@renderables[id] = undefined
			delete @renderables[id]

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
		@doSpawn()		

	doSpawn : =>
		@stopSpawn()
		@_spawnId = setInterval(@spawn, @_spawntime)

	stopSpawn : =>
		if (this._spawnId)
			clearInterval(this._spawnId)
			this._spawnId = null

	more : =>
		if (@_spawntime > 0)
			@_spawntime -= 100
		@doSpawn()
		@_spawntime

	less : =>
		if (@_spawntime < 1200)
			@_spawntime += 100
		@doSpawn()
		@_spawntime		

	spawn : =>
		name = @genID()
		type = 'soldier'
		if (name[0] > 'Z')
			type = 'tank'
		else if (name[1] > 'Z')
			type = 'plane'
		c = @cf.breed({name : name, type : type})
		c.load(this, @map)

	pause : ->

	save : ->

	stop : ->
		if (this._intervalId)
			console.log("Stopping game")
			clearInterval(this._intervalId)
			this._intervalId = null
		@stopSpawn()

$(document).ready(-> 
	game = new Game('battlefield')
	game.initialize()
)