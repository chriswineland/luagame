local HeroCommands = require "hero_commands"

local Map = {}
Map.tile_size = 64
Map.tile_set_name = ""
Map.edge_buffer_size = 5
Map.width = 6
Map.height = 7
Map.heroes = {}
Map.enemies = {}

Map.movement_map = {}
for i = 0, Map.width - 1 do
    Map.movement_map[i] = {}
    for j = 0, Map.height - 1 do
        Map.movement_map[i][j] = 1
    end
end

Map.movement_map[1][2] = 0
Map.movement_map[1][1] = 0
Map.movement_map[4][3] = 0
Map.movement_map[2][4] = 0
Map.movement_map[2][5] = 0
Map.movement_map[3][5] = 0
Map.movement_map[4][5] = 0
Map.movement_map[5][5] = 0

Map.vision_map = {}

function Map.clear_vision_map()
    for i = 0, Map.width - 1 do
        Map.vision_map[i] = {}
        for j = 0, Map.height - 1 do
            Map.vision_map[i][j] = 0
        end
    end
end

Map:clear_vision_map()

function Map:update_vision(heroes)
    self:clear_vision_map()
    for _, hero in ipairs(heroes) do
        self:add_vision_for_hero(hero)
    end
end

function Map:add_vision_for_hero(hero)
    self.vision_map[hero.current_position_x][hero.current_position_y] = 1
    for direction = 0, 7 do -- 8 directions to calculate vision in
        self:add_vison_for_hero_in_direction(hero, direction)
    end
end

function Map:add_vison_for_hero_in_direction(hero, direction)
    local failed_vision_check = false
    for distance = 1, hero.vision_distance + 1 do -- this offset is due to vision 1 being one tile way, not ontop of the unit
        if failed_vision_check then
            break;
        end
        if direction == 0 then
            local new_y = hero.current_position_y - distance
            if new_y < 0 then
                failed_vision_check = true
            elseif self.movement_map[hero.current_position_x][new_y] == 1 then
                self.vision_map[hero.current_position_x][new_y] = 1
            else -- on the map but its a wall
                self.vision_map[hero.current_position_x][new_y] = 1
                failed_vision_check = true
            end
        elseif direction == 1 then
        elseif direction == 2 then
            local new_x = hero.current_position_x + distance
            if new_x > self.width - 1 then
                failed_vision_check = true
            elseif self.movement_map[new_x][hero.current_position_y] == 1 then
                self.vision_map[new_x][hero.current_position_y] = 1
            else -- on the map but its a wall
                self.vision_map[new_x][hero.current_position_y] = 1
                failed_vision_check = true
            end
        elseif direction == 3 then
        elseif direction == 4 then
        elseif direction == 5 then
        elseif direction == 6 then
        elseif direction == 7 then
        end
    end
end

function Map:hero_can_exicute_command(hero)
    if hero.current_command == HeroCommands.move_right then
        return hero.current_position_x < #self and self.movement_map[hero.current_position_x + 1][hero.current_position_y] ~= 0
    elseif hero.current_command == HeroCommands.move_left then
        return hero.current_position_x > 0 and self.movement_map[hero.current_position_x - 1][hero.current_position_y] ~= 0
    elseif hero.current_command == HeroCommands.move_up then
        return hero.current_position_y > 0 and self.movement_map[hero.current_position_x][hero.current_position_y - 1] ~= 0
    elseif hero.current_command == HeroCommands.move_down then
        return hero.current_position_y < #self.movement_map[0] and self.movement_map[hero.current_position_x][hero.current_position_y + 1] ~= 0
    end
    return true
end

function Map:draw()
    for i = 0, self.width - 1 do
        for j = 0, self.height - 1 do
            local rectangle_mode = ""
            --if self.vision_map[i][j] == 1 then
                if self.movement_map[i][j] == 1 then
                    love.graphics.setColor(1, 1, 1)
                    rectangle_mode = "line"
                else 
                    love.graphics.setColor(0, 0, 1)
                    rectangle_mode = "fill"
                end
            --else
            --    love.graphics.setColor(0.59, 0.59, 0.59)
            --    rectangle_mode = "fill"
            --end
            love.graphics.rectangle(
                rectangle_mode, 
                i * self.tile_size + self.edge_buffer_size, 
                j * self.tile_size + self.edge_buffer_size, 
                self.tile_size, 
                self.tile_size)
        end
    end
end

return Map
