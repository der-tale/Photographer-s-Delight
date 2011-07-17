# A simple theme for Photographers Delight
#
##### ToDo
#   * Include main markup creation

# 
class PDSimpleTheme

    options: {}
    
    #### Options

    #
    constructor: (options) ->
        options = if options then options else {}

        @options = _.defaults options, {
            images: []
            imageContainer: null
            fadeDuration: 1000
            paginationContainer: null
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
                imageReader: a
            }

        b = new ImageFader {
            imageReader: a
            viewport: @options.imageContainer
            duration: @options.fadeDuration
            events: 
                click: (e) -> 
                    e.preventDefault()
                    b.next()
                display: (index) ->
                    if c? then c.display index, {
                        overrideEvents: true 
                    } 
                    if e? then e.display index
        }

        if @options.intervalContainer?
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
