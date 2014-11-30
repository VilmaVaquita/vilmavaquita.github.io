# Copyright (c) 2013, 2014 Michele Bini

# A game featuring a Vaquita, the smallest, most endagered marine cetacean

# This program is available under the terms of the MIT License

version = "0.1.112"

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

gameName = "#{title} v#{version}"

htmlcup.jsFile = (f)-> @script type:"text/javascript", (fs.readFileSync(f).toString())

genPage = ->
 htmlcup.html5Page ->
  @head ->
    @meta charset:"utf-8"
    @link rel:"shortcut icon", href:icon
    @title title
    @style type: "text/css",
      """
      body {
        /* background:pink; */
        /* background: #69B2FF; */
        /* background: #21AFF8; */
        /* background: #0286E8; */
        /* background: #1096EE; */
        background:black;
        text-align: center;
        font-size: 22px;
        font-family: Helvetica;
        color:white;
        color:rgba(255,255,255,0.9);
        margin:0;
      }
      .banner {
        border: 5px solid white;
        border: 5px solid white rgba(255,255,255,0.9);
        box-shadow: 0 2px 4px blue;
        margin: 1em;
      }
      footer, p {
        margin-top:0.418em;
        margin-bottom:0.418em;
        margin-left:auto;
        margin-right:auto;
        text-shadow: 0 1px 1px blue;
      }
      p {
        width:22em;
        max-width:100%;
      }
      a {
        /*
        color:rgb(200,255,255);
        color:rgba(200,255,255,0.9);
        */
        color:white;
        color:rgba(255,255,255,0.9);
        text-decoration:none;
        display: inline-block;
        border: 1px solid white;
        padding: 0 0.2em;
        border-radius: 0.2em;
        -moz-border-radius: 0.2em;
        -webkit-border-radius: 0.2em;
        -ie-border-radius: 0.2em;
      }
      a:hover {
        background-color:rgba(20,70,180,1.0);
      }
      .petition {
        margin:0.418em;
        padding:0.618em;
      }
      .petition a {
        font-size:127.2%;
        box-shadow: 0 2px 4px blue;
        margin:0.3em;
      }
      .page {
        width: 100%;
        height: 100%;
        margin: 0;
        border: 0;
      }
      .centering {
        display: table;
        padding: 0;
      }
      .centered {
        display: table-cell;
        vertical-align: middle;
        text-align: center;
      }
      .inline-block {
        display: inline-block;
      }
      .dynamic-section {
        display: inline-block;
        vertical-align:middle;
        max-width:100%;
      }
      .flip-lr {
        -moz-transform:     scaleX(-1);
        -o-transform:       scaleX(-1);
        -webkit-transform:  scaleX(-1);
        transform:          scaleX(-1);
        filter:             FlipH;
        -ms-filter:         "FlipH";
      }
      image, .pixelart {
        image-rendering:optimizeSpeed;             /* Legal fallback */
        image-rendering:-moz-crisp-edges;          /* Firefox        */
        image-rendering:-o-crisp-edges;            /* Opera          */
        image-rendering:-webkit-optimize-contrast; /* Safari         */
        image-rendering:optimize-contrast;         /* CSS3 Proposed  */
        image-rendering:crisp-edges;               /* CSS4 Proposed  */
        image-rendering:pixelated;                 /* CSS4 Proposed  */
        -ms-interpolation-mode:nearest-neighbor;   /* IE8+           */
      }
      /*
      .pixelart {
        image-rendering: -moz-crisp-edges; 
        -ms-interpolation-mode: nearest-neighbor;
        image-rendering: pixelated;
        image-rendering: crisp-edges;
      }
      */
      g.flipped {
        transform:scale(-1,1);
      }
      .dim {
        opacity: 0.2;
      }
      .dim:hover {
        opacity: 1;
      }
      """
  @body ->
    @div class:"centering page", ->
     @div class:"centered", ->
      @div style:"visibility:hidden;position:absolute", ->
        @img id:"pixyvaquita", src:pixyvaquita
        @img id:"pixyvaquita_twist_l", src:frames.twist_l
        @img id:"pixyvaquita_twist_r", src:frames.twist_r
        @img id:"happybubble0", src:frames.happybubble0
        @img id:"grumpybubble0", src:frames.grumpybubble0
        @img id:"evilbubble0", src:frames.evilbubble0
      @div style:"position:relative", ->
        @svg id:"sea-svgroot", width:"960", height:"720", style:"position:absolute;opacity:0.9;z-index:-1000", ->
          @defs ->
            @linearGradient id:"grad1", x1:"0%", y1:"0%", x2:"0%", y2:"100%", ->
              @stop offset:"0%", style:"stop-color:rgb(255,255,255);stop-opacity:1"
              @stop offset:"25%", style:"stop-color:rgb(100,200,250);stop-opacity:1"
              @stop offset:"50%", style:"stop-color:rgb(0,80,240);stop-opacity:1"
              @stop offset:"75%", style:"stop-color:rgb(0,0,180);stop-opacity:1"
              @stop offset:"100%", style:"stop-color:rgb(0,0,0);stop-opacity:1"
          @rect x:"0", y:"0", width:"960", height:"720", fill:"url(#grad1)"
        @canvas width:"960", height:"720",  ->
      @footer class:"dim", ->
        @span gameName
        @span " - "
        @a target:"_blank", href:"index.html", "Learn about Vaquitas"
        @span id:"fps"
    gameObjects = null
    @script type:"text/javascript", "gameObjects=#{JSON.stringify(gameObjects)};"
    @script type:"text/javascript", "__hasProp = {}.hasOwnProperty; __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };"
    @jsFile "jaws/jaws-min.js"
    # @jsFile "jaws-assets-named.js"
    @coffeeScript -> do ->
      # svgroot = document.getElementById("sea-svgroot")

      # reportErrors = (x)->
      #   try
      #     x()
      #   catch error
      #     try
      #       alert error.toString()
      #     catch error2
      #       alert error

      screen_x1 = 240
      screen_y1 = 180
      
      jaws.onload = ->
        class Demo
          { left: leftKey, right: rightKey, up: upKey, down: downKey, space: spaceKey } = jaws.keyCodes
          Sprite = class extends jaws.Sprite
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
          Bubble = class extends Sprite
            draw: ->
              if @py < -212
                @bubbles[@idxs] = null
                return
              super()
          HappyBubble = class extends Bubble
            constructor: ->
              @lr = 3
              @tb = 3
              @image = happybubble0
              super()
            draw: ->
              @py--
              super()
          GrumpyBubble = class extends Bubble
            constructor: ->
              @lr = 6
              @tb = 6
              @image = grumpybubble0
              super()
            draw: ->
              @py -= 2
              super()
          EvilBubble = class extends Bubble
            constructor: ->
              @lr = 12
              @tb = 12
              @image = evilbubble0
              super()
            draw: ->
              @py -= 4
              super()
          twist = [ pixyvaquita_twist_l, pixyvaquita_twist_r ]
          Vaquita = class extends Sprite
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
          AiVaquita = class extends Vaquita
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
                    vx = Math.round(vx * 0.9 - rx)
                    vy = Math.round(vy * 0.9 - ry)
                  @px += @vx = vx
                  @py += @vy = vy
                  if (@time++ % 3) is 0
                    if @image isnt pixyvaquita
                      @image = pixyvaquita
                    else if @vx isnt 0
                      @image = twist[@beat_lr++ & 1]
                  super()
          HeroVaquita = class extends Vaquita
            constructor: ->
              @image = pixyvaquita
              @time = 0
              super()
              @fpx = @px ? 0
              @fpy = @py ? 0
            beat_lr: 0
            draw: ->
              ax = (if jaws.pressed[leftKey]  then -1 else 0)    +   (if jaws.pressed[rightKey]  then 1 else 0)
              ay = (if jaws.pressed[upKey]    then -1 else 0)    +   (if jaws.pressed[downKey]   then 1 else 0)
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
              if (@time++ % 3) is 0
                if @image isnt pixyvaquita
                  @image = pixyvaquita
                else if vx * vx + (vy * vy / 4) > 1
                  @image = twist[@beat_lr++ & 1]
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
          addBubble: ->
              # n = v.cloneNode()
              # n.setAttribute "opacity", "0.5"
              # n.href.baseVal = "#_v105" if Math.random(0) > 0.5
              # n.setAttribute "transform", ""
              # sea.appendChild n
              angle = Math.random() * 6.28
              entropy = (angle * 10000)%100
              v = if x < 50
                new HappyBubble
              else if x < 90
                new GrumpyBubble
              else
                new EvilBubble
              v.vx = 0
              v.vy = 0
              v.px = Math.floor(Math.sin(angle) * 300)
              v.py = 200 # Math.floor(Math.cos(angle) * 300)
              # vaquita.update()
              v.bubbles = b = @bubbles
              if (i = b.indexOf(null)) >= 0
                b[i] = v
                v.idxs = i
              else
                v.idxs = b.length
                b.push v
              v.draw()
          constructor: (@vaquitas = [], @bubbles = [])->
          setup: ->
            v = new HeroVaquita # jaws.Sprite x:screen_x1*2, y:screen_y1*2, scale:2, image:pixyvaquita
            v.px = 0
            v.py = 0
            v.vx = 0
            v.vy = 0
            @vaquitas.push v
          draw: ->
            jaws.clear()
            @addVaquita() if (!(@gameloop.ticks & 0x7f) and @vaquitas.length < 7) or jaws.pressed[spaceKey]
            @addBubble() if 0 is (@gameloop.ticks & 0x7)
            v.draw() for v in @vaquitas
            v?.draw() for v in @bubbles
            if (@gameloop.ticks & 0xff) is 0xff
              fps.innerHTML = " - #{@gameloop.fps} fps"
        if true
          jaws.init()
          jaws.setupInput();
          game = new Demo
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

genPage()
