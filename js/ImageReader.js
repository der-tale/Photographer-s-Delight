(function() {
  var ImageReader, root;
  ImageReader = (function() {
    ImageReader.prototype.options = {};
    function ImageReader(options) {
      options = options ? options : {};
      this.options = _.defaults(options, {
        preloadCount: 5,
        parallelLoadCount: 1
      });
    }
    return ImageReader;
  })();
  root = typeof exports !== "undefined" && exports !== null ? exports : this;
  root.ImageReader = ImageReader;
}).call(this);
