-- config/settings.lua

local Settings = {}

Settings.deadzone = 0.4
Settings.turnStyle = "snap" -- options are "smooth" or "snap"
Settings.snapTurnAngle = math.pi * (1 / 4)
Settings.smoothTurnSpeed = 2 * math.pi * (1 / 2)
Settings.snapTurnThreshold = 0.75

return Settings
