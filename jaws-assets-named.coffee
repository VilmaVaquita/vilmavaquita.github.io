# LGPL-licensed, please consult jawsjs.com
# conversion to coffeescript modification of src_assets.js from 'jawsjs.com' by Michele Bini  

# this supports named assets: like         named:ImageName:image.png"

jaws = ((jaws) ->
  
  ###*
  @fileOverview jaws.assets properties and functions
  
  Loads and processes image, sound, video, and json assets
  (Used internally by JawsJS to create <b>jaws.assets</b>)
  
  @class Jaws.Assets
  @constructor
  @property {boolean}    bust_cache              Add a random argument-string to assets-urls when loading to bypass any cache
  @property {boolean}    fuchia_to_transparent   Convert the color fuchia to transparent when loading .bmp-files
  @property {boolean}    image_to_canvas         Convert all image assets to canvas internally
  @property {string}     root                    Rootdir from where all assets are loaded
  @property {array}      file_type               Listing of file postfixes and their associated types
  @property {array}      can_play                Listing of postfixes and (during runtime) populated booleans
  ###
  
  ###*
  Returns the length of the resource list
  @public
  @returns {number}  The length of the resource list
  ###
  
  ###*
  Set root prefix-path to all assets
  
  @example
  jaws.assets.setRoot("music/").add(["music.mp3", "music.ogg"]).loadAll()
  
  @public
  @param   {string} path-prefix for all following assets
  @returns {object} self
  ###
  
  ###*
  Get one or more resources from their URLs. Supports simple wildcard (you can end a string with "*").
  
  @example
  jaws.assets.add(["song.mp3", "song.ogg"])
  jaws.assets.get("song.*")  // -> Will return song.ogg in firefox and song.mp3 in IE
  
  @public
  @param   {string|array} src The resource(s) to retrieve
  @returns {array|object} Array or single resource if found in cache. Undefined otherwise.
  ###
  
  # Wildcard? song.*, match against asset-srcs, make sure it's loaded and return content of first match.
  
  # TODO: self.loaded[src] is false for supported files for some odd reason.
  
  ###*
  Returns if specified resource is currently loading or not
  @public
  @param {string} src Resource URL
  @return {boolean|undefined} If resource is currently loading. Otherwise, undefined.
  ###
  
  ###*
  Returns if specified resource is loaded or not
  @param src Source URL
  @return {boolean|undefined} If specified resource is loaded or not. Otherwise, undefined.
  ###
  
  ###*
  Returns lowercase postfix of specified resource
  @public
  @param {string} src Resource URL
  @returns {string} Lowercase postfix of resource
  ###
  
  ###*
  Determine type of file (Image, Audio, or Video) from its postfix
  @private
  @param {string} src Resource URL
  @returns {string} Matching type {Image, Audio, Video} or the postfix itself
  ###
  
  ###*
  Add URL(s) to asset listing for later loading
  @public
  @param {string|array|arguments} src The resource URL(s) to add to the asset listing
  @example
  jaws.assets.add("player.png")
  jaws.assets.add(["media/bullet1.png", "media/bullet2.png"])
  jaws.assets.add("foo.png", "bar.png")
  jaws.assets.loadAll({onload: start_game})
  ###
  
  ###*
  Iterate through the list of resource URL(s) and load each in turn.
  @public
  @param {Object} options Object-literal of callback functions
  @config {function} [options.onprogress] The function to be called on progress (when one assets of many is loaded)
  @config {function} [options.onerror] The function to be called if an error occurs
  @config {function} [options.onload] The function to be called when finished
  ###
  
  ###*
  Loads a single resource from its given URL
  Will attempt to match a resource to known MIME types.
  If unknown, loads the file as a blob-object.
  
  @public
  @param {string} src Resource URL
  @param {Object} options Object-literal of callback functions
  @config {function} [options.onload] Function to be called when assets has loaded
  @config {function} [options.onerror] Function to be called if an error occurs
  @example
  jaws.load("media/foo.png")
  jaws.load("http://place.tld/foo.png")
  ###
  # NOTE: assetLoaded can be called several times during loading.
  
  #Load everything else as raw blobs...
  
  # ... But don't load un-supported audio-files.
  
  # Initial loading callback for all assets for parsing specific filetypes or
  # optionally converting images to canvas-objects.
  # @private
  # @param {EventObject} event The EventObject populated by the calling event
  # @see processCallbacks()
  
  #
  #       * Only increment load_count ONCE per unique asset.
  #       * This is needed cause assetLoaded-callback can in certain cases be called several for a single asset...
  #       * ..and not only Once when it's loaded.
  #       
  
  # Called when jaws asset-handler decides that an asset shouldn't be loaded
  # For example, an unsupported audio-format won't be loaded.
  
  # @private
  
  # Increases the error count and calls processCallbacks with false flag set
  # @see processCallbacks()
  # @private
  # @param {EventObject} event The EventObject populated by the calling event
  
  # Processes (if set) the callbacks per resource
  # @private
  # @param {object} asset The asset to be processed
  # @param {boolean} ok If an error has occured with the asset loading
  # @param {EventObject} event The EventObject populated by the calling event
  # @see jaws.start() in core.js

  # Displays the progress of asset handling as an overall percentage of all loading
  # (Can be overridden as jaws.assets.displayProgress = function(percent_done) {})
  # @public
  # @param {number} percent_done The overall percentage done across all resource handling

  # Make Fuchia (0xFF00FF) transparent (BMPs ONLY)
  # @private
  # @param {HTMLImageElement} image The Bitmap Image to convert
  # @returns {CanvasElement} canvas The translated CanvasElement

  fuchiaToTransparent = (image) ->
    return  unless jaws.isDrawable(image)
    canvas = (if jaws.isImage(image) then jaws.imageToCanvas(image) else image)
    context = canvas.getContext("2d")
    img_data = context.getImageData(0, 0, canvas.width, canvas.height)
    pixels = img_data.data
    i = 0

    while i < pixels.length
      # Color: Fuchia
      pixels[i + 3] = 0  if pixels[i] is 255 and pixels[i + 1] is 0 and pixels[i + 2] is 255 # Set total see-through transparency
      i += 4
    context.putImageData img_data, 0, 0
    canvas
  jaws.Assets = Assets = ->
    getType = (src) ->
      if jaws.isString(src)
        postfix = self.getPostfix(src)
        (if self.file_type[postfix] then self.file_type[postfix] else postfix)
      else
        jaws.log.error "jaws.assets.getType: Argument not a String with " + src
      return
    assetLoaded = (event) ->
      asset = @asset
      src = asset.src
      filetype = getType(asset.src)
      try
        if filetype is "json"
          return  if @readyState isnt 4
          self.data[asset.src] = JSON.parse(@responseText)
        else if filetype is "image"
          new_image = (if self.image_to_canvas then jaws.imageToCanvas(asset.image) else asset.image)
          new_image = fuchiaToTransparent(new_image)  if self.fuchia_to_transparent and self.getPostfix(asset.src) is "bmp"
          self.data[asset.src] = new_image
        else if filetype is "audio" and self.can_play[self.getPostfix(asset.src)]
          self.data[asset.src] = asset.audio
        else if filetype is "video" and self.can_play[self.getPostfix(asset.src)]
          self.data[asset.src] = asset.video
        else
          self.data[asset.src] = @response
      catch e
        jaws.log.error "Cannot process " + src + " (Message: " + e.message + ", Name: " + e.name + ")"
        self.data[asset.src] = null
      self.load_count++  unless self.loaded[src]
      self.loaded[src] = true
      self.loading[src] = false
      processCallbacks asset, true, event
      return
    assetSkipped = (asset) ->
      self.loaded[asset.src] = true
      self.loading[asset.src] = false
      self.load_count++
      processCallbacks asset, true
      return
    assetError = (event) ->
      asset = @asset
      self.error_count++
      processCallbacks asset, false, event
      return
    processCallbacks = (asset, ok, event) ->
      percent = parseInt((self.load_count + self.error_count) / self.src_list.length * 100)
      if ok
        self.onprogress asset.src, percent  if self.onprogress
        asset.onprogress event  if asset.onprogress and event isnt `undefined`
      else
        self.onerror asset.src, percent  if self.onerror
        asset.onerror event  if asset.onerror and event isnt `undefined`
      if percent is 100
        self.onload()  if self.onload
        self.onprogress = null
        self.onerror = null
        self.onload = null
      return
    return new arguments.callee()  unless this instanceof arguments.callee
    self = this
    self.loaded = []
    self.loading = []
    self.src_list = []
    self.data = []
    self.bust_cache = false
    self.image_to_canvas = true
    self.fuchia_to_transparent = true
    self.root = ""
    self.file_type = {}
    self.file_type["json"] = "json"
    self.file_type["wav"] = "audio"
    self.file_type["mp3"] = "audio"
    self.file_type["ogg"] = "audio"
    self.file_type["m4a"] = "audio"
    self.file_type["weba"] = "audio"
    self.file_type["aac"] = "audio"
    self.file_type["mka"] = "audio"
    self.file_type["flac"] = "audio"
    self.file_type["png"] = "image"
    self.file_type["jpg"] = "image"
    self.file_type["jpeg"] = "image"
    self.file_type["gif"] = "image"
    self.file_type["bmp"] = "image"
    self.file_type["tiff"] = "image"
    self.file_type["mp4"] = "video"
    self.file_type["webm"] = "video"
    self.file_type["ogv"] = "video"
    self.file_type["mkv"] = "video"
    self.can_play = {}
    try
      audioTest = new Audio()
      self.can_play["wav"] = !!audioTest.canPlayType("audio/wav; codecs=\"1\"").replace(/^no$/, "")
      self.can_play["ogg"] = !!audioTest.canPlayType("audio/ogg; codecs=\"vorbis\"").replace(/^no$/, "")
      self.can_play["mp3"] = !!audioTest.canPlayType("audio/mpeg;").replace(/^no$/, "")
      self.can_play["m4a"] = !!(audioTest.canPlayType("audio/x-m4a;") or audioTest.canPlayType("audio/aac;")).replace(/^no$/, "")
      self.can_play["weba"] = !!audioTest.canPlayType("audio/webm; codecs=\"vorbis\"").replace(/^no$/, "")
      self.can_play["aac"] = !!audioTest.canPlayType("audio/aac;").replace(/^no$/, "")
      self.can_play["mka"] = !!audioTest.canPlayType("audio/x-matroska;").replace(/^no$/, "")
      self.can_play["flac"] = !!audioTest.canPlayType("audio/x-flac;").replace(/^no$/, "")
    try
      videoTest = document.createElement("video")
      self.can_play["mp4"] = !!videoTest.canPlayType("video/mp4;").replace(/^no$/, "")
      self.can_play["webm"] = !!videoTest.canPlayType("video/webm; codecs=\"vorbis\"").replace(/^no$/, "")
      self.can_play["ogv"] = !!videoTest.canPlayType("video/ogg; codecs=\"vorbis\"").replace(/^no$/, "")
      self.can_play["mkv"] = !!videoTest.canPlayType("video/x-matroska;").replace(/^no$/, "")
    self.length = ->
      self.src_list.length

    self.setRoot = (path) ->
      self.root = path
      self

    self.get = (src) ->
      if jaws.isArray(src)
        src.map (i) ->
          self.data[i]

      else if jaws.isString(src)
        if src[src.length - 1] is "*"
          needle = src.replace("*", "")
          i = 0

          while i < self.src_list.length
            return self.data[self.src_list[i]]  if self.src_list[i].indexOf(needle) is 0 and self.data[self.src_list[i]]
            i++
        if self.data[src]
          self.data[src]
        else
          jaws.log.warn "No such asset: " + src, true
      else
        jaws.log.error "jaws.get: Neither String nor Array. Incorrect URL resource " + src
        return
      return

    self.isLoading = (src) ->
      if jaws.isString(src)
        self.loading[src]
      else
        jaws.log.error "jaws.isLoading: Argument not a String with " + src
      return

    self.isLoaded = (src) ->
      if jaws.isString(src)
        self.loaded[src]
      else
        jaws.log.error "jaws.isLoaded: Argument not a String with " + src
      return

    self.getPostfix = (src) ->
      if jaws.isString(src)
        src.toLowerCase().match(/.+\.([^?]+)(\?|$)/)[1]
      else
        jaws.log.error "jaws.assets.getPostfix: Argument not a String with " + src
      return

    self.add = (src) ->
      list = arguments
      list = list[0]  if list.length is 1 and jaws.isArray(list[0])
      i = 0

      while i < list.length
        if jaws.isArray(list[i])
          self.add list[i]
        else
          if jaws.isString(list[i])
            self.src_list.push list[i]
          else
            jaws.log.error "jaws.assets.add: Neither String nor Array. Incorrect URL resource " + src
        i++
      self

    self.loadAll = (options) ->
      self.load_count = 0
      self.error_count = 0
      self.onprogress = options.onprogress  if options.onprogress and jaws.isFunction(options.onprogress)
      self.onerror = options.onerror  if options.onerror and jaws.isFunction(options.onerror)
      self.onload = options.onload  if options.onload and jaws.isFunction(options.onload)
      self.src_list.forEach (item) ->
        self.load item
        return

      self

    self.load = (src, options) ->
      options = {}  unless options
      unless jaws.isString(src)
        jaws.log.error "jaws.assets.load: Argument not a String with " + src
        return
      asset = {}
      resolved_src = ""
      if parts =/^named:([^:]+):/.exec src
        asset.name = parts[1]
        src = src.substring parts[0].length
      asset.src = src
      asset.onload = options.onload
      asset.onerror = options.onerror
      self.loading[src] = true
      parser = RegExp("^((f|ht)tp(s)?:)?//")
      if /^[a-z][a-z0-9-]*:/.test(src)
        resolved_src = asset.src
      else
        resolved_src = self.root + asset.src
      resolved_src += "?" + parseInt(Math.random() * 10000000)  if self.bust_cache
      type = getType(asset.src)
      if type is "image"
        try
          asset.image = new Image()
          asset.image.asset = asset
          asset.image.addEventListener "load", assetLoaded
          asset.image.addEventListener "error", assetError
          asset.image.src = resolved_src
        catch e
          jaws.log.error "Cannot load Image resource " + resolved_src + " (Message: " + e.message + ", Name: " + e.name + ")"
      else if self.can_play[self.getPostfix(asset.src)]
        if type is "audio"
          try
            asset.audio = new Audio()
            asset.audio.asset = asset
            asset.audio.addEventListener "error", assetError
            asset.audio.addEventListener "canplay", assetLoaded
            self.data[asset.src] = asset.audio
            asset.audio.src = resolved_src
            asset.audio.load()
          catch e
            jaws.log.error "Cannot load Audio resource " + resolved_src + " (Message: " + e.message + ", Name: " + e.name + ")"
        else if type is "video"
          try
            asset.video = document.createElement("video")
            asset.video.asset = asset
            self.data[asset.src] = asset.video
            asset.video.setAttribute "style", "display:none;"
            asset.video.addEventListener "error", assetError
            asset.video.addEventListener "canplay", assetLoaded
            document.body.appendChild asset.video
            asset.video.src = resolved_src
            asset.video.load()
          catch e
            jaws.log.error "Cannot load Video resource " + resolved_src + " (Message: " + e.message + ", Name: " + e.name + ")"
      else
        if type is "audio" and not self.can_play[self.getPostfix(asset.src)]
          assetSkipped asset
          return self
        try
          req = new XMLHttpRequest()
          req.asset = asset
          req.onreadystatechange = assetLoaded
          req.onerror = assetError
          req.open "GET", resolved_src, true
          req.responseType = "blob"  if type isnt "json"
          req.send null
        catch e
          jaws.log.error "Cannot load " + resolved_src + " (Message: " + e.message + ", Name: " + e.name + ")"
      self

    self.displayProgress = (percent_done) ->
      return  unless jaws.isNumber(percent_done)
      return  unless jaws.context
      jaws.context.save()
      jaws.context.fillStyle = "black"
      jaws.context.fillRect 0, 0, jaws.width, jaws.height
      jaws.context.fillStyle = "white"
      jaws.context.strokeStyle = "white"
      jaws.context.textAlign = "center"
      jaws.context.strokeRect 50 - 1, (jaws.height / 2) - 30 - 1, jaws.width - 100 + 2, 60 + 2
      jaws.context.fillRect 50, (jaws.height / 2) - 30, ((jaws.width - 100) / 100) * percent_done, 60
      jaws.context.font = "11px verdana"
      jaws.context.fillText "Loading... " + percent_done + "%", jaws.width / 2, jaws.height / 2 - 35
      jaws.context.font = "11px verdana"
      jaws.context.fillStyle = "#ccc"
      jaws.context.textBaseline = "bottom"
      jaws.context.fillText "powered by www.jawsjs.com", jaws.width / 2, jaws.height - 1
      jaws.context.restore()
      return

    return

  jaws.assets = new jaws.Assets()
  jaws
)(jaws or {})
