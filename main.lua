local Map = require "map"
local Hero = require "hero"
local Timer = require "timer"
local Hero1 = Hero:new()
local Hero2 = Hero:new()
local HeroCommands = require "hero_commands"
local GameCommands = require "game_commands"


local hero_in_focus = {}
local hero_selected = GameCommands.select_hero_1

function love.load()
    love.keyboard.setKeyRepeat(false)

    Timer.experation_callback = game_tick_occured

    Hero1.current_position_x = 0
    Hero1.current_position_y = 0
    Hero1.notification_hero_moved = vision_update_needed()
    Hero1.name = "1"

    Hero2.current_position_x = 1
    Hero2.current_position_y = 0
    Hero2.notification_hero_moved = vision_update_needed()
    Hero2.name = "2"

    Map.heroes = {Hero1, Hero2}
    vision_update_needed()

    hero_in_focus = Hero1
    hero_in_focus.is_in_focus = true
end

function love.update(dt)
    Timer:time_passed(dt)
end

function love.draw()
    Map:draw()
    Hero1:draw(Map.tile_size)
    Hero2:draw(Map.tile_size)
    Timer:draw()
end

function love.keypressed(key)
    if HeroCommands:is_hero_command(key) then
        hero_in_focus:set_current_command(key)
    elseif GameCommands:is_game_command(key) then 
        if hero_selected ~= key then
            hero_in_focus.is_in_focus = false
            if key == GameCommands.select_hero_1 then
                hero_in_focus = Hero1
                hero_selected = GameCommands.select_hero_1
            elseif key == GameCommands.select_hero_2 then
                hero_in_focus = Hero2
                hero_selected = GameCommands.select_hero_2
            end
            hero_in_focus.is_in_focus = true
        end
    end
end

function game_tick_occured()
    -- just inform the map it can take care of it
    Hero1:execute_current_command(Map:hero_can_exicute_command(Hero1))
    Hero2:execute_current_command(Map:hero_can_exicute_command(Hero2))
end

function vision_update_needed()
    -- this can be taken care of in the map
    Map:update_vision({Hero1, Hero2})
end