# Creates markup and handles all callbacks to display a fading image 
# gallery. It is up to the actual theme to further customize the markup/css and
# position the viewport in the page.
#
class ImageFader
    
    options: {}

    queue: []
    images: []

    currentImage: -1
    animationInProgress: false

    #### Options

    # ImageFader takes a single object as an option value.
    #
    #     {
    #       imageReader: new ImageReader(...),
    #       viewport: $("div#image"),
    #       viewportDimensions: {
    #         height: -1,
    #         width: -1
    #       },
    #       centerImagesInViewport: true,
    #       fitImagesToViewPort: false,
    #       events: {
    #         click: function(e) { ... }
    #         display: function(index) { ... )
    #       },
    #       duration: 500
    #
    #     }
    #
    # The options in detail:
    #
    #   * **imageReader:** An ImageReader instance
    #   * **viewport:** DOM element to put the gallery markup into
    #   * **viewportDimensions:** Dimensions of the container. If left out, the
    #     dimensions are retrieved via css (and the container has to be sized
    #     correctly beforehand) *(default: get dimensions from container)*
    #   * **centerImagesInViewport:** Set to true if the images should be displayed
    #     centered in the viewport. Comes in handy if your images are of
    #     diverse size. *(default: true)*
    #   * **fitImagesToViewPort:** Set to true if the images should be
    #     enlarged proportionally to fit the viewport. *(default: false)*
    #   * **events:**
    #     * **click:** If clicked anywhere on the current image
    #     * **display:** If a new image is being displayed
    #   * **duration:** Duration of the animation *(default: 500ms)*
    #
    constructor: (options) ->
        options = if options then options else {}
        @options = _.defaults options, {
            imageReader: null
            viewport: null
            viewportDimensions: {
                height: -1
                width: -1
            }
            centerImagesInViewport: true
            fitImagesToViewPort: false
            events: {
                click: () ->
            }
            duration: 500


        }

        @queue = []
        @images = []
        @currentImage = -1

        @_init()

    #### Public Methods

    # Show the image with the given index
    display: (index, options) ->
        if not @images[index]
            @options.imageReader.getImage(index, @_addImage)
        else 
            @_display(index)

        if not options?.overrideEvents or options.overrideEvents is not true 
            @options.events?.display?(index)

    # Show the next image. If the current image is the last one, show the first
    # again.
    next: () =>
        if @currentImage + 1 < @imageCount 
            @display @currentImage + 1
        else
            @display 0

    # Show the previous image. If the current image is the first one, show the
    # last in the set.
    previous: () =>
        if @currentImage > 0
            @display @currentImage - 1
        else 
            @display @imageCount - 1
        

    #### Private Methods

    # Register events and display the first image
    _init: ->
        @imageCount = @options.imageReader.getImageCount()

        if @options.events.click 
            @options.viewport.click @options.events.click

        @display(0, {
            overrideEvents: true
        })


    # Callback for the ImageReader.getImage method.
    # Insert, fit and center the image
    _addImage: (index, image) =>
        @images[index] = image

        @_insertImage image
        if @options.fitImagesToViewPort then @_fitImage image
        @_centerImage image

        @_display(index)

    # Add the next image to show to the queue
    _display: (index) =>
        @queue.push index
        @_animate()

    # Insert the image into the viewport and prepare the CSS
    _insertImage: (image) ->
        @options.viewport.append image.image
        image.image.hide()

        image.image.css {
            opacity: 0 
        }

    # Return the dimensions of an image
    _imageDimensions: (image) ->
        {
            x: image.width()
            y: image.height()
        }

    # Calculate the enlargement factor with:
    # = 1 / (imageDimensions[dimension] / viewportDimensions[dimension])
    _calculateEnlargementFactor: ( dimensions1, dimensions2, dimension ) ->
        dimensions1[dimension] / dimensions2[dimension] 

    # Fit the image into the viewport
    _fitImage: (image) ->
        viewportDimensions = @_imageDimensions(@options.viewport) 
        imageDimensions = @_imageDimensions(image.image)
        
        # Find out which is the "base" dimension to enlarge (or shrink) to 
        # the viewport
        longestDimensionImage = 
            if imageDimensions.x >= viewportDimensions.x 
                'x'
            else if imageDimensions.y > viewportDimensions.y 
                'y'
            else if imageDimensions.x >= imageDimensions.y 
                'x'
            else 
                'y'

        otherDimensionImage =
            if longestDimensionImage is 'x' then 'y' else 'x'

        enlargementFactor = @_calculateEnlargementFactor viewportDimensions,
            imageDimensions,
            longestDimensionImage

        # If the viewport is smaller on the otherDimension as our enlargement
        # would require, take this dimension as the base
        if enlargmentFactor * imageDimensions[otherDimensionImage] > viewportDimensions[otherDimensionImage]
            enlargmentFactor = @_calculateEnlargementFactor viewportDimensions,
                imageDimensions,
                otherDimensionImage

        widthToSet = Math.round(imageDimensions.x * enlargementFactor)
        heightToSet = Math.round(imageDimensions.y * enlargementFactor)

        image.image.css {
            width: widthToSet
            height: heightToSet
        }


    # Calculate the offset for the positioning
    calculateOffset: ( dimensions1, dimensions2, dimension ) ->
        Math.floor ( dimensions1[dimension] - dimensions2[dimension] ) / 2

    # Center this image
    _centerImage: (image) ->

        viewportDimensions = @_imageDimensions(@options.viewport) 
        imageDimensions = @_imageDimensions(image.image)

        image.image.css {
            position: "absolute"
            left: @calculateOffset viewportDimensions, imageDimensions, 'x'
            top: @calculateOffset viewportDimensions, imageDimensions, 'y'
        }


    # Work the animation queue
    _animate: ->
        if @animationInProgress or @queue.length is 0 then return
        
        @animationInProgress = true

        next = @queue[0]
        @queue = _.without @queue, next

        if next is @currentImage then @_animateFinished()
        else 
            if @currentImage > -1
                @images[@currentImage].image.animate {
                    opacity: 0 
                }, @options.duration

            @images[next].image.show()
            @images[next].image.animate {
                opacity: 1,
                useTranslate3d: true
            }, @options.duration, @_animateFinished

            @currentImage = next


    # Animation finished, prepare the next animation
    _animateFinished: =>
        _this = this

        window.setTimeout(() -> 
            _this.animationInProgress = false
            if _this.queue.length > 0 
                _this._animate()
        , 100)



# Export this class 
root = exports ? this
root.ImageFader = ImageFader
