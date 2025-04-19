-- src/entities/vr-rig-entity.lua

local TransformComponent = require 'src.components.transform-component'
local TransformSystem = require 'src.systems.transform-system'
local MotionTrackingComponent = require 'src.components.motion-tracking-component'
local MeshComponent = require 'src.components.mesh-component'
local MaterialComponent = require 'src.components.material-component'

local VRRig = class('VR Rig')

function VRRig:init()
  self.vrRig = {}
  self.vrRig.Name = 'VR Rig'
  self.vrRig.VRRig = {}
  self.vrRig.Transform = TransformComponent()

  local vrCamera = {}
  self.vrCamera.Name = "VR Camera"
  self.vrCamera.Transform = TransformComponent()
  self.vrCamera.MotionTracking = MotionTrackingComponent('head')
  TransformSystem.addChild(self.vrRig.Transform, vrCamera.Transform)

  local vrControllerLeft = {}
  self.vrControllerLeft.Name = "VR Controller Left"
  self.vrControllerLeft.Transform = TransformComponent()
  self.vrControllerLeft.Mesh = MeshComponent('/assets/models/quest-left.glb')
  self.vrControllerLeft.Material = MaterialComponent(nil, {})
  self.vrControllerLeft.MotionTracking = MotionTrackingComponent('left')
  TransformSystem.addChild(self.vrRig.Transform, vrControllerLeft.Transform)

  local vrControllerRight = {}
  self.vrControllerRight.Name = "VR Controller Right"
  self.vrControllerRight.Transform = TransformComponent()
  self.vrControllerRight.Mesh = MeshComponent('/assets/models/quest-right.glb')
  self.vrControllerRight.Material = MaterialComponent(nil, {})
  self.vrControllerRight.MotionTracking = MotionTrackingComponent('right')
  TransformSystem.addChild(self.vrRig.Transform, vrControllerRight.Transform)
end

return VRRig
