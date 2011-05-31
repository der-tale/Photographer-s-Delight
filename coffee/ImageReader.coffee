class ImageReader

    options: {}
    images: []

    imageMap: []

    loadingList: []
    loadingWaitList: []

    constructor: (options) ->
        options = if options then options else {}
        @options = _.defaults options, {
                    preloadCount: 5
                    parallelLoadCount: 1
                    images: []
                }

        @startLoading()


    startLoading: -> 

        @imageMap = ({
            finished: false
            image: null
            url: image
        } for image in @options.images)
         
        @getImage(0)


    getImage: (index, callback) ->
        
        # If we preload more than 2 images, preload from
        # index - floor(preloadCount / 2) 
        offset =    if @options.preloadCount > 2
                        Math.floor @options.preloadCount / 2
                    else
                        0

        # In doubt, preload more images coming up then previous ones
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
        @loadingWaitList = while (current <= end)
            image = @imageMap[current]
            if current == index 
                image.callback = callback
            else 
                if @options.standardCallback? 
                    image.callback = @options.standardCallback

            current += 1

            image



    

    

    

   
root = exports ? this
root.ImageReader = ImageReader
