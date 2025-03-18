SCREENMAN = {}
SCREENMAN.logMessage = ""
SCREENMAN.logTime = 0
SCREENMAN.logTimeLimit = 1
SCREENMAN.logFont = love.graphics.newFont(12)
SCREENMAN.logFont:setFilter("nearest", "nearest")


function SCREENMAN.draw()
    if SCREENMAN.logMessage ~= "" and love.timer.getTime() < SCREENMAN.logTimeLimit then
        love.graphics.setColor(0, 0, 0, 0.5)
        love.graphics.rectangle("fill", 10, 10, love.graphics.getWidth() - 20, SCREENMAN.logFont:getHeight() + 20)
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.setFont(SCREENMAN.logFont)
        love.graphics.print(SCREENMAN.logMessage, 10, 10)
    end
end

function SCREENMAN:log(message)
    SCREENMAN.logMessage = message
    SCREENMAN.logTime = love.timer.getTime()
    SCREENMAN.logTimeLimit = love.timer.getTime() + SCREENMAN.logTimeLimit
end

function SCREENMAN.update()
    if love.timer.getTime() > SCREENMAN.logTimeLimit then
        SCREENMAN.logMessage = ""
    end
end