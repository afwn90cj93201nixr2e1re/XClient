Buffer = {}
Buffer.__index = Buffer

function Buffer.New(Memory)
	local self = setmetatable({}, Buffer)
	self.Position = 0
	self.Size = 0
	self.Memory = ""
	if Memory then
		assert(type(Memory) == "string")
		self.Memory = Memory
		self.Size = #Memory
	end
	return self
end

function Buffer:ToStart()
	self.Position = 0
end

function Buffer:HasSpace(Size)
	return self.Position + Size <= self.Size
end

function Buffer:EnsureSpace(Size)
	if self:HasSpace(Size) then
		return
	end
	self.Size = self.Position + Size
end

-- read unsigned int

local function ReadUInt(self, Sz)
	assert(self:HasSpace(Sz))
	self.Position = self.Position + Sz
	return string.unpack("I" .. tostring(Sz), self.Memory, self.Position - Sz + 1)
end

function Buffer:ReadUInt8()
	return ReadUInt(self, 1)
end

function Buffer:ReadUInt16()
	return ReadUInt(self, 2)
end

function Buffer:ReadUInt32()
	return ReadUInt(self, 4)
end

-- read signed int

local function ReadInt(self, Sz)
	assert(self:HasSpace(Sz))
	self.Position = self.Position + Sz
	return string.unpack("i" .. tostring(Sz), self.Memory, self.Position - Sz + 1)
end

function Buffer:ReadInt8()
	return ReadInt(self, 1)
end

function Buffer:ReadInt16()
	return ReadInt(self, 2)
end

function Buffer:ReadInt32()
	return ReadInt(self, 4)
end

-- write unsigned int

local function WriteUInt(self, Value, Sz)
	assert(type(Value) == "number")
	assert(Value >= 0)
	assert(Value <= 1 << 8 * Sz)
	self:EnsureSpace(Sz)
	self.Position = self.Position + Sz
	self.Memory = string.sub(self.Memory, 1, self.Position - Sz) .. string.pack("I" .. tostring(Sz), Value) .. string.sub(self.Memory, self.Position + Sz)
end

function Buffer:WriteUInt8(Value)
	WriteUInt(self, Value, 1)
end

function Buffer:WriteUInt16(Value)
	WriteUInt(self, Value, 2)
end

function Buffer:WriteUInt32(Value)
	WriteUInt(self, Value, 4)
end

-- write signed int

local function WriteInt(self, Value, Sz)
	assert(type(Value) == "number")
	assert(-Value >= 1 << 7 * Sz)
	assert(Value <= 1 << 7 * Sz)
	self:EnsureSpace(Sz)
	self.Position = self.Position + Sz
	self.Memory = string.sub(self.Memory, 1, self.Position - Sz) .. string.pack("i" .. tostring(Sz), Value) .. string.sub(self.Memory, self.Position + Sz)
end

function Buffer:WriteInt8(Value)
	WriteInt(self, Value, 1)
end

function Buffer:WriteUInt8(Value)
	WriteUInt(self, Value, 1)
end

function Buffer:WriteUInt16(Value)
	WriteUInt(self, Value, 2)
end

function Buffer:WriteUInt32(Value)
	WriteUInt(self, Value, 4)
end

-- floats

function Buffer:WriteFloat(Value)
	assert(type(Value) == "number")
	self:EnsureSpace(4)
	self.Position = self.Position + 4
	self.Memory = string.sub(self.Memory, 1, self.Position - 4) .. string.pack("f", Value) .. string.sub(self.Memory, self.Position + 4)
end

function Buffer:ReadFloat()
	assert(self:HasSpace(4))
	self.Position = self.Position + 4
	return string.unpack("f", self.Memory, self.Position - 4 + 1)
end

-- null terminated string

function Buffer:WriteString(Value)
	assert(type(Value) == "string")
	for I = 1, #Value do
		self:WriteUInt8(Value:byte(I))
	end
	self:WriteUInt8(0)
end

function Buffer:ReadString()
	local Result = ""
	for I = 1, self.Size do
		local B = self:ReadUInt8()
		if B == 0 then
			break
		end
		Result = Result .. string.char(B)
	end
	return Result
end

-- half life

function Buffer:ReadCoord()
	return self:ReadInt16() * (1.0 / 8.0)
end

function Buffer:ReadAngle()
	return self:ReadInt8() * (360.0 / 256.0)
end

function Buffer:ReadHiresAngle()
	return self:ReadInt16() * (360.0 / 65536.0)
end