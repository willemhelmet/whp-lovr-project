-- src/scenes/test-scene-1.lua
local lovr = require "lovr"
local tiny = require "lib.tiny"
local Game = {}

-- Initialize scene
function Game.init()
  print("Game Scene Loaded")

  -- Create a new ECS world
  Game.world = tiny.world()

  -- Define a simple entity (a moving sphere)
  local entity = {
    position = { x = 0, y = 1.5, z = -2 },
    velocity = { x = 1, y = 0, z = 0 },
    renderable = true -- Mark for rendering
  }

  -- Define a movement system
  local movementSystem = tiny.processingSystem()
  movementSystem.filter = tiny.requireAll("position", "velocity")

  function movementSystem:process(e, dt)
    e.position.x = e.position.x + e.velocity.x * dt
    e.position.y = e.position.y + e.velocity.y * dt
    e.position.z = e.position.z + e.velocity.z * dt
  end

  -- Add entity & system to the world
  Game.world:add(entity, movementSystem)
end

-- Update ECS world
function Game.update(dt)
  Game.world:update(dt)
end

-- Render ECS entities
function Game.draw(pass)
  for _, entity in ipairs(Game.world.entities) do
    if entity.renderable then
      pass:setColor(1, 0, 0)
      pass:sphere(entity.position.x, entity.position.y, entity.position.z, 0.2)
    end
  end
end

return Game
