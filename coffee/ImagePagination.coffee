# Offers a simple pagination like menu to select an image to display or
# to go to the next or previous image.

#
class ImagePagination


    options: {}
    previousLink: null
    nextLink: null

    indexLinks: []

    currentImage: -1

    templates: {
        link: "<a href='javascript:;'></a>" 
    }

    #### Options

    # ImageFader takes a single object as an option value.
    #
    #      {
    #          container: null
    #          imageReader: new ImageReader(...)
    #          text: {
    #              previous: "<"
    #              next: ">"
    #          }
    #          css: {
    #              selected: "selected"
    #          }
    #          events: {
    #               display: function() { ... }
    #           }
    #      }
    #
    # The options in detail:
    #
    #   * **container:** DOM element to put the pagination markup into
    #   * **imageReader:** An ImageReader instance
    #   * **text:**
    #     * **previous:** Text to display as previous link
    #     * **next:** Text to display as next link
    #   * **css:**
    #     * **selected:** The CSS class to assign to the current selected 
    #       pagination element
    #   * **events:**
    #     * **display:** This method is called whenever an image link is 
    #       clicked
    constructor: (options) ->
        options = if options then options else {}
        @options = _.defaults options, {
            container: null
            imageReader: null
            text: {
                previous: "<"
                next: ">"
            }
            css: {
                selected: "selected"
            }
            events: {
                display: null
            }
        }

        @previousLink = null
        @nextLink = null
        @indexLinks = []

        @currentImage = -1

        @_init()



    #### Public Methods

    # Display the image with index
    display: (index, options, event) ->
        @indexLinks[index].toggleClass @options.css.selected
        if @currentImage > -1
            @indexLinks[@currentImage].toggleClass @options.css.selected

        @currentImage = index

        if not options?.overrideEvents or options.overrideEvents is not true 
            @options.events?.display?(index)

    # Show the previous image. If the current image is the first one, show the
    # last in the set.
    previous: () =>
        if @currentImage > 0
            @display @currentImage - 1
        else 
            @display @imageCount - 1

    # Show the next image. If the current image is the last one, show the first
    # again.
    next: () =>
        if @currentImage + 1 < @imageCount 
            @display @currentImage + 1
        else
            @display 0



    #### Private Methods

    # Initialize
    _init: () ->
        @imageCount = @options.imageReader.getImageCount()

        # create markup
        @previousLink = $(@templates.link)
        @options.container.append @previousLink.text @options.text.previous  

        for index in [0..@imageCount-1]
            @indexLinks[index] = $(@templates.link)
            @options.container.append @indexLinks[index].text index + 1

        @nextLink = $(@templates.link)
        @options.container.append @nextLink.text @options.text.next  

        # register events
        @previousLink.click @previous
        @nextLink.click @next

        for indexLink in @indexLinks
            indexLink.click _.bind( @display, this, _.indexOf @indexLinks, indexLink )

        # display image one
        @display(0, {
            overrideEvents: true
        })

# Now export this class 
root = exports ? this
root.ImagePagination = ImagePagination
