-- /src/scenes/setup-input.lua

-- lib
local tiny = require 'lib.tiny'

-- entities
local Grid = require 'src.entities.grid'
local leftControllerTextEntity = {}
local rightControllerTextEntity = {}
local leftGripTextEntity = {}
local leftTriggerTextEntity = {}
local rightGripTextEntity = {}
local rightTriggerTextEntity = {}
local aButtonTextEntity = {}
local bButtonTextEntity = {}
local xButtonTextEntity = {}
local yButtonTextEntity = {}
local thumbstickLeftEntity = {}
local thumbstickRightEntity = {}

-- components
local TransformComponent = require 'src.components.transform-component'
local MaterialComponent = require 'src.components.material-component'
local MeshComponent = require 'src.components.mesh-component'
local TextComponent = require 'src.components.text-component'
-- systems
local RenderSystem = require 'src.systems.render-system'
local InputSystem = require 'src.systems.input-system'
local TransformSystem = require 'src.systems.transform-system'

-- assets
local UnlitMaterial = require 'assets.materials.unlit-color-material'


local SetupInput = {}
SetupInput.world = tiny.world(RenderSystem, InputSystem, TransformSystem)

function SetupInput.init()
  SetupInput.world:addEntity(Grid())

  -- left controller label
  leftControllerTextEntity.Transform = TransformComponent(
    Vec3(-2, 4.5, -5)
  )
  leftControllerTextEntity.Text = TextComponent(
    'left controller', 0.5
  )
  SetupInput.world:addEntity(leftControllerTextEntity)

  -- left grip
  leftGripTextEntity.Transform = TransformComponent(
    Vec3(-2, 3.5, -5)
  )
  leftGripTextEntity.Text = TextComponent(
    'grip: ', 0.5
  )
  SetupInput.world:addEntity(leftGripTextEntity)

  -- left trigger
  leftTriggerTextEntity.Transform = TransformComponent(
    Vec3(-2, 4.0, -5)
  )
  leftTriggerTextEntity.Text = TextComponent(
    'trigger: ', 0.5
  )
  SetupInput.world:addEntity(leftTriggerTextEntity)

  -- right controller label
  rightControllerTextEntity = {}
  rightControllerTextEntity.Transform = TransformComponent(
    Vec3(2, 4.5, -5)
  )
  rightControllerTextEntity.Text = TextComponent(
    'right controller', 0.5
  )
  SetupInput.world:addEntity(rightControllerTextEntity)

  -- right grip
  rightGripTextEntity.Transform = TransformComponent(
    Vec3(2, 3.5, -5)
  )
  rightGripTextEntity.Text = TextComponent(
    'grip: ', 0.5
  )
  SetupInput.world:addEntity(rightGripTextEntity)

  -- right trigger
  rightTriggerTextEntity.Transform = TransformComponent(
    Vec3(2, 4.0, -5)
  )
  rightTriggerTextEntity.Text = TextComponent(
    'trigger: ', 0.5
  )
  SetupInput.world:addEntity(rightTriggerTextEntity)

  -- A button
  aButtonTextEntity.Transform = TransformComponent(
    Vec3(2, 2.5, -5)
  )
  aButtonTextEntity.Text = TextComponent(
    'A: ', 0.5
  )
  SetupInput.world:addEntity(aButtonTextEntity)

  -- B button
  bButtonTextEntity.Transform = TransformComponent(
    Vec3(2, 3.0, -5)
  )
  bButtonTextEntity.Text = TextComponent(
    'B: ', 0.5
  )
  SetupInput.world:addEntity(bButtonTextEntity)

  -- X button
  xButtonTextEntity.Transform = TransformComponent(
    Vec3(-2, 2.5, -5)
  )
  xButtonTextEntity.Text = TextComponent(
    'X: ', 0.5
  )
  SetupInput.world:addEntity(xButtonTextEntity)

  -- Y button
  yButtonTextEntity.Transform = TransformComponent(
    Vec3(-2, 3.0, -5)
  )
  yButtonTextEntity.Text = TextComponent(
    'Y: ', 0.5
  )
  SetupInput.world:addEntity(yButtonTextEntity)

  -- left thumbstick
  thumbstickLeftEntity.Transform = TransformComponent(
    Vec3(-2, 1.5, -5),
    Quat(1, 0, 0, 0),
    Vec3(0.15, 0.15, 0.15)
  )
  thumbstickLeftEntity.Mesh = MeshComponent('assets/models/primitives/sphere.glb')
  thumbstickLeftEntity.Material = MaterialComponent(UnlitMaterial, { color = Vec3(1, 1, 1) })
  SetupInput.world:addEntity(thumbstickLeftEntity)

  -- right thumbstick
  thumbstickRightEntity.Transform = TransformComponent(
    Vec3(2, 1.5, -5),
    Quat(1, 0, 0, 0),
    Vec3(0.15, 0.15, 0.15)
  )
  thumbstickRightEntity.Mesh = MeshComponent('assets/models/primitives/sphere.glb')
  thumbstickRightEntity.Material = MaterialComponent(UnlitMaterial, { color = Vec3(1, 1, 1) })
  SetupInput.world:addEntity(thumbstickRightEntity)
end

function SetupInput.update(dt)
  SetupInput.world:update(dt)

  leftGripTextEntity.Text:setText('grip: ' .. InputSystem:getValue('grabLeft'))
  leftTriggerTextEntity.Text:setText('trigger: ' .. InputSystem:getValue('triggerLeft'))
  rightGripTextEntity.Text:setText('grip: ' .. InputSystem:getValue('grabRight'))
  rightTriggerTextEntity.Text:setText('trigger: ' .. InputSystem:getValue('triggerRight'))
  aButtonTextEntity.Text:setText('A: ' .. (InputSystem:getValue('a') and '1' or '0'))
  bButtonTextEntity.Text:setText('B: ' .. (InputSystem:getValue('b') and '1' or '0'))
  xButtonTextEntity.Text:setText('X: ' .. (InputSystem:getValue('x') and '1' or '0'))
  yButtonTextEntity.Text:setText('Y: ' .. (InputSystem:getValue('y') and '1' or '0'))

  TransformSystem.setPosition(
    thumbstickLeftEntity.Transform,
    Vec3(
      -2 + InputSystem:getValue('move').x * 0.5,
      1.5 + InputSystem:getValue('move').y * 0.5,
      -5
    )
  )
  TransformSystem.setPosition(
    thumbstickRightEntity.Transform,
    Vec3(
      2 + InputSystem:getValue('thumbstickRight').x * 0.5,
      1.5 + InputSystem:getValue('thumbstickRight').y * 0.5,
      -5
    )
  )
end

function SetupInput.draw(pass)
  RenderSystem.draw(pass)
end

return SetupInput
