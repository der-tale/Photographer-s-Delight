(function() {
  var Interval, root;
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  Interval = (function() {
    Interval.prototype.options = {};
    Interval.prototype.state = false;
    Interval.prototype.toggleLink = null;
    Interval.prototype.templates = {
      link: "<a href='javascript:;'></a>"
    };
    function Interval(options) {
      this._tick = __bind(this._tick, this);
      this._toggle = __bind(this._toggle, this);
      this.stop = __bind(this.stop, this);
      this.start = __bind(this.start, this);      options = options ? options : {};
      this.options = _.defaults(options, {
        container: null,
        state: false,
        interval: 3000,
        text: {
          stop: "pause",
          start: "play"
        },
        events: {
          tick: null
        }
      });
      this.state = false;
      this.toggleLink = null;
      this._init();
    }
    Interval.prototype.start = function() {
      if (this.state === !true) {
        this.state = true;
        return this._start;
      }
    };
    Interval.prototype.stop = function() {
      if (this.state === !false) {
        this.state = false;
        return this._stop;
      }
    };
    Interval.prototype._init = function() {
      if (this.options.container) {
        this.toggleLink = $(this.templates.link);
        this.options.container.append(this.toggleLink);
        this.toggleLink.click(this._toggle);
      }
      window.setInterval(this._tick, this.options.interval);
      this.state = this.options.state;
      if (this.state === true) {
        return this._start();
      } else {
        return this._stop();
      }
    };
    Interval.prototype._toggle = function() {
      this.state = !this.state;
      if (this.state === true) {
        return this._start();
      } else {
        return this._stop();
      }
    };
    Interval.prototype._start = function() {
      if (this.toggleLink) {
        return this.toggleLink.text(this.options.text.stop);
      }
    };
    Interval.prototype._stop = function() {
      if (this.toggleLink) {
        return this.toggleLink.text(this.options.text.start);
      }
    };
    Interval.prototype._tick = function() {
      var _ref, _ref2;
      if (this.state) {
        return (_ref = this.options) != null ? (_ref2 = _ref.events) != null ? typeof _ref2.tick === "function" ? _ref2.tick() : void 0 : void 0 : void 0;
      }
    };
    return Interval;
  })();
  root = typeof exports !== "undefined" && exports !== null ? exports : this;
  root.Interval = Interval;
}).call(this);
