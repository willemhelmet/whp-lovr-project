-- src/scenes/setup-player.lua

local tiny = require 'lib.tiny'

local Input = require 'src.core.input'
local Grid = require 'src.entities.grid'
local Player = require 'src.entities.player'
local Controller = require 'src.entities.controller'
local PlayerMotionSystem = require 'src.systems.player-motion-system'
local ControllerSystem = require 'src.systems.controller-system'

local SetupPlayerScene = {}

SetupPlayerScene.joysticks = {
  left = {},
  right = {}
}

SetupPlayerScene.world = tiny.world(Player, PlayerMotionSystem, Controller, ControllerSystem)

function SetupPlayerScene.init()

end

function SetupPlayerScene.update(dt)
  Input.update(dt)
  SetupPlayerScene.world:update(dt)
end

function SetupPlayerScene.draw(pass)
  pass:transform(mat4(Player.Pose):invert())

  -- HACK: I do not know if this is functional or not, currently in Chi
  pass:draw(Controller.Models.left, 1.0, Controller.Poses.left:getOrientation())
  pass:draw(Controller.Models.right, 1.0, Controller.Poses.right:getOrientation())

  Grid.draw(pass)
  pass:setShader()
  pass:text("setup player", 0, 1.5, -4, .4)
end

return SetupPlayerScene
