-- src/components/table.lua

local lovr = require 'lovr'
local Table = {}

local TransformComponent = require 'src.components.transform-component'
local MaterialComponent = require 'src.components.material-component'
local PhysicsComponent = require 'src.components.physics-component'

local UnlitColorMaterial = require 'assets.materials.unlit-color-material'

local Box = require 'src.entities.box'

function Table.new(position)
  return {
    Box({
      Transform = TransformComponent(
        Vec3(position[1], position[2] + 1, position[3]),
        Quat(1, 0, 0, 0),
        Vec3(2, 0.1, 1)),
      Physics = PhysicsComponent({
        isKinematic = true,
        shapes = {
          {
            type = 'box',
            width = 2,
            height = 0.1,
            depth = 1
          }
        }
      }),
      Material = MaterialComponent(UnlitColorMaterial, { color = { 0.1, 0.1, 0.1 } })
    }),
    Box({
      Transform = TransformComponent(
        Vec3(position[1] - 0.95, position[2] + 0.475, position[3] + 0.45),
        Quat(1, 0, 0, 0),
        Vec3(0.1, 0.95, 0.1)
      ),
      Physics = PhysicsComponent({
        isKinematic = true,
        shapes = {
          {
            type = 'box',
            width = 0.1,
            height = 0.95,
            depth = 0.1
          }
        }
      }),
      Material = MaterialComponent(UnlitColorMaterial, { color = { 0.1, 0.1, 0.1 } })
    }),
    Box({
      Transform = TransformComponent(
        Vec3(position[1] + 0.95, position[2] + 0.475, position[3] + 0.45),
        Quat(1, 0, 0, 0),
        Vec3(0.1, 0.95, 0.1)
      ),
      Physics = PhysicsComponent({
        isKinematic = true,
        shapes = {
          {
            type = 'box',
            width = 0.1,
            height = 0.95,
            depth = 0.1
          }
        }
      }),
      Material = MaterialComponent(UnlitColorMaterial, { color = { 0.1, 0.1, 0.1 } })
    }),
    Box({
      Transform = TransformComponent(
        Vec3(position[1] - 0.95, position[2] + 0.475, position[3] - 0.45),
        Quat(1, 0, 0, 0),
        Vec3(0.1, 0.95, 0.1)
      ),
      Physics = PhysicsComponent({
        isKinematic = true,
        shapes = {
          {
            type = 'box',
            width = 0.1,
            height = 0.95,
            depth = 0.1
          }
        }
      }),
      Material = MaterialComponent(UnlitColorMaterial, { color = { 0.1, 0.1, 0.1 } })
    }),
    Box({
      Transform = TransformComponent(
        Vec3(position[1] + 0.95, position[2] + 0.475, position[3] - 0.45),
        Quat(1, 0, 0, 0),
        Vec3(0.1, 0.95, 0.1)
      ),
      Physics = PhysicsComponent({
        isKinematic = true,
        shapes = {
          {
            type = 'box',
            width = 0.1,
            height = 0.95,
            depth = 0.1

          }
        }
      }),
      Material = MaterialComponent(UnlitColorMaterial, { color = { 0.1, 0.1, 0.1 } })
    })
  }
end

return Table
