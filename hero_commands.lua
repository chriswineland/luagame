local HeroCommands = {
    move_up = "w",
    move_right = "d",
    move_down = "s",
    move_left = "a",
    hold_position = "space",
    auto_attack = "q",
    ability_1 = "e",
    ability_2 = "r",
    ability_3 = "t"
}

function HeroCommands:is_hero_command(command)
    local t = {"w", "d", "s", "a", "q", "e", "r", "t", "space"}
    for index, value in ipairs(t) do
        if value == command then
            return true
        end
    end
    return false
end

return HeroCommands