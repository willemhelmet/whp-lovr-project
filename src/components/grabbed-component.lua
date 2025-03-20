-- src/components/grabbed-component.lua
--
-- Grabbed Component: Marks an entity as currently being grabbed by a controller.
-- Stores information about which controller is grabbing this object and the
-- original state of the object before being grabbed.
-- Added to entities temporarily while they are being held.

local GrabbedComponent = {
  controller = '',
  --jointId = 0,          -- ID of the physics joint (if using physics constraint) (whp: do i need this?)
  wasKinematic = false, -- Stores previous kinematic state before grab
  grabTime = 0          -- When the grab started (for effects, haptics, etc.)
}

function GrabbedComponent.new(options)
  local component = {}
  component.controller = options.controller or 'left'
  component.wasKinematic = options.wasKinematic or false
  component.grabTime = options.time or 0
  return component
end

return GrabbedComponent
