(function() {
  var ImagePagination, root;
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  ImagePagination = (function() {
    ImagePagination.prototype.options = {};
    ImagePagination.prototype.previousLink = null;
    ImagePagination.prototype.nextLink = null;
    ImagePagination.prototype.indexLinks = [];
    ImagePagination.prototype.currentImage = -1;
    ImagePagination.prototype.templates = {
      link: "<a href='javascript:;'></a>"
    };
    function ImagePagination(options) {
      this.next = __bind(this.next, this);
      this.previous = __bind(this.previous, this);      options = options ? options : {};
      this.options = _.defaults(options, {
        container: null,
        imageReader: null,
        text: {
          previous: "<",
          next: ">"
        },
        css: {
          selected: "selected"
        },
        events: {
          display: null
        }
      });
      this.previousLink = null;
      this.nextLink = null;
      this.indexLinks = [];
      this.currentImage = -1;
      this._init();
    }
    ImagePagination.prototype.display = function(index, options, event) {
      var _ref;
      this.indexLinks[index].toggleClass(this.options.css.selected);
      if (this.currentImage > -1) {
        this.indexLinks[this.currentImage].toggleClass(this.options.css.selected);
      }
      this.currentImage = index;
      if (!(options != null ? options.overrideEvents : void 0) || options.overrideEvents === !true) {
        return (_ref = this.options.events) != null ? typeof _ref.display === "function" ? _ref.display(index) : void 0 : void 0;
      }
    };
    ImagePagination.prototype.previous = function() {
      if (this.currentImage > 0) {
        return this.display(this.currentImage - 1);
      } else {
        return this.display(this.imageCount - 1);
      }
    };
    ImagePagination.prototype.next = function() {
      if (this.currentImage + 1 < this.imageCount) {
        return this.display(this.currentImage + 1);
      } else {
        return this.display(0);
      }
    };
    ImagePagination.prototype._init = function() {
      var index, indexLink, _i, _len, _ref, _ref2;
      this.imageCount = this.options.imageReader.getImageCount();
      this.previousLink = $(this.templates.link);
      this.options.container.append(this.previousLink.text(this.options.text.previous));
      for (index = 0, _ref = this.imageCount - 1; 0 <= _ref ? index <= _ref : index >= _ref; 0 <= _ref ? index++ : index--) {
        this.indexLinks[index] = $(this.templates.link);
        this.options.container.append(this.indexLinks[index].text(index + 1));
      }
      this.nextLink = $(this.templates.link);
      this.options.container.append(this.nextLink.text(this.options.text.next));
      this.previousLink.click(this.previous);
      this.nextLink.click(this.next);
      _ref2 = this.indexLinks;
      for (_i = 0, _len = _ref2.length; _i < _len; _i++) {
        indexLink = _ref2[_i];
        indexLink.click(_.bind(this.display, this, this.indexLinks.indexOf(indexLink)));
      }
      return this.display(0, {
        overrideEvents: true
      });
    };
    return ImagePagination;
  })();
  root = typeof exports !== "undefined" && exports !== null ? exports : this;
  root.ImagePagination = ImagePagination;
}).call(this);
