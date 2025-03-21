-- src/components/text-component

local TextComponent = {}


function TextComponent.new(text, size, halign, valign)
  local comp = {}
  comp.text = text or ""
  comp.size = size or 1
  comp.halign = halign or 'center'
  comp.valign = valign or 'middle'
  function comp:setText(text)
    self.text = text
  end

  return comp
end

return TextComponent
