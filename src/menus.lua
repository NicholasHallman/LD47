

function make_title()
    title = {
        selecting = 0,
        start_game = false,
        show_help = false,
        draw = function(self)
            print("purgatory", 41, 20)
            start = "start"
            help = "help"
            if self.selecting  == 0 then start = '> start' elseif self.selecting  == 1 then help = "> help" end
            print(start, 41, 58)
            print(help, 41, 66)
        end,

        update = function (self) 
            if(btnp(2)) then 
                self.selecting -= 1
                if self.selecting < 0 then self.selecting = 1 end
            elseif(btnp(3)) then
                self.selecting += 1
                if self.selecting > 1 then self.selecting = 0 end
            end

            if btnp(4) or btnp(5) then
                if self.selecting == 0 then
                    self.start_game = true
                else
                    self.show_help = true
                end
            end
        end
    }
    return title
end

function make_help()
    help = {
        back = false,
        lines = {
            "you've died, but this isn't the",
            "end. you wake up in a strange",
            "place. is this the afterlife?",
            "you must explore this world to",
            "discover the secrets of purgatory.",
            "",
            "           \146 \146 \146",
            "",
            "press \131 \139 \145 \148 to move",
            "press \151 to jump",
            "press \142 to attack",
            "",
            "           \146 \146 \146",
            "",
            "thanks for playing ",
        },
        draw = function(self)
            for i, line in pairs(self.lines) do
                print(line, 5, 8 * i)
            end
        end,
        update = function(self)
            if btnp(4) or btnp(5) then
                self.back = true
            end
        end
    }
    return help
end