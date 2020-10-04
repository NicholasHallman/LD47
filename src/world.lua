

function make_event(x, y, say_1, say_2, say_3)
  event = {
    x = x,
    y = y,
    say_1 = say_1,
    say_2 = say_2, 
    say_3 = say_3,
    triggered = false,
    active = false,
    update = function(self, player)
      if self.active and (btn(4) or btn(5)) then
        self.active = false
        textbox.is_visible = false
        player.active = true
      elseif not self.triggered and abs(((player.x + 64) / 8) - self.x) < 2 and abs(((player.y + 64) / 8) - self.y) < 2 then
        self.triggered = true
        self.active = true
        player.active = false
        textbox.is_visible = true
        textbox.phrases = {
          self.say_1,
          self.say_2,
          self.say_3,
        }
      end
    end
  }

  return event
end

function make_world ()
  world = {

    shake_camera = false,

    enemies = {},

    events = {},

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

    init = function (self)
      self.events[1] = make_event(2, 28, 'welcome to purgatory', 'you may never leave', '')
      self.enemies[1] = make_husk()
      self.enemies[1].x = 58 * 8
      self.enemies[1].y = 30 * 8

      printh("events: " .. self.events[1].say_1)
    end,

    update = function (self)
      for enemy in all(self.enemies) do
        enemy:update(player)
      end
      for event in all(self.events) do
        event:update(player)
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

