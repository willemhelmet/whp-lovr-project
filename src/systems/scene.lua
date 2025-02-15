-- src/core/scene.lua
local Scene = {}
Scene.current = nil -- Active scene
Scene.scenes = {}   -- Scene storage

function Scene.register(name, scene)
  Scene.scenes[name] = scene
end

function Scene.switch(name, ...)
  if Scene.scenes[name] then
    if Scene.current and Scene.current.exit then
      Scene.current.exit()       -- Cleanup previous scene
    end
    Scene.current = Scene.scenes[name]
    if Scene.current.init then
      Scene.current.init(...)       -- Initialize the new scene
    end
  else
    error("Scene '" .. name .. "' does not exist!")
  end
end

function Scene.update(dt)
  if Scene.current and Scene.current.update then
    Scene.current.update(dt)
  end
end

function Scene.draw()
  if Scene.current and Scene.current.draw then
    Scene.current.draw()
  end
end

return Scene
