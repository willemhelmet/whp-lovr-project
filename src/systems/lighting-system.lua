-- src/systems/lighting-system.lua

local lovr = require 'lovr'
local tiny = require 'lib.tiny'
local pretty = require 'lib.pl.pretty'
local LightingSystem = tiny.processingSystem()
LightingSystem.filter = tiny.requireAll('Transform', 'Light')

local MAX_LIGHTS = 16

LightingSystem.lightsData = {}
LightingSystem.activeLightCount = 0
LightingSystem.lightBuffer = nil

-- TODO: Create the LOVR Buffer in an init function or on first process
function LightingSystem:onAddToWorld(world)
end

function LightingSystem:process(e, dt)
  local transform = e.Transform
  local light = e.Light

  if #LightingSystem.lightsData < MAX_LIGHTS then
    table.insert(LightingSystem.lightsData, {
      -- WHP: Pack data carefully for buffer layout (Vec3 often aligns as Vec4)
      -- We'll refine this packing when creating the buffer.
      -- For now, just gather the raw data. -AI
      position = transform.position,
      color = light.color,
      intensity = light.intensity,
      constant = light.constant,
      linear = light.linear,
      quadratic = light.quadratic
    })
  else
    lovr.log('LightingSystem: Maximum number of lights (%d) exceeded. Ignoring additional lights.', 'warning')
  end
end

function LightingSystem:postProcess(dt)
  LightingSystem.activeLightCount = #LightingSystem.lightsData
  -- TODO: from AI
  -- 1. Check if self.lightBuffer exists, create if not.
  --    local format = {
  --      {'lights', {'lightData', MAX_LIGHTS, { -- Array name, count, struct members
  --        {'position', 'vec4'}, -- Use vec4 for alignment
  --        {'color', 'vec4'},    -- Use vec4 for alignment (rgb + intensity?)
  --        {'attenuation', 'vec4'} -- constant, linear, quadratic, (unused)
  --      }}}
  --    }
  --    self.lightBuffer = lovr.graphics.newBuffer(format)
  -- 2. Map the buffer: local data = self.lightBuffer:map()
  -- 3. Iterate through self.lightsData and write to the mapped buffer `data`.
  --    Remember alignment! position needs x,y,z,0. color needs r,g,b,intensity. attenuation needs c,l,q,0.
  --    data.lights[i].position = {l.position.x, l.position.y, l.position.z, 0}
  --    data.lights[i].color = {l.color.x, l.color.y, l.color.z, l.intensity}
  --    data.lights[i].attenuation = {l.constant, l.linear, l.quadratic, 0}
  -- 4. Unmap the buffer: self.lightBuffer:unmap()

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

return LightingSystem
