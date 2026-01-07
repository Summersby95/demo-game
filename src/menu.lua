-- src/menu.lua
local UI = require("src/ui")
local Menu = {}
Menu.__index = Menu

function Menu.new(callbacks)
    local self = setmetatable({}, Menu)
    self.callbacks = callbacks -- start, continue, theme, quit
    self.buttons = {}
    self.themeName = ""
    
    local w = love.graphics.getWidth()
    local cx = w / 2
    local btnW, btnH = 200, 60
    local startY = 300
    local gap = 80
    
    -- Initialize buttons
    self.btnContinue = UI.Button.new("Continue", cx - btnW/2, startY, btnW, btnH, function()
        if self.callbacks.continueGame then self.callbacks.continueGame() end
    end)
    self.btnContinue.disabled = true -- Default disabled
    
    self.btnNew = UI.Button.new("New Game", cx - btnW/2, startY + gap, btnW, btnH, function()
        if self.callbacks.newGame then self.callbacks.newGame() end
    end)
    
    self.btnTheme = UI.Button.new("Theme", cx - btnW/2, startY + gap*2, btnW, btnH, function()
        if self.callbacks.changeTheme then self.callbacks.changeTheme() end
    end)
    
    self.btnQuit = UI.Button.new("Quit", cx - btnW/2, startY + gap*3, btnW, btnH, function()
        love.event.quit()
    end)
    
    self.buttons = {self.btnContinue, self.btnNew, self.btnTheme, self.btnQuit}
    return self
end

function Menu:setCanContinue(can)
    self.btnContinue.disabled = not can
end

function Menu:update(dt)
    for _, btn in ipairs(self.buttons) do
        btn:update(dt)
    end
end

function Menu:mousepressed(x, y, button)
    if button == 1 then
        for _, btn in ipairs(self.buttons) do
            if btn:click() then break end
        end
    end
end

function Menu:draw(theme)
    local w = love.graphics.getWidth()
    
    -- Title
    love.graphics.setColor(theme.text)
    love.graphics.setFont(love.graphics.newFont(60))
    love.graphics.printf("2048", 0, 100, w, "center")
    
    love.graphics.setFont(love.graphics.newFont(30))
    love.graphics.printf(theme.name, 0, 180, w, "center")
    
    -- Buttons
    for _, btn in ipairs(self.buttons) do
        btn:draw(theme)
    end
end

return Menu
