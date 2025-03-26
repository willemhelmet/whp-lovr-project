-- src/entities/vr-rig-entity.lua

local TransformComponent = require 'src.components.transform-component'
local TransformSystem = require 'src.systems.transform-system'
local MotionTrackingComponent = require 'src.components.motion-tracking-component'
local MeshComponent = require 'src.components.mesh-component'
local MaterialComponent = require 'src.components.material-component'

local VRRig = {}

function VRRig.new()
  local entities = {}

  local vrRig = {}
  vrRig.Name = 'VR Rig'
  vrRig.VRRig = {}
  vrRig.Transform = TransformComponent.new()
  table.insert(entities, vrRig)

  local vrCamera = {}
  vrCamera.Name = "VR Camera"
  vrCamera.Transform = TransformComponent.new()
  vrCamera.MotionTracking = MotionTrackingComponent.new('head')
  TransformSystem.addChild(vrRig.Transform, vrCamera.Transform)
  table.insert(entities, vrCamera)

  local vrControllerLeft = {}
  vrControllerLeft.Name = "VR Controller Left"
  vrControllerLeft.Transform = TransformComponent.new()
  vrControllerLeft.Mesh = MeshComponent.new('/assets/models/quest-left.glb')
  vrControllerLeft.Material = MaterialComponent.new(nil, {})
  vrControllerLeft.MotionTracking = MotionTrackingComponent.new('left')
  TransformSystem.addChild(vrRig.Transform, vrControllerLeft.Transform)
  table.insert(entities, vrControllerLeft)

  local vrControllerRight = {}
  vrControllerRight.Name = "VR Controller Right"
  vrControllerRight.Transform = TransformComponent.new()
  vrControllerRight.Mesh = MeshComponent.new('/assets/models/quest-right.glb')
  vrControllerRight.Material = MaterialComponent.new(nil, {})
  vrControllerRight.MotionTracking = MotionTrackingComponent.new('right')
  TransformSystem.addChild(vrRig.Transform, vrControllerRight.Transform)
  table.insert(entities, vrControllerRight)

  return table.unpack(entities)
end

return VRRig
