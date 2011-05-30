class ImageReader

    options: {}

    constructor: (options) ->
        options = if options then options else {}
        @options = _.defaults options, {
                    preloadCount: 5
                    parallelLoadCount: 1
                }

   
root = exports ? this
root.ImageReader = ImageReader
