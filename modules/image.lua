Image = {}

function Image.new(path, x, y, width, height)
    local self = {}
    self.path = path
    self.x = x or 0
    self.y = y or 0

    self.image = love.graphics.newImage(path)
    local imgWidth, imgHeight = self.image:getDimensions()
    self.width = width or imgWidth
    self.height = height or imgHeight
    self.scaleX = self.width / imgWidth
    self.scaleY = self.height / imgHeight

    function self.draw()
        love.graphics.draw(self.image, self.x, self.y, 0, self.scaleX, self.scaleY)
    end

    return self
end