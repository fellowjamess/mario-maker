local camera = require("src.utils.camera")

local mouse = {
    x = 0,
    y = 0,
    width = 5,
    height = 5,
    cursor = love.mouse.newCursor("assets/images/cursor/cursor.png", 0, 0),
    grabbing = love.mouse.newCursor("assets/images/cursor/grabbing.png", 0, 0),
}

function mouse.load()
    love.mouse.setCursor(mouse.cursor)
end

function mouse.update()
    mouse.x = love.mouse.getX() + camera.x + 4
    mouse.y = love.mouse.getY() + camera.y - 4

    if love.mouse.isDown(1) then
        love.mouse.setCursor(mouse.grabbing)
    else
        love.mouse.setCursor(mouse.cursor)
    end
end

function mouse.draw()

end

return mouse