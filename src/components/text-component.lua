-- src/components/text-component

local class = require 'lib.30log'

local TextComponent = class('Text')

function TextComponent:init(text, size, halign, valign)
  self.text = text or ""
  self.size = size or 1
  self.halign = halign or 'center'
  self.valign = valign or 'middle'
end

function TextComponent:setText(newText)
  self.text = newText
end

return TextComponent
