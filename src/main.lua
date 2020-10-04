#include ./src/husk.lua

#include ./src/world.lua

world = make_world()

#include ./src/player.lua

player = make_player()


function _init()
  print(player.x)
  world.enemies[1] = make_husk()
  world.enemies[1].x = 64 + 16
  world.enemies[1].y = 64
end

function _draw()
  cls(0)
  world:draw(player)
  player:draw()
end

function _update()
  player:update()
  world:update(player)
end