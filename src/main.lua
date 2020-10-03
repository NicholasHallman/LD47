#include ./src/world.lua

world = make_world()

#include ./src/player.lua

player = make_player()

function _init()
  print(player.x)
end

function _draw()
  cls(0)
  world:draw(player)
  player:draw()
end

function _update()
  on_ground = world:is_touching_solid({x = player.x, y = (player.y + 8)})
  print_ground = 'false'
  if on_ground then
    print_ground = 'true'
  end
  printh(print_ground)
  player.is_touching_ground = on_ground
  player:update()
end