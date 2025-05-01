local box = {}
box.__index = box

box.blocks = {
    { id = "dirt", name = "Dirt", sprite = love.graphics.newImage("assets/sprites/boxes/dirt.png") },
    { id = "grass", name = "Grass", sprite = love.graphics.newImage("assets/sprites/boxes/grass.png") },
    { id = "lava", name = "Lava", sprite = love.graphics.newImage("assets/sprites/boxes/lava.png") },
	{ id = "spikes", name = "Spikes", sprite = love.graphics.newImage("assets/sprites/boxes/spikes.png") }
}

-- This function creates a new box instance
function box.new(x, y, width, height, boxType)
    local self = setmetatable({}, box)
    
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.type = boxType or "normal" 
	
	self.boxes = {}

    return self
end

-- This function adds a new box to the list of boxes
-- It takes the x, y coordinates and the sprite type for the box
function box:addBox(x, y, spriteType)
    -- Make boxes to the coordinates of the grid (32x32 pixels)
    local gridX = math.floor(x / 32) * 32
    local gridY = math.floor(y / 32) * 32
	
	local newBox = box.new(gridX, gridY, 32, 32)
	
	newBox.spriteType = spriteType or "dirt"

    -- If the sprite is "lava" or "spikes", make the type of the box "hazard"
	if spriteType == "lava" or spriteType == "spikes" then
		newBox.type = "hazard"
	else
		newBox.type = "normal"
	end
	

    table.insert(self.boxes, newBox)

    return newBox
end

-- This function removes a box from the boxes table based on its position (x, y)
-- It checks if the box exists at the specified coordinates and removes it if it's not part of the start platform
function box:removeBox(x, y)
    for i, box in ipairs(self.boxes) do
        if box.x == x and box.y == y then
            if not box.isStartPlatform then
                table.remove(self.boxes, i)
            end
            break
        end
    end
end

-- This function is used to draw all the boxes in the boxes table
-- It loops through the boxes table and draws each box using its corresponding sprite
-- The sprite is determined based on the box's spriteType
function box:draw()
    for _, box in ipairs(self.boxes) do
        for _, block in ipairs(box.blocks) do
            if block.id == box.spriteType then
                love.graphics.draw(block.sprite, box.x, box.y)
            end
        end
    end
end


return box