-- src/systems/lighting-system.lua

local lovr = require 'lovr'
local Vec4 = lovr.math.newVec4
local tiny = require 'lib.tiny'
local pretty = require 'lib.pl.pretty'
local LightingSystem = tiny.processingSystem()
LightingSystem.filter = tiny.requireAll('Transform', 'Light')

local MAX_LIGHTS = 16

LightingSystem.lightsData = {}
LightingSystem.activeLightCount = 0
LightingSystem.lightBuffer = nil

-- TODO: Create the LOVR Buffer in an init function or on preprocess
function LightingSystem:onAddToWorld(world)
end

function LightingSystem:process(e, dt)
  local transform = e.Transform
  local light = e.Light

  -- Store the light data for buffer update
  table.insert(self.lightsData, {
    position = transform.position,
    color = light.color,
    intensity = light.intensity,
    constant = light.constant,
    linear = light.linear,
    quadratic = light.quadratic
  })
end

function LightingSystem:postProcess(dt)
  self.activeLightCount = #self.lightsData
  -- AI: Iterate through self.lightsData and write to the mapped buffer `data`.
  --    Remember alignment! position needs x,y,z,0. color needs r,g,b,intensity. attenuation needs c,l,q,0.

  local positions = {}
  local colors = {}
  local attenuations = {}
  for i = 1, MAX_LIGHTS do
    if i <= self.activeLightCount then
      local light = self.lightsData[i]
      table.insert(positions, Vec4(light.position.x, light.position.y, light.position.z, 1.0)) -- Using w=1 to mark active light
      table.insert(colors, Vec4(light.color.x, light.color.y, light.color.z, light.intensity))
      table.insert(attenuations, Vec4(light.constant, light.linear, light.quadratic, 0.0))     -- leftover variable, can use for something else
    else
      -- Inactive light placeholder
      table.insert(positions, Vec4(0, 0, 0, 0)) -- Using w=0 to mark inactive light
      table.insert(colors, Vec4(0, 0, 0, 0))
      table.insert(attenuations, Vec4(1, 0, 0, 0))
    end
  end

  if not self.lightBuffer then
    self.lightBuffer = lovr.graphics.newBuffer(
      {
        { 'position',    'vec4', MAX_LIGHTS }, -- x, y, z, 0 (active/inactive)
        { 'color',       'vec4', MAX_LIGHTS }, -- r, g, b, intensity
        { 'attenuation', 'vec4', MAX_LIGHTS }, -- constant, linear, quadratic, 0
      },
      {
        position = positions,
        color = colors,
        attenuation = attenuations
      })
  else
    -- Update the buffer with new data
    local data = self.lightBuffer:setData({
      position = positions,
      color = colors,
      attenuation = attenuations
    })
  end

  -- Clear collected data for the next frame
  self.lightsData = {}
end

-- Getters for RenderSystem
function LightingSystem.getLightBuffer()
  return LightingSystem.lightBuffer
end

function LightingSystem.getLightCount()
  return LightingSystem.activeLightCount
end

-- Debug function to log light data
function LightingSystem.debugLights()
  lovr.log(pretty.write(LightingSystem.lightBuffer:getData()))
end

return LightingSystem
