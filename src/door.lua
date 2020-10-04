function door_manager() 
    door_manage = {

        doors = {},

        y_debug = true,
        x_debug = true,

        init = function (self)
            for x=0,128 do
                for y=0,64 do
                    tile = world.get_tile(x, y)
                    if tile == 82 then 
                        door = make_door(tile, x, y)
                        self.doors[#self.doors+1] = door
                        printh('found door at: ' .. door.x .. ' ' .. door.y)
                    end
                end
            end
        end,

        update = function (self, player)
            for i, door in pairs(self.doors) do
                printh(#self.doors)
                if i == 2 then printh('distance from door ' .. (player.x + 64) / 8 - door.x .. ' ' .. (player.y + 64) / 8 - door.y) end
                if abs(((player.x + 64) / 8) - (door.x)) < 1.2 and abs(((player.y + 64) / 8) - door.y) < 1 then
                    player.keys -= 1
                    world.change_tile(door.x, door.y, 0)
                    self.doors[i] = nil
                end
            end
        end
    }   
    return door_manage
end

function make_door(tile, x, y)
    door = {
        x = x,
        y = y, 
        tile = tile
    }
    return door
end