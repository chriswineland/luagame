local HeroCommands = require "hero_commands"

local Map = {}
Map.tile_size = 64
Map.edge_buffer_size = 5
Map.width = 6
Map.height = 7

for i = 0, Map.width do
    Map[i] = {}
    for j = 0, Map.height do
        Map[i][j] = 1
    end
end

Map[1][2] = 0
Map[1][1] = 0
Map[4][3] = 0
Map[2][5] = 0
Map[2][6] = 0
Map[3][6] = 0
Map[4][6] = 0
Map[5][6] = 0

Map.vison_map = {}
for i = 0, Map.width do
    Map.vison_map[i] = {}
    for j = 0, Map.height do
        Map.vison_map[i][j] = 0
    end
end

function Map:update_vision()

end

function Map:hero_can_exicute_command(hero)
    if hero.current_command == HeroCommands.move_right then
        return hero.current_position_x < #self and self[hero.current_position_x + 1][hero.current_position_y] ~= 0
    elseif hero.current_command == HeroCommands.move_left then
        return hero.current_position_x > 0 and self[hero.current_position_x - 1][hero.current_position_y] ~= 0
    elseif hero.current_command == HeroCommands.move_up then
        return hero.current_position_y > 0 and self[hero.current_position_x][hero.current_position_y - 1] ~= 0
    elseif hero.current_command == HeroCommands.move_down then
        return hero.current_position_y < #self[0] and self[hero.current_position_x][hero.current_position_y + 1] ~= 0
    end
    return true
end

function Map:draw()
    for i = 0, #self do
        for j = 0, #self[0] do
            local rectangle_mode = ""
            if self[i][j] == 1 then
                love.graphics.setColor(1, 1, 1)
                rectangle_mode = "line"
            else 
                love.graphics.setColor(0, 0, 1)
                rectangle_mode = "fill"
            end
            love.graphics.rectangle(
                rectangle_mode, 
                i * self.tile_size + self.edge_buffer_size, 
                j * self.tile_size + self.edge_buffer_size, 
                self.tile_size, self.tile_size)
        end
    end
end

return Map
