-- src/scenes/learn-physics.lua

--lib
local lovr = require 'lovr'
local tiny = require 'lib.tiny'
local pretty = require 'lib.pl.pretty'

-- entities
local Grid = require 'src.entities.grid'
local Controller = require 'src.entities.controller'

-- systems
local ControllerSystem = require 'src.systems.controller-system'
local PhysicsSystem = require 'src.systems.physics-system'

local LearnPhysics = {}

LearnPhysics.tinyWorld = tiny.world(ControllerSystem, PhysicsSystem)

local boxes = {}
local controllerBoxes = {}

function LearnPhysics:init()
  PhysicsSystem.newBoxCollider("ground", lovr.math.vec3(0, -1, 0), lovr.math.vec3(50, 2, 50))
  PhysicsSystem.getObject("ground"):setKinematic(true)

  local boxNumber = 1
  for x = -1, 1, .25 do
    for y = .125, 2, .2499 do
      local box = PhysicsSystem.newBoxCollider(
        "box" .. boxNumber,
        lovr.math.vec3(x, y, -2 - y / 5),
        lovr.math.vec3(.25, .25, .25)
      )
      table.insert(boxes, box)
      boxNumber = boxNumber + 1
    end
  end
end

function LearnPhysics.update(dt)
  -- Update ECS
  LearnPhysics.tinyWorld:update(dt)

  -- update controller position
  for i, hand in ipairs(ControllerSystem.getHands()) do
    if not controllerBoxes[i] then
      controllerBoxes[i] = PhysicsSystem.newBoxCollider(
        hand,
        lovr.math.vec3(0, 0, 0),
        lovr.math.vec3(.25, .25, .25)
      )
      controllerBoxes[i]:setKinematic(true)
      LearnPhysics.tinyWorld:addEntity(Controller)
    end
    controllerBoxes[i]:setPose(table.unpack(Controller.Pose[hand]))
  end
end

function LearnPhysics.draw(pass)
  Grid.draw(pass)

  pass:setShader()
  pass:setColor(1, 0, 0)
  for _, box in ipairs(boxes) do
    local x, y, z = box:getPosition()
    pass:cube(x, y, z, .25, box:getOrientation())
  end

  pass:setColor(0, 0, 1)

  for _, box in ipairs(controllerBoxes) do
    local x, y, z = box:getPosition()
    pass:cube(x, y, z, .25, box:getOrientation())
  end

  pass:setColor(1, 1, 1)
  pass:text('learn physics', 0, 1.5, -4, .4)
end

return LearnPhysics
