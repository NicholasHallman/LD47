function check_hit(enemy, player)
    local sword_x1 = (player.x + 64 + player.sword_offset)
    local sword_y1 = player.y + 64
    local sword_x2 = sword_x1 + player.sword_length
    local sword_y2 = sword_y1 + 16
    local sword_p1 = {
        x = sword_x1,
        y = sword_y1
    }
    local sword_p2 = {
        x = sword_x2,
        y = sword_y2
    }

    local enemy_x1 = enemy.x
    local enemy_y1 = enemy.y
    local enemy_x2 = enemy.x + 16
    local enemy_y2 = enemy.y + 16
    local enemy_p1 = {
        x = enemy_x1,
        y = enemy_y1
    }
    local enemy_p2 = {
        x = enemy_x2,
        y = enemy_y2
    }

    -- printh(sword_p1.x >= enemy_p2.x)
    -- printh(sword_p2.x >= enemy_p1.x)

    -- printh(sword_p1.y)
    -- printh(enemy_p2.y)
    printh(sword_p1.y <= enemy_p2.y)
    -- printh(sword_p2.y)
    -- printh(enemy_p1.y)
    printh(sword_p2.y <= enemy_p1.y)

    if (sword_p1.x >= enemy_p2.x or sword_p2.x >= enemy_p1.x) return false; 
    if (sword_p1.y <= enemy_p2.y or sword_p2.y <= enemy_p1.y) return false; 
    return true; 
end

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

      if player.attack then
        x = check_hit(self, player)
        if (x) then
          printh("DIIIEEEEE")
        end
      end
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