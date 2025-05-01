local grid = require("src.editor.grid")
local camera = require("src.utils.camera")
local collision = require("src.utils.collision")
local mouse = require("src.utils.mouse")
local blockPicker = require("src.editor.blockPicker")
local platform = require("src.world.platform")

local editor = {
    player = nil,
    boxManager = nil,
    blockPicker = nil,
}

function editor.load(sharedPlayer, sharedBoxManager)
    editor.player = sharedPlayer
    editor.boxManager = sharedBoxManager
    editor.lastMouseX = mouse.x
    editor.lastMouseY = mouse.y

    mouse.load()

    camera.reset()

    platform.createStartPlatform(editor.boxManager)
end

function editor.update(dt)
    love.mouse.setVisible(true)
    mouse.update()

    camera.editorMovement(dt)

    editor.boxPlacement()
    editor.boxDeletion()
    editor.playerDragging()
end

function editor.draw()
    love.graphics.push()
    camera.apply()

    grid.draw(CELL_SIZE, GRID_WIDTH, GRID_HEIGHT)

    editor.boxManager:draw()
    editor.player.draw()

    editor.drawCameraIndicators()

    love.graphics.pop()

    blockPicker.draw()

    mouse.draw()
end

-- Key pressed function
function editor.keypressed(key)
    if key == "g" then
        State = "game"
    elseif key == "b" then
        blockPicker:toggle()
    elseif key == "r" then
        editor.player.resetPosition(START_x, START_y)
        --editor.boxManager:resetBoxes()
    end
end

function editor.mousepressed(x, y, button)
    if button == 1 then -- Left click
        if y <= blockPicker.barHeight then
            if blockPicker.click(x, y) then
                return
            end
        end

        if collision.checkEntityCollision(editor.player, mouse) then
            editor.isDragging = true
            return
        end
    end
end

function editor.mousereleased(x, y, button)
    if button == 1 then -- Left click released
        editor.isDragging = false
    end
end

function editor.boxDeletion()
    -- Only delete boxes on right click
    if love.mouse.isDown(2) then
        -- Screen coordinates to world coordinates
        local worldMouseX = love.mouse.getX() + camera.x
        local worldMouseY = love.mouse.getY() + camera.y

        local gridX = math.floor(worldMouseX / CELL_SIZE) * CELL_SIZE
        local gridY = math.floor(worldMouseY / CELL_SIZE) * CELL_SIZE

        editor.boxManager:removeBox(gridX, gridY)
    end
end

function editor.boxPlacement()
    if love.mouse.isDown(1) and not editor.isDragging and blockPicker.selectedBlock then
        -- Don't place blocks when clicking on block picker
        if blockPicker.isVisible and love.mouse.getY() <= blockPicker.barHeight then
            return
        end

        -- Convert screen coordinates to world coordinates
        local worldMouseX = love.mouse.getX() + camera.x
        local worldMouseY = love.mouse.getY() + camera.y

        editor.placeBox(worldMouseX, worldMouseY)
    end
end

function editor.drawCameraIndicators()
    love.graphics.setColor(1, 1, 1, 0.2)

    if love.mouse.getX() < CAMERA_EDGE_THRESHOLD then
        love.graphics.rectangle("fill", camera.x, camera.y, CAMERA_EDGE_THRESHOLD, love.graphics.getHeight())
    end
    if love.mouse.getX() > love.graphics.getWidth() - CAMERA_EDGE_THRESHOLD then
        love.graphics.rectangle("fill", camera.x + love.graphics.getWidth() - CAMERA_EDGE_THRESHOLD, camera.y, CAMERA_EDGE_THRESHOLD, love.graphics.getHeight())
    end
    if love.mouse.getY() < CAMERA_EDGE_THRESHOLD then
        love.graphics.rectangle("fill", camera.x, camera.y, love.graphics.getWidth(), CAMERA_EDGE_THRESHOLD)
    end
    if love.mouse.getY() > love.graphics.getHeight() - CAMERA_EDGE_THRESHOLD then
        love.graphics.rectangle("fill", camera.x, camera.y + love.graphics.getHeight() - CAMERA_EDGE_THRESHOLD, love.graphics.getWidth(), CAMERA_EDGE_THRESHOLD)
    end

    love.graphics.setColor(1, 1, 1, 1)
end

function editor.placeBox(worldMouseX, worldMouseY)
    local boxes = editor.boxManager.boxes
    local found = false

    for i = 1, #boxes do
        if worldMouseX > boxes[i].x and worldMouseX < boxes[i].x + editor.boxManager.width then
            if worldMouseY > boxes[i].y and worldMouseY < boxes[i].y + editor.boxManager.width then
                found = true
                break
            end
        end
    end

    if not found then
        editor.boxManager:addBox(worldMouseX, worldMouseY, blockPicker.selectedBlock)
    end
end

function editor.playerDragging()
    if editor.isDragging then
        if mouse.x ~= editor.lastMouseX or mouse.y ~= editor.lastMouseY then
            local gridX = math.floor(mouse.x / CELL_SIZE) * CELL_SIZE
            local gridY = math.floor(mouse.y / CELL_SIZE) * CELL_SIZE

            gridX = math.max(0, math.min(GRID_WIDTH * CELL_SIZE - editor.player.width, gridX))
            gridY = math.max(0, math.min(GRID_HEIGHT * CELL_SIZE - editor.player.height, gridY))

            editor.player.x = gridX
            editor.player.y = gridY

            editor.lastMouseX = mouse.x
            editor.lastMouseY = mouse.y
        end
    else
        editor.lastMouseX = mouse.x
        editor.lastMouseY = mouse.y
    end
end

return editor