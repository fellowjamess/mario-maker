local box = require("src.entities.boxes.box")

local spikes = {}
spikes.__index = spikes
setmetatable(spikes, box)

function spikes.new(x, y, width, height)
    local self = setmetatable(box.new(x, y, width, height), spikes)
    self.type = "hazard"
    return self
end

function spikes:isLethal()
    return true
end

return spikes