-- src/scenes/test-scene-2

local tiny = require 'lib.tiny'
local lovr = require 'lovr'

local Game = {}

-- Initialize scene
function Game.init()
  -- Create a new ECS World
  Game.world = tiny.world()

  -- Define my first entity
  local spinningCube = {
    position = { x = 0, y = 1.5, z = -2 },
    rotation = { x = 0, y = 0, z = 0 },
    scale = 0.5,
    renderable = true -- WHP: Do we really need this?
  }

  -- define my own system
  local mySystem = tiny.processingSystem()
  mySystem.filter = tiny.requireAll("position", "rotation")

  function mySystem:process(e, dt)
    e.rotation.x = math.sin(lovr.headset.getTime())
    e.rotation.y = math.cos(lovr.headset.getTime() * 0.25)
  end

  -- add entity and system to game world
  Game.world:add(spinningCube, mySystem)
end

-- Update Game World
function Game.update(dt)
  Game.world:update(dt)
end

-- Render ECS Entities
function Game.draw(pass)
  for _, entity in ipairs(Game.world.entities) do
    if entity.renderable then -- WHP: Do we really need this?
      pass:setColor(1, 1, 1)
      pass:cube(
        entity.position.x,
        entity.position.y,
        entity.position.z,
        entity.scale,
        lovr.headset.getTime(),
        entity.rotation.x,
        entity.rotation.y,
        entity.rotation.z,
        'line')
    end
  end
end

-- Exit scene (cleanup)
function Game.exit()
  print("Exiting Game2 Scene...")
end

return Game
