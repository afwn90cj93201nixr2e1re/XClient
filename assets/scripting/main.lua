--[[
	Console.Execute(s)
	Console.Write(s, col)
	Console.WriteLine(s, col)
	Console.RegisterCommand(name, <description>, <args>, callback)
	Console.RegisterCVar(name, <description>, <args>, <optional_args>, getter, <setter>)
	
	Client.SendCommand(s)
	Client.GetIndex() -> int
	Client.GetMap() -> string
	Client.GetGameDir() -> string
	Client.GetOrigin() -> vec3
	Client.GetEntitiesCount() -> int
	Client.IsEntityActive(int) -> bool
	Client.IsPlayerIndex(int) -> bool
	Client.GetEntity(int) -> ent table
	Client.TraceLine(vec3, vec3) -> trace_result table
	Client.SetCertificate(buffer)
]]

require "buffer"
require "tests"
require "gmsg"
require "vec3"
require "utils"
require "move"

local GameMessageCallbacks = {}
local ThinkTime = 0
local UserCmd = {}

function Initialize()
	TestFeatures()
	InitializeGmsgCallbacks(GameMessageCallbacks)
	math.randomseed(os.clock())
	GenerateCertificate()
	
	Console.Execute("sys_framerate 60")
	Console.Execute("connect 127.0.0.1")
end

function ReadGameMessage(Name, Memory)
	local MSG = Buffer.New(Memory)
	for key, callback in next, GameMessageCallbacks do
		if (key == Name) then
			CurrentGmsgName = Name -- gmsg.lua
			callback(MSG)
			if MSG.Position ~= MSG.Size then
				Log("game message " .. Name .. " bad reading (" .. tostring(MSG.Position) .. "/" .. tostring(MSG.Size) .. ")")
			end
			return
		end
	end
	Log(Name)
end

function IsResourceRequired(Name)
	-- return true if you want this resource to be downloaded

	return false
end

function Frame(dTime)
	--Log(tostring(dTime))
end

function InitializeGame()
	Log "game initialized"
	Console.Execute("delay 1 '" .. 'cmd "jointeam 2"' .. "'")
	Console.Execute("delay 2 '" .. 'cmd "joinclass 6"' .. "'")
end

function Think()
	local now = os.clock() * 1000.0
	local thinkDelta = now - ThinkTime
	ThinkTime = now
	
	UserCmd.MSec = thinkDelta
	UserCmd.ForwardMove = 0
	UserCmd.SideMove = 0
	UserCmd.Buttons = 0

	Move()

	return UserCmd
end

function LookAt(Target)
	local a = VectorAngles(Target - Vec3.New(Client.GetOrigin()))
	UserCmd.ViewAngles = { -a.X, a.Y, a.Z }
end

function MoveTo(Target)
	local speed = 250.0;
	local angles = VectorAngles(Target - Vec3.New(Client.GetOrigin()))
	local dir = UserCmd.ViewAngles[2] - angles.Y
	UserCmd.ForwardMove = math.cos(math.deg(dir)) * speed
	UserCmd.SideMove = math.sin(math.deg(dir)) * speed
end

function MoveFrom(Target)
	MoveTo(Target)
	UserCmd.ForwardMove = -UserCmd.ForwardMove
	UserCmd.SideMove = -UserCmd.SideMove
end

function GenerateCertificate()
	local MSG = Buffer.New()

	MSG:WriteUInt32(1337)
	MSG:WriteUInt32(228)

	Client.SetCertificate(MSG.Memory)
end