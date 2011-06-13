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
          click: function() {
            return console.log("default click event");
          }
        },
        duration: 500
      });
      this.queue = [];
      this.images = [];
      this.currentImage = -1;
      this._init();
    }
    ImageFader.prototype.display = function(index) {
      if (!this.images[index]) {
        console.log("get image from reader", index);
        return this.options.imageReader.getImage(index, this._addImage);
      } else {
        console.log("we have the image", index);
        return this._display(index);
      }
    };
    ImageFader.prototype.next = function() {
      if (this.imageCount < this.currentImage + 1) {
        return this.display(this.currentImage + 1);
      } else {
        return this.display(0);
      }
    };
    ImageFader.prototype.previous = function() {
      if (this.currentImage > 0) {
        return this.display(this.currentImage(-1));
      } else {
        return this.display(this.imageCount - 1);
      }
    };
    ImageFader.prototype._init = function() {
      this.imageCount = this.options.imageReader.getImageCount();
      if (this.options.events.click) {
        this.options.viewport.click(this.options.events.click);
      }
      return this.display(0);
    };
    ImageFader.prototype._addImage = function(index, image) {
      this.images[index] = image;
      this._insertImage(image);
      return this._display(index);
    };
    ImageFader.prototype._display = function(index) {
      this.queue.push(index);
      console.log("display ", index, "called, queue now", this.queue);
      return this._animate();
    };
    ImageFader.prototype._insertImage = function(image) {
      console.log("insertImage", image);
      console.log(this.options.viewport);
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
    ImageFader.prototype._fitImage = function(image) {
      var calculateEnlargementFactor, enlargementFactor, enlargmentFactor, imageDimensions, longestDimensionImage, otherDimensionImage, viewportDimensions;
      viewportDimensions = this._imageDimensions(this.options.viewport);
      imageDimensions = this._imageDimensions(image.image);
      longestDimensionImage = imageDimensions.x >= viewportDimensions.x ? 'x' : 'y';
      otherDimensionImage = longestDimensionImage === 'x' ? 'y' : 'x';
      calculateEnlargementFactor = function(dimension) {
        return viewportDimensions[dimension] / imageDimension[dimension];
      };
      enlargementFactor = calculateEnlargementFactor(longestDimensionImage);
      if (enlargmentFactor * imageDimensions[otherDimensionImage] > viewportDimensions[otherDimensionImage]) {
        enlargmentFactor = calculateEnlargementFactor(otherDimensionImage);
      }
      return image.css({
        width: imageDimensions.x * enlargmentFactor,
        height: imageDimensions.y * enlargmentFactor
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
        top: this.calculateOffset(viewportDimensions, imageDimensions, 'x')
      });
    };
    ImageFader.prototype._animate = function() {
      var next;
      if (this.animationInProgress || this.queue.length === 0) {
        return;
      }
      this.animationInProgress = true;
      console.log(next, this.queue);
      next = this.queue[0];
      this.queue = _.without(this.queue, next);
      console.log(next, this.queue);
      console.log(next, this.currentImage);
      if (next === this.currentImage) {
        return this._animateFinished();
      } else {
        if (this.currentImage > -1) {
          console.log("hide", this.currentImage);
          this.images[this.currentImage].image.animate({
            opacity: 0
          }, this.options.duration);
        }
        console.log("show", next);
        this.images[next].image.show();
        this.images[next].image.animate({
          opacity: 1
        }, this.options.duration, this._animateFinished);
        return this.currentImage = next;
      }
    };
    ImageFader.prototype._animateFinished = function() {
      this.animationInProgress = false;
      console.log("animateFinished");
      if (this.queue.length > 0) {
        return this._animate();
      }
    };
    return ImageFader;
  })();
  root = typeof exports !== "undefined" && exports !== null ? exports : this;
  root.ImageFader = ImageFader;
}).call(this);
