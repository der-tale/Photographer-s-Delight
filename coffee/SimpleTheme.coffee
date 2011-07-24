# A simple "theme" for Photographer's Delight
#
# A theme for Photographer's Delight is invoking the several classes with a
# set of options and should provide default markup and/or CSS styling. 
#
# The syntax, features and concept of a theme is subject to change.
#
##### ToDo
#   * Include main markup creation

# 
class PDSimpleTheme

    options: {}
    
    #### Options
    #
    #     {
    #         images: []
    #         imageContainer: null
    #         imageClickToAdvance: true
    #         imageCenterImageInViewport: true
    #         imageFitImagesToViewport: false
    #         fadeDuration: 1000
    #         paginationContainer: null
    #         useInterval: false
    #         intervalContainer: null
    #         intervalInitialState: false
    #         intervalInterval: 5000
    #         intervalText: {
    #             stop: "pause"
    #             start: "play"
    #         }
    #         captionContainer: null
    #         captions: []
    #     }
    #
    #    The options in detail can be looked up in the documentation of the 
    #    single classes. 
    #
    constructor: (options) ->
        options = if options then options else {}

        @options = _.defaults options, {
            images: []
            imageContainer: null
            imageClickToAdvance: true
            imageCenterImageInViewport: true
            imageFitImagesToViewport: false
            fadeDuration: 1000
            paginationContainer: null
            useInterval: false
            intervalContainer: null
            intervalInitialState: false
            intervalInterval: 5000
            intervalText: {
                stop: "pause"
                start: "play"
            }
            captionContainer: null
            captions: []
        }

        @_init()
    
    #### Private Methods
    _init: ->
        a = b = c = d = e = null

        a = new ImageReader {
            images: @options.images
        } 

        if @options.paginationContainer?
            c = new ImagePagination {
                container: @options.paginationContainer
                events: 
                    display: (index) -> 
                        b.display index, {
                            overrideEvents: true 
                        } 
                        e.display index
                imageReader: a
            }

        b = new ImageFader {
            imageReader: a
            viewport: @options.imageContainer
            duration: @options.fadeDuration
            centerImagesInViewport: @options.imageCenterImageInViewport
            fitImagesToViewPort: @options.imageFitImagesToViewport
            events: 
                click: (e) => 
                    e.preventDefault()
                    if @options.imageClickToAdvance is true then b.next()
                display: (index) ->
                    if c? then c.display index, {
                        overrideEvents: true 
                    } 
                    if e? then e.display index
        }

        if @options.useInterval is true
            d = new Interval {
                container: @options.intervalContainer
                state: @options.intervalInitialState
                interval: @options.intervalInterval
                text: @options.intervalText
                events: 
                    tick: () -> 
                        b.next() 
            }

        if @options.captionContainer?
            e = new ImageCaption {
                container: @options.captionContainer
                captions: @options.captions
            }



# Now export this class 
root = exports ? this
root.PDSimpleTheme = PDSimpleTheme
