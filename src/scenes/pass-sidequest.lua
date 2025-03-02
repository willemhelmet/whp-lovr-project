-- src/scenes/pass-sidequest.lua

-- lib
local tiny = require 'lib.tiny'

-- entities
local Grid = require 'src.entities.grid'

-- Systems
local ExampleRenderSystem = require 'src.systems.example-render-system'

-- Components
local RenderingComponent = require 'src.components.rendering-component'
local TransformComponent = require 'src.components.transform-component'
local MaterialComponent = require 'src.components.material-component'

-- World
local PassSidequest = {}
PassSidequest.world = tiny.world(ExampleRenderSystem)

local balls = {}

function PassSidequest.init()
  -- Grid
  PassSidequest.world:addEntity(Grid.new())

  -- Sin wave controllers
  for i = 1, 20 do
    local x = (i - 10) * 0.5
    local y = math.sin(i) + 1.5
    local z = -2
    local ball = {
      Transform = TransformComponent.new(x, y, z, 0, 0, 0, 0, 1, 1, 1),
      Mesh = RenderingComponent.new("/assets/models/controller-right.glb"),
      Material = MaterialComponent.new(nil, {})
    }
    balls[i] = ball
    PassSidequest.world:addEntity(ball)
  end
end

function PassSidequest.update(dt)
  PassSidequest.world:update(dt)
end

function PassSidequest.draw(pass)
  ExampleRenderSystem.draw(pass)
  pass:text('pass sidequest', 0, 1.5, -2, 0.25)
end

return PassSidequest
