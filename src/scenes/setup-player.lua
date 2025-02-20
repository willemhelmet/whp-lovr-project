-- src/scenes/setup-player.lua

local tiny = require 'lib.tiny'

local Input = require 'src.core.input'
local Grid = require 'src.entities.grid'
local Player = require 'src.entities.player'
local PlayerMotionSystem = require 'src.systems.player-motion-system'

local SetupPlayerScene = {}

SetupPlayerScene.joysticks = {
  left = {},
  right = {}
}

SetupPlayerScene.world = tiny.world(Player, PlayerMotionSystem)

function SetupPlayerScene.init()
end

function SetupPlayerScene.update(dt)
  Input.update(dt)
  SetupPlayerScene.world:update(dt)
end

function SetupPlayerScene.draw(pass)
  pass:transform(mat4(Player.Pose):invert())
  Grid.draw(pass)
  pass:setShader()
  pass:text("setup player", 0, 1.5, -4, .4)

  SetupPlayerScene.joysticks.left = Input.getValue("move")
  SetupPlayerScene.joysticks.right = Input.getValue("turn")
  pass:sphere(-1 + SetupPlayerScene.joysticks.left.x, 2 + SetupPlayerScene.joysticks.left.y, -4, 0.2)
  pass:sphere(1 + SetupPlayerScene.joysticks.right.x, 2 + SetupPlayerScene.joysticks.right.y, -4, 0.2)
end

return SetupPlayerScene
