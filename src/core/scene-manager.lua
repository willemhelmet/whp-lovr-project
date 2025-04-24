-- src/core/scene-manager.lua
local SceneManager = {}
SceneManager.current = nil -- Active scene
SceneManager.scenes = {}   -- SceneManager storage

function SceneManager.register(name, scene)
  SceneManager.scenes[name] = scene
end

function SceneManager.switch(name)
  local sceneClass = SceneManager.scenes[name]
  if sceneClass then
    -- Exit the current scene if it exists and has an exit method
    if SceneManager.current and SceneManager.current.exit then
      SceneManager.current:exit()
    end
    -- Instantiate the new scene
    SceneManager.current = sceneClass:new()
  else
    error("SceneManager '" .. name .. "' does not exist!")
  end
end

function SceneManager.update(dt)
  if SceneManager.current and SceneManager.current.update then
    SceneManager.current:update(dt)
  end
end

function SceneManager.draw(pass)
  if SceneManager.current and SceneManager.current.draw then
    SceneManager.current:draw(pass)
  end
end

return SceneManager
