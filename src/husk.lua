

function make_husk()
  husk = {
    x = 0,
    y = 0,
    frames = {
      idle = {start = 64, len = 2 },
      walk = {start = 65, len = 2 },
      attack = {start = 67, len = 4},
    },
    current_frame = 64,
    action = 'idle',
    timeout = 6,
    timeout_count = 0,
    gravity = 9.8 / 60,
    forces = {
      up = 0,
      down = 0,
    },
    
    draw = function(self) 
      spr(self.current_frame, self.x, self.y)
      if self.timeout_count == 0 then
        self.current_frame += 1
        at_frame = self.current_frame - self.frames[self.action].start
        if at_frame >= self.frames[self.action].len then
          self.current_frame = self.frames[self.action].start
        end
      else 
        if self.timeout_count > self.timeout then
          self.timeout_count = -1
        end
      end
      self.timeout_count += 1
    end,
    
    update = function(self, player)
      -- TODO
      -- do you see the player?
      player_pos = {x = player.x + 64, y = player.y + 64}
      if player_pos.y - 8 < self.y and player_pos.y + 4 > self.y then
        distance = self.x - player_pos.x
        direction = distance / abs(distance)
        self:move({x = -direction, y = 0})
      end
      -- walk toward the player
      -- when touching player, play bite animation
    end,

    move = function(self, vector)
      if not world:is_touching_solid({x = self.x + vector.x, y = self.y}) then
        self.x += vector.x
      end
      if not world:is_touching_solid({x = self.x, y = self.y + vector.y}) then
        self.y += vector.y
      end
    end
  }
  
  return husk
end