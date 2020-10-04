
function make_textbox()
    textbox = {
        is_visible = false,
        phrases = {'','',''},

        draw = function(self)
            if self.is_visible then
                -- draw the corners
                rectfill(8 + player.x,80 + player.y,112 + player.x,112 + player.y,1)
                for x=1,14 do
                    for y = 10,14 do
                        if y == 10 then
                            spr(33, (x * 8) + player.x, (y * 8) + player.y)
                        elseif y == 14 then
                            spr(33, (x * 8) + player.x, (y * 8) + player.y, 1, 1, false, true)
                        elseif x == 1 then
                            spr(34, (x * 8) + player.x, (y * 8) + player.y, 1, 1, false)
                        elseif x == 14 then
                            spr(34, (x * 8) + player.x, (y * 8) + player.y, 1, 1, true)
                        end
                    end
                end
                spr(32, 8 + player.x, 80 + player.y)
                spr(32, 8 + player.x, 112 + player.y, 1, 1, false, true)
                spr(32, 112 + player.x, 80 + player.y, 1, 1, true)
                spr(32, 112 + player.x, 112 + player.y, 1, 1, true, true)
                print(self.phrases[1], player.x + 2 * 8, player.y + 11 * 8, 7)
                print(self.phrases[2], player.x + 2 * 8, player.y + 12 * 8, 7)
                print(self.phrases[3], player.x + 2 * 8, player.y + 13 * 8, 7)
            end 
        end,

        close = function(self)
            if self.is_visible then
                self.is_visible = false
                player.active = true
            end
        end
    }
    return textbox
end