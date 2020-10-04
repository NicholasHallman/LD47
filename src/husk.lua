

function make_husk()
  husk = {
    x = 0,
    y = 0,
    frames = {
      idle = {start = 9, len = 2, timeout = 6 },
      walk = {start = 10, len = 2, timeout = 4 },
      attack = {start = 12, len = 4, timeout = 2},
    },
    current_frame = 64,
    action = 'idle',
    timeout_count = 0,
    gravity = 9.8 / 60,
    on_ground = false,
    forces = {
      up = 0,
      down = 0,
    },
    flip_x = false,
    terminal_velocity = 5,
    damage = 5,
    drops_key = false,

    draw = function(self) 
      spr(self.current_frame, self.x, self.y, 1, 1, self.flip_x)
      if self.timeout_count == 0 then
        self.current_frame += 1
        at_frame = self.current_frame - self.frames[self.action].start
        if at_frame >= self.frames[self.action].len then
          self.current_frame = self.frames[self.action].start
        end
      else 
        if self.timeout_count > self.frames[self.action].timeout then
          self.timeout_count = -1
        end
      end
      self.timeout_count += 1
    end,
    
    update = function(self, player)
      -- TODO
      -- do you see the player?
      player_pos = {x = player.x + 64, y = player.y + 64}
      distance = self.x - player_pos.x
      direction = distance / abs(distance)

      if player_pos.y - 8 < self.y and player_pos.y + 4 > self.y then
        if abs(distance) > 8 then 
          if direction < 0 then self.flip_x = false else self.flip_x = true end
          self.action = 'walk'
          self:move({x = (-direction) / 2, y = 0}, {x = 0, y = 0})
        else 
          self.action = 'attack'
          self:hit(direction)
        end
      else 
        self.action = 'idle'
      end
      -- walk toward the player
      -- when touching player, play bite animation

      self.on_ground = world:is_touching_solid({x = self.x, y = self.y + 7})
      if not self.on_ground then
        self.forces.down = self.forces.down + self.gravity
        if self.forces.down > self.terminal_velocity then self.forces.down = self.terminal_velocity end
      else
        self.forces.down = 0
      end
      self:move({x = 0, y = self.forces.down - self.forces.up}, {x = 0, y = 7})
    end,

    move = function(self, vector, adjust)
      if not world:is_touching_solid({x = self.x + vector.x + adjust.x, y = self.y}) then
        self.x += vector.x
      end
      if not world:is_touching_solid({x = self.x, y = self.y + vector.y + adjust.y}) then
        self.y += vector.y
      end
    end,

    hit = function(self, direction)
      player:get_hit(self.damage, direction)
    end
  }
  
  return husk
end