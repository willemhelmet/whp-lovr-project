-- config/settings.lua

local Settings = {}

Settings.thumbStickDeadzone = 0.4
Settings.turnStyle = "smooth" -- options are "smooth" or "snap"
Settings.snapTurnAngle = math.pi * (1 / 4)
Settings.smoothTurnSpeed = 2 * math.pi * (1 / 2)
Settings.snapTurnThreshold = 0.75
Settings.forwardDirectionFrom = 'head' -- options are 'head', 'left', or 'right'

return Settings
