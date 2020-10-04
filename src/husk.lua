

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
    on_ground = false,
    forces = {
      up = 0,
      down = 0,
    },
    flip_x = false,
    terminal_velocity = 5,
    draw = function(self) 
      spr(self.current_frame, self.x, self.y, 1, 1, self.flip_x)
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
        if abs(distance) > 8 then 
          direction = distance / abs(distance)
          if direction < 0 then self.flip_x = false else self.flip_x = true end
          self.action = 'walk'
          self:move({x = - direction, y = 0}, {x = 0, y = 0})
        else 
          self.action = 'attack'
        end
      else 
        self.action = 'idle'
      end
      -- walk toward the player
      -- when touching player, play bite animation

      self.on_ground = world:is_touching_solid({x = self.x, y = self.y + 8})
      if self.on_ground then printh('on ground: ' .. self.forces.down) else printh('falling: ' .. self.forces.down) end
      if not self.on_ground then
        self.forces.down = self.forces.down + self.gravity
        if self.forces.down > self.terminal_velocity then self.forces.down = self.terminal_velocity end
      else
        self.forces.down = 0
      end
      self:move({x = 0, y = self.forces.down - self.forces.up}, {x = 0, y = 8})
    end,

    move = function(self, vector, adjust)
      if not world:is_touching_solid({x = self.x + vector.x + adjust.x, y = self.y}) then
        self.x += vector.x
      end
      if not world:is_touching_solid({x = self.x, y = self.y + vector.y + adjust.y}) then
        self.y += vector.y
      end
    end
  }
  
  return husk
end