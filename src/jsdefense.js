// Generated by CoffeeScript 1.5.0-pre
(function() {
  var BasicMap, Creep, CreepFactory, Game, Map, Renderable, Tile,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Renderable = (function() {

    function Renderable() {}

    Renderable.prototype.load = function(game) {
      return game.register(this.getId(), this);
    };

    Renderable.prototype.render = function() {
      return console.log("render base!");
    };

    Renderable.prototype.raise = function(msg) {
      throw new Error(msg);
    };

    Renderable.prototype.getId = function() {
      return this.raise("getId is abstract on Renderable");
    };

    Renderable.prototype.draw = function() {
      return false;
    };

    Renderable.prototype.update = function() {
      return false;
    };

    return Renderable;

  })();

  Tile = (function(_super) {

    __extends(Tile, _super);

    function Tile(_arg) {
      this.x = _arg.x, this.y = _arg.y, this.color = _arg.color, this.entrance = _arg.entrance, this.exit = _arg.exit, this.cls = _arg.cls;
      this.id = this.getId();
    }

    Tile.prototype.clickHandle = function() {
      if (this.cls === 'grass') {
        this.getEl().removeClass(this.cls);
        this.cls = 'hole';
        return this.getEl().addClass(this.cls);
      }
    };

    Tile.prototype.render = function(el, append) {
      var fn;
      return fn = function(err, out) {
        el.innerHTML += out;
        this.el = document.getElementById();
        console.log(this);
        if (!document.getElementById(this.getId())) {
          return console.log("failed");
        }
      };
    };

    Tile.prototype.getEl = function() {
      return $('#' + this.getId());
    };

    Tile.prototype.getId = function() {
      return this.x + '_' + this.y;
    };

    Tile.prototype.loadEl = function(el) {
      this.el = el;
      return this.onRender();
    };

    Tile.prototype.update = function() {
      return false;
    };

    Tile.prototype.draw = function() {
      return false;
    };

    Tile.prototype.onRender = function() {
      var me;
      if (this.el) {
        me = this;
        return this.el.addEventListener("click", function(p) {
          return me.clickHandle();
        });
      }
    };

    Tile.prototype.isEntrance = function() {
      return this.entrance;
    };

    Tile.prototype.isExit = function() {
      return this.exit;
    };

    return Tile;

  })(Renderable);

  Map = (function(_super) {

    __extends(Map, _super);

    function Map() {
      this.tiles = new Array(0);
    }

    Map.prototype.getTileDefinitions = function() {
      return this.raise("getTileDefinitions is abstract on Map");
    };

    Map.prototype.getId = function() {
      return this.raise("getId is abstract on Map");
    };

    Map.prototype.load = function(game) {
      var i, j, t, _i, _j, _len, _len1, _ref;
      _ref = this.getTileDefinitions();
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        i = _ref[_i];
        for (_j = 0, _len1 = i.length; _j < _len1; _j++) {
          j = i[_j];
          j.x = _j;
          j.y = _i;
          t = new Tile(j);
          if (t.isEntrance()) {
            console.log('entrance set');
            this.entrance = t;
          } else if (t.isExit()) {
            this.exit = t;
          }
          t.load(game);
          this.tiles.push(t);
        }
      }
      return Map.__super__.load.call(this, game);
    };

    Map.prototype.render = function(el) {
      var fn, me;
      me = this;
      fn = function(err, out) {
        var t, _i, _len, _ref, _results;
        el.innerHTML += out;
        _ref = me.tiles;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          t = _ref[_i];
          _results.push(t.loadEl(document.getElementById(t.getId())));
        }
        return _results;
      };
      return dust.render("map", {
        tiles: this.tiles
      }, fn);
    };

    Map.prototype.getEntrance = function() {
      return this.entrance;
    };

    Map.prototype.getExit = function() {
      return this.exit;
    };

    return Map;

  })(Renderable);

  BasicMap = (function(_super) {

    __extends(BasicMap, _super);

    function BasicMap() {
      return BasicMap.__super__.constructor.apply(this, arguments);
    }

    BasicMap.prototype.getTileDefinitions = function() {
      return MAPS.Basic.tiles;
    };

    BasicMap.prototype.getId = function() {
      return 'map.basic';
    };

    return BasicMap;

  })(Map);

  Creep = (function(_super) {

    __extends(Creep, _super);

    function Creep(_arg) {
      this.name = _arg.name, this.velocity = _arg.velocity;
      if (!this.velocity) {
        this.velocity = 0.5;
      }
      this.left = 0;
      this.top = 0;
      this.el = $("#creepcave");
    }

    Creep.prototype.render = function() {
      var fn, self;
      if ((this.getEl().length)) {
        return this.getEl().offset({
          top: this.top,
          left: this.left
        });
      } else {
        self = this;
        fn = function(err, out) {
          return self.el[0].innerHTML += out;
        };
        this.id = this.getId();
        return dust.render("creep", this, fn);
      }
    };

    Creep.prototype.load = function(game, map) {
      var pos;
      if (map.getEntrance()) {
        pos = map.getEntrance().getEl().position();
        this.left = pos.left;
        this.top = pos.top;
      }
      return Creep.__super__.load.call(this, game);
    };

    Creep.prototype.getEl = function() {
      return $('#' + this.getId());
    };

    Creep.prototype.getId = function() {
      return 'creep_' + this.name;
    };

    Creep.prototype.update = function() {
      return this.left += this.velocity;
    };

    Creep.prototype.draw = function() {
      return this.render();
    };

    return Creep;

  })(Renderable);

  CreepFactory = (function() {

    function CreepFactory() {}

    CreepFactory.prototype.breed = function(options) {
      console.log('Created creep with name: ' + options.name);
      return new Creep(options);
    };

    return CreepFactory;

  })();

  Game = (function() {

    function Game(elID) {
      this.elID = elID;
      this.fps = 60;
      this.renderables = {};
    }

    Game.prototype.initialize = function() {
      var hank;
      window.Game = this;
      this.map = new BasicMap();
      this.map.load(this);
      this.map.render(document.getElementById(this.elID));
      this.cf = new CreepFactory();
      hank = this.cf.breed({
        name: 'Hank'
      });
      hank.load(this, this.map);
      return console.log("Plays best at 200% zoom.");
    };

    Game.prototype.register = function(id, renderable) {
      return this.renderables[id] = renderable;
    };

    Game.prototype.unregister = function(id) {
      if (this.renderables[id]) {
        return this.renderables[id] = void 0;
      }
    };

    Game.prototype.spawn = function() {
      var c;
      c = this.cf.breed({
        name: this.genID()
      });
      c.load(this, this.map);
      return c;
    };

    Game.prototype.draw = function() {
      var k, v, _ref, _results;
      _ref = this.renderables;
      _results = [];
      for (k in _ref) {
        if (!__hasProp.call(_ref, k)) continue;
        v = _ref[k];
        if (v.draw) {
          _results.push(v.draw());
        } else {
          _results.push(void 0);
        }
      }
      return _results;
    };

    Game.prototype.update = function() {
      var k, v, _ref, _results;
      _ref = this.renderables;
      _results = [];
      for (k in _ref) {
        if (!__hasProp.call(_ref, k)) continue;
        v = _ref[k];
        if (v.update) {
          _results.push(v.update());
        } else {
          _results.push(void 0);
        }
      }
      return _results;
    };

    Game.prototype.genID = function() {
      var i, set, text, _i;
      text = "";
      set = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
      for (i = _i = 0; _i <= 5; i = ++_i) {
        text += set.charAt(Math.floor(Math.random() * set.length));
      }
      return text;
    };

    Game.prototype.start = function() {
      var run, self, spawn;
      if (this._intervalId) {
        return;
      }
      self = this;
      spawn = function() {
        var c;
        c = self.cf.breed({
          name: self.genID()
        });
        return c.load(self, self.map);
      };
      run = (function(game) {
        var loops, nextGameTick, skipTicks;
        loops = 0;
        skipTicks = 1000 / game.fps;
        nextGameTick = (new Date).getTime();
        return function() {
          loops = 0;
          while ((new Date).getTime() > nextGameTick) {
            game.update();
            nextGameTick += skipTicks;
            loops++;
          }
          return game.draw();
        };
      })(this);
      console.log("Starting game");
      this._intervalId = setInterval(run, 0);
      return this._spawnId = setInterval(spawn, 500);
    };

    Game.prototype.pause = function() {};

    Game.prototype.save = function() {};

    Game.prototype.stop = function() {
      if (this._intervalId) {
        console.log("Stopping game");
        clearInterval(this._intervalId);
        this._intervalId = null;
      }
      if (this._spawnId) {
        clearInterval(this._spawnId);
        return this._spawnId = null;
      }
    };

    return Game;

  })();

  $(document).ready(function() {
    var game;
    game = new Game('battlefield');
    return game.initialize();
  });

}).call(this);