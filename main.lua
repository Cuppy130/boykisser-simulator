require("modules.button")
click_sound = love.audio.newSource("assets/click.mp3", "static")

local linkHovered = false
local linkClicked = false

local screens = {
    current = 'screen_mainMenu',
    'screen_mainMenu',
    'screen_options'
}

local buttons = {
    screen_mainMenu = {
        buttons = {
            Button.new("Start", 10, 40, 100, 50, function()
                click_sound:play()
                screens.current = 'screen_game'
            end),
            Button.new("Options", 10, 100, 100, 50, function()
                click_sound:play()
                screens.current = 'screen_options'
            end),
            Button.new("Exit", 10, 160, 100, 50, function()
                love.event.quit()
            end)
        }
    },
    screen_options = {
        buttons = {
            Button.new("Back", 10, 40, 100, 50, function()
                click_sound:play()
                screens.current = 'screen_mainMenu'
            end)
        }
    }
}

backgroundAudio = love.audio.newSource("assets/Cats.ogg", "stream")
boykisserTexture = love.graphics.newImage("assets/boykisser.png")
boykisserTexture:setWrap("repeat", "repeat")
boykisserTexture:setFilter("nearest", "nearest")



local boykisser = love.graphics.newShader [[
    extern number time;
    vec4 effect(vec4 color, Image img, vec2 texture_coords, vec2 pixel_coords){
        vec2 tex = texture_coords;
        tex *= 10.0;

        tex.x += time;
        tex.y += sin(time) * 2;
        vec4 pixel = Texel(img, tex);
        // return the pixel color
        return pixel;
    }
]]

backgroundAudio:setVolume(0.05)

function love.load()
    backgroundAudio:play()
    backgroundAudio:setLooping(true)
end

function love.draw()


    if buttons[screens.current] == nil then
        love.graphics.setColor(1, 0, 0)
        love.graphics.print("Screen " .. screens.current .. " does not exist", 10, 10)
        return
    end

    
    love.graphics.setShader(boykisser)
    love.graphics.draw(boykisserTexture, 0, 0, 0, 1.25, 1)
    love.graphics.setShader()

    for _, button in ipairs(buttons[screens.current].buttons) do
        button.draw()
    end

    love.graphics.setColor(0, 0, 0)
    love.graphics.print("Boykisser simulator v1.0.0", 10, 10)

    if linkHovered then
        love.graphics.setColor(0, 0, 1)
    else
        love.graphics.setColor(0, 0, 0)
    end
    love.graphics.print("https://github.com/Cuppy130/boykisser-simulator", 10, love.graphics.getHeight() - 20) -- we will make this clickable in update
end


function love.update(dt)

    if buttons[screens.current] == nil then
        return
    end

    boykisser:send("time", love.timer.getTime())

    -- make the link clickable
    local mx, my = love.mouse.getPosition()
    if mx >= 10 and mx <= 10 + 200 and my >= love.graphics.getHeight() - 20 and my <= love.graphics.getHeight() then
        linkHovered = true
    else
        linkHovered = false
        linkClicked = false
    end

    if linkHovered and love.mouse.isDown(1) and not linkClicked then
        linkClicked = true
        love.system.openURL("https://github.com/Cuppy130/boykisser-simulator")
    elseif not love.mouse.isDown(1) then
        linkClicked = false
    end

    for _, button in ipairs(buttons[screens.current].buttons) do
        button.update()
    end
end