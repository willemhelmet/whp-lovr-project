-- src/scenes/setup-player-3.lua

-- lib
local tiny = require 'lib.tiny'
local utils = require 'lib.pl.utils'
-- scene
local Scene = {}
Scene.world = tiny.world()
-- entities
local Grid = require 'src.entities.grid'
local Controller = require 'src.entities.controller'
local InputDebug = require 'src.entities.input-debug-entity'
-- local VrRig = require 'src.entities.vr-rig-entity'
-- components
local TransformComponent = require 'src.components.transform-component'
local MotionTrackingComponent = require 'src.components.motion-tracking-component'
-- systems
local Systems = require 'src.core.system-registry'
local TransformSystem = require 'src.systems.transform-system'
local RenderSystem = require 'src.systems.render-system'

local vrRigRoot = {
  Name = 'VR Rig Root',
  Player = {},
  Transform = TransformComponent(),
  Velocity = Vec3()
}
local vrCamera = {
  Name = 'VR Camera',
  Transform = TransformComponent(),
  MotionTracking = MotionTrackingComponent('head')
}
TransformSystem.addChild(vrRigRoot.Transform, vrCamera.Transform)
local vrControllerLeft = Controller('left')
TransformSystem.addChild(vrRigRoot.Transform, vrControllerLeft.Transform)
local vrControllerRight = Controller('right')
-- TransformSystem.addChild(vrRigRoot.Transform, vrControllerRight.Transform)

function Scene.init()
  for i, system in ipairs(Systems) do
    Scene.world:add(system[1])
    tiny.setSystemIndex(Scene.world, system[1], i)
  end

  Scene.world:add(Grid())
  -- WHP: is this the most elegant solution? I think not
  Scene.world:add(table.unpack(InputDebug().entities))
  -- TODO: move this from local insantiation to a separate .lua file
  Scene.world:add(vrRigRoot, vrCamera, vrControllerLeft, vrControllerRight)
end

function Scene.update(dt)
  Scene.world:update(dt)
end

function Scene.draw(pass)
  RenderSystem.draw(pass)
  -- WHP: debug sphere while i try to figure out controller craziness
  pass:setShader()
  pass:setColor(0, 0, 1)
  pass:sphere(vec3(lovr.headset.getPosition('left')), 0.015)
end

return Scene
