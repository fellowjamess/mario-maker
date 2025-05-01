local collision = {}

function collision.checkIfInside(a, b)
    return a.x < b.x + b.width and
           a.x + a.width > b.x and
           a.y < b.y + b.height and
           a.y + a.height > b.y
end

-- Moves the player out
function collision.fixCollision(player, boxes)
    player.isOnGround = false
    local px, py = player.x, player.y

    for _, box in ipairs(boxes) do
        if collision.checkIfInside(player, box) then
            -- Findes and calculates the overlap on all sides
            local dx = (player.x + player.width / 2) - (box.x + box.width / 2)
            local dy = (player.y + player.height / 2) - (box.y + box.height / 2)
            local overlapX = (player.width + box.width) / 2 - math.abs(dx)
            local overlapY = (player.height + box.height) / 2 - math.abs(dy)

            if overlapX < overlapY then
                if dx > 0 then
                    player.x = player.x + overlapX
                else
                    player.x = player.x - overlapX
                end
                player.vx = 0
            else
                if dy > 0 then
                    player.y = player.y + overlapY
                    player.vy = 0
                    player.isJumping = false
                else
                    player.y = player.y - overlapY
                    player.vy = 0
                    player.isOnGround = true
                end
            end

            -- Check for hazard
            if collision.checkHazardCollision(box) then
                player.isHazard = true
            end
        end
    end
end

--checks collision between mouse and player
function collision.checkEntityCollision(entity1, entity2)
    return entity1.x + entity1.width > entity2.x and
           entity1.x < entity2.x + entity2.width and
           entity1.y + entity1.height > entity2.y and
           entity1.y < entity2.y + entity2.height
end

-- This function checks if box is a hazard type
function collision.checkHazardCollision(box)
    return box.type == "hazard"
end

return collision