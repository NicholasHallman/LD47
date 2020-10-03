
left = 0
righ = 1
up = 2
down = 3

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
        standing = 128
    },
    draw = function (self)
        spr(self.frames.standing, self.x + 64, self.y + 64)
    end,
    update = function (self)
        if(btn(left)) then self.x = self.x - 1 end
        if(btn(right)) then self.x = self.x + 1 end
        printh('left: ' .. btn(left) .. ' right: ' .. btn(right))
    end
}
