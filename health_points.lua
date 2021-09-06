--[[
    HealthPoints Module
    Chris Wineland
    2021-09-05
]]

-- private vars
local defalut_draw_width = 28
local defalut_draw_height = 6

local HealthPoints = {
    health_capacity = 30,
    current_health = 30,
    over_shield = 0,
    draw_width = defalut_draw_width,
    draw_height = defalut_draw_height,
    represented_hero = nil,
    notification_did_die = function() end
}   

function HealthPoints:new(template)
    template = template or {}
    setmetatable(template, self)
    self.__index = self
    return template
end

function HealthPoints:draw(center_x, center_y)
    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle(
        "fill",
        center_x - (self.draw_width / 2),
        center_y - (self.draw_height / 2),
        self.draw_width,
        self.draw_height)

    love.graphics.setColor(0, 1, 0)
    love.graphics.rectangle(
        "fill",
        center_x - (self.draw_width / 2),
        center_y - (self.draw_height / 2),
        self.draw_width * (self.current_health / self.health_capacity),
        self.draw_height)

end

function HealthPoints:add_health_capacity(amount)
    if amount < 0 then
        self:remove_health_capacity(amount * -1)
    elseif amount > 0 then
        self.health_capacity = self.health_capacity + amount
    end
end

function HealthPoints:remove_health_capacity(amount)
    if amount < 0 then
        self:add_health_capacity(amount * -1)
    elseif amount > 0 then
        self.health_capacity = self.health_capacity - amount
        if self.health_capacity > self.current_health then
            self.current_health = self.health_capacity
            self:check_for_death()
        end
    end
end

function HealthPoints:add_health(amount)
    if amout < 0 then
        self:remove_health(amount * -1)
    elseif amount > 0 then
        if (self.current_health + amount) > self.health_capacity then
            self.current_health = self.health_capacit
        else
            self.current_health = self.current_health + amount
        end
    end
end

function HealthPoints:remove_health(amount, ignores_shield)
    if ignores_shield or self.over_shield == 0 then
        if amount < 0 then
            self:add_health(amount * -1)
        elseif amount > 0 then
            self.current_health = self.current_health - amount
            self:check_for_death()
        end
    else
        self:remove_shield(amount, true)
    end
end

function HealthPoints:add_shield(amount)
    if amount < 0 then
        self:remove_shield(amount * -1)
    elseif amount > 0 then
        self.over_shield = self.over_shield + amount
    end
end

function HealthPoints:remove_shield(amount, does_bleed_into_health)
    if amount < 0 then
        self:add_shield(amount * -1)
    elseif amount > 0 then
        if amount <= self.over_shield then
            self.over_shield = self.over_shield - amount
        elseif does_bleed_into_health then
            bleed_damage = amount - over_shield
            over_shield = 0
            self:remove_health(bleed_damage)
        else
            self.over_shield = 0
        end
    end
end

function HealthPoints:check_for_death()
    if self.current_health <= 0 then
        self.notification_did_die(self.represented_hero)
    end
end

return HealthPoints
