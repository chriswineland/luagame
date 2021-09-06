--[[
    Damage Calculations Module
    Chris Wineland
    2021-09-06
]]

local DamageType = require "damage_type"

local DamageCalculations = {}

function DamageCalculations.deal_damage_to_target(damage_type, damage_amount, target)
    if damage_type == DamageType.physical then
        local calculated_damage = damage_amount - target.armor
        if calculated_damage > 0 then
            target.health_points:remove_health(calculated_damage, false)
        else 
            --completely resisted damage, prob do some sort of notification
        end
    elseif damage_type == DamageType.magical then
        local calculated_damage = damage_amount - target.magic_resist
        if calculated_damage > 0 then
            target.health_points.remove_health(calculated_damage, false)
        else 
            --completely resisted damage, prob do some sort of notification
        end
    elseif damage_type == DamageType.true_damage then
        target.health_points.remove_health(damage_amount, true)
    end
end

return DamageCalculations
