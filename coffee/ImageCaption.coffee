# Takes a list of pieces of text and offers methods
# to display one piece of text on demand.

#
class ImageCaption

    
    options: {}

    currentCaption: -1

    captions: []

    templates: {
        captionContainer: "<div></div>"
    }

    #### Options

    #
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

    # Display the caption with index
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
