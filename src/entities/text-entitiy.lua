-- src/entities/text-entity.lua

local class = require 'lib.30log'
local Text = class('Text')

local TransformComponent = require 'src.components.transform-component'
local TextComponent = require 'src.components.text-component'

function Text:init(options)
  options = options or {}
  self.Transform = options.Transform or TransformComponent()
  self.Text = options.Text or TextComponent('text goes here', 0.25)
end

return Text
