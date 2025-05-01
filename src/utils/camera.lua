local camera = {
    -- Camera's current position
    x = 0,
    y = 0,
    -- Where the camera wants to move to
    targetX = 0,
    targetY = 0,
    -- How quickly the camera moves to its target (here is 1 = instant and 0 = not moving)
    smoothness = 0.1
}

-- Makes the camera follow something (such as the player)
function camera.follow(target)
    -- Make sure we can actually follow the target
    if not target or not target.x or not target.y or not target.width or not target.height then
        return
    end

    -- Try to keep the target in the center of the screen
    camera.targetX = target.x - love.graphics.getWidth() / 2 + target.width / 2
    camera.targetY = target.y - love.graphics.getHeight() / 2 + target.height / 2

    -- Get how big the screen is
    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()

    -- Don't let camera show beyond the level boundaries
    local maxX = LEVEL_WIDTH - screenWidth
    local maxY = LEVEL_HEIGHT - screenHeight

    -- Keeps the camera within level boundaries
    local targetBoundedX = math.max(0, math.min(maxX, camera.targetX))
    local targetBoundedY = math.max(0, math.min(maxY, camera.targetY))

    -- Smoothly moves camera towards target
    -- Higher smoothness = faster camera movement
    camera.x = camera.x + (targetBoundedX - camera.x) * camera.smoothness
    camera.y = camera.y + (targetBoundedY - camera.y) * camera.smoothness
end

-- Move everything to create camera effect
function camera.apply()
    love.graphics.translate(-camera.x, -camera.y)
end

-- Move camera in editor when mouse is near screen edges
function camera.editorMovement(dt)
    local screenMouseX = love.mouse.getX()
    local screenMouseY = love.mouse.getY()
    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()

    -- Calculate boundaries so camera stays in level
    local maxX = LEVEL_WIDTH - screenWidth
    local maxY = LEVEL_HEIGHT - screenHeight
    local minX = 0
    local minY = 0

    -- Move camera when mouse is near edges
    -- Left/Right movement
    if screenMouseX < CAMERA_EDGE_THRESHOLD then
        camera.x = math.max(minX, camera.x - CAMERA_SPEED * dt)
    elseif screenMouseX > screenWidth - CAMERA_EDGE_THRESHOLD then
        camera.x = math.min(maxX, camera.x + CAMERA_SPEED * dt)
    end

    -- Up/Down movement
    if screenMouseY < CAMERA_EDGE_THRESHOLD then
        camera.y = math.max(minY, camera.y - CAMERA_SPEED * dt)
    elseif screenMouseY > screenHeight - CAMERA_EDGE_THRESHOLD then
        camera.y = math.min(maxY, camera.y + CAMERA_SPEED * dt)
    end

    -- Make sure camera stays within level boundaries
    camera.x = math.max(minX, math.min(maxX, camera.x))
    camera.y = math.max(minY, math.min(maxY, camera.y))
end

function camera.reset()
    camera.x = 0
    camera.y = 0
    camera.targetX = 0
    camera.targetY = 0
end

return camera