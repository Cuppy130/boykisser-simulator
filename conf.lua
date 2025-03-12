function love.conf(t)
    t.window.title = "Boykisser simulator v1.0.0"
    t.window.icon = "assets/boykisser.png"
    t.window.width = 640
    t.window.height = 480
    t.window.resizable = false
    t.window.fullscreen = false
    t.window.vsync = 1
    t.window.msaa = 0
    t.window.display = 1

    -- this is for the gamesave system
    t.identity = "boykisser-sim"
    t.version = "11.3"
    t.console = false
    t.accelerometerjoystick = false
end