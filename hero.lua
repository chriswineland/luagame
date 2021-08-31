local Direction = require "direction"
local HeroCommands = require "hero_commands"

local Hero = {}

Hero.uid = 0
Hero.name = ""
Hero.sprite_name = ""
Hero.speed = 0
Hero.size = 32
Hero.vision_distance = 2
Hero.current_command = HeroCommands.hold_position
Hero.current_direction = Direction.North
Hero.is_in_focus = false
Hero.current_position_x = 0
Hero.current_position_y = 0
Hero.notification_hero_moved = function() end

function Hero:new(uid)
    new_obj = {}
    setmetatable(new_obj, self)
    self.__index = self
    new_obj.uid = uid
    return new_obj
 end

function Hero:set_current_command(command)
    if command == HeroCommands.move_right then
        self.current_command = HeroCommands.move_right
        self.current_direction = Direction.East
    elseif command == HeroCommands.move_left then 
        self.current_command = HeroCommands.move_left
        self.current_direction = Direction.West
    elseif command == HeroCommands.move_up then
        self.current_command = HeroCommands.move_up
        self.current_direction = Direction.North
    elseif command == HeroCommands.move_down then
        self.current_command = HeroCommands.move_down
        self.current_direction = Direction.South
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

function Hero:execute_current_command(permision)
    if not permision then
        self.current_command = hold_position
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

function Hero:draw(map_tile_size)
    if self.current_command == HeroCommands.move_right then
        self:draw_move_right_indicator(map_tile_size)
    elseif self.current_command == HeroCommands.move_left then 
        self:draw_move_left_indicator(map_tile_size)
    elseif self.current_command == HeroCommands.move_up then
        self:draw_move_up_indicator(map_tile_size)
    elseif self.current_command == HeroCommands.move_down then
        self:draw_move_down_indicator(map_tile_size)
    elseif self.current_command == HeroCommands.hold_position then
        self:draw_hold_position_indicator(map_tile_size)
    elseif self.current_command == HeroCommands.auto_attack then
        self:draw_auto_attack_indicator(map_tile_size)
    end

    if self.is_in_focus then
        love.graphics.setColor(1, 1, 1)
    else
        love.graphics.setColor(0.5, 0.5, 0.5)
    end
    love.graphics.rectangle(
        "fill",
        (map_tile_size / 2) - (self.size / 3) + (self.current_position_x * map_tile_size),
        (map_tile_size / 2) - (self.size / 3) + (self.current_position_y * map_tile_size),
        self.size,
        self.size)

    love.graphics.setColor(0, 0, 0)
    love.graphics.print(
        self.name, 
        ((self.current_position_x * map_tile_size) + (map_tile_size / 2) + 1), 
        ((self.current_position_y * map_tile_size) + (map_tile_size / 2)) - 3)
end

function Hero:draw_move_left_indicator(map_tile_size)
    love.graphics.setColor(0, 1, 0)
    love.graphics.circle(
        "fill",
        13 + (self.current_position_x * map_tile_size),
        5 + (map_tile_size / 2) + (self.current_position_y * map_tile_size),
        5)
end

function Hero:draw_move_right_indicator(map_tile_size)
    love.graphics.setColor(0, 1, 0)
    love.graphics.circle(
        "fill",
        ((self.current_position_x + 1) * map_tile_size) - 3,
        5 + (map_tile_size / 2) + (self.current_position_y * map_tile_size),
        5)
end

function Hero:draw_move_up_indicator(map_tile_size)
    love.graphics.setColor(0, 1, 0)
    love.graphics.circle(
        "fill",
        5 + (map_tile_size / 2) + (self.current_position_x * map_tile_size),
        14 + (self.current_position_y * map_tile_size),
        5)
end

function Hero:draw_move_down_indicator(map_tile_size)
    love.graphics.setColor(0, 1, 0)
    love.graphics.circle(
        "fill",
        5 + (map_tile_size / 2) + (self.current_position_x * map_tile_size),
        ((self.current_position_y + 1) * map_tile_size) - 3,
        5)
end

function Hero:draw_hold_position_indicator(map_tile_size)
    love.graphics.setColor(1, 0.65, 0)
    love.graphics.rectangle(
        "fill",
        18 + (self.current_position_x * map_tile_size),
        ((self.current_position_y + 1) * map_tile_size) - 6,
        map_tile_size * 0.6,
        5)
end

function Hero:draw_auto_attack_indicator(map_tile_size)
    love.graphics.setColor(0, 0, 1)
    if self.current_direction == Direction.North then
        love.graphics.circle(
            "fill",
            5 + (map_tile_size / 2) + (self.current_position_x * map_tile_size),
            14 + (self.current_position_y * map_tile_size),
            5)
    elseif self.current_direction == Direction.East then
        love.graphics.circle(
            "fill",
            ((self.current_position_x + 1) * map_tile_size) - 3,
            5 + (map_tile_size / 2) + (self.current_position_y * map_tile_size),
            5)
    elseif self.current_direction == Direction.South then
        love.graphics.circle(
            "fill",
            5 + (map_tile_size / 2) + (self.current_position_x * map_tile_size),
            ((self.current_position_y + 1) * map_tile_size) - 3,
            5)
    elseif self.current_direction == Direction.West then
        love.graphics.circle(
            "fill",
            13 + (self.current_position_x * map_tile_size),
            5 + (map_tile_size / 2) + (self.current_position_y * map_tile_size),
            5)
    end
end

return Hero