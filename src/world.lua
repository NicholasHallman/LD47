
function make_world ()
  world = {

    enemies = {},

    non_solid_tiles = {},
    
    get_tile = function (x, y)
      if(x > 128) then return -1 end
      if( x < 0 ) then return -1 end
      if( y > 64) then return -1 end
      if( y < 0 ) then return -1 end
      
      location = 0x2000 + ( x + (y * 128) )
      return peek(location)
    end,
    
    is_touching_solid = function (self, entity)

      on_tile = self.get_tile(flr((entity.x) / 8), flr((entity.y) / 8))
      if(on_tile > 191) then
        return true
      end
      return false
    end,

    is_touching_platform = function (self, entity)
      on_tile = self.get_tile(flr((entity.x) / 8), flr((entity.y) / 8))
      if(on_tile > 239 and on_tile < 253) then
        return true
      end
      return false
    end,

    update = function (self)
      for enemy in all(self.enemies) do
        enemy:update(player)
      end
    end,
    
    draw = function (self, player)
      camera(player.x, player.y)
      map(0, 0, 0, 0, 128, 32)

      for enemy in all(self.enemies) do
        enemy:draw()
      end
    end
  }

  return world
end