
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
        constructor: (@cx, @cy, @ctx) ->
                @absx = @absy = 0
                @rad = 30
                @hRad = 30 / 2
                @vx = @vy = @v = 0
                @x = @cx
                @y = @cy
                @dirx = @diry = 0
                @pi = Math.PI
                @_windowResizeListener = window.addEventListener "resize", (=> @resize), false
                @resize()
        updatePos: (x, y) ->
                @clear()
                @vx = @absx - x
                @vy = @absy - y
                @v = Math.atan2 @vy, @vx
                @dirx = (- Math.cos(@v) * @rad) >> 0
                @diry = (- Math.sin(@v) * @rad) >> 0
                @x =  @cx + @dirx
                @y =  @cy + @diry
                @projx = @absx + @dirx
                @projy = @absy + @diry

                @draw()
        clear: () ->
                @ctx.clearRect @x - @hRad, @y - @hRad, @rad, @rad
                @
        draw: () ->
                @ctx.fillRect @x - @hRad, @y - @hRad, @rad, @rad
                @
        resize: () ->
                @absx = @cx + @ctx.canvas.offsetLeft
                @absy = @cy + @ctx.canvas.offsetTop
                @


class Eyes
        constructor: (@subCanvas) ->
                @mx = @my = 0
                @eyeCanvas = document.getElementById "logo-canvas"
                console.log @eyeCanvas
                @eyeCanvas.width = 300
                @eyeCanvas.height = 150
                @eyeCtx = @eyeCanvas.getContext "2d"
                @followMouse()
                @er = new Eye(300 / 3, 150 / 2, @eyeCtx).draw()
                @el = new Eye(300 / 3 * 2 , 150 / 2, @eyeCtx).draw()
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
                @er.updatePos @mx, @my
                @el.updatePos @mx, @my
        eyesOnFire: () ->
                @subCanvas.fireLaser(@er, {x: @mx, y: @my}, @el, {x: @mx, y: @my})

subcanvas = new SubCanvas "sub-canvas"
logo = new Eyes(subcanvas)