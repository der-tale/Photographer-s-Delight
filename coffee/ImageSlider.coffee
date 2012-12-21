# Extends the imageChanger class
# Handles all animation spezific prozesses
#
class ImageSlider extends ImageChanger
    
    imageOpacity: 1

    #### Private Methods

    # Calculate the slide direction
    _calculateDirection: ( currentImage, nextImage ) ->
        # shortest distance algorithm, with closed loop
        # from last element go to the first element and vice versa

        if currentImage < nextImage
            if @automaticAnimation
                @automaticAnimation = false
                if currentImage == 0 and nextImage == (@imageCount-1)
                    "right"
                else
                    "left"
            else
                "left"
        else
            if @automaticAnimation
                @automaticAnimation = false
                if nextImage == 0 and currentImage == (@imageCount-1)
                    "left"
                else
                    "right"
            else
                "right"


    # Setup the animation workflow
    _animate: ->
        # check queue for next image id
        next = super

        if next > -1
            if @currentImage > -1
                if @_calculateDirection(@currentImage, next) is 'left'
                    offset = @options.viewport.width()
                else
                    offset = -@options.viewport.width()

                @images[@currentImage].image.animate {
                    left: '-='+offset
                }, @options.duration

                @images[next].image.css {
                    left: (@calculateOffset @_imageDimensions(@options.viewport), @_imageDimensions(@images[next].image), 'x')+offset
                }
                @images[next].image.show()
                @images[next].image.animate {
                    left: '-='+offset
                    useTranslate3d: true
                }, @options.duration, @_animateFinished
            else
                @images[next].image.show()
                @_animateFinished()

            @currentImage = next



# Export this class 
root = exports ? this
root.ImageSlider = ImageSlider
