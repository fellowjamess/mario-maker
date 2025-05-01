local camera = require("src.utils.camera")

local clouds = {
    cloudTable = {},
    numberOfClouds = 15,

    moveSpeed = 0.01,
    minWidth = 100,
    maxWidth = 200,
    maxHeight = 90,
    minHeight = 40,

    lastCameraX = 0
}
function clouds.load()
    local maxCloudHeight = LEVEL_HEIGHT * 0.25
    clouds.lastCameraX = camera.x

    for i = 1, clouds.numberOfClouds do
        table.insert(clouds.cloudTable, {
            x = love.math.random(0, LEVEL_WIDTH),
            y = love.math.random(0, maxCloudHeight),
            width = love.math.random(clouds.minWidth, clouds.maxWidth),
            height = love.math.random(clouds.minHeight, clouds.maxHeight)
        })
    end
end

function clouds.update()
    local maxCloudHeight = LEVEL_HEIGHT * 0.25

    local cameraDeltaX = camera.x - clouds.lastCameraX

    for _, cloud in ipairs(clouds.cloudTable) do
        cloud.x = cloud.x - cameraDeltaX * clouds.moveSpeed

        if cloud.x + cloud.width < 0 then
            cloud.x = LEVEL_WIDTH
            cloud.y = love.math.random(0, maxCloudHeight)
        elseif cloud.x > LEVEL_WIDTH then
            cloud.x = -cloud.width
            cloud.y = love.math.random(0, maxCloudHeight)
        end
    end

    clouds.lastCameraX = camera.x
end

function clouds.draw()
    love.graphics.setColor(1, 1, 1)

    for _, cloud in ipairs(clouds.cloudTable) do
        love.graphics.setColor(1, 1, 1)

        love.graphics.ellipse(
            'fill',
            cloud.x + cloud.width/2,
            cloud.y + cloud.height/2,
            cloud.width/2,
            cloud.height/2
        )
    end

    love.graphics.setColor(1, 1, 1, 1)
end

return clouds