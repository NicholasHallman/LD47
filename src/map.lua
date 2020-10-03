

map = {
    non_solid_tiles = {},

    get_tile = function (x, y)
        if(x > 128) then return -1 end
        if( x < 0 ) then return -1 end
        if( y > 64) then return -1 end
        if( y < 0 ) then return -1 end

        location = 0x2000 + ( x + (y * 128) )
        return peek(location)
    end,

    is_touching_solid = function (player)
        on_tile = get_tile((player.x / 8), flr(player.y / 8))
        if(on_tile > 191 and on_tile % 14 != 0 and on_tile % 15 != 0) then
            return true
        end
        return false
    end,
}