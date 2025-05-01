local physics = require("src.utils.physics")
local collision = require("src.utils.collision")
local sound = require("src.utils.sound")

local player = {
    x = 0,
    y = 0,
    speed = 400,
    width = 32,
    height = 64,
    vx = 0,
    vy = 0,
    acceleration = 2000,
    deceleration = 1600,
    facingRight = true,
    boxManager = nil,
    jumpForce = -425,
    maxJumpForce = -450,
    jumpChargeRate = -225,
    isOnGround = false,
    groundHeight = 352,
    coyoteTime = 0.1,
    coyoteTimer = 0,
    jumpBufferTime = 0.1,
    jumpBufferTimer = 0, 
    maxJumpDuration = 0.16,
    jumpTimer = 0,
    isJumping = false,
    sprite = love.graphics.newImage("assets/sprites/player/player_standing.png")
}

-- New player
function player.new(x, y, boxManager)
    player.x = x
    player.y = y
    player.boxManager = boxManager

    return player
end

-- Jump function
function player.jump()
    -- You can only jump if on ground or within coyote time
    if player.isOnGround or player.coyoteTimer > 0 then
        sound.playSound("jump", 0.5, false)

        player.isJumping = true
        player.jumpTimer = 0
        player.vy = player.jumpForce
        player.isOnGround = false
        player.coyoteTimer = 0
        player.jumpBufferTimer = 0
    end
end

-- Buffer jump function
function player.bufferJump()
    player.jumpBufferTimer = player.jumpBufferTime
end

-- End jump function
function player.endJump()
    player.isJumping = false
end

-- Reset position function
function player.resetPosition(x, y)
    player.x = x
    player.y = y
    player.vx = 0
    player.vy = 0
    player.isJumping = false
    player.jumpTimer = 0
    player.coyoteTimer = 0
    player.jumpBufferTimer = 0
    player.isOnGround = false
end

-- Update function
function player.update(dt)
	--Use gravity when in air
	if not player.isOnGround then
		player.vy = physics.applyGravity(player.vy, dt)
	end

	-- Move the player with current velocity
	player.x = player.x + player.vx * dt
	player.y = player.y + player.vy * dt

	player.x = player.boundaries(player.x)

    -- Reset if fallen off level
    if player.y > LEVEL_HEIGHT then
        sound.playSound("death", nil, false)
        player.resetPosition(START_x, START_y)
        return
    end

    player.collisions()

    -- Update jump timers
    player.updateJumpTimers(dt)

    -- Movement
    player.horizontalMovement(dt)

    -- Jumping
    player.jumping(dt)
end

function player.collisions()
    local currentEntity = {
        x = player.x,
        y = player.y,
        width = player.width,
        height = player.height,
        vx = player.vx,
        vy = player.vy,
        isOnGround = false,
        isHazard = false
    }

    collision.fixCollision(currentEntity, player.boxManager.boxes)

	-- Update the player
    player.x = currentEntity.x
    player.y = currentEntity.y
    player.vx = currentEntity.vx
    player.vy = currentEntity.vy
    player.isOnGround = currentEntity.isOnGround

    if currentEntity.isHazard then
        sound.playSound("death", nil, false)
        player.resetPosition(START_x, START_y)
    end
end


function player.boundaries(nextX)
    if nextX < 0 then
        nextX = 0
        player.vx = 0
    elseif nextX > LEVEL_WIDTH - player.width then
        nextX = LEVEL_WIDTH - player.width
        player.vx = 0
    end
    return nextX
end

function player.horizontalMovement(dt)
    if love.keyboard.isDown("d") then
        -- Move right
        player.vx = player.vx + player.acceleration * dt
        player.vx = math.min(player.vx, player.speed)
        player.facingRight = true
    elseif love.keyboard.isDown("a") then
        -- Move left
        player.vx = player.vx - player.acceleration * dt
        player.vx = math.max(player.vx, -player.speed)
        player.facingRight = false
    else
        -- Player slow down when no keypressed
        if player.vx > 0 then
            player.vx = math.max(0, player.vx - player.deceleration * dt)
        elseif player.vx < 0 then
            player.vx = math.min(0, player.vx + player.deceleration * dt)
        end
    end
end

function player.updateJumpTimers(dt)
    if player.isOnGround then
        player.coyoteTimer = player.coyoteTime
    else
        player.coyoteTimer = player.coyoteTimer - dt
    end

    if player.jumpBufferTimer > 0 then
        player.jumpBufferTimer = player.jumpBufferTimer - dt
    end

    if player.jumpBufferTimer > 0 and (player.isOnGround or player.coyoteTimer > 0) then
        player.jump()
    end
end

function player.jumping(dt)
    if player.isJumping then
        player.jumpTimer = player.jumpTimer + dt
        player.vy = player.jumpForce + player.jumpChargeRate * player.jumpTimer
        player.vy = math.max(player.vy, player.maxJumpForce)

        if player.jumpTimer >= player.maxJumpDuration then
            player.endJump()
        end
    end
end

function player.draw()
    -- Draws the player sprite
    local offsetX = player.width
    local scaleX = -1

    if player.facingRight then
        offsetX = 0
        scaleX = 1
    end

    love.graphics.draw(player.sprite, player.x + offsetX, player.y, 0, scaleX, 1)
end

return player