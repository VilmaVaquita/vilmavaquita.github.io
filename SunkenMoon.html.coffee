# Copyright (c) 2013, 2014 Michele Bini

# A game featuring a Vaquita, the smallest, most endagered marine cetacean

# This program is available under the terms of the MIT License

version = "0.1.764"

{ htmlcup } = require 'htmlcup'

htmlcup[x] = htmlcup.compileTag x for x in [ "svg", "rect", "g", "ellipse", "polygon", "line", "image", "defs", "linearGradient", "stop", "use" ]

title = "Vilma, the happy Vaquita - Sunken Moon"

fs = require 'fs'

datauri = (t,x)-> "data:#{t};base64,#{new Buffer(fs.readFileSync(x)).toString("base64")}"
datauripng = (x)-> datauri "image/png", x
datauriicon = (x)-> datauri "image/x-icon", x

icon = datauriicon "vaquita.ico"
pixyvaquita = datauripng "vilma.png"

frames =
  _: pixyvaquita
  twist_l: datauripng "vilma_twist_l.png"
  twist_r: datauripng "vilma_twist_r.png"
  happybubble0: datauripng "Happy-oxygen-bubble.png"
  grumpybubble0: datauripng "Grumpy-bubble.png"
  evilbubble0: datauripng "Evil-bubble.png"
  stilla0: datauripng "Stilla-the-starfish.png"

gameName = "#{title} v#{version}"

htmlcup.jsFile = (f)-> @script type:"text/javascript", (fs.readFileSync(f).toString())

gameAreaSize = [ 240, 360 ]

genPage = ->
 htmlcup.printHtml "<!DOCTYPE html>\n"
 htmlcup.html lang:"en", manifest:"SunkenMoon.appcache", style:"height:100%", ->
  @head ->
    @meta charset:"utf-8"
    @meta name:"viewport", content:"width=480, user-scalable=no"
    @meta name:"apple-mobile-web-app-capable", content:"yes"
    @meta name:"mobile-web-app-capable", content:"yes"
    # Improve support: http://www.html5rocks.com/en/mobile/fullscreen/
    # Homescreen installed webapp on Android Chrome has weird name! (Web App)
    @link rel:"shortcut icon", href:icon
    @title title
  @body style:"margin:0;border:0;padding:0;height:100%;width:100%;background:black", ->
    @div style:"visibility:hidden;position:absolute", ->
        @img id:"pixyvaquita", src:pixyvaquita
        @img id:"pixyvaquita_twist_l", src:frames.twist_l
        @img id:"pixyvaquita_twist_r", src:frames.twist_r
        @img id:"happybubble0", src:frames.happybubble0
        @img id:"grumpybubble0", src:frames.grumpybubble0
        @img id:"evilbubble0", src:frames.evilbubble0
        @img id:"stilla0", src:frames.stilla0
    @div style:"display:table;width:100%;max-width:100%;height:100%;margin:0;border:0;padding:0", ->
     @div style:"display:table-cell;vertical-align:middle;width:100%;margin:0;border:0;padding:0;text-align:center", ->
      @div style:"position:relative;display:inline-block",  width:"#{gameAreaSize[0]*2}", height:"#{gameAreaSize[1]*2}", ->
        @canvas width:"#{gameAreaSize[0]*2}", height:"#{gameAreaSize[1]*2}"
        @header style:"position:absolute;top:0;left:0;font-size:14px;width:100%;color:black", ->
          @span gameName
          @span " - "
          @a target:"_blank", href:"index.html", "Save Vaqitas"
          @div style:"text-align:right", id:"fps"
    gameObjects = null
    @script type:"text/javascript", "gameObjects=#{JSON.stringify(gameObjects)};"
    @script type:"text/javascript", "__hasProp = {}.hasOwnProperty; __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };"
    @jsFile "jaws/jaws-min.js"
    # @jsFile "jaws-assets-named.js"
    @coffeeScript -> do ->

      # reportErrors = (x)->
      #   try
      #     x()
      #   catch error
      #     try
      #       alert error.toString()
      #     catch error2
      #       alert error

      screen_x1 = 120
      screen_y1 = 180
      { sqrt } = Math

      ###
      # an ad-hoc redux of hammer.js
      hammerLet = do(window, navigator)@>
        mobile_regex: mobile_regex = /mobile|tablet|ip(ad|hone|od)|android/i
        support_touch: support_touch = ('ontouchstart' in window)
        prefixed: prefixed =
          global: window
          get: (sym)@>
            { global } = @g
            for v in @vendors
              return r if (r = global[v + sym])?
            undefined
          vendors: [ 'webkit', 'moz', 'MS', 'ms', 'o' ]
        PointerEvent: PointerEvent ? prefixed.run(window, 'PointerEvent')?
        suppourt_touch_only: support_touch && mobile_regex.test(navigator.userAgent)
      ###
      jaws.onload = ->
        class Demo
          keyCodes: { left: leftKey, right: rightKey, up: upKey, down: downKey, space: spaceKey } = jaws.keyCodes
          Sprite: Sprite = class extends jaws.Sprite
            # caller needs to set lr for flip center
            constructor: ->
              super
                image: @image
                x: 0
                y: 0
                scale: 2
            draw: ->
              @flipped = @lr >= 0
              @x = (screen_x1 + @px + @lr) * 2
              @y = (screen_y1 + @py - @tb) * 2
              super()
          Bubble: Bubble = Sprite
          HappyBubble: HappyBubble = class extends Bubble
            image: happybubble0
            constructor: ->
              @lr = 3
              @tb = 3
              super()
            draw: ->
              @py--
              super()
          GrumpyBubble: GrumpyBubble = class extends Bubble
            image: grumpybubble0
            constructor: ->
              @lr = 6
              @tb = 6
              super()
            draw: ->
              @py -= 3
              super()
          EvilBubble: EvilBubble = class extends Bubble
            image: evilbubble0
            constructor: ->
              @lr = 12
              @tb = 12
              super()
            draw: ->
              @py -= 8
              super()
          Stilla: Stilla = class extends Bubble
            image: stilla0
            Bubble: @Bubble
            constructor: ->
              @lr = 12
              @tb = 12
              super()
          Vaquita: Vaquita = class extends Sprite
            twist: [ pixyvaquita_twist_l, pixyvaquita_twist_r ]
            constructor: ->
              @lr = 18
              @tb = 5
              super()
            draw: ->
                  if @vx < 0
                    @lr = - 18
                  else if @vx > 0
                    @lr = 18
                  super()
          AiVaquita: AiVaquita = class extends Vaquita
            constructor: ->
              @image = pixyvaquita
              @time = 0
              super()
            beat_lr: 0
            draw: ->
                  vx = @vx + Math.floor(Math.random()*3) - 1
                  vy = @vy + Math.floor(Math.random()*3) - 1
                  x = @px
                  y = @py
                  rx = 0.5 * x / screen_x1
                  ry = 0.5 * y / screen_y1
                  if (s = vx * vx + vy * vy * 2) > 6
                    vx = Math.round(vx * 0.8 - rx)
                    vy = Math.round(vy * 0.8 - ry)
                  @px += @vx = vx
                  @py += @vy = vy
                  if (@time++ % 3) is 0
                    if @image isnt pixyvaquita
                      @image = pixyvaquita
                    else if vx * vx + vy * vy > 2
                      @image = @twist[ @beat_lr++ & 1 ]
                  super()
          Vilma: Vilma = class extends Vaquita
            constructor: (@game)->
              @image = pixyvaquita
              @time = 0
              super()
              @fpx = @px ? 0
              @fpy = @py ? 0
              @touch = @game.touchInput
            beat_lr: 0
            move: ->
              { touch } = @
              { tx, ty } = touch
              itx = (tx >= 2 then 2 else tx <= -2 then -2 else 0)
              ity = (ty >= 2 then 2 else ty <= -2 then -2 else 0)
              touch.tx = tx * 0.9 - itx
              touch.ty = ty * 0.9 - ity
              ax = (if jaws.pressed[leftKey]  then -1 else 0)    +   (if jaws.pressed[rightKey]  then 1 else 0) - itx / 2
              ay = (if jaws.pressed[upKey]    then -1 else 0)    +   (if jaws.pressed[downKey]   then 1 else 0) - ity / 2
              if (aq = ax * ax + ay * ay) > 1
                aq = sqrt(aq)
                ax /= aq
                ay /= aq
              ax *= 0.618
              ay *= 0.618
              vx = @vx
              vy = @vy
              if ax * vx < 0
                vx = 0
              else
                vx += ax
                vx *= 0.9
              if ay * vy < 0
                vy = 0
              else
                vy += ay
                vy *= 0.9
              @vx = vx
              @vy = vy
              @px = (@fpx += @vx)
              @py = (@fpy += @vy)
            draw: ->
              { vx, vy } = @
              if (@time++ % 3) is 0
                if @image isnt pixyvaquita
                  @image = pixyvaquita
                else if vx * vx + (vy * vy / 4) > 1
                  @image = @twist[@beat_lr++ & 1]
              super()
          addVaquita: ->
              # n = v.cloneNode()
              # n.setAttribute "opacity", "0.5"
              # n.href.baseVal = "#_v105" if Math.random(0) > 0.5
              # n.setAttribute "transform", ""
              # sea.appendChild n
              angle = Math.random() * 6.28
              v = new AiVaquita
              v.vx = 0
              v.vy = 0
              v.px = Math.floor(Math.sin(angle) * 300)
              v.py = Math.floor(Math.cos(angle) * 300)
              v.draw()
              # vaquita.update()
              @vaquitas.push v
          addStilla: (x, y)@>
            return if @stilla?
            v = new @Stilla
            v.px = x
            v.py = y
            @stilla = v
          addInto: (n, v, x, y)@>
              v.vx = 0
              v.vy = 0
              v.px = x
              v.py = y
              b = @[n]
              if (i = b.indexOf(null)) >= 0
                b[i] = v
              else
                b.push v
              v.draw()
          constructor: (@vaquitas = [], @cameos = [], @stilla = null)->
          encounters:
            __proto__:
              encounter: encounter =
                add: (game, x, y)@> game.addInto('cameos', new @creature(), x, y)
                vy: 0
              random: Math.random
              log: Math.log
              exp: Math.exp
              pow: Math.pow
              poissonSample: (m)@>
                { exp, random } = @
                pgen = (m)->
                    x = 0
                    p = exp(-m)
                    s = p
                    u = random()
                    while u > s
                        x++
                        p = p * m / x
                        s += p
                    x
                s = 0
                while m > 50
                  s += pgen 50
                  m -= 50
                s + pgen m
              generate: (game,left,top,width,height,vx,vvy)@>
                { probability, random } = @
                genRect = (m,left,top,width,height)=>
                  c = m.p * width * height
                  # c = 0
                  c = @poissonSample(c)
                  # c = 0 # if c > 1000
                  # c-- if random() > 0.15
                  while c-- > 0
                    m.add?( game, left + ((random() * width)|0), top + ((random() * height)|0) )
                    1
                if vx * vx >= width * width
                  for k,v of @
                    genRect(v, left, top, width, height)
                else for k,v of @
                  vy = vvy - v.vy
                  if vy * vy >= height * height
                    genRect(v, left, top, width, height)
                  else if vx > 0
                    if vy > 0
                      genRect(v, left, top + height - vy, width, vy)
                      genRect(v, left + width - vx, top, vx, height - vy)
                    else if vy < 0
                      genRect(v, left, top, width, -vy)
                      genRect(v, left + width - vx, top - vy, vx, height + vy)
                    else
                      genRect(v, left + width, top, vx, height)
                  else if vx < 0
                    if vy > 0
                      genRect(v, left, top + height - vy, width, vy)
                      genRect(v, left, top, -vx, height - vy)
                    else if vy < 0
                      genRect(v, left, top, width, -vy)
                      genRect(v, left, top - vy, -vx, height + vy)
                    else
                      genRect(v, left, top, -vx, height)
                  else if vy > 0
                    genRect(v, left, top + height - vy, width, vy)
                  else if vy < 0
                    genRect(v, left, top, width, -vy)
            happybubble:
                __proto__: encounter
                p: 1/1000
                creature: HappyBubble
                vy: -1
            grumpybubble:
                __proto__: encounter
                p: 1/9000
                creature: GrumpyBubble
                vy: -3
            evilbubble:
                __proto__: encounter
                p: 1/18000
                creature: EvilBubble
                vy: -8
            stilla:
                __proto__: encounter
                p: 1/40000
                add: (game, x, y)@> game.addStilla(x, y)
          touchInput:
            tx: 0
            ty: 0
            ongoing: { }
            __proto__:
              eval: eval
              start: (ev,el)@>
                { ongoing } = @
                for t in ev.changedTouches
                  { identifier, pageX, pageY } = t
                  ongoing[identifier] =
                    px: pageX
                    py: pageY
              move: (ev,el)@>
                { ongoing } = @
                for t in ev.changedTouches
                  { identifier, pageX, pageY } = t
                  o = ongoing[identifier]
                  @tx += pageX - o.px
                  @ty += pageY - o.py
                  o.px = pageX
                  o.py = pageY
              end: (ev,el)@>
                { ongoing } = @
                for t in ev.changedTouches
                  { identifier } = t
                  delete ongoing[identifier]
              handle: (name)->
                touchInput = @
                (event)->
                  event.preventDefault()
                  event.stopPropagation()
                  touchInput[name](event,this) catch err
                    alert err.toString()
          ColorPlane: ColorPlane = do->
            document: document
            init: @>
              { color } = @
              if color and typeof color is 'string'
                e = @document.createElement "canvas"
                e.width   = @w
                e.height  = @h
                ctx = e.getContext '2d'
                @color = ctx.fillStyle = color
            frame: (t)@>
              # t.save()
              t.fillStyle = @color
              t.fillRect 0,0,1024,1024
              # t.restore()
          GenericPlane: GenericPlane =
            document: document
            init: @>
              { document } = @
              e = document.createElement "canvas"
              e.width   = @w
              e.height  = @h
              @ctx = e.getContext '2d'
          ParallaxPlane: ParallaxPlane =
            __proto__: GenericPlane
            ParallaxPlaneSuper: GenericPlane
            lower: null
            logscale: 2
            x: 0
            y: 0
            fx: 0
            fy: 0
            frame: (t,dx,dy)@>
              { fx, fy, x, y, logscale, w, h, ctx } = @
              nfx = fx + dx
              nfy = fy + dy
              nx = nfx >> logscale
              ny = nfy >> logscale
              if nx isnt x
                if nx >= w
                  nx -= w
                  nfx -= w << logscale
                else if nx < 0
                  nx += w
                  nfx += w << logscale
                @x = nx
              if ny isnt y
                if ny >= h
                  ny -= h
                  nfy -= h << logscale
                else if ny < 0
                  ny += h
                  nfy += h << logscale
                @y = ny
              @fx = nfx
              @fy = nfy
              @lower?.frame t, dx >> logscale, dy >> logscale
              { canvas } = ctx
              t.drawImage canvas,  nx,      ny
              t.drawImage canvas,  nx - w,  ny
              t.drawImage canvas,  nx,      ny - h
              t.drawImage canvas,  nx - w,  ny - h
            init: @>
              @lower?.init()
              @ParallaxPlaneSuper.init.call @
          SeamlessPlane: SeamlessPlane =
            withRect: (rx,ry,rw,rh,cb)@>
              { w, h } = @
              if (ex = rx + rw) > w
                if (ey = ry + rh) > h
                  cb  rx,  ry,  w - rx,  h - ry, 0,      0
                  cb  0,   ry,  ex - w,  h - ry, w - rx, 0
                  cb  rx,  0,   w - rx,  ey - h, 0,      h - ry
                  cb  0,   0,   ex - w,  ey - h, w - rx, h - ry
                else
                  cb rx, ry, w - rx, rh, 0,      0
                  cb 0,  ry, ex - w, rh, w - rx, 0
              else
                if (ey = ry + rh) > h
                  cb rx, ry, rw, h - ry, 0, 0
                  cb rx, 0,  rw, ey - h, 0, h - ry
                else
                  cb rx, ry, rw, rh, 0, 0
            __proto__: ParallaxPlane
          WaterPlane: WaterPlane = do->
            waterscapeSuper: waterscapeSuper = SeamlessPlane
            __proto__: waterscapeSuper
            random: Math.random
            sqrt: Math.sqrt
            colors: [ "cyan", "blue" ]
            randomStuff: @>
              { random, sqrt, ctx } = @
              s = sqrt(15000 / (random() * 100 + 1)) | 0
              @withRect (random() * @w | 0), (random() * @h | 0), s, s >> 2, (x,y,w,h)->
                ctx.fillRect x,y,w,h
              @
            init: @>
              { lower, w, h, moltf, colors } = @
              if lower?
                lower.w ?= w
                lower.h ?= h
                lower.moltf ?= moltf >> lower.logscale if moltf?
              @waterscapeSuper.init.call @
              { ctx } = @
              for k,v of colors
                ctx.fillStyle = v
                colors[k] = ctx.fillStyle
              ctx.globalAlpha = 0.06
              if false
                x = 300
                while x-- > 0
                  @randomStuff()
            waterscapeSuperFrame: waterscapeSuper.frame
            frame: (t)@>
              { ctx, moltf, random } = @
              
              ctx.fillStyle = @colors[ random() * 1.2 | 0 ]
              @randomStuff() while moltf-- > 0

              # t.save()
              t.globalAlpha = @alpha
              @waterscapeSuperFrame.apply @, arguments
              # t.restore()
            logscale: 0
          
          # PinkWaveletPlane: PinkWaveletPlane = do->
          #   waterscapeSuper: waterscapeSuper = SeamlessPlane
          #   __proto__: waterscapeSuper
          #   random: Math.random
          #   sqrt: Math.sqrt
          #   sprites: [ "cyan", "blue" ]
          #   wlets: null
          #   randmix: @>
          #     { random, sqrt, ctx } = @
          #     s = sqrt(15000 / (random() * 100 + 1)) | 0
          #     @withRect (random() * @w | 0), (random() * @h | 0), s, s >> 2, (x,y,w,h)->
          #       ctx.fillRect x,y,w,h
          #     @
          #   init: @>
          #     { lower, w, h, moltf, colors } = @
          #     if lower?
          #       lower.w ?= w
          #       lower.h ?= h
          #       lower.moltf ?= moltf >> lower.logscale if moltf?
          #     @waterscapeSuper.init.call @
          #     { ctx } = @
          #     for k,v of colors
          #       ctx.fillStyle = v
          #       colors[k] = ctx.fillStyle
          #     ctx.globalAlpha = 0.06
          #     if true
          #       x = 300
          #       while x-- > 0
          #         @randomStuff()
          #   waterscapeSuperFrame: waterscapeSuper.frame
          #   frame: (t)@>
          #     { ctx, moltf, random } = @
              
          #     ctx.fillStyle = @colors[ random() * 1.2 | 0 ]
          #     @randomStuff() while moltf-- > 0

          #     { alpha } = @
          #     # t.save()
          #     t.globalAlpha = alpha if alpha?
          #     @waterscapeSuperFrame.apply @, arguments
          #     # t.restore()
          #   logscale: 0
          waterscape: waterscape = do->
            __proto__: WaterPlane
            # color: "cyan"
            logscale: 0
            moltf: 12
            colors: [ "#051555", "#33ddff" ]
            alpha: 0.3
            lower:
              logscale: 2
              __proto__: WaterPlane
              # color: "blue"
              colors: [ "#0000ff", "#0077ff" ]
              alpha: 0.3
              lower:
                  color: "#051555"
                  __proto__: ColorPlane
          bluescape:
            __proto__: SeamlessPlane
            bluescapeSuper: SeamlessPlane
            lower: waterscape
            frame: (t,sx,sy)@>
              { ctx, random, w, h } = @

              x = @x + sx
              x = (x + w) % w
              y = (y + h) % h
              @x = x
              y = @y + sy
              y += h while y < 0
              y -= h while y >= h
              @y = y
              # i = ctx.getImageData(0,0,@w,@h)

              ctx.save()
              @lower.frame ctx, sx, sy
              ctx.restore()
              # t.save()
              # t.globalCompositeOperation = 'copy'

              t.drawImage ctx.canvas, 0,0,w,h, 0,0,w*4,h*4
              
              # t.drawImage ctx.canvas, 0,0,w>>2,h>>2, 0,0,w*2,h*2

              # t.drawImage ctx.canvas, 0,0,w>>2,h>>2, 0,0,w*2,h>>2
              # t.drawImage t.canvas, 0,0,w*2,h>>2, 0,0,w*2,h*2

              # t.restore()
              # @withRect x, y, rx*2, ry*2, (x,y,w,h,ox,oy)-> t.drawImage c, x,y,w,h, ox*2,oy*2,w*2,h*2
              # t.drawImage c, 0, 0, 
              # t.fillColor = if random() > 0.5 then "#104080" else "#155590"
              # t.fillRect 0, 0, 100, 100
              # t.clearRect 0, 0, 100, 100
              # t.drawImage t, 0, 0, 100, 100, 50, 50, 100, 100
            init: @>
              { w, h, lower } = @

              @w = w
              @h = h

              lower.w = (w >> 2) * 5
              lower.h = (h >> 2) * 5

              @bluescapeSuper.init.call @

              { ctx } = @

              # ctx.fillStyle = "#0099dd"
              # ctx.fillRect 0, 0, @w, @h
              
          setup: ->
            { bluescape, radx, rady } = @
            bluescape.w = radx
            bluescape.h = rady
            bluescape.init()
            v = new Vilma(@) # jaws.Sprite x:screen_x1*2, y:screen_y1*2, scale:2, image:pixyvaquita
            v.px = 0
            v.py = 0
            v.vx = 0
            v.vy = 0
            @vilma = v
            @encounters.generate(@,-radx, -rady, radx * 2, rady * 2, radx * 2, 0)
            { touchInput } = @
            touchInput.game = @
            x = document.body
            x.addEventListener "touchmove",   touchInput.handle('move'), true
            x.addEventListener "touchstart",  touchInput.handle('start'), true
            tend = touchInput.handle 'end'
            x.addEventListener "touchend",     tend, true
            x.addEventListener "touchleave",   tend, true
            x.addEventListener "touchcancel",  tend, true
          radx: screen_x1
          rady: screen_y1
          rad: screen_x1 * screen_x1 + screen_y1 * screen_y1
          draw: @>
            { jaws, spaceKey, radx, rady, vilma, vaquitas, cameos, stilla, rad } = @
            @addVaquita() if (!(@gameloop.ticks & 0x7f) and vaquitas.length < 1) or jaws.pressed[spaceKey]
            vilma.move()
            { px, py } = vilma
            vilma.fpx = 0
            vilma.fpy = 0
            vilma.px = 0
            vilma.py = 0
            px = px | 0
            py = py | 0
            @bluescape.frame jaws.context, -px, -py
            collidables = [ vilma ]
            for v in vaquitas
              v.px -= px
              v.py -= py
              v.draw()
            vilma.draw()
            if stilla?
              x = stilla.px -= px
              y = stilla.py -= py
              if x * x + y * y > rad * 16
                @stilla = null
              else
                stilla.draw()
            for k,v of cameos
              continue unless v?
              x = v.px -= px
              y = v.py -= py
              if (x < -radx) or (x >= radx) or (y < -rady) or (y >= rady)
                cameos[k] = null
              else
                v.draw()
            @encounters.generate(@,-radx, -rady, radx * 2, rady * 2, px, py)
              
            if (@gameloop.ticks & 0xff) is 0xff
              fps.innerHTML = "#{@gameloop.fps} fps"
          jaws: jaws
          spaceKey: spaceKey
        if true
          jaws.init()
          jaws.setupInput();
          window.game = game = new Demo
          gameloop = new jaws.GameLoop(game, { fps:24 })
          (game.gameloop = gameloop).start()
        else
          jaws.start Demo, fps:25

      #   gameFrame = -> reportErrors ->
      #     if (time & 0xff) is 0x00 and vaquitas.length < 4
      #       addVaquita()
      #     # s += 0.001
      #     x -= vx = pressedKeys[leftKey] - pressedKeys[rightKey]
      #     y -= pressedKeys[upKey] - pressedKeys[downKey]
      #     if vx > 0
      #       scaleX = 1
      #     else if vx < 0
      #       scaleX = -1
      #     v.setAttribute("transform", "translate(#{x}, #{y}) scale(#{scaleX}, #{scaleY})")
      #     # transform = v.transform.baseVal.getItem(0)
      #     # transformMatrix.a = scaleX
      #     # transformMatrix.e = x
      #     # transformMatrix.f = y
      #     if (time % 3) is 0
      #       if currentFrame.baseVal is "#twistleft"
      #         currentFrame .baseVal = "#_"
      #       else if vx isnt 0
      #         currentFrame.baseVal = "#twistleft"
      #     # transformList.initialize(transform)
      #     vq.update() for vq in vaquitas
      #     time++
        
      #   # setInterval gameFrame, 40
      # window.location.reload(true)
      window.addEventListener('load', ((e)->
        if (window.applicationCache)
          window.applicationCache.addEventListener('updateready', ((e)->
              # if (window.applicationCache.status == window.applicationCache.UPDATEREADY)
                # Browser downloaded a new app cache.
                # Swap it in and reload the page to get the new hotness.
                window.applicationCache.swapCache()
                if (confirm('A new version of this site is available. Load it?'))
                  window.location.reload()
              # else
                # Manifest didn't changed. Nothing new to server.
          ), false)
      ), false)

genPage()
