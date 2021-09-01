local HealthPoints = {}

HealthPoints.health_capacity = 0
HealthPoints.current_health = 0
HealthPoints.over_shield = 0
HealthPoints.notification_did_die = function() end

function HealthPoints:new(health, capacity, shield, did_die)
    new_obj = {}
    setmetatable(new_obj, self)
    self.__index = self
    new_obj.health_capacity = capacity
    new_obj.current_health = health
    new_obj.over_shield = shield
    new_obj.notification_did_die = did_die
    return new_obj
end

function HealthPoints:add_health_capacity(amount)
end

function HealthPoints:remove_health_capacity(amount)
end

function HealthPoints:add_health(amount)
end

function HealthPoints:remove_health(amount)
end

function HealthPoints:add_shield(amount)
end

function HealthPoints:remove_shield(amount, does_bleed_into_health)
end

function HealthPoints:check_for_death()
    if self.current_health <= 0 then
        self.notification_did_die()
    end
end

return HealthPoints