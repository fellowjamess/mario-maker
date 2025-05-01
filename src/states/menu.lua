local sound = require("src.utils.sound")

local menu = {
    -- Title starts off-screen (negative x position)
    titlePosition = -400,
    -- How fast the title moves
    timeSpeed = 500,
    -- Special font for the title
    font = love.graphics.setNewFont("assets/fonts/menu.ttf", 48),

    titlePixelLength = 0,
    studioImage = love.graphics.newImage("assets/images/studio/zox.png"),

    buttons = {
        {
            text = "Play",
            x = 400,
            y = 300,
            width = 225,
            height = 50
        },
        {
            text = "Quit",
            x = 400,
            y = 370,
            width = 200,
            height = 50
        }
    }
}

function menu.load()
    menu.titlePixelLength = menu.font:getWidth(TITLE)

    -- Start playing menu music on loop at 70% volume
    sound.playSound("menuMusic", 0.7, true)
end

function menu.update(dt)
    love.mouse.setVisible(true)

    -- Slide the title in from left until it reaches center
    if menu.titlePosition < love.graphics.getWidth()/2 then
        menu.titlePosition = menu.titlePosition + menu.timeSpeed * dt
    else
        menu.titlePosition = love.graphics.getWidth()/2
    end
end

function menu.drawButton(button)
    -- Check if mouse is over this button
    local mx, my = love.mouse.getPosition()
    local hover = mx > button.x - button.width/2 and
                 mx < button.x + button.width/2 and
                 my > button.y - button.height/2 and
                 my < button.y + button.height/2

    -- Makes button darker when mouse hovers over it
    if hover then
        love.graphics.setColor(0.2, 0.2, 0.2, 0.9)
    else
        love.graphics.setColor(0.2, 0.2, 0.2, 0.7)
    end

    love.graphics.rectangle(
        "fill",
        button.x - button.width/2,
        button.y - button.height/2,
        button.width,
        button.height
    )

    -- Reset color and draw button text
    love.graphics.setColor(1, 1, 1, 1)
    local mainFont = love.graphics.newFont("assets/fonts/main.ttf", 32)
    love.graphics.setFont(mainFont)

    -- Center the text in the button
    local textW = mainFont:getWidth(button.text)
    local textH = mainFont:getHeight()
    love.graphics.print(button.text, button.x - textW/2, button.y - textH/2)
end

function menu.draw()
    love.graphics.draw(menu.studioImage, 10, 350, 0, 0.5, 0.5)
    love.graphics.print("By Zox Studio", 10, 310, 0, 0.8, 0.8)

    love.graphics.setFont(menu.font)
    love.graphics.print(TITLE, menu.titlePosition - menu.titlePixelLength/2, love.graphics.getHeight()/10)

    -- Draws all buttons
    for _, button in ipairs(menu.buttons) do
        menu.drawButton(button)
    end
end

-- Chekcs if the mouse click was within a button, and
-- does the action, such as changing the state of the game
function menu.mousepressed(x, y, button)
    if button == 1 then -- Left click
        for _, btn in ipairs(menu.buttons) do
            if x > btn.x - btn.width/2 and
               x < btn.x + btn.width/2 and
               y > btn.y - btn.height/2 and
               y < btn.y + btn.height/2 then
                if btn.text == "Play" then
                    sound.stopSound("menuMusic")
                    State = "editor"
                elseif btn.text == "Quit" then
                    love.event.quit()
                end
                return
            end
        end
    end
end

return menu