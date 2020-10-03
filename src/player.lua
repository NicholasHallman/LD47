
left = 0
right = 1
up = 2
down = 3

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
    frames = {
      standing = 0
    },
    gravity = 9.8 / 60, 
    down_force = 0,
    terminal_velocity = 5,
    is_touching_ground = true,

    
    draw = function (self)
      spr(self.frames.standing, self.x + 64, self.y + 64)
    end,
    
    update = function (self)
      if(btn(left)) then 
        self.x = self.x - 1 
      end
      if(btn(right)) then 
        self.x = self.x + 1 
      end
      if not self.is_touching_ground then 
        self.y += self.down_force
        self.down_force += self.gravity
        if self.down_force > self.terminal_velocity then
          self.down_force = self.terminal_velocity
        end
      end
      if self.is_touching_ground then
        self.down_force = 0
        stuck = world:is_touching_solid({x = (self.x + 4), y = (self.y + 7)})
        if(stuck) then
          self.y -= 1
          printh('stuck')
        end
      end
    end,

    is_wall = function(self) 
      world:is_touching_solid({x = player.x, y = player.y})
    end
  }
  
  return player
end

