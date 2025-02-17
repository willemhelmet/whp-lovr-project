-- scr/core/input.lua
--[[
--
--  What i want here is a system that can handle a large variety of inputs
--  from various modalities.
--  For instance, I want to get all types of button input from:
--    VR controllers,
--    Hand tracking,
--    Keyboard,
--    Mouse
--  I think for the time being I should focus only on the keyboard, and then VR controllers
--
--
--  TODO:
--  Simulate left/right controller joysticks with:
--    T       I
--  F G H   J K L
-- don't forget to do the square root thing with diagonals
--]]
local lovr = require 'lovr'
local tablex = require 'lib.pl.tablex'
local Input = {}

-- Constants
Input.DEADZONE = 0.2;

-- is this necessary?
Input.devices = {
  left = {

  },
  right = {

  },
  keyboard = {

  }
}

Input.bindings = {
  move = {
    type = "vector2",
    bindings = {
      {
        device = "keyboard",
        positive_x = "h",
        negative_x = "f",
        positive_y = "t",
        negative_y = "g"
      },
      {
        device = "vr",
        source = "left",
        input = "thumbstick"
      }
    }
  },
  thumbstickRight = {
    type = 'vector2',
    bindings = {
      {
        device = 'keyboard',
        positive_x = 'l',
        negative_x = 'j',
        positive_y = 'i',
        negative_y = 'k',
      },
      {
        device = 'vr',
        source = 'left',
        input = 'thumbstick'
      }
    }
  },
  -- turn = {
  --   type = "float",
  --   bidings = {
  --     {
  --       device = "keyboard",
  --       positive_x = "l",
  --       negative_x = "j"
  --     },
  --     {
  --       device = "vr",
  --       source = "right",
  --       input = "thumbstick"
  --     }
  --   }
  -- },
  grabLeft = {
    type = "float",
    bindings = {
      {
        device = "keyboard",
        key = "y"
      },
      {
        device = "vr",
        source = "left",
        input = "grip"
      },
    },
  },
  grabRight = {
    type = "float",
    bindings = {
      {
        device = "keyboard",
        key = "o"
      },
      {
        device = "vr",
        source = "right",
        input = "grip"
      }
    },
  },
  triggerLeft = {
    type = "float",
    bindings = {
      {
        device = "keyboard",
        key = "r"
      },
      {
        device = "vr",
        source = "left",
        input = "trigger"
      },
    }
  },
  triggerRight = {
    type = "float",
    bindings = {
      {
        device = "keyboard",
        key = "u"
      },
      {
        device = "vr",
        source = "right",
        input = "trigger"
      }
    }
  },
  a = {
    type = 'boolean',
    bindings = {
      {
        device = 'keyboard',
        key = 'm'
      },
      {
        device = "vr",
        source = 'left',
        input = 'a'
      }
    },
  },
  b = {
    type = 'boolean',
    bindings = {
      {
        device = 'keyboard',
        key = 'n'
      },
      {
        device = 'vr',
        source = 'left',
        input = 'b'
      }
    }
  },
  x = {
    type = 'boolean',
    bindings = {
      {
        device = 'keyboard',
        key = 'b'
      },
      {
        device = "vr",
        source = 'left',
        input = 'x'
      }
    },
  },
  y = {
    type = 'boolean',
    bindings = {
      {
        device = 'keyboard',
        key = 'v'
      },
      {
        device = 'vr',
        source = 'left',
        input = 'y'
      }
    }
  },
  thumbstickClickLeft = {
    type = 'boolean',
    bindings = {
      {
        device = 'keyboard',
        key = ','
      },
      {
        device = 'vr',
        source = 'left',
        input = 'thumbstick'
      }
    }
  },
  thumbstickClickRight = {
    type = 'boolean',
    bindings = {
      {
        device = 'keyboard',
        key = '.'
      },
      {
        device = 'vr',
        source = 'left',
        input = 'thumbstick'
      }
    }
  },
  quit = {
    type = "boolean",
    bindings = {
      {
        device = "keyboard",
        key = "escape"
      }
    }
  }
}

Input.states = {}
Input.previousStates = {}
Input.callbacks = {}

function Input.getValue(actionName)
  return Input.states[actionName]
end

function Input.onInputChanged(callback)
  table.insert(Input.callbacks, callback)
end

function Input.update(dt)
  -- Store previous states -- why?
  Input.previousStates = tablex.copy(Input.states)

  -- Update all action states
  for actionName, action in pairs(Input.bindings) do
    local value = Input.evaluateAction(action)
    if Input.states[actionName] ~= value then
      Input.states[actionName] = value
      -- Trigger callbacks
      for _, callback in ipairs(Input.callbacks) do
        callback(actionName, value, Input.previousStates[actionName])
      end
    end
  end
end

function Input.evaluateAction(action)
  if not action or not action.type or not action.bindings then
    return nil
  end

  -- Handle different action types
  if action.type == 'boolean' then
    for _, binding in ipairs(action.bindings) do
      if binding.device == 'keyboard' and binding.key then
        if lovr.system.isKeyDown(binding.key) then
          return true
        end
      elseif binding.device == 'vr' and binding.source and binding.input then
        -- WHP: Do I also want to include funtionality to make analog inputs
        --      (i.e. trigger, grip, joysticks) act as boolean triggers?
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
          -- WHP: Not so sure about this one... what does select() do here?
          local value = select(1, lovr.headset.getAxis(binding.source, binding.input))
          -- WHP: Additionally, the math.abs value feels geared towards the thumbsticks
          --      but that doens't feel right to me. will have to revisit
          maxValue = math.max(maxValue, math.abs(value))
        end
      end
    end
    return maxValue
  elseif action.type == 'vector2' then
    for _, binding in ipairs(action.bindings) do
      if binding.device == 'keyboard' then
        -- Handle keyboard directional input
        local x, y = 0, 0
        if binding.positive_x and lovr.system.isKeyDown(binding.positive_x) then x = x + 1 end
        if binding.negative_x and lovr.system.isKeyDown(binding.negative_x) then x = x - 1 end
        if binding.positive_y and lovr.system.isKeyDown(binding.positive_y) then y = y + 1 end
        if binding.negative_y and lovr.system.isKeyDown(binding.negative_y) then y = y - 1 end

        -- Normalize diagonal movement
        if x ~= 0 and y ~= 0 then
          local length = math.sqrt(x * x + y * y)
          x = x / length
          y = y / length
        end

        if x ~= 0 or y ~= 0 then
          return { x = x, y = y }
        end
      elseif binding.device == 'vr' and binding.source and binding.input then
        -- Handle VR Thumbstick input
        local x, y = lovr.headset.getAxis(binding.source, binding.input)
        return { x = x, y = y }
      end
    end
    return { x = 0, y = 0 }
  end
  return nil
end

function Input.getAxis(device, axis)
  local x, y = lovr.headset.getAxis(device, axis)
  return x, y
end

function Input.isDown(device, button)
  if device == 'keyboard' then
    return lovr.system.isKeyDown(button)
  else
    return lovr.headset.isDown(device, button)
  end
end

return Input
