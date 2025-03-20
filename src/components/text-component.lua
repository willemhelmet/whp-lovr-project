-- src/components/text-component

local TextComponent = {}


function TextComponent.new(text, size, halign, valign)
  local textComp = {
    text = text,
    size = size,
    halign = halign or 'center',
    valign = valign or 'middle'
  }
  function textComp:setText(text)
    self.text = text
  end

  return textComp
end

return TextComponent
