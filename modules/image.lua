Image = {}

function Image.new(path, x, y, width, height)
    local self = {}
    self.path = path
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.image = love.graphics.newImage(path)
    self.image:setFilter("nearest", "nearest")
    self.scaleX = width / self.image:getWidth()
    self.scaleY = height / self.image:getHeight()

    function self.draw()
        love.graphics.draw(self.image, self.x, self.y, 0, self.scaleX, self.scaleY)
    end

    function self.update()
        -- Update logic if needed
    end
end