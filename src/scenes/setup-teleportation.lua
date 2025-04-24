-- src/scenes/setup-teleportation.lua

local BaseScene = require 'src.core.base-scene'

local Grid = require 'src.entities.grid'
local Controller = require 'src.entities.controller'
local InputDebug = require 'src.entities.input-debug-entity'
local Player = require 'src.entities.player'
local Text = require 'src.entities.text-entitiy'

-- define scene instance
local SetupTeleportationScene = BaseScene:extend('Setup Teleportation Scene')


local text = Text()
function SetupTeleportationScene:init()
  print('setup-teleportation: init')
  self.super:init()
  self.leftController = Controller('left')
  self.rightController = Controller('right')
  self.world:add(self.leftController, self.rightController)
  self.world:add(Player())
  self.world:add(table.unpack(InputDebug().entities))
  self.world:add(Grid())
  text.Transform:setPosition(Vec3(0, 1, -4))
  self.world:add(text)
end

function SetupTeleportationScene:update(dt)
  text.Text:setText(tostring(Vec3(lovr.headset.getPosition('left'))))
  self.super:update(dt)
end

function SetupTeleportationScene:draw(pass)
  self.super:draw(pass)
end

return SetupTeleportationScene
