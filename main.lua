if os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then
    require("lldebugger").start()
end

local MapModule = require "map"
local timer = require "timer"
local HeroModule = require "hero"
local heroCommands = require "hero_commands"
local gameCommands = require "game_commands"

local test_map = MapModule:new()
local hero_in_focus = {}
local hero_selected = gameCommands.select_hero_1

local heroes = {}

function love.load()
    love.keyboard.setKeyRepeat(false)

    timer.experation_callback = game_execution_timer_tick

    for i = 1, 2 do
        local new_hero = HeroModule:new()
        new_hero.uid = i
        new_hero.current_position_x = i
        new_hero.current_position_y = 1

        new_hero.name = tostring(i)

        new_hero.notification_hero_moved = hero_did_move
        new_hero.notification_ability_used = ability_was_used
        new_hero.notification_did_die = hero_died

        table.insert(heroes, new_hero)
    end

    test_map.heroes = heroes
    test_map:update_vision(heroes)

    hero_in_focus = heroes[1]
    hero_in_focus.is_in_focus = true
end

function love.update(dt)
    timer:time_passed(dt)
end

function love.draw()
    test_map:draw()
    for index, hero in pairs(heroes) do
        hero:draw(test_map.tile_size)
    end
    timer:draw()
end

function love.keypressed(key)
    if heroCommands:is_hero_command(key) then
        hero_in_focus:set_current_command(key)
    elseif gameCommands:is_game_command(key) then 
        if hero_selected ~= key and #heroes >= tonumber(key) then
            hero_in_focus.is_in_focus = false
            if key == gameCommands.select_hero_1 then
                hero_in_focus = heroes[1]
                hero_selected = gameCommands.select_hero_1
            elseif key == gameCommands.select_hero_2 then
                hero_in_focus = heroes[2]
                hero_selected = gameCommands.select_hero_2
            end
            hero_in_focus.is_in_focus = true
        end
    end
end

function game_execution_timer_tick()
    for index, hero in pairs(heroes) do
        hero:execute_current_command(test_map:hero_can_execute_command(hero))
    end
end

function hero_did_move()
    test_map:update_vision(heroes)
end 

function ability_was_used(hero, action, direction, range)
    test_map:check_ability_colision(hero, action, direction, range)
end

function hero_died(dead_hero)
    for index, hero in pairs(heroes) do
        if dead_hero.uid == hero.uid then
            table.remove(heroes, index)
            test_map.heroes = heroes
            test_map:update_vision(heroes)
        end
    end
end