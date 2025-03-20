-- /src/scenes/setup-input.lua

-- core
-- TODO: Make this a System
-- local Input = require 'src.core.input'

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
-- local Player = require 'src.entities.player'

-- components
local RenderingComponent = require 'src.components.rendering-component'
local TransformComponent = require 'src.components.transform-component'
local MaterialComponent = require 'src.components.material-component'
local MeshComponent = require 'src.components.mesh-component'
local TextComponent = require 'src.components.text-component'
-- systems
local RenderSystem = require 'src.systems.render-system'
local InputSystem = require 'src.systems.input-system'

-- assets
local UnlitMaterial = require 'assets.materials.unlit-color-material'


local SetupInput = {}
SetupInput.world = tiny.world(RenderSystem, InputSystem)


function SetupInput.init()
  SetupInput.world:addEntity(Grid.new())

  -- left controller label
  leftControllerTextEntity.Transform = TransformComponent.new(
    -2, 4.5, -5
  )
  leftControllerTextEntity.Text = TextComponent.new(
    'left controller', 0.5
  )
  SetupInput.world:addEntity(leftControllerTextEntity)

  -- left grip
  leftGripTextEntity.Transform = TransformComponent.new(
    -2, 3.5, -5
  )
  leftGripTextEntity.Text = TextComponent.new(
    'grip: ', 0.5
  )
  SetupInput.world:addEntity(leftGripTextEntity)

  -- left trigger
  leftTriggerTextEntity.Transform = TransformComponent.new(
    -2, 4.0, -5
  )
  leftTriggerTextEntity.Text = TextComponent.new(
    'trigger: ', 0.5
  )
  SetupInput.world:addEntity(leftTriggerTextEntity)

  -- right controller label
  rightControllerTextEntity = {}
  rightControllerTextEntity.Transform = TransformComponent.new(
    2, 4.5, -5
  )
  rightControllerTextEntity.Text = TextComponent.new(
    'right controller', 0.5
  )
  SetupInput.world:addEntity(rightControllerTextEntity)

  -- right grip
  rightGripTextEntity.Transform = TransformComponent.new(
    2, 3.5, -5
  )
  rightGripTextEntity.Text = TextComponent.new(
    'grip: ', 0.5
  )
  SetupInput.world:addEntity(rightGripTextEntity)

  -- right trigger
  rightTriggerTextEntity.Transform = TransformComponent.new(
    2, 4.0, -5
  )
  rightTriggerTextEntity.Text = TextComponent.new(
    'trigger: ', 0.5
  )
  SetupInput.world:addEntity(rightTriggerTextEntity)

  -- A button
  aButtonTextEntity.Transform = TransformComponent.new(
    2, 2.5, -5
  )
  aButtonTextEntity.Text = TextComponent.new(
    'A: ', 0.5
  )
  SetupInput.world:addEntity(aButtonTextEntity)

  -- B button
  bButtonTextEntity.Transform = TransformComponent.new(
    2, 3.0, -5
  )
  bButtonTextEntity.Text = TextComponent.new(
    'B: ', 0.5
  )
  SetupInput.world:addEntity(bButtonTextEntity)

  -- X button
  xButtonTextEntity.Transform = TransformComponent.new(
    -2, 2.5, -5
  )
  xButtonTextEntity.Text = TextComponent.new(
    'X: ', 0.5
  )
  SetupInput.world:addEntity(xButtonTextEntity)

  -- Y button
  yButtonTextEntity.Transform = TransformComponent.new(
    -2, 3.0, -5
  )
  yButtonTextEntity.Text = TextComponent.new(
    'Y: ', 0.5
  )
  SetupInput.world:addEntity(yButtonTextEntity)

  -- left thumbstick
  thumbstickLeftEntity.Transform = TransformComponent.new(
    -2, 1.5, -5,
    1, 0, 0, 0,
    0.15, 0.15, 0.15
  )
  thumbstickLeftEntity.Mesh = MeshComponent.new('assets/models/primitives/sphere.glb')
  thumbstickLeftEntity.Material = MaterialComponent.new(UnlitMaterial, { color = Vec3(1, 1, 1) })
  SetupInput.world:addEntity(thumbstickLeftEntity)

  -- right thumbstick
  thumbstickRightEntity.Transform = TransformComponent.new(
    2, 1.5, -5,
    1, 0, 0, 0,
    0.15, 0.15, 0.15
  )
  thumbstickRightEntity.Mesh = MeshComponent.new('assets/models/primitives/sphere.glb')
  thumbstickRightEntity.Material = MaterialComponent.new(UnlitMaterial, { color = Vec3(1, 1, 1) })
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
  thumbstickLeftEntity.Transform.position = {
    -2 + InputSystem:getValue('move').x * 0.5,
    1.5 + InputSystem:getValue('move').y * 0.5,
    -5
  }
  thumbstickRightEntity.Transform.position = {
    2 + InputSystem:getValue('thumbstickRight').x * 0.5,
    1.5 + InputSystem:getValue('thumbstickRight').y * 0.5,
    -5
  }
end

function SetupInput.draw(pass)
  RenderSystem.draw(pass)
end

return SetupInput
