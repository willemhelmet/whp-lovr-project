-- src/systems/controller-system.lua

local tiny = require 'lib.tiny'
local ControllerSystem = tiny.processingSystem(class('Controller System'))
ControllerSystem.filter = tiny.requireAny("Hand", "Controller")

function ControllerSystem:init()

end

function ControllerSystem:onAdd(e)
  if e.Hand == 'left' then
    self.leftController = e
  elseif e.Hand == 'right' then
    self.rightController = e
  end
end

function ControllerSystem:process(e)
end

function ControllerSystem:getControllers()
  return { self.leftController and 'hand/left' or nil, self.rightController and 'hand/right' or nil }
end

return ControllerSystem
