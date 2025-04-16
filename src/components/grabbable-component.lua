-- src/components/grabbable-component.lua
--
-- Grab Component: Marks an entity as grabbable by VR controllers.
-- Configures how the object behaves when grabbed (offset from hand,
-- whether it maintains physics properties, grab detection radius).
-- Used by the Grab System to determine which objects can be interacted with.


local GrabbableComponent = class('Grabbable')

function GrabbableComponent:init(options)
  options = options or {}
  self.Grabbable = {}
end

return GrabbableComponent
