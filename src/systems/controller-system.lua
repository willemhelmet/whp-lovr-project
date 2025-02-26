-- src/systems/controller-system.lua

local lovr = require 'lovr'

-- WHP: Should I make this system handle both controllers?
local tiny = require 'lib.tiny'

local ControllerSystem = tiny.processingSystem()
ControllerSystem.filter = tiny.requireAll("Poses", "Models")

function ControllerSystem:process(e, dt)
  for hand, _ in pairs(e.Poses) do
    if lovr.headset.isTracked(hand) then
      e.Poses[hand] = mat4(lovr.headset.getPose(hand))
    end
  end
end

function ControllerSystem.getHands()
  return lovr.headset.getHands()
end

function ControllerSystem.getPose(device)
  return lovr.headset.getPose(device)
end

return ControllerSystem
