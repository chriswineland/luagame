--[[
    Hero Module
    Chris Wineland
    2021-09-05
]]

local Direction = require "direction"
local HeroCommands = require "hero_commands"
local HealthPointsModule = require "health_points"

-- Global private vars
local defalut_size = 32
local defalut_vision_distance = 2
local deflaut_speed = 0
local defalut_direction = Direction.North
local defalut_command = HeroCommands.hold_position

local Hero = {}

function Hero:new()
    local self = {}

    -- Private vars
    local uid = 0
    --local health_points = HealthPointsModule
    local sprite_name = ""
    local speed = deflaut_speed
    local size = defalut_size
    local current_direction = defalut_direction

    -- Public vars
    self.name = ""
    self.current_position_x = 0
    self.current_position_y = 0
    self.vision_distance = defalut_vision_distance
    self.is_in_focus = false
    self.current_command = defalut_command
    self.notification_hero_moved = function() end

    -- Private Methods
    local function draw_move_left_indicator(map_tile_size)
        love.graphics.setColor(0, 1, 0)
        love.graphics.circle(
            "fill",
            13 + (self.current_position_x * map_tile_size),
            5 + (map_tile_size / 2) + (self.current_position_y * map_tile_size),
            5)
    end
    
    local function draw_move_right_indicator(map_tile_size)
        love.graphics.setColor(0, 1, 0)
        love.graphics.circle(
            "fill",
            ((self.current_position_x + 1) * map_tile_size) - 3,
            5 + (map_tile_size / 2) + (self.current_position_y * map_tile_size),
            5)
    end
    
    local function draw_move_up_indicator(map_tile_size)
        love.graphics.setColor(0, 1, 0)
        love.graphics.circle(
            "fill",
            5 + (map_tile_size / 2) + (self.current_position_x * map_tile_size),
            14 + (self.current_position_y * map_tile_size),
            5)
    end
    
    local function draw_move_down_indicator(map_tile_size)
        love.graphics.setColor(0, 1, 0)
        love.graphics.circle(
            "fill",
            5 + (map_tile_size / 2) + (self.current_position_x * map_tile_size),
            ((self.current_position_y + 1) * map_tile_size) - 3,
            5)
    end
    
    local function draw_hold_position_indicator(map_tile_size)
        love.graphics.setColor(1, 0.65, 0)
        love.graphics.rectangle(
            "fill",
            18 + (self.current_position_x * map_tile_size),
            ((self.current_position_y + 1) * map_tile_size) - 6,
            map_tile_size * 0.6,
            5)
    end
    
    local function draw_auto_attack_indicator(map_tile_size)
        love.graphics.setColor(0, 0, 1)
        if current_direction == Direction.North then
            love.graphics.circle(
                "fill",
                5 + (map_tile_size / 2) + (self.current_position_x * map_tile_size),
                14 + (self.current_position_y * map_tile_size),
                5)
        elseif current_direction == Direction.East then
            love.graphics.circle(
                "fill",
                ((self.current_position_x + 1) * map_tile_size) - 3,
                5 + (map_tile_size / 2) + (self.current_position_y * map_tile_size),
                5)
        elseif current_direction == Direction.South then
            love.graphics.circle(
                "fill",
                5 + (map_tile_size / 2) + (self.current_position_x * map_tile_size),
                ((self.current_position_y + 1) * map_tile_size) - 3,
                5)
        elseif current_direction == Direction.West then
            love.graphics.circle(
                "fill",
                13 + (self.current_position_x * map_tile_size),
                5 + (map_tile_size / 2) + (self.current_position_y * map_tile_size),
                5)
        end
    end

    -- Public Methods
    function self.set_current_command(command)
        if command == HeroCommands.move_right then
            self.current_command = HeroCommands.move_right
            current_direction = Direction.East
        elseif command == HeroCommands.move_left then 
            self.current_command = HeroCommands.move_left
            current_direction = Direction.West
        elseif command == HeroCommands.move_up then
            self.current_command = HeroCommands.move_up
            current_direction = Direction.North
        elseif command == HeroCommands.move_down then
            self.current_command = HeroCommands.move_down
            current_direction = Direction.South
        elseif command == HeroCommands.hold_position then
            self.current_command = HeroCommands.hold_position
        elseif command == HeroCommands.auto_attack then
            self.current_command = HeroCommands.auto_attack
        --[[elseif command == HeroCommands.ability_1 then
            self.current_command = HeroCommands.ability_1
        elseif command == HeroCommands.ability_2 then
            self.current_command = HeroCommands.ability_2
        elseif command == HeroCommands.ability_3 then
            self.current_command = HeroCommands.ability_3]]
        end
    end
    
    function self.execute_current_command(permision)
        if not permision then
            self.current_command = HeroCommands.hold_position
        end
        if self.current_command == HeroCommands.move_right then
            self.current_position_x = self.current_position_x + 1
            self.notification_hero_moved()
        elseif self.current_command == HeroCommands.move_left then 
            self.current_position_x = self.current_position_x - 1
            self.notification_hero_moved()
        elseif self.current_command == HeroCommands.move_up then
            self.current_position_y = self.current_position_y - 1
            self.notification_hero_moved()
        elseif self.current_command == HeroCommands.move_down then
            self.current_position_y = self.current_position_y + 1
            self.notification_hero_moved()
        end
    end
    
    function self.draw(map_tile_size)
        if self.current_command == HeroCommands.move_right then
            draw_move_right_indicator(map_tile_size)
        elseif self.current_command == HeroCommands.move_left then 
            draw_move_left_indicator(map_tile_size)
        elseif self.current_command == HeroCommands.move_up then
            draw_move_up_indicator(map_tile_size)
        elseif self.current_command == HeroCommands.move_down then
            draw_move_down_indicator(map_tile_size)
        elseif self.current_command == HeroCommands.hold_position then
            draw_hold_position_indicator(map_tile_size)
        elseif self.current_command == HeroCommands.auto_attack then
            draw_auto_attack_indicator(map_tile_size)
        end
    
        if self.is_in_focus then
            love.graphics.setColor(1, 1, 1)
        else
            love.graphics.setColor(0.5, 0.5, 0.5)
        end
        love.graphics.rectangle(
            "fill",
            (map_tile_size / 2) - (size / 3) + (self.current_position_x * map_tile_size),
            (map_tile_size / 2) - (size / 3) + (self.current_position_y * map_tile_size),
            size,
            size)
        
        --[[self.health_points:draw(
            (map_tile_size / 2) - (size / 3) + (self.current_position_x * map_tile_size) + (size / 2),
            (map_tile_size / 2) - (size / 3) + (self.current_position_y * map_tile_size) + 5)]]
    
        love.graphics.setColor(0, 0, 0)
        love.graphics.print(
            self.name, 
            ((self.current_position_x * map_tile_size) + (map_tile_size / 2) + 1), 
            ((self.current_position_y * map_tile_size) + (map_tile_size / 2)) - 3)
    end
    
    return self

 end

 return Hero
