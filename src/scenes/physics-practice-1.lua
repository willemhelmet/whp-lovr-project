-- src/scenes/physics-practice-1.lua

-- core
local Input = require 'src.core.input'

-- libraries
local lovr = require 'lovr'
local tiny = require 'lib.tiny'
local pretty = require 'lib.pl.pretty'

-- entities
local Grid = require 'src.entities.grid'
local Controller = require 'src.entities.controller'

-- systems
local ControllerSystem = require 'src.systems.controller-system'
local PhysicsSystem = require 'src.systems.physics-system'
local ControllerRenderingSystem = require 'src.systems.controller-rendering-system'

local NewtonsCradle = {}
NewtonsCradle.tiny = tiny.world(PhysicsSystem, ControllerSystem)

local frame
local framePose
local balls = {}
local count = 10
local radius = 1 / count / 2
local gap = 0.01

local controllerBoxes = {}

function NewtonsCradle.init()
  -- static geometry from which balls are suspended
  local size = lovr.math.vec3(1.2, 0.1, 0.3)
  frame = PhysicsSystem.newBoxCollider(
    "frame",
    lovr.math.vec3(0, 2, -2),
    size
  )
  frame:setKinematic(true)
  framePose = lovr.math.newMat4(frame:getPose()):scale(size)

  -- create balls along length of frame
  -- and attach them with two distance joints to frame
  local ballCounter = 1
  for x = -0.5, 0.5, 1 / count do
    local ball = PhysicsSystem.newSphereCollider(
      "ball" .. ballCounter,
      lovr.math.vec3(x, 1, -2),
      radius - gap
    )
    ball:setRestitution(1.0)
    table.insert(balls, ball)
    -- TODO: I want to visualize these joints
    lovr.physics.newDistanceJoint(frame, ball, vec3(x, 2, -2 + 0.25), vec3(x, 1, -2))
    lovr.physics.newDistanceJoint(frame, ball, vec3(x, 2, -2 - 0.25), vec3(x, 1, -2))
    ballCounter = ballCounter + 1
  end
  local lastBall = balls[#balls]
  lastBall:applyLinearImpulse(.6, 0, 0)
end

function NewtonsCradle.update(dt)
  NewtonsCradle.tiny:update(dt)
  -- TODO: Make this a entity
  for i, hand in ipairs(ControllerSystem.getHands()) do
    if not controllerBoxes[i] then
      controllerBoxes[i] = PhysicsSystem.newBoxCollider(
        hand,
        lovr.math.vec3(0, 0, 0),
        lovr.math.vec3(.25, .25, .25)
      )
      controllerBoxes[i]:setKinematic(true)
      NewtonsCradle.tiny:addEntity(Controller)
    end
    controllerBoxes[i]:setPose(table.unpack(Controller.Pose[hand]))
  end
end

function NewtonsCradle.draw(pass)
  Grid.draw(pass)

  pass:setShader()
  pass:box(framePose)
  pass:setColor(1, 1, 1)
  for i, ball in ipairs(balls) do
    local position = lovr.math.vec3(ball:getPosition())
    pass:sphere(position, radius)
  end

  -- pass:setColor(0, 0, 1)
  ControllerRenderingSystem.draw(pass)


  -- example showing how to render controller using local assets
  -- for i, hand in ipairs(ControllerSystem.getHands()) do
  --   local x, y, z = controllerBoxes[i]:getPosition()
  --   pass:draw(Controller.Model[hand], x, y, z)
  -- end
  -- pass:draw(Controller.Model.left, -4, 1.5, -3)
  -- pass:draw(Controller.Model.right, -3.5, 1.5, -3)

  -- box hands
  -- for _, box in ipairs(controllerBoxes) do
  --   local x, y, z = box:getPosition()
  --   pass:cube(x, y, z, .25, box:getOrientation())
  -- end

  -- ControllerRenderingSystem.draw(pass)

  pass:setColor(1, 1, 1)
  pass:text('newtons cradle', 0, 1.5, -4, 0.35)
end

return NewtonsCradle
