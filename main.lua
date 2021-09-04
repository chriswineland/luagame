if os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then
    require("lldebugger").start()
end

local MapModule = require "map"
local test_map = MapModule:new()

local timer = require "timer"

local HeroModule = require "hero"
local hero1 = HeroModule:new()
local hero2 = HeroModule:new()

local heroCommands = require "hero_commands"
local gameCommands = require "game_commands"


local hero_in_focus = {}
local hero_selected = gameCommands.select_hero_1

function love.load()
    love.keyboard.setKeyRepeat(false)

    timer.experation_callback = game_execution_timer_tick

    hero1.current_position_x = 1
    hero1.current_position_y = 1
    hero1.name = "1"

    hero2.current_position_x = 2
    hero2.current_position_y = 1
    hero2.name = "2"

    hero1.notification_hero_moved = hero_did_move
    hero2.notification_hero_moved = hero_did_move

    test_map.heroes = {hero1, hero2}
    test_map:update_vision({hero1, hero2})

    hero_in_focus = hero1
    hero_in_focus.is_in_focus = true
end

function love.update(dt)
    timer:time_passed(dt)
end

function love.draw()
    test_map:draw()
    hero1:draw(test_map.tile_size)
    hero2:draw(test_map.tile_size)
    timer:draw()
end

function love.keypressed(key)
    if heroCommands:is_hero_command(key) then
        hero_in_focus:set_current_command(key)
    elseif gameCommands:is_game_command(key) then 
        if hero_selected ~= key then
            hero_in_focus.is_in_focus = false
            if key == gameCommands.select_hero_1 then
                hero_in_focus = hero1
                hero_selected = gameCommands.select_hero_1
            elseif key == gameCommands.select_hero_2 then
                hero_in_focus = hero2
                hero_selected = gameCommands.select_hero_2
            end
            hero_in_focus.is_in_focus = true
        end
    end
end

function game_execution_timer_tick()
    hero1:execute_current_command(test_map:hero_can_execute_command(hero1))
    hero2:execute_current_command(test_map:hero_can_execute_command(hero2))
end

function hero_did_move()
    test_map:update_vision({hero1, hero2})
end 