
function make_world ()
  world = {

    shake_camera = false,

    enemies = {},

    non_solid_tiles = {},
    
    get_tile = function (x, y)
      if(x > 128) then return -1 end
      if( x < 0 ) then return -1 end
      if( y > 64) then return -1 end
      if( y < 0 ) then return -1 end

      start_location = 0x2000
      if y > 31 then 
        start_location = 0x1000 
        y -= 32
      end
      
      location = start_location + ( x + (y * 128) )
      return peek(location)
    end,

    change_tile = function (x, y, new)
      if(x > 128) then return -1 end
      if( x < 0 ) then return -1 end
      if( y > 64) then return -1 end
      if( y < 0 ) then return -1 end

      start_location = 0x2000
      if y > 31 then 
        start_location = 0x1000 
        y -= 32
      end
      
      location = start_location + ( x + (y * 128) )
      return poke(location, new)
    end,
    
    is_touching_solid = function (self, entity)

      on_tile = self.get_tile(flr((entity.x) / 8), flr((entity.y) / 8))
      if(on_tile >= 64 and (on_tile - 76) % 16 != 0 and (on_tile - 77) % 16 != 0 and (on_tile - 78) % 16 != 0 and (on_tile - 79) % 16 != 0) then
        return true
      end
      return false
    end,

    is_touching_platform = function (self, entity)
      on_tile = self.get_tile(flr((entity.x) / 8), flr((entity.y) / 8))
      if(on_tile > 111 and on_tile < 125) then
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
      rx = 0
      ry = 0
      if self.shake_camera then
        rx = rnd(2) - 1
        ry = rnd(2) - 1
      end
      camera(player.x + rx, player.y + ry)
      map(0, 0, 0, 0, 128, 64)

      for enemy in all(self.enemies) do
        enemy:draw()
      end
    end
  }

  return world
end