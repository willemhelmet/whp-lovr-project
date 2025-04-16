-- src/entities/input-debug-entity.lua

local InputDebug = {}

local TransformComponent = require 'src.components.transform-component'
local TransformSystem = require 'src.systems.transform-system'
local MaterialComponent = require 'src.components.material-component'
local MeshComponent = require 'src.components.mesh-component'
local TextComponent = require 'src.components.text-component'
local UnlitMaterial = require 'assets.materials.unlit-color-material'
local InputSystem = require 'src.systems.input-system'

function InputDebug.new()
  local entities = {}

  -- left controller label
  local leftControllerTextEntity = {
    Transform = TransformComponent(Vec3(-2, 4.5, -5)),
    Text = TextComponent('left controller', 0.5)
  }
  table.insert(entities, leftControllerTextEntity)

  -- left grip
  local leftGripTextEntity = {
    Transform = TransformComponent(Vec3(-2, 3.5, -5)),
    Text = TextComponent('grip: ', 0.5)
  }
  table.insert(entities, leftGripTextEntity)

  -- left trigger
  local leftTriggerTextEntity = {
    Transform = TransformComponent(Vec3(-2, 4.0, -5)),
    Text = TextComponent('trigger: ', 0.5)
  }
  table.insert(entities, leftTriggerTextEntity)

  -- right controller label
  local rightControllerTextEntity = {
    Transform = TransformComponent(Vec3(2, 4.5, -5)),
    Text = TextComponent('right controller', 0.5)
  }
  table.insert(entities, rightControllerTextEntity)

  -- right grip
  local rightGripTextEntity = {
    Transform = TransformComponent(Vec3(2, 3.5, -5)),
    Text = TextComponent('grip: ', 0.5)
  }
  table.insert(entities, rightGripTextEntity)

  -- right trigger
  local rightTriggerTextEntity = {
    Transform = TransformComponent(Vec3(2, 4.0, -5)),
    Text = TextComponent('trigger: ', 0.5)
  }
  table.insert(entities, rightTriggerTextEntity)

  -- A button
  local aButtonTextEntity = {
    Transform = TransformComponent(Vec3(2, 2.5, -5)),
    Text = TextComponent('A: ', 0.5)
  }
  table.insert(entities, aButtonTextEntity)

  -- B button
  local bButtonTextEntity = {
    Transform = TransformComponent(Vec3(2, 3.0, -5)),
    Text = TextComponent('B: ', 0.5)
  }
  table.insert(entities, bButtonTextEntity)

  -- X button
  local xButtonTextEntity = {
    Transform = TransformComponent(Vec3(-2, 2.5, -5)),
    Text = TextComponent('X: ', 0.5)
  }
  table.insert(entities, xButtonTextEntity)

  -- Y button
  local yButtonTextEntity = {
    Transform = TransformComponent(Vec3(-2, 3.0, -5)),
    Text = TextComponent('Y: ', 0.5)
  }
  table.insert(entities, yButtonTextEntity)

  -- left thumbstick
  local thumbstickLeftEntity = {
    Transform = TransformComponent(
      Vec3(-2, 1.5, -5),
      Quat(1, 0, 0, 0),
      Vec3(0.15, 0.15, 0.15)
    ),
    Mesh = MeshComponent('assets/models/primitives/sphere.glb'),
    Material = MaterialComponent(UnlitMaterial, { color = Vec3(1, 1, 1) })
  }
  table.insert(entities, thumbstickLeftEntity)

  -- right thumbstick
  local thumbstickRightEntity = {
    Transform = TransformComponent(
      Vec3(2, 1.5, -5),
      Quat(1, 0, 0, 0),
      Vec3(0.15, 0.15, 0.15)
    ),
    Mesh = MeshComponent('assets/models/primitives/sphere.glb'),
    Material = MaterialComponent(UnlitMaterial, { color = Vec3(1, 1, 1) })
  }
  table.insert(entities, thumbstickRightEntity)

  -- Register update callback with InputSystem
  InputSystem:onInputChanged(function(actionName, value)
    if actionName == 'grabLeft' then
      leftGripTextEntity.Text:setText('grip: ' .. value)
    elseif actionName == 'triggerLeft' then
      leftTriggerTextEntity.Text:setText('trigger: ' .. value)
    elseif actionName == 'grabRight' then
      rightGripTextEntity.Text:setText('grip: ' .. value)
    elseif actionName == 'triggerRight' then
      rightTriggerTextEntity.Text:setText('trigger: ' .. value)
    elseif actionName == 'a' then
      aButtonTextEntity.Text:setText('A: ' .. (value and '1' or '0'))
    elseif actionName == 'b' then
      bButtonTextEntity.Text:setText('B: ' .. (value and '1' or '0'))
    elseif actionName == 'x' then
      xButtonTextEntity.Text:setText('X: ' .. (value and '1' or '0'))
    elseif actionName == 'y' then
      yButtonTextEntity.Text:setText('Y: ' .. (value and '1' or '0'))
    elseif actionName == 'move' then
      TransformSystem.setPosition(thumbstickLeftEntity.Transform, Vec3(
        -2 + value.x * 0.5,
        1.5 + value.y * 0.5,
        -5
      ))
    elseif actionName == 'thumbstickRight' then
      TransformSystem.setPosition(thumbstickRightEntity.Transform, Vec3(
        2 + value.x * 0.5,
        1.5 + value.y * 0.5,
        -5
      ))
    end
  end)

  return table.unpack(entities)
end

return InputDebug
