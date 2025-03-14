Hyperlink = {}

-- Hyperlink class
function Hyperlink.new(text, x, y, url, fontSize)
    local self = {}

    self.text = text
    self.url = url
    self.x = x
    self.y = y
    self.fontSize = fontSize or 12

    self.hovered = false
    self.clicked = false
    self.enabled = true
    self.font = love.graphics.newFont(self.fontSize)
    self.font:setFilter("nearest", "nearest")
    self.width = self.font:getWidth(self.text)
    self.height = self.font:getHeight(self.text)
    self.color = {0, 0, 0}
    self.hoverColor = {0, 0, 1}

    function self.draw()
        if not self.enabled then
            love.graphics.setColor(0.5, 0.5, 0.5)
        elseif self.hovered then
            love.graphics.setColor(self.hoverColor)
        else
            love.graphics.setColor(self.color)
        end

        love.graphics.setFont(self.font)
        love.graphics.print(self.text, self.x, self.y)
    end
    function self.update()
        if not self.enabled then
            return
        end

        local mx, my = love.mouse.getPosition()
        if mx >= self.x and mx <= self.x + self.width and my >= self.y and my <= self.y + self.height then
            self.hovered = true
            if love.mouse.isDown(1) then
                self.clicked = true
            elseif self.clicked then
                self.clicked = false
                love.system.openURL(self.url)
            end
        else
            self.hovered = false
            self.clicked = false
        end
    end
    function self.setColor(r, g, b)
        self.color = {r, g, b}
    end
    function self.setHoverColor(r, g, b)
        self.hoverColor = {r, g, b}
    end
    function self.setEnabled(enabled)
        self.enabled = enabled
    end
    function self.setFontSize(size)
        self.fontSize = size
        self.font = love.graphics.newFont(self.fontSize)
        self.font:setFilter("nearest", "nearest")
        self.width = self.font:getWidth(self.text)
        self.height = self.font:getHeight(self.text)
    end
    function self.setPosition(x, y)
        self.x = x
        self.y = y
    end
    function self.setText(text)
        self.text = text
        self.width = self.font:getWidth(self.text)
        self.height = self.font:getHeight(self.text)
    end



    return self
end