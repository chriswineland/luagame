-- meta class
local HealthPoints = {
    health_capacity = 30,
    current_health = 30,
    over_shield = 0,
    notification_did_die = function() end
}   

-- derived class new
function HealthPoints:new(input)
    new_obj = {}
    if input then
        new_obj = input
    end
    setmetatable(new_obj, self)
    self.__index = self
    return new_obj
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

function HealthPoints:remove_health(amount)
    if amount < 0 then
        self:add_health(amount * -1)
    elseif amount > 0 then
        self.current_health = self.current_health - amount
        self:check_for_death()
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
        self.notification_did_die()
    end
end

return HealthPoints
