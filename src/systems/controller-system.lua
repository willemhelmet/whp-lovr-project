-- src/systems/controller-system.lua

local lovr = require 'lovr'
local tablex = require 'lib.pl.tablex'
local pretty = require 'lib.pl.pretty'
local tiny = require 'lib.tiny'

local ControllerSystem = tiny.processingSystem()
ControllerSystem.filter = tiny.requireAll("Pose", "Model", "Collider")

ControllerSystem.Model = {
  left = lovr.graphics.newModel("/assets/models/controller-left.glb"),
  right = lovr.graphics.newModel("/assets/models/controller-right.glb")
}

function ControllerSystem:process(e, dt)
  for _, hand in ipairs(lovr.headset.getHands()) do
    e.Pose[hand:sub(6)] = { lovr.headset.getPose(hand) }
  end
end

function ControllerSystem.getHands()
  local hands = {}
  for _, hand in ipairs(lovr.headset.getHands()) do
    table.insert(hands, hand:sub(6))
  end
  return hands
end

function ControllerSystem.getPose(device)
  return lovr.headset.getPose(device)
end

function ControllerSystem.draw(pass)
  for _, hand in ipairs(lovr.headset.getHands()) do
    pass:draw(model, pose.x, pose.y, pose.z)
  end
end

return ControllerSystem
