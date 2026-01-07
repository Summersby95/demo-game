-- src/game.lua
local UI = require("src/ui")
local Game = {}
Game.__index = Game

function Game.new(themeIdx)
    local self = setmetatable({}, Game)
    self.grid = {}
    self.tiles = {} 
    self.gridSize = 4
    self.cellSize = 120
    self.padding = 15
    self.score = 0
    self.gameOver = false
    
    -- Layout
    local w = love.graphics.getWidth()
    local totalWidth = (self.cellSize + self.padding) * self.gridSize + self.padding
    self.startX = (w - totalWidth) / 2
    self.startY = 120
    
    -- UI
    self.menuBtn = UI.Button.new("MENU", w - 120, 30, 100, 40, nil) -- Action attached later
    
    self:reset()
    return self
end

function Game:reset()
    self.grid = {}
    self.tiles = {}
    for y = 1, self.gridSize do
        self.grid[y] = {}
        for x = 1, self.gridSize do
            self.grid[y][x] = 0
        end
    end
    self.score = 0
    self.gameOver = false
    self:spawnTile()
    self:spawnTile()
end

function Game:spawnTile()
    local empties = {}
    for y = 1, self.gridSize do
        for x = 1, self.gridSize do
            if self.grid[y][x] == 0 then
                table.insert(empties, {x=x, y=y})
            end
        end
    end
    
    if #empties > 0 then
        local choice = empties[love.math.random(#empties)]
        local val = love.math.random() < 0.9 and 2 or 4
        self.grid[choice.y][choice.x] = val
        
        local t = {
            value = val,
            x = choice.x,
            y = choice.y,
            visualX = self.startX + self.padding + (choice.x - 1) * (self.cellSize + self.padding),
            visualY = self.startY + self.padding + (choice.y - 1) * (self.cellSize + self.padding),
            scale = 0
        }
        table.insert(self.tiles, t)
    end
end

function Game:getTileAt(x, y)
    for _, tile in ipairs(self.tiles) do
        if tile.x == x and tile.y == y and not tile.remove and not tile.mergingInto then
            return tile
        end
    end
    return nil
end

function Game:update(dt)
    self.menuBtn:update(dt)
    
    for i = #self.tiles, 1, -1 do
        local tile = self.tiles[i]
        
        -- Lerp Position
        local destX = self.startX + self.padding + (tile.x - 1) * (self.cellSize + self.padding)
        local destY = self.startY + self.padding + (tile.y - 1) * (self.cellSize + self.padding)
        
        local diffX = destX - tile.visualX
        local diffY = destY - tile.visualY
        
        tile.visualX = tile.visualX + diffX * 20 * dt
        tile.visualY = tile.visualY + diffY * 20 * dt
        
        -- Merge Logic
        if math.abs(diffX) < 1 and math.abs(diffY) < 1 then
            tile.visualX = destX
            tile.visualY = destY
            
            if tile.mergeTarget then
                 -- Fixed: Use stored result from moving tile to prevent nil race condition
                 if tile.mergeResult then
                     tile.mergeTarget.value = tile.mergeResult
                 end
                 tile.mergeTarget.scale = 1.2
                 tile.remove = true 
            end
            
            if tile.remove then table.remove(self.tiles, i) end
        end
        
        -- Lerp Scale
        local targetScale = 1.0
        if tile.scale < 1 then
            tile.scale = tile.scale + (targetScale - tile.scale) * 15 * dt
        elseif tile.scale > 1 then
            tile.scale = tile.scale + (targetScale - tile.scale) * 15 * dt
        end
    end
end

function Game:isGameOver()
    for y = 1, self.gridSize do
        for x = 1, self.gridSize do
            if self.grid[y][x] == 0 then return false end
        end
    end
    for y = 1, self.gridSize do
        for x = 1, self.gridSize do
            local val = self.grid[y][x]
            if x < self.gridSize and self.grid[y][x+1] == val then return false end
            if y < self.gridSize and self.grid[y+1][x] == val then return false end
        end
    end
    return true
end

function Game:move(dx, dy)
    if self.gameOver then return end
    
    local moved = false
    local mergedFlags = {}
    
    local xStart, xEnd, xStep = 1, self.gridSize, 1
    local yStart, yEnd, yStep = 1, self.gridSize, 1
    
    if dx == 1 then xStart, xEnd, xStep = self.gridSize, 1, -1 end
    if dy == 1 then yStart, yEnd, yStep = self.gridSize, 1, -1 end
    
    for y = yStart, yEnd, yStep do
        for x = xStart, xEnd, xStep do
            if self.grid[y][x] ~= 0 then
                local val = self.grid[y][x]
                local cx, cy = x, y
                
                while true do
                    local nx, ny = cx + dx, cy + dy
                    if nx < 1 or nx > self.gridSize or ny < 1 or ny > self.gridSize then break end
                    
                    if self.grid[ny][nx] == 0 then
                        self.grid[ny][nx] = val
                        self.grid[cy][cx] = 0
                        local t = self:getTileAt(cx, cy)
                        if t then t.x, t.y = nx, ny end
                        cx, cy = nx, ny
                        moved = true
                    elseif self.grid[ny][nx] == val and not mergedFlags[ny*self.gridSize+nx] then
                        local newVal = val * 2
                        self.grid[ny][nx] = newVal
                        self.grid[cy][cx] = 0
                        self.score = self.score + newVal
                        local tMoving = self:getTileAt(cx, cy)
                        local tStationary = self:getTileAt(nx, ny)
                        
                        -- Fixed: Don't set nextValue on stationary. Move result to moving tile.
                        if tMoving then
                            tMoving.x, tMoving.y = nx, ny
                            tMoving.mergeTarget = tStationary
                            tMoving.mergingInto = true
                            tMoving.mergeResult = newVal
                        end
                        mergedFlags[ny*self.gridSize+nx] = true
                        moved = true
                        break
                    else
                        break
                    end
                end
            end
        end
    end
    
    if moved then
        self:spawnTile()
        if self:isGameOver() then
            self.gameOver = true
        end
    end
end

function Game:keypressed(key)
    if self.gameOver then
        if key == "r" or key == "return" then self:reset() end
        return
    end
    if key == "up" or key == "w" then self:move(0, -1) end
    if key == "down" or key == "s" then self:move(0, 1) end
    if key == "left" or key == "a" then self:move(-1, 0) end
    if key == "right" or key == "d" then self:move(1, 0) end
end

function Game:mousepressed(x, y, btn)
    self.menuBtn:click()
end

function Game:draw(theme)
    -- Header
    love.graphics.setColor(theme.score)
    love.graphics.setFont(love.graphics.newFont(40))
    love.graphics.print("SCORE: " .. self.score, 20, 30)
    levelText = "Theme: " .. theme.name
    love.graphics.setFont(love.graphics.newFont(16))
    love.graphics.print(levelText, 20, 80)
    
    -- UI
    self.menuBtn:draw(theme)
    
    -- Grid
    love.graphics.setColor(theme.grid)
    local gridW = (self.cellSize + self.padding) * self.gridSize + self.padding
    love.graphics.rectangle("fill", self.startX, self.startY, gridW, gridW, 10, 10)
    
    -- Empties
    for y = 1, self.gridSize do
        for x = 1, self.gridSize do
            local tx = self.startX + self.padding + (x-1) * (self.cellSize + self.padding)
            local ty = self.startY + self.padding + (y-1) * (self.cellSize + self.padding)
            love.graphics.setColor(theme.empty)
            love.graphics.rectangle("fill", tx, ty, self.cellSize, self.cellSize, 5, 5)
        end
    end
    
    -- Tiles
    local font = love.graphics.newFont(40)
    love.graphics.setFont(font)
    for _, tile in pairs(self.tiles) do
        local x, y = tile.visualX, tile.visualY
        local size = self.cellSize * tile.scale
        local offset = (self.cellSize - size) / 2
        
        local c = theme.tiles[tile.value] or theme.tiles[2048]
        love.graphics.setColor(c)
        love.graphics.rectangle("fill", x + offset, y + offset, size, size, 5, 5)
        
        if tile.value > 0 then
            love.graphics.setColor(theme.text)
            -- Theme specific tweaks
             if theme.name == "Bob-omb Battlefield" and (tile.value == 2 or tile.value == 4) then
                 love.graphics.setColor(0.2, 0.2, 0.2)
            end
            if theme.name == "Cool, Cool Mountain" then
                love.graphics.setColor(0, 0, 0.5)
            end
            
            local text = tostring(tile.value)
            local tw = font:getWidth(text)
            local th = font:getHeight()
            love.graphics.print(text, x + offset + (size - tw)/2, y + offset + (size - th)/2)
        end
    end
    
    if self.gameOver then
        love.graphics.setColor(0, 0, 0, 0.8)
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
        love.graphics.setColor(1, 1, 1)
        love.graphics.setFont(love.graphics.newFont(60))
        love.graphics.printf("GAME OVER", 0, 250, love.graphics.getWidth(), "center")
        love.graphics.setFont(love.graphics.newFont(30))
        love.graphics.printf("Score: " .. self.score, 0, 350, love.graphics.getWidth(), "center")
        love.graphics.printf("Press R to Restart", 0, 400, love.graphics.getWidth(), "center")
    end
end

return Game
