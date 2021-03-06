--[[
    Map Module
    Chris Wineland
    2021-09-08
]]

local HeroCommands = require "hero_commands"
local Direction = require "direction"

-- private vars
local default_tile_size = 64
local default_edge_padding = 5

local Map = {
    uid = 0,
    tile_size = default_tile_size,
    tile_set_name = "",
    edge_padding = default_edge_padding,
    width = 6,
    height = 7,
    heroes = {},
    enemies = {},
    movement_map = {},
    vision_map = {}
}

function Map:new(template)
    template = template or {}
    setmetatable(template, self)
    self.__index = self
    return template
 end

 function Map:__debug_setup_movement_map()
    for i = 1, Map.width do
        Map.movement_map[i] = {}
        for j = 1, Map.height do
            Map.movement_map[i][j] = 1
        end
    end
    
    Map.movement_map[2][3] = 0
    Map.movement_map[2][2] = 0
    Map.movement_map[5][4] = 0
    Map.movement_map[3][5] = 0
    Map.movement_map[3][6] = 0
    Map.movement_map[4][6] = 0
    Map.movement_map[5][6] = 0
    Map.movement_map[6][6] = 0
 end

 function Map:__debug_setup_debug_map()
    self:__debug_setup_movement_map()
    self:clear_vision_map()
 end

function Map:clear_vision_map()
    for i = 1, Map.width do
        self.vision_map[i] = {}
        for j = 1, self.height do
            self.vision_map[i][j] = 0
        end
    end
end

function Map:check_ability_colision(hero, action, direction, range)
    local success = false
    local found_range = 0
    local found_target = nil
    for distance = 1, range do
        if direction == Direction.North then
            local new_y = hero.current_position_y - distance
            if self:vision_check_for_cordinates(hero.current_position_x, new_y) then
                break;
            else 
                local target = self:valid_target_at_point(hero.current_position_x, new_y)
                if target then
                    success = true
                    found_range = distance
                    found_target = target
                    break;
                end
            end
        elseif direction == Direction.East then
            local new_x = hero.current_position_x + distance
            if self:vision_check_for_cordinates(new_x, hero.current_position_y) then
                break;
            else 
                local target = self:valid_target_at_point(new_x, hero.current_position_y)
                if target then
                    success = true
                    found_range = distance
                    found_target = target
                    break;
                end
            end
        elseif direction == Direction.South then
            local new_y = hero.current_position_y + distance
            if self:vision_check_for_cordinates(hero.current_position_x, new_y) then
                break;
            else 
                local target = self:valid_target_at_point(hero.current_position_x, new_y)
                if target then
                    success = true
                    found_range = distance
                    found_target = target
                    break;
                end
            end
        elseif direction == Direction.West then
            local new_x = hero.current_position_x - distance
            if self:vision_check_for_cordinates(new_x, hero.current_position_y) then
                break;
            else 
                local target = self:valid_target_at_point(new_x, hero.current_position_y)
                if target then
                    success = true
                    found_range = distance
                    found_target = target
                    break;
                end
            end
        end
    end
    hero:ability_result(success, action, found_range, found_target)
end

function Map:valid_target_at_point(x, y)
    found_target = nil
    for index, hero in pairs(self.heroes) do
        if hero.current_position_x == x and hero.current_position_y == y then
            found_target = hero
            break
        end
    end
    if found_target then
        return found_target
    end
    for index, enemy in pairs(self.enemies) do
        if enemy.current_position_x == x and enemy.current_position_y == y then
            found_target = enemy
            break
        end
    end
    return found_target
end

function Map:update_vision(heroes)
    self:clear_vision_map()
    --this needs to get re thought, need to check for all effected heros based on this ones postion to all others
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
    for distance = 1, hero.vision_distance do
        if failed_vision_check then
            break;
        end
        if direction == 0 then -- UP
            local new_y = hero.current_position_y - distance
            failed_vision_check = self:vision_check_for_cordinates(hero.current_position_x, new_y)
        elseif direction == 1 then  -- Up/Right
            if distance ~= hero.vision_distance then
                local new_x = hero.current_position_x + distance
                local new_y = hero.current_position_y - distance
                failed_vision_check = self:vision_check_for_cordinates(new_x, new_y)
            end
        elseif direction == 2 then -- Right
            local new_x = hero.current_position_x + distance
            failed_vision_check = self:vision_check_for_cordinates(new_x, hero.current_position_y)
        elseif direction == 3 then -- Right/Down
            if distance ~= hero.vision_distance then
                local new_x = hero.current_position_x + distance
                local new_y = hero.current_position_y + distance
                failed_vision_check = self:vision_check_for_cordinates(new_x, new_y)
            end
        elseif direction == 4 then -- Down
            local new_y = hero.current_position_y + distance
            failed_vision_check = self:vision_check_for_cordinates(hero.current_position_x, new_y)
        elseif direction == 5 then -- Down/Left
            if distance ~= hero.vision_distance then
                local new_x = hero.current_position_x - distance
                local new_y = hero.current_position_y + distance
                failed_vision_check = self:vision_check_for_cordinates(new_x, new_y)
            end
        elseif direction == 6 then -- Left
            local new_x = hero.current_position_x - distance
            failed_vision_check = self:vision_check_for_cordinates(new_x, hero.current_position_y)
        elseif direction == 7 then -- Left/Up
            if distance ~= hero.vision_distance then
                local new_x = hero.current_position_x - distance
                local new_y = hero.current_position_y - distance
                failed_vision_check = self:vision_check_for_cordinates(new_x, new_y)
            end
        end
    end
end

function Map:vision_check_for_cordinates(x, y)
    if x <= 0 or y <= 0 then
        return true
    elseif x > self.width or y > self.height then 
        return true
    end
    self.vision_map[x][y] = 1 -- at this point we know we need to show the square
    return self.movement_map[x][y] == 0 -- its a wall stop searching 
end

function Map:hero_can_execute_command(hero)
    if hero.current_command == HeroCommands.move_right then
        return hero.current_position_x < #self.movement_map and self.movement_map[hero.current_position_x + 1][hero.current_position_y] ~= 0
    elseif hero.current_command == HeroCommands.move_left then
        return hero.current_position_x > 1 and self.movement_map[hero.current_position_x - 1][hero.current_position_y] ~= 0
    elseif hero.current_command == HeroCommands.move_up then
        return hero.current_position_y > 1 and self.movement_map[hero.current_position_x][hero.current_position_y - 1] ~= 0
    elseif hero.current_command == HeroCommands.move_down then
        return hero.current_position_y < #self.movement_map[1] and self.movement_map[hero.current_position_x][hero.current_position_y + 1] ~= 0
    end
    return true
end

function Map:draw()
    for i = 1, self.width do
        for j = 1, self.height do
            local rectangle_mode = ""
            if self.vision_map[i][j] == 1 then
                if self.movement_map[i][j] == 1 then
                    love.graphics.setColor(1, 1, 1)
                    rectangle_mode = "line"
                else 
                    love.graphics.setColor(0, 0, 1)
                    rectangle_mode = "fill"
                end
            else
                love.graphics.setColor(0.59, 0.59, 0.59)
                rectangle_mode = "fill"
            end
            love.graphics.rectangle(
                rectangle_mode, 
                i * self.tile_size + self.edge_padding, 
                j * self.tile_size + self.edge_padding, 
                self.tile_size, 
                self.tile_size)
        end
    end
end

return Map
