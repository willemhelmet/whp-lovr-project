-- src/systems/controller-rendering-system.lua

-- lib
local lovr = require 'lovr'
local tiny = require 'lib.tiny'
local pretty = require 'lib.pl.pretty'

-- core
local Input = require 'src.core.input'

local ControllerRenderingSystem = tiny.processingSystem()
ControllerRenderingSystem.filter = tiny.requireAll("Pose", "Collider")

ControllerRenderingSystem.Models = {
  left = lovr.graphics.newModel("/assets/models/quest-left.glb"),
  right = lovr.graphics.newModel("/assets/models/quest-right.glb")
}

function ControllerRenderingSystem.draw(pass)
  local controller = ControllerRenderingSystem.entities[1]


  for hand, model in pairs(ControllerRenderingSystem.Models) do
    if lovr.headset.isTracked(hand) and controller ~= nil then
      --WHP: I don't really like this currently. I think it would be better like
      --     pose.x, pose.y, pose.z, 1, pose.angle, pose.ax, pose.ay, pose.az
      --     or maybe
      --     table.unpack(pose.position), 1, table.unpack(pose.orientation)
      local pose = controller.Pose[hand]
      pass:draw(model, pose[1], pose[2], pose[3], 1, pose[4], pose[5], pose[6], pose[7])
      if controller.shouldShowCollider == true then
        pass:cube(pose[1], pose[2], pose[3], 0.25, 0, 0, 0, 0, 'line')
      end
    end
  end
end

return ControllerRenderingSystem
