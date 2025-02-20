-- src/systems/controller-system.lua

-- WHP: Should I make this system handle both controllers?
local tiny = require 'lib.tiny'
local pretty = require 'lib.pl.pretty'

local ControllerSystem = tiny.processingSystem()
ControllerSystem.filter = tiny.requireAll("Poses", "Models")

function ControllerSystem:process(e, dt)
  for hand, model in pairs(e.Poses) do
    if lovr.headset.isTracked(hand) then
      e.Poses[hand] = mat4(lovr.headset.getPose(hand))
    end
  end
end

return ControllerSystem
