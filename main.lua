require("modules.button")
require("modules.hyperlink")
require("modules.file")
require("modules.image")
require("global")

click_sound = love.audio.newSource("assets/click.mp3", "static")
click_sound:setVolume(0.5)

local github = Hyperlink.new("Github", 10, love.graphics.getHeight() - 20, "https://github.com/Cuppy130/boykisser-simulator")

local screens = {
    current = 'screen_mainMenu'
}

backgroundAudio = love.audio.newSource("assets/Cats.ogg", "stream")
boykisserTexture = love.graphics.newImage("assets/boykisser.png")
boykisserTexture:setWrap("repeat", "repeat")
boykisserTexture:setFilter("nearest", "nearest")

local saveData = {}
local selectedSave = 1

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
                inventory = {
                    items = {},
                    food = {},
                    toys = {},
                    medicine = {},
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
    file.clear()
    file.writeString(saveName)
    file.writeUInt32(petAge)
    file.writeUInt8(petHunger)
    file.writeUInt8(petHappiness)
    file.writeUInt8(petHealth)
    file.writeUInt8(petEnergy)
    file.writeUInt32(lovePoints)
    file.writeUInt32(money)
    file.write()
    file = nil
    saveData[slot] = {
        name = saveName,
        data = {
            pet = {
                name = petName,
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
    SCREENMAN:log("Saved game " .. slot .. " to " .. love.filesystem.getSaveDirectory() .. "/save" .. slot .. ".txt")
end


local function loadGame(slot)
    local file = File.new("save" .. slot .. ".txt")
    if not file.exists() then
        SCREENMAN:log("Save " .. slot .. " does not exist")
        return
    end
    file.read()
    local saveName = file.readString()
    local petAge = file.readUInt32()
    local petHunger = file.readUInt8()
    local petHappiness = file.readUInt8()
    local petHealth = file.readUInt8()
    local petEnergy = file.readUInt8()
    local lovePoints = file.readUInt32()
    local money = file.readUInt32()
    
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
    file = nil
    SCREENMAN:log("Loaded game " .. slot .. " from " .. love.filesystem.getSaveDirectory() .. "/save" .. slot .. ".txt")
end

local buttons = {
    screen_mainMenu = {
        buttons = {
            Button.new("Start", love.graphics.getWidth() / 2 - 100, love.graphics.getHeight() / 2 - 25, 200, 50, function()
                click_sound:play()
                screens.current = 'screen_game'
            end),
            Button.new("Options", love.graphics.getWidth() / 2 - 100, love.graphics.getHeight() / 2 + 50, 200, 50, function()
                click_sound:play()
                screens.current = 'screen_options'
            end),
            Button.new("Exit", love.graphics.getWidth() / 2 - 100, love.graphics.getHeight() / 2 + 125, 200, 50, function()
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
            end)
        },
        images = {
            Image.new("assets/sprites/tribar.png", love.graphics.getWidth() - 40, 10, 30, 30)
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

        //pixelate
        tex.x = floor(tex.x * 32.0) / 32.0; 
        tex.y = floor(tex.y * 32.0) / 32.0;

        tex.x += time;
        tex.y += sin(time) * 2;
        vec4 pixel = Texel(img, tex);
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
                SCREENMAN:log("Deleted save " .. selectedSave .. " from " .. love.filesystem.getSaveDirectory() .. "/save" .. selectedSave .. ".txt")
            end)
        }
    }
end

local title = {
    image = love.graphics.newImage("assets/sprites/title.png"),
    x = love.graphics.getWidth() / 2,
    y = 100
}

function love.draw()
    if buttons[screens.current] == nil then
        love.graphics.setColor(1, 1, 1)
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

    if screens.current == 'screen_mainMenu' then
        love.graphics.draw(title.image, title.x, title.y, 0, 1, 1, title.image:getWidth() / 2, title.image:getHeight() / 2)
    end

    SCREENMAN.draw()
    github.draw()
end


function love.update(dt)

    if buttons[screens.current] == nil then
        return
    end

    boykisser:send("time", love.timer.getTime())

    for _, button in ipairs(buttons[screens.current].buttons) do
        button.update()
    end

    SCREENMAN.update()

    github.update()
end