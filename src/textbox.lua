
function make_textbox()
    textbox = {
        is_visible = false,
        phrase = "test text box",
        draw = function(self)
            if self.is_visible then
                -- draw the corners
                spr(32, 0, 72)
                spr(32, 0, 72)
            end 
        end
    }
    return textbox
end