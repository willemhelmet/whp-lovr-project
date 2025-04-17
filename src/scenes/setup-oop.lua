-- src/scenes/setup-oop.lua

-- lib
local tiny = require 'lib.tiny'
local pretty = require 'lib.pl.pretty'
local utils = require 'lib.pl.utils'
local class = require 'lib.30log'
-- scene
local Scene = {}
Scene.world = tiny.world()
-- entities
local Grid = require 'src.entities.grid'
local Box = require 'src.entities.box'
local drawCallsText
-- WHP: This seems like a great opportunity to use OOP!
--      The Scene class can have all of these components and systems
--      already setup, so all i need to do is create an instance
--      of the Scene class whenever I want to create a new level
-- components
Scene.components = {}
local componentRegistry = require 'src.core.component-registry'
utils.import(componentRegistry, Scene.components)
-- systems
Scene.systems = {}
local systemRegistry = require 'src.core.system-registry'
utils.import(systemRegistry, Scene.systems)
-- assets
local PhongMaterial = require 'assets.materials.phong-material'
local UnlitColorMaterial = require 'assets.materials.unlit-color-material'

function Scene.init()
  -- Add systems, perfect moment for OOP, every scene should have this in their initialization
  for _, system in pairs(Scene.systems) do
    Scene.world:add(system)
  end
  -- add grid
  Scene.world:add(Grid())

  local myBox0 = Box({
    Transform = Scene.components.TransformComponent(
      Vec3(1, 0.5, -4)
    )
  })
  Scene.world:add(myBox0)

  local myBox1 = Box({
    Transform = Scene.components.TransformComponent(
      Vec3(2, 0.5, -4),
      Quat(),
      Vec3(1, 1, 1)
    ),
    Material = Scene.components.MaterialComponent(
      UnlitColorMaterial, { color = Vec3(1, 0, 0) }
    )
  })
  Scene.world:add(myBox1)

  local myBox2 = Box()
  myBox2.Transform = Scene.components.TransformComponent(
    Vec3(3, 0.5, -4),
    Quat(),
    Vec3(.6, .6, .6)
  )
  myBox2.Mesh = Scene.components.MeshComponent('assets/models/suzanne.glb')
  myBox2.Material = Scene.components.MaterialComponent(
    UnlitColorMaterial, { color = Vec3(0, 1, 0) }
  )
  Scene.world:add(myBox2)

  -- add text
  Scene.world:add({
    Name = 'Text',
    Transform = Scene.components.TransformComponent(
      Vec3(0, 0.5, -3),
      Quat(1, 0, 0, 0),
      Vec3(1, 1, 1)
    ),
    Text = Scene.components.TextComponent(
      'setup OOP', 0.25
    )
  })

  Scene.world:add({
    Name = 'dir light',
    Transform = Scene.components.TransformComponent(
      Vec3(0, 0, -4),
      Quat(1, -math.pi * 0.25, -math.pi * 0.25, 0)
    ),
    Light = Scene.components.LightComponent({
      color = Vec3(1, 1, 1),
      intensity = 0.08,
      type = 'directional',

    })
  })


  drawCallsText = {
    Transform = Scene.components.TransformComponent(
      Vec3(0, 2.5, -3)
    ),
    Text = Scene.components.TextComponent(
      'number of draw calls', 0.25
    )
  }
  Scene.world:add(drawCallsText)
end

function Scene.update(dt)
  Scene.world:update(dt)
end

function Scene.draw(pass)
  Scene.systems.RenderSystem.draw(pass)
  drawCallsText.Text:setText(Scene.systems.RenderSystem.getDrawCalls(pass))
end

return Scene
