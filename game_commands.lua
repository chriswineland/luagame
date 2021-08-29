local GameCommands = {
    select_hero_1 = "1",
    select_hero_2 = "2"
}

function GameCommands:is_game_command(command)
    local t = {"1", "2"}
    for index, value in ipairs(t) do
        if value == command then
            return true
        end
    end
    return false
end

return GameCommands