(function() {
  var ImageFader, root;
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  ImageFader = (function() {
    ImageFader.prototype.options = {};
    ImageFader.prototype.queue = [];
    ImageFader.prototype.images = [];
    ImageFader.prototype.currentImage = -1;
    ImageFader.prototype.animationInProgress = false;
    function ImageFader(options) {
      this._animateFinished = __bind(this._animateFinished, this);
      this._display = __bind(this._display, this);
      this._addImage = __bind(this._addImage, this);
      this.previous = __bind(this.previous, this);
      this.next = __bind(this.next, this);      options = options ? options : {};
      this.options = _.defaults(options, {
        imageReader: null,
        viewport: null,
        viewportDimensions: {
          height: -1,
          width: -1
        },
        centerImagesInViewport: true,
        fitImagesToViewPort: false,
        events: {
          click: function() {}
        },
        duration: 500
      });
      this.queue = [];
      this.images = [];
      this.currentImage = -1;
      this._init();
    }
    ImageFader.prototype.display = function(index, options) {
      var _ref;
      if (!this.images[index]) {
        this.options.imageReader.getImage(index, this._addImage);
      } else {
        this._display(index);
      }
      if (!(options != null ? options.overrideEvents : void 0) || options.overrideEvents === !true) {
        return (_ref = this.options.events) != null ? typeof _ref.display === "function" ? _ref.display(index) : void 0 : void 0;
      }
    };
    ImageFader.prototype.next = function() {
      if (this.currentImage + 1 < this.imageCount) {
        return this.display(this.currentImage + 1);
      } else {
        return this.display(0);
      }
    };
    ImageFader.prototype.previous = function() {
      if (this.currentImage > 0) {
        return this.display(this.currentImage - 1);
      } else {
        return this.display(this.imageCount - 1);
      }
    };
    ImageFader.prototype._init = function() {
      this.imageCount = this.options.imageReader.getImageCount();
      if (this.options.events.click) {
        this.options.viewport.click(this.options.events.click);
      }
      return this.display(0, {
        overrideEvents: true
      });
    };
    ImageFader.prototype._addImage = function(index, image) {
      this.images[index] = image;
      this._insertImage(image);
      if (this.options.fitImagesToViewPort) {
        this._fitImage(image);
      }
      this._centerImage(image);
      return this._display(index);
    };
    ImageFader.prototype._display = function(index) {
      this.queue.push(index);
      return this._animate();
    };
    ImageFader.prototype._insertImage = function(image) {
      this.options.viewport.append(image.image);
      image.image.hide();
      return image.image.css({
        opacity: 0
      });
    };
    ImageFader.prototype._imageDimensions = function(image) {
      return {
        x: image.width(),
        y: image.height()
      };
    };
    ImageFader.prototype._calculateEnlargementFactor = function(dimensions1, dimensions2, dimension) {
      return dimensions1[dimension] / dimensions2[dimension];
    };
    ImageFader.prototype._fitImage = function(image) {
      var enlargementFactor, enlargmentFactor, heightToSet, imageDimensions, longestDimensionImage, otherDimensionImage, viewportDimensions, widthToSet;
      viewportDimensions = this._imageDimensions(this.options.viewport);
      imageDimensions = this._imageDimensions(image.image);
      longestDimensionImage = imageDimensions.x >= viewportDimensions.x ? 'x' : imageDimensions.y > viewportDimensions.y ? 'y' : imageDimensions.x >= imageDimensions.y ? 'x' : 'y';
      otherDimensionImage = longestDimensionImage === 'x' ? 'y' : 'x';
      enlargementFactor = this._calculateEnlargementFactor(viewportDimensions, imageDimensions, longestDimensionImage);
      if (enlargmentFactor * imageDimensions[otherDimensionImage] > viewportDimensions[otherDimensionImage]) {
        enlargmentFactor = this._calculateEnlargementFactor(viewportDimensions, imageDimensions, otherDimensionImage);
      }
      widthToSet = Math.round(imageDimensions.x * enlargementFactor);
      heightToSet = Math.round(imageDimensions.y * enlargementFactor);
      return image.image.css({
        width: widthToSet,
        height: heightToSet
      });
    };
    ImageFader.prototype.calculateOffset = function(dimensions1, dimensions2, dimension) {
      return Math.floor((dimensions1[dimension] - dimensions2[dimension]) / 2);
    };
    ImageFader.prototype._centerImage = function(image) {
      var imageDimensions, viewportDimensions;
      viewportDimensions = this._imageDimensions(this.options.viewport);
      imageDimensions = this._imageDimensions(image.image);
      return image.image.css({
        position: "absolute",
        left: this.calculateOffset(viewportDimensions, imageDimensions, 'x'),
        top: this.calculateOffset(viewportDimensions, imageDimensions, 'y')
      });
    };
    ImageFader.prototype._animate = function() {
      var next;
      if (this.animationInProgress || this.queue.length === 0) {
        return;
      }
      this.animationInProgress = true;
      next = this.queue[0];
      this.queue = _.without(this.queue, next);
      if (next === this.currentImage) {
        return this._animateFinished();
      } else {
        if (this.currentImage > -1) {
          this.images[this.currentImage].image.animate({
            opacity: 0
          }, this.options.duration);
        }
        this.images[next].image.show();
        this.images[next].image.animate({
          opacity: 1,
          useTranslate3d: true
        }, this.options.duration, this._animateFinished);
        return this.currentImage = next;
      }
    };
    ImageFader.prototype._animateFinished = function() {
      var _this;
      _this = this;
      return window.setTimeout(function() {
        _this.animationInProgress = false;
        if (_this.queue.length > 0) {
          return _this._animate();
        }
      }, 100);
    };
    return ImageFader;
  })();
  root = typeof exports !== "undefined" && exports !== null ? exports : this;
  root.ImageFader = ImageFader;
}).call(this);
