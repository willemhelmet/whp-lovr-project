-- src/components/material-component-lua


local MaterialComponent = {
  shader = nil,
  uniforms = {}
}

function MaterialComponent.new(shader, uniforms)
  return {
    shader = shader,
    values = uniforms or {}
  }
end

return MaterialComponent
