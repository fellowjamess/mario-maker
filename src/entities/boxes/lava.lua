local box = require("src.entities.boxes.box")

local lava = {}
lava.__index = lava

setmetatable(lava, { __index = box })

function lava.new(x, y, width, height)
    local self = setmetatable(box.new(x, y, width, height), lava)
    self.type = "hazard"
    return self
end

function lava:isLethal()
	return true
end

return lava