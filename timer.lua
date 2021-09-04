local Timer = {
    default_duration = 5,
    duration = 5,
    experation_callback = function() end
}

function Timer:time_passed(dt)
    self.duration = self.duration - dt
    if self.duration <= 0 then
        self.experation_callback()
        self.duration = self.default_duration
    end
end

function Timer:draw()
    local timer_height = 100
    local timer_width = 60

    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle(
        "line", 
        480, 
        80, 
        timer_width, 
        timer_height)
    love.graphics.rectangle(
        "fill", 
        480, 
        80 + timer_height - (timer_height * (self.duration / self.default_duration)), 
        timer_width, timer_height * (self.duration / self.default_duration))
end

return Timer