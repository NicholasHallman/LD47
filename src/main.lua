#include ./src/player.lua
#include ./src/map.lua

function _init()
    print(player.x)
end

function _draw()
    cls(0)
    player:draw()
end

function _update()
    player:update()
end