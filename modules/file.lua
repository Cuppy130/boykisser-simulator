File = {}

-- File: file.lua
function File.new(name)
    local self = {}
    self.name = name
    self.index = 0
    self.data = {}
    self.open = false
    self.write = false
    
    function self.open(mode)

        if mode == "r" then
            self.file = love.filesystem.newFile(self.name)
            self.file:open("r")
            self.index = 0
            self.data = {}
            self.open = true
            self.write = false
        elseif mode == "w" then
            self.file = love.filesystem.newFile(self.name)
            self.file:open("w")
            self.index = 0
            self.data = {}
            self.open = true
            self.write = true
        else
            error("Invalid mode: " .. mode)
        end
    end

    function self.close()
        if self.open then
            self.file:close()
            self.open = false
            self.write = false
            self.index = 0
            self.data = {}
        else 
            error("File not open")
        end
    end

    function self.writeUInt8(value)
        if(value < 0 or value > 255) then
            error("Value out of range for UInt8: " .. value)
        end
        if self.open then
            self.file:write(string.char(value))
            self.index = self.index + 1
        else
            error("File not open for writing")
        end
    end

    function self.writeUInt16(value)
        if(value < 0 or value > 65535) then
            error("Value out of range for UInt16: " .. value)
        end
        if self.open then
            self.file:write(string.char(value % 256, math.floor(value / 256)))
            self.index = self.index + 2
        else
            error("File not open for writing")
        end
    end

    function self.writeUInt32(value)
        if(value < 0 or value > 4294967295) then
            error("Value out of range for UInt32: " .. value)
        end
        if self.open then
            self.file:write(string.char(value % 256, math.floor(value / 256) % 256, math.floor(value / 65536) % 256, math.floor(value / 16777216)))
            self.index = self.index + 4
        else
            error("File not open for writing")
        end
    end

    function self.writeString(value)
        if self.open then
            local length = #value
            if length > 255 then
                error("String too long: " .. value)
            end
            self.file:write(string.char(length))
            self.file:write(value)
            self.index = self.index + length + 1
        else
            error("File not open for writing")
        end
    end

    function self.readUInt8()
        if self.open then
            local byte = self.file:read(1)
            if byte then
                self.index = self.index + 1
                return string.byte(byte)
            else
                error("End of file reached")
            end
        else
            error("File not open for reading")
        end
    end

    function self.readUInt16()
        if self.open then
            local bytes = self.file:read(2)
            if bytes then
                self.index = self.index + 2
                return string.byte(bytes, 1) + string.byte(bytes, 2) * 256
            else
                error("End of file reached")
            end
        else
            error("File not open for reading")
        end
    end

    function self.readUInt32()
        if self.open then
            local bytes = self.file:read(4)
            if bytes then
                self.index = self.index + 4
                return string.byte(bytes, 1) + string.byte(bytes, 2) * 256 + string.byte(bytes, 3) * 65536 + string.byte(bytes, 4) * 16777216
            else
                error("End of file reached")
            end
        else
            error("File not open for reading")
        end
    end

    function self.readString()
        if self.open then
            local length = self.file:read(1)
            if length then
                length = string.byte(length)
                local str = self.file:read(length)
                if str then
                    self.index = self.index + length + 1
                    return str
                else
                    error("End of file reached")
                end
            else
                error("End of file reached")
            end
        else
            error("File not open for reading")
        end
    end

    return self

end