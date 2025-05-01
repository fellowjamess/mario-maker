local physics = {
    gravity = 1250
}

function physics.applyGravity(vy, dt)
    return vy + physics.gravity * dt
end

--[[
function physics.updatePosition(x, y, vx, vy, dt)
    x = x + vx * dt
    y = y + vy * dt
    return x, y-
end
--]]

return physics