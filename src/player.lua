left = 0
right = 1
up = 2
down = 3
sword_offset = 8
player_x = 64
player_y = 64

function make_player()
  player = {
    x = 0,
    y = 0,
    jump_force = 0,
    is_jumping = false,
    speed = 4,
    strength = 2,
    double_sword_enabled = false,
    double_jump_enabled = false,
    gravity = 9.8 / 60, 
    down_force = 0,
    terminal_velocity = 5,
    is_touching_ground = true,

    frames = {
      stand = 0,
      walk = 1,
      jump = 2,
      sword = {3, 4, 5, 6}
    },
    timers = {
      jump = 0,
      move = 0,
      sword = 0
    },
    direction = right,
    jump = false,
    sword = false,
    move = false, 

    draw = function (self)
      self.character_frame(self)
      if(self.sword) then self.sword_frame(self) end
    end,
    
    update = function (self)
      if(btn(left)) then 
        self.x = self.x - 1 
        move = true
        direction = left
      elseif(btn(right)) then 
        self.x = self.x + 1 
        move = true
        direction = right
      else
        move = false
        self.timers.walk = 0
      end

      if(btnp(4)) then self.jump = true end
      if(btnp(5)) then self.sword = true end

      if not self.is_touching_ground then 
        self.y += self.down_force
        self.down_force += self.gravity
        if self.down_force > self.terminal_velocity then
          self.down_force = self.terminal_velocity
        end
      else
        self.down_force = 0
        stuck = world:is_touching_solid({x = (self.x + 4), y = (self.y + 7)})
        if(stuck) then
          self.y -= 1
          printh('stuck')
        end
      end
    end,

    sword_frame = function (self) 
      frame = self.frames.sword[1]
      for i = 1, 4 do 
        if(self.timers.sword < i*2) then
          frame = self.frames.sword[i]
          break
        end
      end

      self.timers.sword += 1
      if(self.timers.sword >= 8) then
        self.timers.sword = 0
        self.sword = false
      end

      flip = self.direction == self.right
      sword_x = player_x - sword_offset
      if(flip) sword_x = player_x + sword_offset
      sword_y = player_y
      spr(frame, sword_x, sword_y, 1, 1, flip, false)
    end,

    character_frame = function (self) 
      frame = self.frames.stand
      if(jump) then
        frame = self.frames.jump
        if(self.timers.jump>30) then
          self.timers.jump = 0
          jump = false
        end
      elseif(walk) then
        if(self.timers.walk > 10) then s=1 end

        self.timers.walk += 1
        if(self.timers.walk>=20) then self.timers.walk=0 end
      end 

      spr(frame,self.x+64,self.y+64,1,1,self.direction==left,false)
    end,

    is_wall = function(self) 
      world:is_touching_solid({x = player.x, y = player.y})
    end
  }
  
  return player
end

