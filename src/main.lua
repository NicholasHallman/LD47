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
  
  player:update()
end