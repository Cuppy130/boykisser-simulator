File = {}

function File.new(path)
    local self = {}
    self.path = path
    self.index = 1

    self.data = love.filesystem.read(path)

    function self.clear()
        self.data = {}
    end
    
    if self.data == nil then
        self.data = {}
    end

    function self.writeUInt8(value)
        self.data[self.index] = value % 256
        self.index = self.index + 1
    end
    function self.writeUInt16(value)
        self.data[self.index] = value % 256
        self.data[self.index + 1] = math.floor(value / 256) % 256
        self.index = self.index + 2
    end

    function self.writeUInt32(value)
        self.data[self.index] = value % 256
        self.data[self.index + 1] = math.floor(value / 256) % 256
        self.data[self.index + 2] = math.floor(value / 65536) % 256
        self.data[self.index + 3] = math.floor(value / 16777216) % 256
        self.index = self.index + 4
    end

    function self.writeString(value)
        local len = #value or 0
        self.data[self.index] = len
        self.index = self.index + 1
        for i = 1, len do
            self.data[self.index] = string.byte(value, i)
            self.index = self.index + 1
        end

    end

    function self.write()
        local file = love.filesystem.newFile(self.path)
        file:open("w")
        file:write(string.char(unpack(self.data)))
        file:close()
    end

    function self.readUInt8()
        local value = self.data[self.index]
        self.index = self.index + 1
        return value
    end
    function self.readUInt16()
        local value = self.data[self.index] + (self.data[self.index + 1] * 256)
        self.index = self.index + 2
        return value
    end
    function self.readUInt32()
        local value = self.data[self.index] + (self.data[self.index + 1] * 256) + (self.data[self.index + 2] * 65536) + (self.data[self.index + 3] * 16777216)
        self.index = self.index + 4
        return value
    end
    function self.readString()
        local len = self.data[self.index]
        self.index = self.index + 1
        local value = ""
        for i = 1, len do
            value = value .. string.char(self.data[self.index])
            self.index = self.index + 1
        end
        return value
    end
    function self.reset()
        self.index = 1
    end
    function self.read()
        local file = love.filesystem.newFile(self.path)
        file:open("r")
        self.data = file:read()
        file:close()
        self.data = {string.byte(self.data, 1, #self.data)}
        self.index = 1
    end

    function self.exists()
        return love.filesystem.getInfo(self.path) ~= nil
    end


    return self
end