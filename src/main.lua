#include ./src/enemy_common.lua
#include ./src/husk.lua

#include ./src/world.lua

#include ./src/door.lua

world = make_world()

door_man = door_manager()

#include ./src/player.lua

player = make_player()

function _init()
  print(player.x)
  world:init()
  
  door_man:init()
end

function _draw()
  cls(0)
  world:draw(player)
  player:draw()
end

function _update()
  player:update()
  world:update(player)
  door_man:update(player)
end