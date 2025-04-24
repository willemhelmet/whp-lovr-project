-- src/systems/input-system.lua

-- lib
local lovr = require 'lovr'
local tiny = require 'lib.tiny'
local tablex = require 'lib.pl.tablex'
local Keybinds = require 'config.keybinds'
local class = require 'lib.30log'

local InputSystem = tiny.processingSystem(class('Input System'))
-- InputSystem.filter = tiny.requireAll('Input') -- Assuming entities have an inputComponent

InputSystem.states = {}
InputSystem.previousStates = {}
InputSystem.callbacks = {}

function InputSystem:getValue(actionName)
  if self.states[actionName] then
    return self.states[actionName]
  end
end

function InputSystem:onInputChanged(callback)
  table.insert(self.callbacks, callback)
end

function InputSystem:update(dt)
  -- Store previous states
  self.previousStates = tablex.copy(self.states)

  -- Update all action states
  for actionName, action in pairs(Keybinds) do
    local value = self:evaluateAction(action)
    if self.states[actionName] ~= value then
      self.states[actionName] = value
      -- Trigger callbacks
      for _, callback in ipairs(self.callbacks) do
        callback(actionName, value, self.previousStates[actionName])
      end
    end
  end
end

function InputSystem:evaluateAction(action)
  if not action or not action.type or not action.bindings then
    return nil
  end

  if action.type == 'boolean' then
    for _, binding in ipairs(action.bindings) do
      if binding.device == 'keyboard' and binding.key then
        if lovr.system.isKeyDown(binding.key) then
          return true
        end
      elseif binding.device == 'vr' and binding.source and binding.input then
        if lovr.headset.isDown(binding.source, binding.input) then
          return true
        end
      end
    end
    return false
  elseif action.type == 'float' then
    local maxValue = 0
    for _, binding in ipairs(action.bindings) do
      if binding.device == 'keyboard' and binding.key then
        if lovr.system.isKeyDown(binding.key) then
          maxValue = math.max(maxValue, 1.0)
        end
      else
        if binding.device == 'vr' and binding.source and binding.input then
          local value = select(1, lovr.headset.getAxis(binding.source, binding.input))
          maxValue = math.max(maxValue, math.abs(value))
        end
      end
    end
    return maxValue
  elseif action.type == 'vector2' then
    for _, binding in ipairs(action.bindings) do
      if binding.device == 'keyboard' then
        local x, y = 0, 0
        if binding.positive_x and lovr.system.isKeyDown(binding.positive_x) then x = x + 1 end
        if binding.negative_x and lovr.system.isKeyDown(binding.negative_x) then x = x - 1 end
        if binding.positive_y and lovr.system.isKeyDown(binding.positive_y) then y = y + 1 end
        if binding.negative_y and lovr.system.isKeyDown(binding.negative_y) then y = y - 1 end

        if x ~= 0 and y ~= 0 then
          local length = math.sqrt(x * x + y * y)
          x = x / length
          y = y / length
        end

        if x ~= 0 or y ~= 0 then
          return { x = x, y = y }
        end
      elseif binding.device == 'vr' and binding.source and binding.input then
        local x, y = lovr.headset.getAxis(binding.source, binding.input)
        return { x = x, y = y }
      end
    end
    return { x = 0, y = 0 }
  end
  return nil
end

return InputSystem
