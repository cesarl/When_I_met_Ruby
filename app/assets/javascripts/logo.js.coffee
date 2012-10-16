class SubCanvas
        constructor: (id) ->
                @domElem = document.getElementById id
                @ctx = @domElem.getContext "2d"
                @domElem.style.position = "absolute"
                @domElem.style.top = 0
                @domElem.style.left = 0
                @domElem.style.zIndex = 0
                @domElem.style.pointerEvents = "none"
                @_windowResizeListener = window.addEventListener "resize", (=> @resize()), false
                setTimeout (=> @resize()), 150
        resize: () ->
                @w = if window.innerWidth > document.body.offsetWidth then window.innerWidth - 15 else document.body.offsetWidth
                @h = if window.innerHeight > document.body.offsetHeight then window.innerHeight else document.body.offsetHeight
                @domElem.width = @w
                @domElem.height = @h
        clear: () ->
                @domElem.width = 0
                @domElem.width = @w
        fireLaser: (from1, to1, from2, to2) ->
                @ctx.strokeStyle = "red"
                @ctx.lineCap = "round"
                @ctx.lineJoin = "round"
                @ctx.lineWidth = 15
                @ctx.beginPath()
                @ctx.moveTo(from1.projx, from1.projy)
                @ctx.lineTo(to1.x, to1.y)
                @ctx.closePath()
                @ctx.stroke()
                @ctx.beginPath()
                @ctx.moveTo(from2.projx, from2.projy)
                @ctx.lineTo(to2.x, to2.y)
                @ctx.closePath()
                @ctx.stroke()
                setTimeout((
                        => @clear()
                        ) , 80
                )


class Eye
        constructor: (@cx, @cy, @ctx, @img) ->
                @absx = @absy = 0
                @globRad = 90
                @hGlobRad = @globRad / 2
                @rad = 50
                @hRad = @rad / 2
                @vx = @vy = @v = 0
                @x = @cx
                @y = @cy
                @dirx = @diry = 0
                @pi = Math.PI
                @_windowResizeListener = window.addEventListener "resize", (=> @resize()), false
                setTimeout (=> @resize()), 150
        updatePos: (x, y) ->
                @vx = @absx - x
                @vy = @absy - y
                @v = Math.atan2 @vy, @vx
                @dirx = (- Math.cos(@v) * @hRad) >> 0
                @diry = (- Math.sin(@v) * @hRad) >> 0
                @x =  if Math.abs(@dirx) < Math.abs(@vx) then @cx + @dirx else @cx - @vx
                @y =  if Math.abs(@diry) < Math.abs(@vy) then @cy + @diry else @cy - @vy
                @projx = @absx + @dirx
                @projy = @absy + @diry
                @draw()
        clear: () ->
                @ctx.clearRect 0, 0, @ctx.canvas.width, @ctx.canvas.height
                @
        draw: () ->
                @ctx.drawImage @img, 97, 0, 171, 170, @cx - @hGlobRad, @cy - @hGlobRad, @globRad, @globRad
                @ctx.drawImage @img, 0, 0, 97, 97, @x - @hRad, @y - @hRad, @rad, @rad
                @
        fire: (x, y) ->
                @ctx.strokeStyle = "red"
                @ctx.lineCap = "round"
                @ctx.lineJoin = "round"
                @ctx.lineWidth = 15
                @ctx.beginPath()
                @ctx.moveTo(@projx, @projy)
                @ctx.lineTo(x, y)
                @ctx.closePath()
                @ctx.stroke()
                @
        resize: () ->
                @absx = @cx + @ctx.canvas.offsetLeft
                @absy = @cy + @ctx.canvas.offsetTop
                @


class Eyes
        constructor: (@subCanvas) ->
                @eyeSprite = new Image();
                @eyeSprite.src = "/eye.png"
                @eyeSprite.addEventListener "load", (e) =>
                        @init()
        init: () ->
                @mx = @my = 0
                @eyeCanvas = document.getElementById "logo-canvas"
                @eyeCanvas.style.zIndex = -3
                @eyeCanvas.width = 300
                @eyeCanvas.height = 140
                @eyeCtx = @eyeCanvas.getContext "2d"
                @followMouse()
                @er = new Eye(300 / 3, 150 / 2, @eyeCtx, @eyeSprite)
                @el = new Eye(300 / 3 * 2 , 150 / 2, @eyeCtx, @eyeSprite)
                @updateEyesPos()
        followMouse: () ->
                @_mouseMoveListener = document.addEventListener "mousemove", ((e) => @onMouseMove(e)), false
                @_mouseDownListener = document.addEventListener "mousedown",  ((e) => @onMouseClick(e)), false
        getMouseCoord: (e) ->
                @mx = e.pageX
                @my = e.pageY
        onMouseMove: (e) ->
                @getMouseCoord e
                @updateEyesPos()
        onMouseClick: (e) ->
                @getMouseCoord e
                @eyesOnFire();
        updateEyesPos: () ->
                @el.clear()
                @el.updatePos @mx, @my
                @er.updatePos @mx, @my
        eyesOnFire: () ->
                @subCanvas.fireLaser(@er, {x: @mx, y: @my}, @el, {x: @mx, y: @my})
                @subCanvas.ctx.drawImage @eyeSprite, 279, 0, 165, 144, @mx - 80, @my - 70, 165, 144

class Bubble
        constructor: (@y, maxX) ->
                @x = Math.random() * maxX >> 0
                @size = (Math.random() * 15) >> 0
                @dir = -1
                @dec = 0
        update: () ->
                @y = (@y - @size / 5) >> 0
                @x = (@x + (@dir * 1)) >> 0
                if @dec > 30
                        @dir *= -1
                        @dec = 0
                @dec++
                @size -= 0.08
                @

class Beer
        constructor: (id) ->
                @domElem = document.getElementById id
                @domElem.style.position = "fixed"
                @domElem.style.bottom = 0
                @domElem.style.zIndex = 0
                @domElem.style.pointerEvents = "none"
                @ctx = @domElem.getContext "2d"
                @max = 300
                @bbnb = 0
                @interval = 5
                @intervalCounter = 0
                @col = []
                @_windowResizeListener = window.addEventListener "resize", (=> @resize()), false
                setTimeout (=> @resize() and @bubble()), 150
        resize: () ->
                @w = window.innerWidth
                @h = window.innerHeight
                @domElem.width = @w
                @domElem.height = @h
        bubble: () ->
                @ctx.clearRect 0, 0, @w, @h
                @ctx.globalAlpha = 0.3
                @ctx.fillStyle = "#fff"
                if @bbnb < @max and @intervalCounter > @interval
                        @getBubbles()
                        @intervalCounter = 0
                @col.forEach (obj) =>
                        @ctx.beginPath();
                        @ctx.arc obj.x, obj.y, obj.size, 0, Math.PI * 180 / 2
                        @ctx.fill()
                @col.forEach (obj, index) =>
                        obj.update()
                        if obj.size < 0.1 or obj.y < 0
                                @trash(obj)
                @intervalCounter++
                requestAnimFrame(=> @bubble())
        trash: (elem) ->
                i = 0
                @bbnb--
                while @col[i]
                        if @col[i] is elem
                                @col.splice i, 1
                                return true
                        i++
        getBubbles: () ->
                i = 0
                m = ((@max - @bbnb) / 20) >> 0
                while i < m
                        @col.push new Bubble(@h, @w)
                        @bbnb++
                        i++

beer = new Beer("bgCanvas")
subcanvas = new SubCanvas "sub-canvas"
logo = new Eyes(subcanvas)

