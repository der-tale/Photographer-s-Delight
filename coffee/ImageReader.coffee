# Takes a list of image urls and offers methods and callbacks
# to retrieve image dom objects ready to put into the markup. 
#                                                                           
# ImageReader preloads a certain number of previous and next images
# to speed up any potential interaction. Preloading happens (if configured)
# in a parallel fashion up to a certain number of connections.

#
class ImageReader

    options: {}
    images: []

    imageMap: []

    loadingList: []
    loadingWaitList: []

    #### Options

    # ImageReader takes a single object as an option value.
    #
    #     {
    #        preloadCount: 5,
    #        parallelLoadCount: 1,
    #        images: [
    #           "http://www.example.com/images/image1.jpg",
    #           ...
    #        ]
    #     }
    constructor: (options) ->
        options = if options then options else {}
        @options = _.defaults options, {
                    preloadCount: 5
                    parallelLoadCount: 1
                    images: []
                }

        @loadingList = []
        @loadingWaitList = []

        @_startLoading()


    #### Public Methods

    # Returns the total image count
    getImageCount: () ->
        @options.images.length

    # Calls the callback with an image identified by its index from the 
    # sources list. The callback will be called when the image is ready.
    getImage: (index, callback) ->
        
        # If we preload more than 2 images, preload from
        # index - floor(preloadCount / 2) 
        offset =    if @options.preloadCount > 2
                        Math.floor @options.preloadCount / 2
                    else
                        0

        # Preload more images coming up then previous ones.
        offset = if @options.preloadCount % 2 == 0 then offset - 1 else offset

        begin = if (begin = index - offset) >= 0 
                    begin 
                else
                    0

        end =   if (end = index + @options.preloadCount - offset) < @imageMap.length 
                    end
                else
                    @imageMap.length - 1
        
        current = begin 
        loadingWaitList = while (current <= end)
            image = @imageMap[current]

            if current == index 
                image.callback ?= callback
            else 
                image.callback ?= @options.standardCallback

            current += 1

            image

        @loadingWaitList.push loadingWaitList
        @loadingWaitList = _.flatten @loadingWaitList
        @loadingWaitList = _.uniq @loadingWaitList

        @_workOnLoadingList()


    #### Private Methods

    # Build all data structures and start (pre)loading
    _startLoading: -> 

        @imageMap = ({
            finished: false
            image: null
            url: image
            index: _.indexOf @options.images, image
        } for image in @options.images)
         


    # Work on the loading list. Check if there is another image to preload and
    # if there are enough resources left. 
    _workOnLoadingList: ->
        if @loadingWaitList.length >= 1 && @loadingList.length < @options.parallelLoadCount 
            
            current = @loadingWaitList[0]
            @loadingWaitList = _.without @loadingWaitList, current

            if not current.finished 
                @loadingList.push current

                # Mind the order in which we create the image, bind the event handler and 
                # assign the image url. This should now work as expected on all browsers 
                # out there.
                image = new Image()
                current.image = image
                image.src = ""

                jQuery(image).load _.bind(@_loadingFinished, this, current)

                image.src = current.url
                
                # **TODO**: Handle the alt attribute
                if @loadingList.length < @options.parallelLoadCount 
                    @_workOnLoadingList()
            
            else
                @_loadingFinished current


     # Finish callback for the onLoad event. Calls the callback submitted with the
     # image requst.
    _loadingFinished: (imageMapElement, event) =>

        @loadingList = _.without @loadingList, imageMapElement

        imageMapElement.finished = true

        imageMapElement.image = $(imageMapElement.image)

        imageMapElement?.callback?( 
            @imageMap.indexOf(imageMapElement),
            imageMapElement
        )

        imageMapElement.callback = null


        @_workOnLoadingList()

    

# Now export this class 
root = exports ? this
root.ImageReader = ImageReader
