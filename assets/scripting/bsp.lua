require "buffer"
require "console"
require "vec3"

local Lump = {
	Entities = 0,
	Planes = 1,
	Textures = 2,
	Vertices = 3,
	Visibility = 4,
	Nodes = 5,
	TexInfo = 6,
	Faces = 7,
	Lighting = 8,
	ClipNodes = 9,
	Leafs = 10,
	MarkSurfaces = 11,
	Edges = 12,
	Surfedges = 13,
	Models = 14
}

BSP = {}
BSP.__index = Buffer

local function LoadVertices(self, MSG)
	MSG.Position = self.Lumps[Lump.Vertices].offset	
	local Count = self.Lumps[Lump.Vertices].size / 12 -- sizeof(vec3)

	self.Vertices = {}

	for I = 0, Count - 1 do
		local x = MSG:ReadFloat()
		local y = MSG:ReadFloat()
		local z = MSG:ReadFloat()
		
		self.Vertices[I] = Vec3.New(x, y, z)
	end
end

local function LoadEdges(self, MSG)
	MSG.Position = self.Lumps[Lump.Edges].offset
	local Count = self.Lumps[Lump.Edges].size / 4 -- sizeof(uint16_t) * 2

	self.Edges = {}

	for I = 0, Count - 1 do
		self.Edges[I] = {}
		self.Edges[I][0] = MSG:ReadUInt16()
		self.Edges[I][1] = MSG:ReadUInt16()
	end

end

local function LoadEntities(self, MSG)
	MSG.Position = self.Lumps[Lump.Entities].offset	

	local data = MSG:ReadString()

	--print(data) -- ok
end

function BSP.New(FileName)
	local self = setmetatable({}, BSP)
	local file = io.open("assets/" .. FileName, "rb")
	local MSG = Buffer.New(file:read("*all"))
	file:close()
	
	self.Version = MSG:ReadInt32()
	
	self.Lumps = {}

	for I = 0, 15 - 1 do
		self.Lumps[I] = {}
		self.Lumps[I].offset = MSG:ReadInt32()
		self.Lumps[I].size = MSG:ReadInt32()
	end

	LoadVertices(self, MSG)
	LoadEdges(self, MSG)
	LoadEntities(self, MSG)

	return self
end