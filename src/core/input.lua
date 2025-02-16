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
--]]
local lovr = require 'lovr'
local Input = {}

Input.bindings = {
  moveForward = { 'w', 'up' },
  moveBackward = { 's', 'down' },
  moveLeft = { 'a', 'left' },
  moveRight = { 'd', 'right' },
  one = { '1' },
  two = { '2' },
  quit = { 'escape' },
}

Input.states = {}

function Input.isPressed(action)
  for _, key in ipairs(Input.bindings[action] or {}) do
    -- TODO: implement system to register VR controller button events
    -- if lovr.headset.isDown(key) or lovr.system.isKeyDown(key) then
    if lovr.system.isKeyDown(key) then
      return true
    end
  end
  return false
end

-- function Input.update()
--   for action, keys in pairs(Input.bindings) do
--     for _, key in ipairs(key) do
--       local isDown = Input.is
--     end
--   end
-- end

return Input
