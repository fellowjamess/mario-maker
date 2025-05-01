local camera = require("src.utils.camera")
local clouds = require("src.world.clouds")

local game = {
    player = nil,
    boxManager = nil
}

function game.load(sharedPlayer, sharedBoxManager)
    game.player = sharedPlayer
    game.boxManager = sharedBoxManager
    clouds.load()
end

function game.update(dt)
    love.mouse.setVisible(false)
    game.player.update(dt)
    clouds.update()
    camera.follow(game.player)
end

function game.draw()
    love.graphics.push()
    camera.apply()
    
    clouds.draw()
    game.boxManager:draw()
    game.player.draw()

    love.graphics.pop()
end

function game.keypressed(key)
    if key == "escape" then
        State = "menu"
        return
    end

    if key == "space" then
        game.player.bufferJump()
    end

    if key == "e" then
        State = "editor"
    end
end

function game.keyreleased(key)
    if key == "space" then
        game.player.endJump()
    end
end

return game