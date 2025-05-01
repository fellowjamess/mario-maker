local gird = {}

function gird.draw(cellSize, width, height)
    love.graphics.setColor(1, 1, 1, 0.5)  -- Light gray color for the grid lines

    -- This draws the vertical and horizontal lines of the grid,
    -- the grid is drawn from the top left corner of the screen
    for i = 0, width do
        love.graphics.line(i * cellSize, 0, i * cellSize, height * cellSize)
    end

    -- This draws the horizontal lines of the grid,
    -- the grid is drawn from the top left corner of the screen
    for j = 0, height do
        love.graphics.line(0, j * cellSize, width * cellSize, j * cellSize)
    end

    love.graphics.setColor(1, 1, 1, 1)
end

return gird