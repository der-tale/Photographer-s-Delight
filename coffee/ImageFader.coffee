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
    #       fitImagesToViewPort: true,
    #       events: {
    #         click: function(e) { ... }
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
    #     enlarged proportionally to fit the viewport. *(default: true)*
    #   * **events:**
    #     * **click:** If clicked anywhere on the current image
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
    display: (index) ->
        if not @images[index]
            @options.imageReader.getImage(index, @_addImage)
        else 
            @_display(index)

    next: () =>
        if @currentImage + 1 < @imageCount 
            @display @currentImage + 1
        else
            @display 0

    previous: () =>
        if @currentImage > 0
            @display @currentImage -1
        else 
            @display @imageCount - 1
        

    #### Private Methods
    _init: ->
        @imageCount = @options.imageReader.getImageCount()

        if @options.events.click 
            @options.viewport.click @options.events.click

        @display(0)


    _addImage: (index, image) =>
        @images[index] = image

        @_insertImage image
        if @options.fitImagesToViewPort then @_fitImage image
        @_centerImage image

        @_display(index)

    _display: (index) =>
        @queue.push index
        @_animate()


    _insertImage: (image) ->
        @options.viewport.append image.image
        image.image.hide()

        image.image.css {
            opacity: 0 
        }

    _imageDimensions: (image) ->
        {
            x: image.width()
            y: image.height()
        }

    # = 1 / (imageDimensions[dimension] / viewportDimensions[dimension])
    _calculateEnlargementFactor: ( dimensions1, dimensions2, dimension ) ->
        dimensions1[dimension] / dimensions2[dimension] 

    # Fit the image into the viewport
    _fitImage: (image) ->
        viewportDimensions = @_imageDimensions(@options.viewport) 
        imageDimensions = @_imageDimensions(image.image)

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


    calculateOffset: ( dimensions1, dimensions2, dimension ) ->
        Math.floor ( dimensions1[dimension] - dimensions2[dimension] ) / 2

    _centerImage: (image) ->

        viewportDimensions = @_imageDimensions(@options.viewport) 
        imageDimensions = @_imageDimensions(image.image)

        image.image.css {
            position: "absolute"
            left: @calculateOffset viewportDimensions, imageDimensions, 'x'
            top: @calculateOffset viewportDimensions, imageDimensions, 'y'
        }


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
                opacity: 1 
            }, @options.duration, @_animateFinished

            @currentImage = next


    _animateFinished: =>

        @animationInProgress = false

        if @queue.length > 0 then @_animate()





# Export this class 
root = exports ? this
root.ImageFader = ImageFader
