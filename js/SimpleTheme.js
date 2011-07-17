(function() {
  var PDSimpleTheme, root;
  PDSimpleTheme = (function() {
    PDSimpleTheme.prototype.options = {};
    function PDSimpleTheme(options) {
      options = options ? options : {};
      this.options = _.defaults(options, {
        images: [],
        imageContainer: null,
        fadeDuration: 1000,
        paginationContainer: null,
        intervalContainer: null,
        intervalInitialState: false,
        intervalInterval: 5000,
        intervalText: {
          stop: "pause",
          start: "play"
        },
        captionContainer: null,
        captions: []
      });
      this._init();
    }
    PDSimpleTheme.prototype._init = function() {
      var a, b, c, d, e;
      a = b = c = d = e = null;
      a = new ImageReader({
        images: this.options.images
      });
      if (this.options.paginationContainer != null) {
        c = new ImagePagination({
          container: this.options.paginationContainer,
          events: {
            display: function(index) {
              b.display(index, {
                overrideEvents: true
              });
              return e.display(index);
            }
          },
          imageReader: a
        });
      }
      b = new ImageFader({
        imageReader: a,
        viewport: this.options.imageContainer,
        duration: this.options.fadeDuration,
        events: {
          click: function(e) {
            e.preventDefault();
            return b.next();
          },
          display: function(index) {
            if (c != null) {
              c.display(index, {
                overrideEvents: true
              });
            }
            if (e != null) {
              return e.display(index);
            }
          }
        }
      });
      if (this.options.intervalContainer != null) {
        d = new Interval({
          container: this.options.intervalContainer,
          state: this.options.intervalInitialState,
          interval: this.options.intervalInterval,
          text: this.options.intervalText,
          events: {
            tick: function() {
              return b.next();
            }
          }
        });
      }
      if (this.options.captionContainer != null) {
        return e = new ImageCaption({
          container: this.options.captionContainer,
          captions: this.options.captions
        });
      }
    };
    return PDSimpleTheme;
  })();
  root = typeof exports !== "undefined" && exports !== null ? exports : this;
  root.PDSimpleTheme = PDSimpleTheme;
}).call(this);
