-- src/systems/controller-rendering-system.lua

-- lib
local lovr = require 'lovr'

-- core
local Input = require 'src.core.input'

local ControllerRenderingSystem = {}

ControllerRenderingSystem.Models = {
  left = lovr.graphics.newModel("/assets/models/quest-left.glb"),
  right = lovr.graphics.newModel("/assets/models/quest-right.glb")
}

function ControllerRenderingSystem.draw(pass)
  -- taken from docs example
  for hand, model in pairs(ControllerRenderingSystem.Models) do
    if lovr.headset.isTracked(hand) then
      pass:draw(model, lovr.math.mat4(lovr.headset.getPose(hand)))
    end
  end
  -- example showing how to render controller
  -- for i, hand in ipairs(ControllerSystem.getHands()) do
  --   local pose = Controller.Pose[hand]
  --   local x, y, z = pose.x, pose.y, pose.z
  --   pass:draw(Controller.Model[hand], x, y, z)
  -- end
  -- pass:draw(Controller.Model.left, -4, 1.5, -3)
  -- pass:draw(Controller.Model.right, -3.5, 1.5, -3)
end

return ControllerRenderingSystem
