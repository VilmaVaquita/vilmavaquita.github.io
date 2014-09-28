# Copyright (c) 2013, 2014 Michele Bini

# This program is free software: you can redistribute it and/or modify
# it under the terms of the version 3 of the GNU General Public License
# as published by the Free Software Foundation.

# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

version = "0.0.10"

{ htmlcup } = require 'htmlcup'

htmlcup[x] = htmlcup.compileTag x for x in [ "svg", "rect", "g", "ellipse", "polygon", "line", "image", "defs", "linearGradient", "stop", "use" ]

title = "Vilma the Vaquita"

fs = require 'fs'

datauri = (t, x)-> "data:#{t};base64,#{new Buffer(fs.readFileSync(x)).toString("base64")}"
datauripng = (x)-> datauri "image/png", x
datauriicon = (x)-> datauri "image/x-icon", x

icon = datauriicon "vaquita.ico"
pixyvaquita = datauripng "pixyvaquita_v2.png"
pixyvaquita_v105 = datauripng "pixyvaquita_v105_v.png"
frames =
  _: pixyvaquita
  _v105: pixyvaquita_v105
  twistleft: datauripng "pixyvaquita_v2_twistleft.png"

useSvg = true

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
      }
      .banner {
        border: 5px solid white;
        border: 5px solid white rgba(255,255,255,0.9);
        box-shadow: 0 2px 4px blue;
        margin: 1em;
      }
      p {
        color:white;
        color:rgba(255,255,255,0.9);
        margin-top:0.418em;
        margin-bottom:0.418em;
        margin-left:auto;
        margin-right:auto;
        width:22em;
        max-width:100%;
        text-shadow: 0 1px 1px blue;
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
      .dimmed {
        opacity: 0.2;
      }
      .dimmed:hover {
        opacity: 1;
      }
      """
  @body ->
    @div class:"centering page", ->
     @div class:"centered", ->
      @div -> @a class:"dimmed", "Vilma the Vaquita - v#{version}"
      if useSvg
        @svg id:"sea-svgroot", width:"960", height:"720", ->
          @defs ->
            @linearGradient id:"grad1", x1:"0%", y1:"0%", x2:"0%", y2:"100%", ->
              @stop offset:"0%", style:"stop-color:rgb(255,255,255);stop-opacity:1"
              @stop offset:"25%", style:"stop-color:rgb(100,200,250);stop-opacity:1"
              @stop offset:"50%", style:"stop-color:rgb(0,80,240);stop-opacity:1"
              @stop offset:"75%", style:"stop-color:rgb(0,0,180);stop-opacity:1"
              @stop offset:"100%", style:"stop-color:rgb(0,0,0);stop-opacity:1"
            for k,v of frames
              @g id:k, ->
                  @g transform:"translate(-18,-15)", ->
                    @image width:"50", height:"30", "xlink:href":v
          @rect x:"0", y:"0", width:"960", height:"720", fill:"url(#grad1)"
          @g transform:"scale(2)", ->
            @g id:"sea", transform:"translate(240,180)", ->
              @use "xlink:href":"#_"
      else
        @canvas width:"960", height:"720", ->
      @div -> @a class:"dimmed", target:"_blank", href:"index.html", "Learn about Vaquitas"
    gameObjects = null
    @script type:"text/javascript", "gameObjects=#{JSON.stringify(gameObjects)};"
    @coffeeScript ->
      svgroot = document.getElementById("sea-svgroot")

      reportErrors = (x)->
        try
          x()
        catch error
          try
            alert error.toString()
          catch error2
            alert error

      screen_x1 = 240
      screen_y1 = 180
      vaquitas = [ ]
      vaquitaObj =
        update: (x, y)->
          if !window.abcd
            window.abcd = 1
          vx = @vx + Math.floor(Math.random()*3) - 1
          vy = @vy + Math.floor(Math.random()*3) - 1
          x = @x
          y = @y
          rx = 0.5 * x / screen_x1
          ry = 0.5 * y / screen_y1
          if (s = vx * vx + vy * vy * 2) > 6
            vx = Math.round(vx * 0.9 + rx)
            vy = Math.round(vy * 0.9 + ry)
          @x = x -= @vx = vx
          @y = y -= @vy = vy
          if vx > 0
            @scaleX = 1
          else if vx < 0
            @scaleX = -1
          @e.setAttribute "transform", "translate(#{x}, #{y}) scale(#{@scaleX}, 1)"
          m = @m; m.e = x; m.f = y; m.a = @scaleX
          # @e.transform.baseVal.consolidate()
          # @e.transform.baseVal.initialize(@e.transform.baseVal.matrix)
      sea = document.getElementById "sea"
      v = sea.firstChild

      getTransformMatrix = (el)->
          transformListXX = el.transform.baseVal
          transformMatrixXX = svgroot.createSVGMatrix()
          transformXX = svgroot.createSVGTransform()
          transformXX.setMatrix(transformMatrixXX)
          transformListXX.initialize(transformXX)
          transformXX.matrix

      addVaquita = ->
          n = v.cloneNode()
          n.setAttribute "opacity", "0.5"
          n.href.baseVal = "#_v105" if Math.random(0) > 0.5
          # n.setAttribute "transform", ""
          sea.appendChild n
          angle = Math.random() * 6.28
          vaquita = 
            e: n
            m: getTransformMatrix(n)
            x: Math.sin(angle) * 300
            y: Math.cos(angle) * 300
            vx: 0
            vy: 0
            scaleX: 1
            __proto__: vaquitaObj
          vaquita.update()
          vaquitas.push vaquita

      leftKey = 37
      upKey = 38
      rightKey = 39
      downKey = 40
      usedKeys = [ leftKey, upKey, rightKey, downKey ]

      keyDownActions =
        32: addVaquita

      pressedKeys = { }
      pressedKeys[k] = 0 for k in usedKeys

      window.addEventListener 'keydown',  (event)->
        code = event.keyCode
        keyDownActions[ code ]?(event)
        pressedKeys[ code ] = 1
      window.addEventListener 'keyup',    (event)->
        pressedKeys[ event.keyCode ] = 0

      do (x = 0, y = 0)-> reportErrors ->
        time = 0
        vx = 0
        vy = 0
        ax = 0
        ay = 0
        # s = 1
        # x = 0
        # y = 0
        scaleX = 1
        scaleY = 1

        window.cf = currentFrame = v.href
        transformMatrix = getTransformMatrix(v)
        transformMatrix.a = scaleX
        transformMatrix.e = x
        transformMatrix.f = y

        gameFrame = -> reportErrors ->
          if (time & 0xff) is 0x00 and vaquitas.length < 4
            addVaquita()
          # s += 0.001
          x -= vx = pressedKeys[leftKey] - pressedKeys[rightKey]
          y -= pressedKeys[upKey] - pressedKeys[downKey]
          if vx > 0
            scaleX = 1
          else if vx < 0
            scaleX = -1
          v.setAttribute("transform", "translate(#{x}, #{y}) scale(#{scaleX}, #{scaleY})")
          # transform = v.transform.baseVal.getItem(0)
          # transformMatrix.a = scaleX
          # transformMatrix.e = x
          # transformMatrix.f = y
          if (time % 3) is 0
            if currentFrame.baseVal is "#twistleft"
              currentFrame .baseVal = "#_"
            else if vx isnt 0
              currentFrame.baseVal = "#twistleft"
          # transformList.initialize(transform)
          vq.update() for vq in vaquitas
          time++
        
        setInterval gameFrame, 40

genPage()
