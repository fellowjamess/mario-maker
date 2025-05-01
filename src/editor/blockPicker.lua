local boxes = require("src.entities.boxes.boxes")

local blockPicker = {
    selectedBlock = nil,
    space = 45,
    barHeight = 80,
    isVisible = true
}

local BoxManager = boxes.new(0, 0)
blockPicker.blocks = BoxManager.blocks
blockPicker.sprites = {}
for _, block in ipairs(BoxManager.blocks) do
    blockPicker.sprites[block.id] = block.sprite
end
blockPicker.blockSize = 32

function blockPicker.draw()
    if not blockPicker.isVisible then
        return
    end

    -- Draw background
    love.graphics.setColor(0.2, 0.2, 0.2, 0.8)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), blockPicker.barHeight)

    -- Draw blocks
    love.graphics.setColor(1, 1, 1, 1)
    for i, block in ipairs(blockPicker.blocks) do
        local x = (i-1) * (blockPicker.blockSize + blockPicker.space) + blockPicker.space
        local y = 10

        if block.id == blockPicker.selectedBlock then
            love.graphics.setColor(1, 1, 0, 0.3)
            love.graphics.rectangle("fill", x-2, y-2, blockPicker.blockSize+4, blockPicker.blockSize+4)
        end

        love.graphics.setColor(1, 1, 1, 1)
        local sprite = blockPicker.sprites[block.id]
        if sprite then
            love.graphics.draw(sprite, x, y)
        end

        local font = love.graphics.getFont()
        local textWidth = font:getWidth(block.name)
        local textX = x + (blockPicker.blockSize - textWidth * 0.8) / 2
        love.graphics.print(block.name, textX, y + blockPicker.blockSize + 8, 0, 0.8, 0.8)
    end

    blockPicker.drawKeybinds()
end

function blockPicker.drawKeybinds()
    local keybindsFont = love.graphics.newFont("assets/fonts/main.ttf", 16)
    love.graphics.setFont(keybindsFont)

    local keybinds = {
        "G = Game",
        "E = Editor",
        "B = Block picker",
        "R = Reset player"
    }

    local startX = love.graphics.getWidth() - 400
    local startY = 10
    local spaceBetween = 20
    local numRows = 2

    love.graphics.setColor(1, 1, 1, 1)
    for i, keybindString in ipairs(keybinds) do
        local column = math.ceil(i / numRows)
        local row = i % numRows
        local x = startX + (column * 120)
        local y = startY + (row * spaceBetween)
        love.graphics.print(keybindString, x, y)
    end
end

function blockPicker.click(x, y)
    if not blockPicker.isVisible then
        return false
    end

    if y <= blockPicker.barHeight then
        for i, block in ipairs(blockPicker.blocks) do
            local blockX = (i-1) * (blockPicker.blockSize + blockPicker.space) + blockPicker.space
            local blockY = 10

            if x >= blockX and x <= blockX + blockPicker.blockSize and
               y >= blockY and y <= blockY + blockPicker.blockSize then
                blockPicker.selectedBlock = block.id
                return true
            end
        end
    end

    return false
end

function blockPicker.toggle()
    blockPicker.isVisible = not blockPicker.isVisible
end

return blockPicker