-- src/core/base-scene.lua

local tiny = require 'lib.tiny'

local SystemRegistry = require 'src.core.system-registry'
local RenderSystem = require 'src.systems.render-system'

local BaseScene = class('Scene')

function BaseScene:init()
  self.world = tiny.world()
  for i, system in ipairs(SystemRegistry) do
    self.world:add(system[1])
    tiny.setSystemIndex(self.world, system[1], i)
  end
end

function BaseScene:update(dt)
  self.world:update(dt)
end

function BaseScene:draw(pass)
  RenderSystem.draw(pass)
end

function BaseScene:exit()
  -- AI: Default exit behavior: clear the world (removes all entities and systems)
  -- Subclasses can override this for more specific cleanup before calling super
  if self.world then
    tiny.clearSystems(self.world)
    tiny.clearEntities(self.world)
  end
  self.world = nil -- Release reference
end

return BaseScene
