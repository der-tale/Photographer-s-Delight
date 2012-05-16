# Offers a simple timer to invoke functions on a certain interval

#
class Interval

    options: {}
    state: false

    toggleLink: null

    #### Options

    # Interval takes a single object as an option value.
    #
    #      {
    #         container: null,
    #         state: false,
    #         interval: 3000,
    #         text: {
    #              stop: "pause",
    #              start: "play"
    #         },
    #         events: {
    #              tick: null 
    #         }
    #       }
    #
    #
    # The options in detail:
    #
    #   * **container:** DOM element to put the timer control widget into. If
    #     null, no control widget will be displayed.
    #   * **state:** Initial timer state.
    #   * **interval:** Timer interval in miliseconds
    #   * **text:**
    #     * **stop:** Text to display, when the timer is running
    #     * **start:** Text to display, when the timer is not running
    #   * **events:**
    #     * **tick:** Function in invoke when a timer interval is finished
    #
    #
    constructor: (options) ->
        options = if options then options else {}
        @options = _.defaults options, {
            container: null
            state: false
            interval: 3000
            toggleMarkup: $("<a>").attr("href", "javascript:;")
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

    # Start the timer
    start: () =>
        if @state is not true
            @state = true
            @_start

    # Stop the timer
    stop: () =>
        if @state is not false
            @state = false
            @_stop
    
    #### Private Methods

    # Initialize
    _init: () ->
        if @options.container 
            @toggleLink = @options.toggleMarkup
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
