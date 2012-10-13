
class SubCanvas
        constructor: (id) ->
                @domElem = document.getElementById id
                @resize()
                @ctx = @domElem.getContext "2d"
                @domElem.style.position = "fixed"
                @domElem.style.zIndex = -10
                @_windowResizeListener = window.addEventListener "resize", (=> @resize), false
                @resize()
        resize: () ->
                @w = window.innerWidth
                @h = window.innerHeight
                @domElem.width = @w
                @domElem.height = @h
        clear: () ->
                @domElem.width = 0
                @domElem.width = @w
        fireLaser: (from1, to1, from2, to2) ->
                @anim = true
                @domElem.style.zIndex = 20
                b1 = {x: from1.projx, y: from1.projy, vx: from1.dirx, vy: from1.diry}
                b2 = {x: from2.projx, y: from2.projy, vx: from2.dirx, vy: from2.diry}
                draw = =>
                        b1.x += b1.vx
                        b1.y += b1.vy
                        @ctx.arc b1.x, b1.y, 15, 0, Math.PI * 180 / 2
                        @ctx.fill()
                        b2.x += b2.vx
                        b2.y += b2.vy
                        @ctx.arc b2.x, b2.y, 15, 0, Math.PI * 180 / 2
                        @ctx.fill()
                i = 0
                lazers = =>
                        @clear()
                        draw()
                        if i < 100
                                requestAnimFrame(lazers)
                        else
                                @domElem.style.zIndex = -10
                                @clear()
                        i++
                lazers()


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
                @_windowResizeListener = window.addEventListener "resize", (=> @resize), false
                @resize()
        updatePos: (x, y) ->
                @vx = @absx - x
                @vy = @absy - y
                @v = Math.atan2 @vy, @vx
                @dirx = (- Math.cos(@v) * @hRad) >> 0
                @diry = (- Math.sin(@v) * @hRad) >> 0
                @x =  @cx + @dirx
                @y =  @cy + @diry
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
        resize: () ->
                @absx = @cx + @ctx.canvas.offsetLeft
                @absy = @cy + @ctx.canvas.offsetTop
                @


class Eyes
        constructor: (@subCanvas) ->
                @eyeSprite = new Image();
                @eyeSprite.src = "http://demo.cesar.lc/eye.png"
                @eyeSprite.load =  @init()
        init: () ->
                @mx = @my = 0
                @eyeCanvas = document.getElementById "logo-canvas"
                console.log @eyeCanvas
                @eyeCanvas.width = 300
                @eyeCanvas.height = 200
                @eyeCtx = @eyeCanvas.getContext "2d"
                @followMouse()
                @er = new Eye(300 / 3, 150 / 2, @eyeCtx, @eyeSprite).draw()
                @el = new Eye(300 / 3 * 2 , 150 / 2, @eyeCtx, @eyeSprite).draw()
        followMouse: () ->
                @_mouseMoveListener = document.addEventListener "mousemove", ((e) => @onMouseMove(e)), false
                @_mouseClickListener = document.addEventListener "click",  ((e) => @onMouseClick(e)), false
        getMouseCoord: (e) ->
                @mx = e.pageX
                @my = e.pageY
        onMouseMove: (e) ->
                @getMouseCoord e
                @updateEyesPos()
        onMouseClick: (e) ->
                @getMouseCoord e
                @updateEyesPos();
                @eyesOnFire();
        updateEyesPos: () ->
                @el.clear()
                @el.updatePos @mx, @my
                @er.updatePos @mx, @my
        eyesOnFire: () ->
                @subCanvas.fireLaser(@er, {x: @mx, y: @my}, @el, {x: @mx, y: @my})

subcanvas = new SubCanvas "sub-canvas"
logo = new Eyes(subcanvas)

# class Bubble
#         constructor: (@y, maxX) ->
#                 @x = Math.random() * maxX
#                 @size = (Math.random() * 15) >> 0
#                 @vel = @size / 3 + 1
#                 @dir = -1
#                 @dec = 0
#         update: () ->
#                 if @dec > @size / 2 then @dir *= -1
#                 @dec += (@size / 3) * @dir
#                 @size *= 0.98
#                 @

# class Beer
#         constructor: (id) ->
#                 @domElem = document.getElementById id
#                 @ctx = @domElem.getContext "2d"
#                 @resize()
#                 @bbnb = 0
#                 @col = []
#                 @_windowResizeListener = window.addEventListener "resize", (=> @resize), false
#                 @bubble()
#         resize: () ->
#                 @w = window.innerWidth
#                 @h = window.innerHeight
#                 @max = @w / 5
#                 @domElem.width = @w
#                 @domElem.height = @h
#         bubble: () ->
#                 @ctx.clearRect 0, 0, @w, @h
#                 if @bbnb < @max
#                         @getBubbles()
#                 @col.forEach (obj) =>
#                         @ctx.fillRect obj.x, obj.y, obj.size, obj.size
#                         console.log obj.x, obj.y, obj.size, obj.size
#         getBubbles: () ->
#                 i = 0
#                 m = ((@max - @bbnb) / 3) >> 0
#                 while i < m
#                         @col.push new Bubble(@h, @w)
#                         i++

# beer = new Beer("bgCanvas")