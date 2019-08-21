
Camera = require 'libraries/hump/camera'

local canvas 
local previous_mx, previous_my = 0, 0
local zoom = 1
local element_radius = 20

local graph = {}
local hovered_skill = nil
local clicked_skill = {}

graph[1] = {
    title='+5 HP Regen',
    links={2,3},
    position={x=400, y=200}
}

graph[2] = {
    title='+10000 Mana Regen',
    position={x=200, y=200},
    links={4}
}

graph[3] = {
    title='+10000000 HP Regen',
    position={x=600, y=200}
}

graph[4] = {
    title='+2000 HP Regen',
    position={x=500, y=500},
    links={1}
}


function love.load()
  camera = Camera(gw/2, gh/2)
  canvas = love.graphics.newCanvas(gw, gh)
  --resize(3)
end


function love.update(dt)
  if love.mouse.isDown(1) then
    local mx, my = camera:mousePosition(0, 0, gw, gh)
    local dx,dy = mx - previous_mx, my - previous_my
    camera:move(-dx, -dy)
  end
  -- mouse position with respect to window, we need with respect to game world
  previous_mx, previous_my = camera:mousePosition(0, 0, gw, gh)
  for i=1, #graph do
    -- if (x2 - x1) ^ 2 + (y2 - y1) ^ 2 <= r^2 then point is either inside or on the circle.
    if math.pow(graph[i].position.x - previous_mx, 2) + math.pow(graph[i].position.y - previous_my, 2) <=  math.pow(element_radius, 2) then
      hovered_skill = i
      break;
    else 
      hovered_skill = nil
    end
  end
end

function love.mousepressed(x, y, button, istouch, presses )
	local mx, my = camera:mousePosition(0, 0, gw, gh)

	for i=1, #graph do
		    -- if (x2 - x1) ^ 2 + (y2 - y1) ^ 2 <= r^2 then point is either inside or on the circle.
    if math.pow(graph[i].position.x - mx, 2) + math.pow(graph[i].position.y - my, 2) <=  math.pow(element_radius, 2) then
      clicked_skill[i] =  not clicked_skill[i]
      break;
    end
    end

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
    for i=1, #graph do
	    local fillStyle = 'line'
	if clicked_skill[i] then
		fillStyle = 'fill'
	end

      love.graphics.circle(fillStyle, graph[i].position.x, graph[i].position.y, element_radius)
      if graph[i].links then
        for j=1, #graph[i].links do
          love.graphics.line(graph[i].position.x, graph[i].position.y, graph[graph[i].links[j]].position.x, graph[graph[i].links[j]].position.y)
        end
      end
    end
    if hovered_skill then
      -- make sure this isn't resized
      love.graphics.print(graph[hovered_skill].title, previous_mx + 25, previous_my - 25, 0, 1/zoom, 1/zoom)
    end
    camera:detach()
  -- reset to original drawing surface
  love.graphics.setCanvas()
  love.graphics.setColor(255, 255, 255, 255)
  -- drawing on canvas is done with alpha, if we do not set premultiplied alpha, we are multiplying alphas again.
  love.graphics.setBlendMode('alpha', 'premultiplied')
  love.graphics.draw(canvas, 0, 0, 0, sx, sy)
  -- set it back to default.
  love.graphics.setBlendMode('alpha')
end


function resize(s)
    love.window.setMode(s*gw, s*gh) 
    sx, sy = s, s
end
