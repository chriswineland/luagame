local GameCommands = {
    select_hero_1 = "1",
    select_hero_2 = "2",
    select_hero_3 = "3"
}

function GameCommands:is_game_command(command)
    for index, value in pairs(self) do
        if value == command then
            return true
        end
    end
    return false
end

return GameCommands