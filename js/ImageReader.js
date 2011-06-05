(function() {
  var ImageReader, root;
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  ImageReader = (function() {
    ImageReader.prototype.options = {};
    ImageReader.prototype.images = [];
    ImageReader.prototype.imageMap = [];
    ImageReader.prototype.loadingList = [];
    ImageReader.prototype.loadingWaitList = [];
    function ImageReader(options) {
      this._loadingFinished = __bind(this._loadingFinished, this);      options = options ? options : {};
      this.options = _.defaults(options, {
        preloadCount: 5,
        parallelLoadCount: 1,
        images: []
      });
      this.loadingList = [];
      this.loadingWaitList = [];
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
      var begin, current, end, image, loadingWaitList, offset;
      offset = this.options.preloadCount > 2 ? Math.floor(this.options.preloadCount / 2) : 0;
      offset = this.options.preloadCount % 2 === 0 ? offset - 1 : offset;
      begin = (begin = index - offset) >= 0 ? begin : 0;
      end = (end = index + this.options.preloadCount - offset) < this.imageMap.length ? end : this.imageMap.length - 1;
      current = begin;
      loadingWaitList = (function() {
        var _ref, _ref2, _results;
        _results = [];
        while (current <= end) {
          image = this.imageMap[current];
          if (current === index) {
                        if ((_ref = image.callback) != null) {
              _ref;
            } else {
              image.callback = callback;
            };
          } else {
                        if ((_ref2 = image.callback) != null) {
              _ref2;
            } else {
              image.callback = this.options.standardCallback;
            };
          }
          current += 1;
          _results.push(image);
        }
        return _results;
      }).call(this);
      this.loadingWaitList.push(loadingWaitList);
      this.loadingWaitList = _.flatten(this.loadingWaitList);
      this.loadingWaitList = _.uniq(this.loadingWaitList);
      return this._workOnLoadingList();
    };
    ImageReader.prototype._workOnLoadingList = function() {
      var current, image;
      if (this.loadingWaitList.length >= 1 && this.loadingList.length < this.options.parallelLoadCount) {
        current = this.loadingWaitList[0];
        this.loadingWaitList = _.without(this.loadingWaitList, current);
        if (!current.finished) {
          this.loadingList.push(current);
          image = new Image();
          current.image = image;
          image.src = "";
          jQuery(image).load(_.bind(this._loadingFinished, this, current));
          image.src = current.url;
          if (this.loadingList.length < this.options.parallelLoadCount) {
            return this._workOnLoadingList();
          }
        } else {
          return this._loadingFinished(current);
        }
      }
    };
    ImageReader.prototype._loadingFinished = function(imageMapElement, event) {
      imageMapElement.finished = true;
      if (imageMapElement != null) {
        if (typeof imageMapElement.callback === "function") {
          imageMapElement.callback(this.imageMap.indexOf(imageMapElement), imageMapElement.image);
        }
      }
      this.loadingList = _.without(this.loadingList, imageMapElement);
      return this._workOnLoadingList();
    };
    return ImageReader;
  })();
  root = typeof exports !== "undefined" && exports !== null ? exports : this;
  root.ImageReader = ImageReader;
}).call(this);
