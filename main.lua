
Camera = require 'libraries/hump/camera'

local canvas 
local previous_mx, previous_my = 0, 0
local zoom = 1



function love.load()
  camera = Camera(gw/2, gh/2)
  canvas = love.graphics.newCanvas(gw, gh)
  --resize(3)
end


function love.update(dt)
  if love.mouse.isDown(1) then
    local mx, my = love.mouse.getPosition()
    local dx,dy = mx - previous_mx, my - previous_my
    camera:move(-dx, -dy)
  end
  previous_mx, previous_my = love.mouse.getPosition()
end

function love.wheelmoved(x, y)
  -- wheel moved up -> zoom in
  if y > 0 then
    zoom = zoom + 0.1
    camera:zoom(zoom)
  elseif y < 0 then
    if zoom > 1 then
      zoom = zoom - 0.1
      camera:zoomTo(zoom)
    end
  end
  print(zoom)
end

function love.keypressed(key)
  if key == 'escape' then
    love.event.quit(0)
  end
end

function love.draw()
  -- set canvas to draw on
  love.graphics.setCanvas(canvas)
  love.graphics.setDefaultFilter('nearest')
  love.graphics.setLineStyle('rough')
  love.graphics.clear()
  -- draw on canvas
    camera:attach()
    love.graphics.circle('line', gw/2, gh/2, 30)
    camera:detach()
  love.graphics.setCanvas()
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.setBlendMode('alpha', 'premultiplied')
  love.graphics.draw(canvas, 0, 0, 0, sx, sy)
  love.graphics.setBlendMode('alpha')
end


function resize(s)
    love.window.setMode(s*gw, s*gh) 
    sx, sy = s, s
end