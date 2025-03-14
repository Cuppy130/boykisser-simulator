File = {}

function File.new(path)
    local self = {}
    self.path = path
    self.index = 1

    self.data = love.filesystem.read(path)

    function self.clear()
        self.data = ""
    end
    
    if self.data == nil then
        self.data = ""
    end

    function self.writeUInt8(value)
        if value < 0 and value > 255 then
            error("Value out of range for UInt8: " .. value)
        end

        self.data = self.data .. string.char(value)
    end

    function self.writeUInt16(value)
        if value < 0 and value > 65535 then
            error("Value out of range for UInt16: " .. value)
        end

        self.data = self.data .. string.char(value % 256, math.floor(value / 256))
    end
    function self.writeUInt32(value)
        if value < 0 and value > 4294967295 then
            error("Value out of range for UInt32: " .. value)
        end

        self.data = self.data .. string.char(value % 256, math.floor(value / 256) % 256, math.floor(value / 65536) % 256, math.floor(value / 16777216))
    end
    function self.writeString(value)
        local len = #value
        self.writeUInt8(len)
        for i = 1, len do
            self.data = self.data .. string.char(value:byte(i))
        end
    end

    function self.readUInt8()
        local value = string.byte(self.data, self.index)
        self.index = self.index + 1
        return value
    end
    function self.readUInt16()
        local value = string.byte(self.data, self.index) + string.byte(self.data, self.index + 1) * 256
        self.index = self.index + 2
        return value
    end
    function self.readUInt32()
        local value = string.byte(self.data, self.index) + string.byte(self.data, self.index + 1) * 256 + string.byte(self.data, self.index + 2) * 65536 + string.byte(self.data, self.index + 3) * 16777216
        self.index = self.index + 4
        return value
    end
    function self.readString()
        local len = string.byte(self.data, self.index)
        self.index = self.index + 1
        local value = ""
        for i = 1, len do
            value = value .. string.char(string.byte(self.data, self.index))
            self.index = self.index + 1
        end
        return value
    end
    function self.write()
        love.filesystem.write(self.path, self.data)
    end
    function self.read()
        self.data = love.filesystem.read(self.path)
        if self.data == nil then
            self.data = ""
        end
        self.index = 1
    end

    return self
end
local f = File.new("save1.txt")
f.clear()
f.writeString("Boykisser")
f.writeUInt32(18)
f.writeUInt8(100)
f.writeUInt8(100)

f.write();
print(f.data)