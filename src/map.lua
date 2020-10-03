

map = {
    solid_tiles = {};

    get_tile = func(x, y)
        if(x > 128) then return -1 end
        if( x < 0 ) then return -1 end
        if( y > 64) then return -1 end
        if( y < 0 ) then return -1 end

        location = 0x2000 + ( x + (y * 128) )
        return peek(location)
    end

    is_touching_solid = func(player)
        on_tile = get_tile(player.x, player.y)
        for tile in solid_tiles do
            if(on_tile == tile) then return true end
        end
        return false
    end
}