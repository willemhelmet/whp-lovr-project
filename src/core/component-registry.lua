-- src/core/component-registry.lua

local ComponentRegistry = {
  TransformComponent = require 'src.components.transform-component',
  MaterialComponent = require 'src.components.material-component',
  MeshComponent = require 'src.components.mesh-component',
  MotionTrackingComponent = require 'src.components.motion-tracking-component',
  PhysicsComponent = require 'src.components.physics-component',
  GrabbableComponent = require 'src.components.grabbable-component',
  JointComponent = require 'src.components.joint-component',
  TextComponent = require 'src.components.text-component',
  LightComponent = require 'src.components.light-component'
}

return ComponentRegistry
