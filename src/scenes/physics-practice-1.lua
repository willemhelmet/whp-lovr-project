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
NewtonsCradle.tiny = tiny.world(PhysicsSystem, ControllerSystem, ControllerRenderingSystem)

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
    lovr.physics.newDistanceJoint(frame, ball, vec3(x, 2, -2 + 0.25), vec3(x, 1, -2))
    lovr.physics.newDistanceJoint(frame, ball, vec3(x, 2, -2 - 0.25), vec3(x, 1, -2))
    ballCounter = ballCounter + 1
  end
  local lastBall = balls[#balls]
  lastBall:applyLinearImpulse(.6, 0, 0)
end

function NewtonsCradle.update(dt)
  NewtonsCradle.tiny:update(dt)
  -- TODO: Make this a entity... should it be in our controller?
  for i, hand in ipairs(ControllerSystem.getHands()) do
    if not controllerBoxes[i] then
      controllerBoxes[i] = PhysicsSystem.newBoxCollider(
        hand,
        lovr.math.vec3(0, 0, 0),
        lovr.math.vec3(0.25, 0.25, 0.25)
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

  ControllerRenderingSystem.draw(pass)

  pass:setColor(1, 1, 1)
  pass:text('newtons cradle', 0, 1.5, -4, 0.35)
end

return NewtonsCradle
