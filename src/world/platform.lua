local platform = {}

-- Small platform at the grid height near the start
function platform.createStartPlatform(boxManager)
    local startX = 0
    local startY = 10 * 32
    local width = 5 -- Number of boxes in the platform
    local platformY = startY - 32

    -- places the boxes as specified in the width
    for i = 0, width - 1 do
        local box = boxManager:addBox(startX + (i * 32), platformY, "grass")
        if box then
            box.isStartPlatform = true
        end
    end
end

return platform