
function make_world ()
  world = {
    non_solid_tiles = {},
    
    get_tile = function (x, y)
      if(x > 128) then return -1 end
      if( x < 0 ) then return -1 end
      if( y > 64) then return -1 end
      if( y < 0 ) then return -1 end
      
      location = 0x2000 + ( x + (y * 128) )
      return peek(location)
    end,
    
    is_touching_solid = function (self, player)

      on_tile = self.get_tile(flr((player.x + 64) / 8), flr((player.y + 64) / 8))
      if(on_tile > 191) then
        return true
      end
      return false
    end,
    
    draw = function (self, player)
      camera(player.x, player.y)
      map(0, 0, 0, 0, 128, 32)
    end
  }

  return world
end