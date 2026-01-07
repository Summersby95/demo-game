-- src/ui.lua
local UI = {}

local Button = {}
Button.__index = Button

function Button.new(text, x, y, w, h, action)
    local self = setmetatable({}, Button)
    self.text = text
    self.x = x
    self.y = y
    self.w = w
    self.h = h
    self.action = action
    
    -- Animation state
    self.scale = 1.0
    self.hovered = false
    self.disabled = false
    
    return self
end

function Button:update(dt)
    local mx, my = love.mouse.getPosition()
    self.hovered = mx >= self.x and mx <= self.x + self.w and
                   my >= self.y and my <= self.y + self.h
                   
    -- Tween scale
    local targetScale = self.hovered and 1.05 or 1.0
    if self.disabled then targetScale = 1.0 end
    
    self.scale = self.scale + (targetScale - self.scale) * 15 * dt
end

function Button:draw(theme)
    local cx = self.x + self.w / 2
    local cy = self.y + self.h / 2
    
    love.graphics.push()
    love.graphics.translate(cx, cy)
    love.graphics.scale(self.scale)
    love.graphics.translate(-cx, -cy)
    
    -- Background
    if self.disabled then
         love.graphics.setColor(0.5, 0.5, 0.5, 0.5)
    else
         -- Use theme colors or default white with opacity
         love.graphics.setColor(1, 1, 1, 0.85)
         if self.hovered then love.graphics.setColor(1, 1, 1, 1) end
    end
    
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.h, 10, 10)
    
    -- Text
    love.graphics.setColor(theme.text)
    if self.text == "Quit" then love.graphics.setColor(0, 0, 0) end -- Force contrast for white buttons
    -- Or just use theme.text if it contrasts well. 
    -- Let's hardcode black text for white buttons for readability
    love.graphics.setColor(0.1, 0.1, 0.1)
    if self.disabled then love.graphics.setColor(0.3, 0.3, 0.3) end
    
    local font = love.graphics.getFont()
    local tw = font:getWidth(self.text)
    local th = font:getHeight()
    love.graphics.print(self.text, self.x + (self.w - tw)/2, self.y + (self.h - th)/2)
    
    love.graphics.pop()
end

function Button:click()
    if not self.disabled and self.hovered and self.action then
        self.action()
        return true
    end
    return false
end

UI.Button = Button
return UI
