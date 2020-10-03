#include ./src/player.lua
#include ./src/world.lua

player = make_player()

function _init()
  print(player.x)
end

function _draw()
  cls(0)
  player:draw()
end

function _update()
  player:update()
  world:draw(player)
end