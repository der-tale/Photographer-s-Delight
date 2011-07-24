# Takes a list of captions and offers methods
# to display captions on demand.

#
class ImageCaption

    
    options: {}

    currentCaption: -1

    captions: []

    templates: {
        captionContainer: "<div></div>"
    }

    #### Options

    # ImageCaption takes a single object as an option value.
    #
    #     { 
    #        captions: ["Caption 1", "Caption 2"],
    #        container: null,
    #        duration: 500
    #     } 
    #
    # The options in detail:
    #
    #   * **captions**: A list of captions
    #   * **container**: DOM element to put the caption into
    #   * **duration**: Fade duration for the animation
    constructor: (options) ->
        options = if options then options else {}
        @options = _.defaults options, {
            captions: [],
            container: null,
            duration: 500
        }

        @options.container = $ @options.container

        @currentCaption = -1
        @captions = []

        @_init()

    #### Public Methods

    # Display the caption with the given index
    display: (index) ->

        newImage = @captions[index]
        oldImage = @captions[@currentCaption]

        if oldImage then oldImage.animate {
            opacity: 0 
        }, @options.duration

        newImage.animate {
            opacity: 1,
            useTranslate3d: true
        }, @options.duration

        @currentCaption = index


    #### Private Methods
    _init: ->

        @captions = ( ($(@templates.captionContainer)
                .text(caption)
                .attr("id", _.indexOf @options.captions, caption)
                .css({
                    position: "absolute"
                    opacity: 0
                }).appendTo @options.container
        ) for caption in @options.captions )

        @display 0

        
# Now export this class 
root = exports ? this
root.ImageCaption = ImageCaption
