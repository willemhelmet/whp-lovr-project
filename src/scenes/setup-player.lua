-- src/scenes/setup-player.lua
-- lib
local lovr = require 'lovr'
local tiny = require 'lib.tiny'
local pretty = require 'lib.pl.pretty'
-- entities
local Grid = require 'src.entities.grid'
local Player = require 'src.entities.player'
local Controller = require 'src.entities.controller'
local Box = require 'src.entities.box'
-- components
local TransformComponent = require 'src.components.transform-component'
local MaterialComponent = require 'src.components.material-component'
local TextComponent = require 'src.components.text-component'
-- systems
local RenderSystem = require 'src.systems.render-system'
local PlayerMotionSystem = require 'src.systems.player-motion-system'
local InputSystem = require 'src.systems.input-system'
local MotionTrackingSystem = require 'src.systems.motion-tracking-system'
local TransformSystem = require 'src.systems.transform-system'
-- assets
local UnlitColorMaterial = require 'assets.materials.unlit-color-material'

local SetupPlayerScene = {}
SetupPlayerScene.world = tiny.world(TransformSystem, MotionTrackingSystem, RenderSystem, InputSystem, PlayerMotionSystem)


-- local entities
local player = Player.new({})
local leftController = Controller.new('left')

local playerPosText = {
  Transform = TransformComponent.new(
    lovr.math.newVec3(0, 1.5, -2)
  ),
  Text = TextComponent.new(
    'Player Position',
    0.25
  )
}
local headsetPosText = {
  Transform = TransformComponent.new(
    lovr.math.newVec3(0, 2.0, -2)
  ),
  Text = TextComponent.new(
    'Headset Position',
    0.25
  )
}
local combinedPosText = {
  Transform = TransformComponent.new(
    lovr.math.newVec3(0, 1.0, -2)
  ),
  Text = TextComponent.new(
    'Combined Position',
    0.25
  )
}

function SetupPlayerScene.init()
  -- Set up parent-child relationship
  TransformSystem.addChild(player.Transform, leftController.Transform)

  -- add player to world
  SetupPlayerScene.world:addEntity(player)

  -- Create controller
  SetupPlayerScene.world:addEntity(leftController)

  -- Add other entities
  SetupPlayerScene.world:addEntity(Grid.new())

  SetupPlayerScene.world:addEntity(playerPosText)
  SetupPlayerScene.world:addEntity(headsetPosText)
  SetupPlayerScene.world:addEntity(combinedPosText)
end

function SetupPlayerScene.update(dt)
  local playerPos = vec3(player.Transform.position)
  playerPosText.Text:setText('Player Position:\n' .. tostring(playerPos))
  local headsetPos = vec3(lovr.headset.getPosition())
  headsetPosText.Text:setText('Headset Position:\n' .. tostring(headsetPos))
  local combinedPos = lovr.math.vec3(playerPos):add(headsetPos)
  combinedPosText.Text:setText('Combined Position:\n' .. tostring(combinedPos))

  SetupPlayerScene.world:update(dt)
end

function SetupPlayerScene.draw(pass)
  pass:transform(TransformSystem.toMat4(player.Transform):invert())
  RenderSystem.draw(pass)
  pass:setShader()
  pass:sphere(lovr.math.vec3(player.Transform.position), 0.25)
  pass:setColor(1, 0, 0)
  local combinedPos = vec3(player.Transform.position):add(vec3(lovr.headset.getPosition()))
  combinedPos.y = 0
  pass:sphere(combinedPos, 0.25)
end

return SetupPlayerScene
