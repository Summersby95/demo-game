-- 2048: Super Mario 64 Edition
-- Refactored Entry Point

local Theme = require("src/theme")
local Game = require("src/game")
local Menu = require("src/menu")

local state = "MENU" -- MENU, PLAYING
local currentThemeIdx = 1

local game = nil
local menu = nil

function love.load()
    love.window.setTitle("2048: SM64 Edition")
    
    -- Initialize Game (but don't start yet if we want clean state, 
    -- actually Game.new() starts a fresh game. 
    -- We'll create it on "New Game".)
    
    -- Callbacks for Menu
    local callbacks = {
        newGame = function()
            game = Game.new(currentThemeIdx)
            state = "PLAYING"
        end,
        continueGame = function()
            if game then
                state = "PLAYING"
            end
        end,
        changeTheme = function()
            currentThemeIdx = currentThemeIdx + 1
            if currentThemeIdx > #Theme.themes then currentThemeIdx = 1 end
        end
    }
    
    menu = Menu.new(callbacks)
    
    -- Set menu button action in Game to return to menu
    -- We need a way to hook this up since Game is created dynamically.
    -- We'll handle this in love.update or wrap Game creation.
end

-- Helper to ensure game has reference to menu return
function checkGameMenuAction()
    if game and not game.menuBtn.action then
        game.menuBtn.action = function()
            state = "MENU"
        end
    end
end

function love.update(dt)
    if state == "MENU" then
        menu:setCanContinue(game ~= nil and not game.gameOver)
        menu:update(dt)
    elseif state == "PLAYING" then
        checkGameMenuAction()
        if game then game:update(dt) end
    end
end

function love.draw()
    local theme = Theme.themes[currentThemeIdx]
    love.graphics.setBackgroundColor(theme.background)
    
    if state == "MENU" then
        menu:draw(theme)
    elseif state == "PLAYING" then
        if game then game:draw(theme) end
    end
end

function love.mousepressed(x, y, button, istouch, presses)
    if state == "MENU" then
        menu:mousepressed(x, y, button)
    elseif state == "PLAYING" then
        if game then game:mousepressed(x, y, button) end
    end
end

function love.keypressed(key)
    if state == "PLAYING" then
        if game then game:keypressed(key) end
        if key == "escape" then state = "MENU" end
    else
        -- Optional keyboard nav for menu could go here
        if key == "escape" then love.event.quit() end
    end
end
