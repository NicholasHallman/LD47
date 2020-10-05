function check_hit(enemy, player)
    local sword_x1 = (player.x + player.sword_offset)
    local sword_y1 = player.y
    local sword_x2 = sword_x1 + player.sword_length
    local sword_y2 = sword_y1 + 16
    local sword_p1 = {
        x = sword_x1,
        y = sword_y1
    }
    local sword_p2 = {
        x = sword_x2,
        y = sword_y2
    }

    local enemy_x1 = enemy.x
    local enemy_y1 = enemy.y
    local enemy_x2 = enemy.x + 16
    local enemy_y2 = enemy.y + 16
    local enemy_p1 = {
        x = enemy_x1,
        y = enemy_y1
    }
    local enemy_p2 = {
        x = enemy_x2,
        y = enemy_y2
    }

    printh(sword_p1)
    printh(sword_p2)
    printh(enemy_p1)
    printh(enemy_p2)

    if (sword_p1.x >= enemy_p2.x or sword_p2.x >= enemy_p1.x) return false; 
    if (sword_p1.y <= enemy_p2.y or sword_p2.y <= enemy_p1.y) return false; 
    return true; 
end