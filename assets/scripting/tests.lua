require "buffer"
require "console"

function BufferTest()
	local MSG = Buffer.New()
	
	MSG:WriteUInt8(1)
	MSG:WriteUInt8(2)
	MSG:WriteUInt8(3)
	MSG:WriteUInt8(4)
	MSG:ToStart()
	assert(MSG.Position == 0)
	assert(MSG:ReadInt32() == 67305985)
	
	MSG:ToStart()
	MSG:WriteUInt16(42)
	MSG:WriteUInt16(43)
	MSG:ToStart()
	assert(MSG:ReadInt32() == 2818090)
	
	MSG:ToStart()
	MSG:WriteUInt32(12345)
	MSG:ToStart()
	assert(MSG:ReadUInt32() == 12345)
	
	MSG:ToStart()
	MSG:WriteUInt8(255)
	MSG:ToStart()
	assert(MSG:ReadInt8() == -1)
	
	MSG:ToStart()
	MSG:WriteFloat(42.0)
	MSG:ToStart()
	assert(MSG:ReadUInt32() == 1109917696)
	
	MSG:ToStart()
	MSG:WriteUInt32(1109917696)
	MSG:ToStart()
	assert(MSG:ReadFloat() == 42.0)
	
	assert(MSG.Position == 4)
	assert(MSG.Size == 4)
	assert(#MSG.Memory == 4)
	
	local str = "we are your friends"
	
	MSG:ToStart()
	MSG:WriteString(str)
	MSG:WriteFloat(42.0)
	MSG:ToStart()
	assert(MSG:ReadString() == str)
	assert(MSG:ReadFloat() == 42.0)
	
	local str_size = #str + 1 -- zero byte included
	local full_size = str_size + 4 -- sizeof(float) = 4 bytes
	
	assert(MSG.Size == full_size)
	assert(MSG.Position == full_size)
	assert(#MSG.Memory == full_size)
	
	Log "buffer test completed"
end

function ConsoleCommandsTest()
	local testcmd_value = 0

	local testcmd_callback = function(Args) 
		if #Args == 0 then
			Log "testcmd must contain one argument"
			return
		end
		local value = tonumber(Args[1])
		if value == nil then
			Log "argument must be numeric"
		end
		testcmd_value = value
	end

	Console.RegisterCommand("testcmd1", "testcmd1 description", { "num" }, testcmd_callback)
	Console.RegisterCommand("testcmd2", "testcmd2 description", testcmd_callback)
	Console.RegisterCommand("testcmd3", { "num" }, testcmd_callback)
	Console.RegisterCommand("testcmd4", testcmd_callback)
	
	Console.Execute("testcmd1 1")
	assert(testcmd_value == 1)

	Console.Execute("testcmd2 2")
	assert(testcmd_value == 2)

	Console.Execute("testcmd3 3")
	assert(testcmd_value == 3)

	Console.Execute("testcmd4 4")
	assert(testcmd_value == 4)
	
	local testcvar_value = 0
	local testcvar_value2 = ""

	testcvar_getter = function()
		return { tostring(testcvar_value), testcvar_value2 }
	end

	testcvar_setter = function(Args)
		local arg1 = tonumber(Args[1])
		if arg1 == nil then
			Log "argument must be numeric"
			return
		end
		testcvar_value = arg1
		if #Args > 2 then
			testcvar_value2 = Args[3]
		end
	end

	Console.RegisterCVar("testcvar1", "testcvar1 description", { "int", "int" }, { "str" }, testcvar_getter, testcvar_setter)
	Console.RegisterCVar("testcvar2", "testcvar2 description", { "int", "int" }, { "str" }, testcvar_getter)
	Console.RegisterCVar("testcvar3", { "int", "int" }, { "str" }, testcvar_getter, testcvar_setter)
	Console.RegisterCVar("testcvar4", { "int", "int" }, { "str" }, testcvar_getter)
	Console.RegisterCVar("testcvar5", "testcvar5 description", { "int", "int" }, testcvar_getter, testcvar_setter)
	Console.RegisterCVar("testcvar6", "testcvar6 description", { "int", "int" }, testcvar_getter)
	Console.RegisterCVar("testcvar7", { "int", "int" }, testcvar_getter, testcvar_setter)
	Console.RegisterCVar("testcvar8", { "int", "int" }, testcvar_getter)
	Console.RegisterCVar("testcvar9", "testcvar7 description", testcvar_getter, testcvar_setter)
	Console.RegisterCVar("testcvar10", "testcvar8 description", testcvar_getter)
	Console.RegisterCVar("testcvar11", testcvar_getter, testcvar_setter)
	Console.RegisterCVar("testcvar12", testcvar_getter)
	
	Console.Execute("testcvar1 1 any")
	assert(testcvar_value == 1)

	Console.Execute("testcvar3 3 any")
	assert(testcvar_value == 3)
	
	Console.Execute("testcvar5 5 any")
	assert(testcvar_value == 5)
	
	Console.Execute("testcvar7 7 any")
	assert(testcvar_value == 7)
	
	Console.Execute("testcvar9 9 any")
	assert(testcvar_value == 9)
	
	Console.Execute("testcvar11 11 any")
	assert(testcvar_value == 11)
	
	Console.Execute("testcvar1 1 1 one")
	assert(testcvar_value2 == "one")
	
	Console.Execute("testcvar3 3 3 three")
	assert(testcvar_value2 == "three")
	
	Log "console commands test completed"
end

function TestFeatures()
	BufferTest()
	ConsoleCommandsTest()
end