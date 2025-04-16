-- src/scenes/pass-sidequest.lua

-- lib
local tiny = require 'lib.tiny'

-- entities
local Grid = require 'src.entities.grid'

-- Systems
local RenderSystem = require 'src.systems.render-system'

-- Components
local TransformComponent = require 'src.components.transform-component'
local MaterialComponent = require 'src.components.material-component'
local MeshComponent = require 'src.components.mesh-component'

-- World
local PassSidequest = {}
PassSidequest.world = tiny.world(RenderSystem)

local balls = {}
local plane

function PassSidequest.init()
  -- Grid
  PassSidequest.world:addEntity(Grid())

  -- plane
  plane = lovr.graphics.newModel('/assets/models/primitives/plane.glb')

  -- Sin wave controllers
  for i = 1, 20 do
    local x = (i - 10) * 0.5
    local y = math.sin(i) + 1.5
    local z = -2
    local ball = {
      Transform = TransformComponent(x, y, z, 0, 0, 0, 0, .1, .1, .1),
      Mesh = MeshComponent("/assets/models/primitives/sphere.glb"),
      Material = MaterialComponent(nil, {})
    }
    balls[i] = ball
    PassSidequest.world:addEntity(ball)
  end
end

function PassSidequest.update(dt)
  PassSidequest.world:update(dt)
end

function PassSidequest.draw(pass)
  -- Grid.draw(pass)
  RenderSystem.draw(pass)
  pass:text('pass sidequest', 0, 1.5, -2, 0.25)
  -- pass:setColor(1, 0, 0)
  -- pass:draw(plane, 0, 0, 0, 1, -math.pi / 2, 1, 0, 0)

  -- example of using two different passes in one draw command
  -- local pass1 = lovr.headset.getPass()
  -- Grid.draw(pass1)
  -- pass1:setShader()
  -- pass1:text('pass sidequest', 0, 1.5, -2, 0.25)
  -- pass:text('hi willem!', 0, 2, -2, 0.25)
end

return PassSidequest
