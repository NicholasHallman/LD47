left = 0
right = 1
up = 2
down = 3
sword_offset = 8

function make_player()
  player = {
    x = 0,
    y = 0,
    jump_force = 0,
    is_jumping = false,
    speed = 4,
    sanity = 100,
    strength = 2,
    double_sword_enabled = false,
    double_jump_enabled = false,
    gravity = 9.8 / 60, 
    down_force = 0,
    terminal_velocity = 5,
    is_touching_ground = true,
    dead = false,
    frames = {
      stand = 0,
      walk = 1,
      jump = 2,
      sword = {3, 4, 5, 6},
      die = {16, 17, 18},
    },
    timers = {
      jump = 0,
      move = 0,
      sword = 0,
      die = 0
    },
    direction = right,
    jump = false,
    move = false,
    die = false,
    sword = false,
    force_up = 0,
    force_x = 0,
    slow_fall = true,
    is_player = true,
    keys = 2,
    active = true,
    can_jump = true,

    draw = function (self)
      self.character_frame(self)
      if(self.sword) then self.sword_frame(self) end
      self:draw_inventory()
    end,
    
    update = function (self)
      if(btn(left)) then 
        if not world:is_touching_solid({x = (self.x - 1) + 64, y = self.y + 64}) or world:is_touching_platform({x = (self.x - 1) + 64, y = self.y + 64}) then
          self.x = self.x - 1 
          self.move = true
          self.direction = left
        end
      elseif(btn(right)) then 
        if not world:is_touching_solid({x = (self.x + 8) + 64, y = self.y + 64}) or world:is_touching_platform({x = (self.x + 8) + 64, y = self.y + 64}) then
          self.x = self.x + 1 
          self.move = true
          self.direction = right
        end
      else
        self.move = false
        self.timers.walk = 0
      end  
      
      if(btnp(5)) then 
        self.sword = true 
        sfx(0)
      end

      -- Jump code

      on_ground = world:is_touching_solid({x = (self.x + 4) + 64, y = (self.y + 8) + 64})
      self.is_touching_ground = on_ground

      if(btn(4)) then 
        if on_ground and self.can_jump then
          self.can_jump = false
          self.jump = true 
          sfx(1)
          self.force_up = 2
        end
        if self.slow_fall then self.gravity = 9.8 / (60 * 2) end 
      else
        self.slow_fall = false
        self.gravity = 9.8 / 60
        self.can_jump = true
      end

      if self.force_up > 0 then
        if not world:is_touching_solid({x = (self.x + 4) + 64, y = self.y - self.force_up + 64}) then
          self.y -= self.force_up
        elseif world:is_touching_platform({x = (self.x + 4) + 64, y = self.y - self.force_up + 64}) then
          self.y -= self.force_up
        else
          self.slow_fall = false
          self.force_down = 9.8
          self.force_up = 0
        end
        self.force_up -= self.gravity
      end

      if not self.is_touching_ground then 
        if not world:is_touching_solid({x = (self.x + 4) + 64, y = (self.y + 8 + self.down_force) + 64}) then
          self.y += self.down_force
          self.down_force += self.gravity
        else 
          while not world:is_touching_solid({x = (self.x + 4) + 64, y = (self.y + 8) + 64}) do
            self.y += 1
          end
        end
        if self.down_force > self.terminal_velocity then
          self.down_force = self.terminal_velocity
        end
      else
        self.down_force = 0
        self.jump = false
        self.slow_fall = true
      end

      if abs(self.force_x) > 0 and not world:is_touching_solid({x = (self.x + self.force_x) + 64, y = self.y + 64}) then
        self.x -= self.force_x
        if self.force_x > 0 then self.force_x -= 0.2 else self.force_x += 0.2 end
        if self.force_x < 0.5 and self.force_x > -0.5 then 
          self.force_x = 0 
          world.shake_camera = false
        end
      end
    end,

    sword_frame = function (self) 
      local frame = self.frames.sword[1]
      if(self.timers.sword == 1) then
        frame = self.frames.sword[2]
      elseif(self.timers.sword == 2) then
        frame = self.frames.sword[3]
      else
        frame = self.frames.sword[4]
      end

      self.timers.sword += 1
      if(self.timers.sword >= 6) then
        self.timers.sword = 0
        self.sword = false
      end

      local flip = self.direction==right
      sword_x = self.x + 64 - sword_offset
      if(flip) sword_x = self.x + 64 + sword_offset
      sword_y = self.y + 64
      spr(frame, sword_x, sword_y, 1, 1, flip, false)
    end,

    character_frame = function (self) 
      local frame = self.frames.stand

      if(self.die) then
        if(self.timers.die>=9) then
          frame = self.frames.die[3]
        end

        for i = 1, 3 do
          if(self.timers.die < i*3) then 
            frame = self.frames.die[i]
            break
          end
        end

        self.timers.die = max(self.timers.die + 1, 9)
      elseif(self.jump) then
        frame = self.frames.jump

        self.timers.jump+=1
        if(self.timers.jump>30) then
          self.timers.jump = 0
          self.jump = false
        end
      elseif(self.move) then
        if(self.timers.walk > 10) then frame = self.frames.walk end

        self.timers.walk += 1
        if(self.timers.walk>=20) then self.timers.walk=0 end
      end

      spr(frame,self.x+64,self.y+64,1,1,self.direction==left,false)
    end,

    is_wall = function(self) 
      world:is_touching_solid({x = player.x + 64, y = player.y + 64})
    end,

    get_hit = function (self, damage, direction)
      world.shake_camera = true
      self.sanity -= damage
      if self.sanity <= 0 then self.dead = true end
      self.force_x = 2 * direction
    end,

    draw_inventory = function(self)
      for i=0,self.keys do
        spr(41, self.x + (8 * i), self.y)
      end
    end
  }
  
  return player
end

