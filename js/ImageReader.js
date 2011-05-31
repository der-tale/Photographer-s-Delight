(function() {
  var ImageReader, root;
  ImageReader = (function() {
    ImageReader.prototype.options = {};
    ImageReader.prototype.images = [];
    ImageReader.prototype.imageMap = [];
    ImageReader.prototype.loadingList = [];
    ImageReader.prototype.loadingWaitList = [];
    function ImageReader(options) {
      options = options ? options : {};
      this.options = _.defaults(options, {
        preloadCount: 5,
        parallelLoadCount: 1,
        images: []
      });
      this.startLoading();
    }
    ImageReader.prototype.startLoading = function() {
      var image;
      this.imageMap = (function() {
        var _i, _len, _ref, _results;
        _ref = this.options.images;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          image = _ref[_i];
          _results.push({
            finished: false,
            image: null,
            url: image
          });
        }
        return _results;
      }).call(this);
      return this.getImage(0);
    };
    ImageReader.prototype.getImage = function(index, callback) {
      var begin, current, end, image, offset;
      offset = this.options.preloadCount > 2 ? Math.floor(this.options.preloadCount / 2) : 0;
      offset = this.options.preloadCount % 2 === 0 ? offset - 1 : offset;
      begin = (begin = index - offset) >= 0 ? begin : 0;
      end = (end = index + this.options.preloadCount - offset) < this.imageMap.length ? end : this.imageMap.length - 1;
      current = begin;
      return this.loadingWaitList = (function() {
        var _results;
        _results = [];
        while (current <= end) {
          image = this.imageMap[current];
          if (current === index) {
            image.callback = callback;
          } else {
            if (this.options.standardCallback != null) {
              image.callback = this.options.standardCallback;
            }
          }
          current += 1;
          _results.push(image);
        }
        return _results;
      }).call(this);
    };
    return ImageReader;
  })();
  root = typeof exports !== "undefined" && exports !== null ? exports : this;
  root.ImageReader = ImageReader;
}).call(this);
