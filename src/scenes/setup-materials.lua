-- src/scenes/setup-materials.lua

-- lib
local tiny = require 'lib.tiny'
local utils = require 'lib.pl.utils'
-- scene
local Scene = {}
Scene.world = tiny.world()
-- entities
local Grid = require 'src.entities.grid'
local Suzanne = require 'src.entities.suzanne'
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

local materialNames = {
  "Emerald", "Jade", "Obsidian", "Pearl", "Ruby",
  "Turquoise", "Brass", "Bronze", "Chrome", "Copper",
  "Gold", "Silver", "BlackPlastic", "CyanPlastic",
  "GreenPlastic", "RedPlastic", "WhitePlastic",
  "YellowPlastic", "BlackRubber", "CyanRubber",
  "GreenRubber", "RedRubber", "WhiteRubber", "YellowRubber"
}
local materials = {
  Emerald = {
    ambient = Vec4(0.0215, 0.1745, 0.0215),
    diffuse = Vec4(0.07568, 0.61424, 0.07568),
    specular = Vec4(0.633, 0.727811, 0.633),
    metalness = 0.6 * 128
  },
  Jade = {
    ambient = Vec4(0.135, 0.2225, 0.1575),
    diffuse = Vec4(0.54, 0.89, 0.63),
    specular = Vec4(0.316228, 0.316228, 0.316228),
    metalness = 0.1 * 128
  },
  Obsidian = {
    ambient = Vec4(0.05375, 0.05, 0.06625),
    diffuse = Vec4(0.18275, 0.17, 0.22525),
    specular = Vec4(0.332741, 0.328634, 0.346435),
    metalness = 0.3 * 128
  },
  Pearl = {
    ambient = Vec4(0.25, 0.20725, 0.20725),
    diffuse = Vec4(1.0, 0.829, 0.829),
    specular = Vec4(0.296648, 0.296648, 0.296648),
    metalness = 0.088 * 128
  },
  Ruby = {
    ambient = Vec4(0.1745, 0.01175, 0.01175),
    diffuse = Vec4(0.61424, 0.04136, 0.04136),
    specular = Vec4(0.727811, 0.626959, 0.626959),
    metalness = 0.6 * 128
  },
  Turquoise = {
    ambient = Vec4(0.1, 0.18725, 0.1745),
    diffuse = Vec4(0.396, 0.74151, 0.69102),
    specular = Vec4(0.297254, 0.30829, 0.306678),
    metalness = 0.1 * 128
  },
  Brass = {
    ambient = Vec4(0.329412, 0.223529, 0.027451),
    diffuse = Vec4(0.780392, 0.568627, 0.113725),
    specular = Vec4(0.992157, 0.941176, 0.807843),
    metalness = 0.21794872 * 128
  },
  Bronze = {
    ambient = Vec4(0.2125, 0.1275, 0.054),
    diffuse = Vec4(0.714, 0.4284, 0.18144),
    specular = Vec4(0.393548, 0.271906, 0.166721),
    metalness = 0.2 * 128
  },
  Chrome = {
    ambient = Vec4(0.25, 0.25, 0.25),
    diffuse = Vec4(0.4, 0.4, 0.4),
    specular = Vec4(0.774597, 0.774597, 0.774597),
    metalness = 0.6 * 128
  },
  Copper = {
    ambient = Vec4(0.19125, 0.0735, 0.0225),
    diffuse = Vec4(0.7038, 0.27048, 0.0828),
    specular = Vec4(0.256777, 0.137622, 0.086014),
    metalness = 0.1 * 128
  },
  Gold = {
    ambient = Vec4(0.24725, 0.1995, 0.0745),
    diffuse = Vec4(0.75164, 0.60648, 0.22648),
    specular = Vec4(0.628281, 0.555802, 0.366065),
    metalness = 0.4 * 128
  },
  Silver = {
    ambient = Vec4(0.19225, 0.19225, 0.19225),
    diffuse = Vec4(0.50754, 0.50754, 0.50754),
    specular = Vec4(0.508273, 0.508273, 0.508273),
    metalness = 0.4 * 128
  },
  BlackPlastic = {
    ambient = Vec4(0.0, 0.0, 0.0),
    diffuse = Vec4(0.01, 0.01, 0.01),
    specular = Vec4(0.5, 0.5, 0.5),
    metalness = 0.25 * 128
  },
  CyanPlastic = {
    ambient = Vec4(0.0, 0.1, 0.06),
    diffuse = Vec4(0.0, 0.50980392, 0.50980392),
    specular = Vec4(0.50196078, 0.50196078, 0.50196078),
    metalness = 0.25 * 128
  },
  GreenPlastic = {
    ambient = Vec4(0.0, 0.0, 0.0),
    diffuse = Vec4(0.1, 0.35, 0.1),
    specular = Vec4(0.45, 0.55, 0.45),
    metalness = 0.25 * 128
  },
  RedPlastic = {
    ambient = Vec4(0.0, 0.0, 0.0),
    diffuse = Vec4(0.5, 0.0, 0.0),
    specular = Vec4(0.7, 0.6, 0.6),
    metalness = 0.25 * 128
  },
  WhitePlastic = {
    ambient = Vec4(0.0, 0.0, 0.0),
    diffuse = Vec4(0.55, 0.55, 0.55),
    specular = Vec4(0.7, 0.7, 0.7),
    metalness = 0.25 * 128
  },
  YellowPlastic = {
    ambient = Vec4(0.0, 0.0, 0.0),
    diffuse = Vec4(0.5, 0.5, 0.0),
    specular = Vec4(0.6, 0.6, 0.5),
    metalness = 0.25 * 128
  },
  BlackRubber = {
    ambient = Vec4(0.02, 0.02, 0.02),
    diffuse = Vec4(0.01, 0.01, 0.01),
    specular = Vec4(0.4, 0.4, 0.4),
    metalness = 0.078125 * 128
  },
  CyanRubber = {
    ambient = Vec4(0.0, 0.05, 0.05),
    diffuse = Vec4(0.4, 0.5, 0.5),
    specular = Vec4(0.04, 0.7, 0.7),
    metalness = 0.078125 * 128
  },
  GreenRubber = {
    ambient = Vec4(0.0, 0.05, 0.0),
    diffuse = Vec4(0.4, 0.5, 0.4),
    specular = Vec4(0.04, 0.7, 0.04),
    metalness = 0.078125 * 128
  },
  RedRubber = {
    ambient = Vec4(0.05, 0.0, 0.0),
    diffuse = Vec4(0.5, 0.4, 0.4),
    specular = Vec4(0.7, 0.04, 0.04),
    metalness = 0.078125 * 128
  },
  WhiteRubber = {
    ambient = Vec4(0.05, 0.05, 0.05),
    diffuse = Vec4(0.5, 0.5, 0.5),
    specular = Vec4(0.7, 0.7, 0.7),
    metalness = 0.078125 * 128
  },
  YellowRubber = {
    ambient = Vec4(0.05, 0.05, 0.0),
    diffuse = Vec4(0.5, 0.5, 0.4),
    specular = Vec4(0.7, 0.7, 0.04),
    metalness = 0.078125 * 128
  }
}

local suzannes = {}
function Scene.generateSuzeanne(x, y, i)
  local suzanne = Suzanne({
    Transform = Scene.components.TransformComponent(
      Vec3(x, y, -3),
      Quat(),
      Vec3(0.25, 0.25, 0.25)
    ),
    Material = Scene.components.MaterialComponent(
      PhongMaterial, {
        specularStrength = 0.0,
        metallic = materials[materialNames[i]].metalness,
        ambientColor = materials[materialNames[i]].ambient,
        diffuseColor = materials[materialNames[i]].diffuse,
        specularColor = materials[materialNames[i]].specular,
      }
    )
  })
  return suzanne
end

local directionalLight = {
  Transform = Scene.components.TransformComponent(
    Vec3(0, 0, 0),
    Quat(1, -math.pi * 0.25, -math.pi * 0.25, 0)
  ),
  Light = Scene.components.LightComponent({
    color = Vec3(1, 1, 1),
    intensity = 0.08,
    type = 'directional',

  })
}

local materialLabelLocations = {}

function Scene.init()
  for _, system in pairs(Scene.systems) do
    Scene.world:add(system)
  end
  -- Scene.world:add(VrRig.new()) -- BORKED
  Scene.world:add(Grid())
  -- suzannes
  local rows = 4
  local cols = 6
  local x = -2.5
  local y = 1
  local i = 1
  for _ = 1, rows do
    for _ = 1, cols do
      x = x + 0.75
      table.insert(suzannes, Scene.generateSuzeanne(x, y, i))
      table.insert(materialLabelLocations, Vec3(x, y + 0.35, -3))
      i = i + 1
    end
    y = y + 0.75
    x = -2.5
  end

  Scene.world:add(table.unpack(suzannes))
  -- lighting
  Scene.world:add(directionalLight)
end

function Scene.update(dt)
  for i, suzanne in ipairs(suzannes) do
    Scene.systems.TransformSystem.setOrientation(
      suzanne.Transform,
      Quat(
        lovr.headset.getTime() + math.sin(i) * 0.25,
        1, 1, 0
      )
    )
  end
  Scene.world:update(dt)
end

function Scene.draw(pass)
  Scene.systems.PlayerMotionSystem.transform(pass)
  Scene.systems.RenderSystem.draw(pass)
  pass:setShader()
  for i, materialName in ipairs(materialNames) do
    pass:text(materialName, materialLabelLocations[i], 0.05)
  end
end

return Scene
