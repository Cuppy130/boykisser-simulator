require("modules.button")
require("modules.file")

click_sound = love.audio.newSource("assets/click.mp3", "static")
click_sound:setVolume(0.5)

local menuButtons

local linkHovered = false
local linkClicked = false

local screens = {
    current = 'screen_mainMenu'
}

backgroundAudio = love.audio.newSource("assets/Cats.ogg", "stream")
boykisserTexture = love.graphics.newImage("assets/boykisser.png")
boykisserTexture:setWrap("repeat", "repeat")
boykisserTexture:setFilter("nearest", "nearest")

local saveData = {}
local selectedSave = 1

local sf = File.new("save1.txt")
sf.open("w")
sf.writeString("Boykisser")
sf.close()

local function saveGame(slot)
    local data = saveData[slot]
    if data == nil then
        data = {
            name = "New save",
            data = {
                pet = {
                    name = "Boykisser",
                    age = 18,
                    hunger = 100,
                    happiness = 100,
                    health = 100,
                    energy = 100,
                    lovePoints = 0,
                    money = 100
                },
                items = {
                    {
                        name = "Apple",
                        quantity = 5
                    },
                    {
                        name = "Banana",
                        quantity = 5
                    },
                    {
                        name = "Orange",
                        quantity = 5
                    }
                }
            }
        }
    end
    
    local saveName = data.name
    local petName = data.data.pet.name
    local petAge = data.data.pet.age
    local petHunger = data.data.pet.hunger
    local petHappiness = data.data.pet.happiness
    local petHealth = data.data.pet.health
    local petEnergy = data.data.pet.energy
    local lovePoints = data.data.pet.lovePoints
    local money = data.data.pet.money
    
    local file = File.new("save" .. slot .. ".txt")
    file.open("w")
    file.writeUInt8(#saveName)
    file.write(saveName)
    file.writeUInt32(petAge)
    file.writeUInt8(petHunger)
    file.writeUInt8(petHappiness)
    file.writeUInt8(petHealth)
    file.writeUInt8(petEnergy)
    file.writeUInt16(lovePoints)
    file.writeUInt16(money)
    file.close()
end


local function loadGame(slot)
    local file = File.new("save" .. slot .. ".txt")
    file:open("r")
    
    local saveNameLength = file.readUInt8()
    local saveName = file.read(saveNameLength)
    local petAge = file.readUInt32()
    local petHunger = file.readUInt8()
    local petHappiness = file.readUInt8()
    local petHealth = file.readUInt8()
    local petEnergy = file.readUInt8()
    local lovePoints = file.readUInt16()
    local money = file.readUInt16()

    saveData[slot] = {
        name = saveName,
        data = {
            pet = {
                name = "Boykisser",
                age = petAge,
                hunger = petHunger,
                happiness = petHappiness,
                health = petHealth,
                energy = petEnergy,
                lovePoints = lovePoints,
                money = money
            }
        }
    }
    
    file.close()
    -- Update the buttons to reflect the loaded save
    buttons.screen_game.buttons[#buttons.screen_game.buttons + 1] = Button.new("Load save " .. slot, 10, 100 + (60 * slot), 100, 50, function()
        click_sound:play()
        loadGame(slot)
        selectedSave = slot
        reloadSaveDirectory()
        screens.current = 'screen_gameplay'
    end)
end

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
    },
    screen_game = {
        buttons = {
            Button.new("Back", 10, 40, 100, 50, function()
                click_sound:play()
                screens.current = 'screen_mainMenu'
            end),
        }
    },
    screen_gameplay = {
        buttons = {
            Button.new("", love.graphics.getWidth() - 40, 10, 30, 30, function()
                click_sound:play()
                screens.current = 'screen_gameplay_menu'
            end),
        }
    }
}


local function reloadSaveDirectory()
    for i = 1, 3 do
        if love.filesystem.getInfo("save" .. i .. ".txt") then
            buttons.screen_game.buttons[#buttons.screen_game.buttons + 1] = Button.new("Load save " .. i, 10, 100 + (60 * i), 100, 50, function()
                click_sound:play()
                loadGame(i)
                selectedSave = i
                reloadSaveDirectory()
                screens.current = 'screen_gameplay'
            end)
        else
            buttons.screen_game.buttons[#buttons.screen_game.buttons + 1] = Button.new("New save " .. i, 10, 100 + (60 * i), 100, 50, function()
                click_sound:play()
                saveGame(i)
                loadGame(i)
                selectedSave = i
                reloadSaveDirectory()
                screens.current = 'screen_gameplay'
            end)
        end
    end
end

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

    -- check for 3 save slots
    reloadSaveDirectory()

    local width = love.graphics.getWidth()
    local height = love.graphics.getHeight()
    local centerX = width / 2
    local centerY = height / 2

    buttons['screen_gameplay_menu'] = {
        buttons = {
            Button.new("Back", 10, 40, 100, 50, function()
                click_sound:play()
                screens.current = 'screen_gameplay'
            end),
            Button.new("Save & Exit", 10, 100, 100, 50, function()
                click_sound:play()
                saveGame(selectedSave)
                screens.current = 'screen_mainMenu'
            end),
            Button.new("Load", 10, 160, 100, 50, function()
                click_sound:play()
                loadGame(selectedSave)
                reloadSaveDirectory()
                screens.current = 'screen_gameplay'
            end),
            Button.new("Delete save", 10, 220, 100, 50, function()
                click_sound:play()
                love.filesystem.remove("save" .. selectedSave .. ".txt")
                reloadSaveDirectory()
                screens.current = 'screen_mainMenu'
            end),
        }
    }
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

    -- drawing the elements
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
    love.graphics.print("Github", 10, love.graphics.getHeight() - 20) -- we will make this clickable in update
end


function love.update(dt)

    if buttons[screens.current] == nil then
        return
    end

    boykisser:send("time", love.timer.getTime())

    -- make the link clickable
    local mx, my = love.mouse.getPosition()
    if mx >= 10 and mx <= 10 + love.graphics.getFont():getWidth("Github") and my >= love.graphics.getHeight() - 20 and my <= love.graphics.getHeight() then
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