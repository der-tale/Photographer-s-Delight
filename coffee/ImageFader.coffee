# Extends the imageChanger class
# Handles all animation spezific prozesses
#
class ImageFader extends ImageChanger
    
    # Setup the animation workflow
    _animate: ->
        # check queue for next image id
        next = super

        if next > -1
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



# Export this class 
root = exports ? this
root.ImageFader = ImageFader
