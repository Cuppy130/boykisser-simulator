Button = {}


function Button.new(text, x, y, width, height, onClick)
    local self = {}
    self.text = text
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.onClick = onClick
    self.hovered = false
    self.clicked = false
    self.enabled = true
    


    function self.draw()
        if not self.enabled then
            love.graphics.setColor(0.5, 0.5, 0.5)
        elseif self.hovered then
            love.graphics.setColor(0.8, 0.8, 0.8)
        else
            love.graphics.setColor(1, 1, 1)
        end
        love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
        love.graphics.setColor(0, 0, 0)
        love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
        love.graphics.print(self.text, self.x + 10, self.y + 10)
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
                self.onClick()
            end
        else
            self.hovered = false
            self.clicked = false
        end
    end

    return self
end
