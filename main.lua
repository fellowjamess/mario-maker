-- Soper Mariu Makor
-- By Andreas and Søren-Emil

TITLE = "Soper Mariu Makor"
State = "menu"

CELL_SIZE = 32
GRID_WIDTH = 100
GRID_HEIGHT = 25
LEVEL_WIDTH = GRID_WIDTH * CELL_SIZE
LEVEL_HEIGHT = GRID_HEIGHT * CELL_SIZE
CAMERA_EDGE_THRESHOLD = 50
CAMERA_SPEED = 500
START_x = 0
START_y = 7*CELL_SIZE

local game = require("src.states.game")
local menu = require("src.states.menu")
local editor = require("src.editor.editor")
local player = require("src.entities.player")
local boxes = require("src.entities.boxes.boxes")
local sound = require("src.utils.sound")

function love.load()
    -- Love configurations
    love.window.setTitle(TITLE)
    love.window.setVSync(1)
    -- IsFullscreen = false
    -- love.window.setFullscreen(IsFullscreen)

    local sharedBoxManager = boxes.new(0, 0, CELL_SIZE, CELL_SIZE)
    local sharedPlayer = player.new(0, 7*32, sharedBoxManager)

    menu.load()
    game.load(sharedPlayer, sharedBoxManager)
    editor.load(sharedPlayer, sharedBoxManager)

    local r, g, b = love.math.colorFromBytes(132, 193, 238) -- Light blue color
    love.graphics.setBackgroundColor(r, g, b)

    -- Load font and set the main font
    MainFont = love.graphics.newFont("assets/fonts/main.ttf", 16)
    love.graphics.setFont(MainFont)
end

function love.update(dt)
    if string.lower(State) == "menu" then
        menu.update(dt)
    elseif string.lower(State) == "game" then
        game.update(dt)
    elseif string.lower(State) == "editor" then
        editor.update(dt)
    end
end

function love.draw()
    if string.lower(State) == "menu" then
        menu.draw()
    elseif string.lower(State) == "game" then
        game.draw()
    elseif string.lower(State) == "editor" then
        editor.draw()
    end
end

function love.keypressed(key)
    if key == "escape" then
        State = "menu"
        return
    end
    --[[
    elseif key == "m" then
        if sound.sounds.muted == false then
            sound.sounds.muted = true
        else
            sound.sounds.muted = false
        end
    end 
    --]]

    if string.lower(State) == "menu" then
        --menu.keypressed(key)
    elseif string.lower(State) == "game" then
        game.keypressed(key)
    elseif string.lower(State) == "editor" then
        editor.keypressed(key)
    end
end

function love.keyreleased(key)
    if string.lower(State) == "game" then
        game.keyreleased(key)
    end
end

function love.mousepressed(x, y, button)
    if string.lower(State) == "menu" then
        menu.mousepressed(x, y, button)
    elseif string.lower(State) == "editor" then
        editor.mousepressed(x, y, button)
    end
end

function love.mousereleased( x, y, button)
    --if string.lower(State) == "game" then
        --game.mousereleased(x, y, button)
    --end
    if string.lower(State) == "editor" then
        editor.mousereleased(x, y, button)
    end
end