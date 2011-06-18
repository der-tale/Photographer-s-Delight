# Offers a simple timer to invoke functions on a certain interval

#
class Interval

    options: {}
    state: false

    toggleLink: null

    templates: {
        link: "<a href='javascript:;'></a>" 
    }

    #### Options

    # Interval takes a single object as an option value.
    constructor: (options) ->
        options = if options then options else {}
        @options = _.defaults options, {
            container: null
            state: false
            interval: 3000
            text: {
                stop: "pause"
                start: "play"
            }
            events: {
                tick: null 
            }
        }

        @state = false
        @toggleLink = null

        @_init() 


    #### Public Methods
    start: () =>
        if @state is not true
            @state = true
            @_start

    stop: () =>
        if @state is not false
            @state = false
            @_stop

    #### Private Methods

    # Initialize
    _init: () ->
        if @options.container 
            @toggleLink = $(@templates.link) 
            @options.container.append @toggleLink
            @toggleLink.click @_toggle

        window.setInterval @_tick, @options.interval

        @state = @options.state

        if @state is true
            @_start()
        else
            @_stop()

    _toggle: () =>
        @state = not @state
        if @state is true then @_start() else @_stop()

    _start: () ->
        if @toggleLink 
            @toggleLink.text @options.text.stop

    _stop: () ->
        if @toggleLink
            @toggleLink.text @options.text.start

    _tick: () =>
        if @state
            @options?.events?.tick?()
            

# Now export this class 
root = exports ? this
root.Interval = Interval
