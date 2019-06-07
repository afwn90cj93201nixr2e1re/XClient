CurrentGmsgName = ""

function LogValueBegin()
	LogBegin()
	LogContinue(CurrentGmsgName, Console.Color.Cyan)
	LogContinue(" - ")
end

function LogValue(Name, Value)
	LogContinue(Name .. ": ")
	LogContinue(Value, Console.Color.Yellow)
	LogContinue(", ")
end

function LogValueEnd(Name, Value)
	LogContinue(Name .. ": ")
	LogContinue(Value, Console.Color.Yellow)
	LogEnd()
end

function InitializeGmsgCallbacks(Callbacks)
    Callbacks["AmmoX"] = ReadAmmoX
	Callbacks["WeaponList"] = ReadWeaponList
    Callbacks["ReqState"] = ReadReqState
	Callbacks["SayText"] = ReadSayText
	Callbacks["MOTD"] = ReadMOTD
	Callbacks["TeamInfo"] = ReadTeamInfo
	Callbacks["ScoreInfo"] = ReadScoreInfo
	Callbacks["TextMsg"] = ReadTextMsg
	Callbacks["ServerName"] = ReadServerName
	Callbacks["Money"] = ReadMoney
	Callbacks["TeamScore"] = ReadTeamScore
	Callbacks["ScoreAttrib"] = ReadScoreAttrib
	Callbacks["StatusIcon"] = ReadStatusIcon
	Callbacks["StatusValue"] = ReadStatusValue
	Callbacks["FlashBat"] = ReadFlashBat
	Callbacks["CurWeapon"] = ReadCurWeapon
	Callbacks["Health"] = ReadHealth
	Callbacks["RoundTime"] = ReadRoundTime
	Callbacks["SetFOV"] = ReadSetFOV
	Callbacks["Location"] = ReadLocation
	Callbacks["WeapPickup"] = ReadWeapPickup
	Callbacks["AmmoPickup"] = ReadAmmoPickup
	Callbacks["ScreenFade"] = ReadScreenFade
	Callbacks["Damage"] = ReadDamage
	Callbacks["DeathMsg"] = ReadDeathMsg
	Callbacks["HostagePos"] = ReadHostagePos
	Callbacks["Battery"] = ReadBattery
	Callbacks["BarTime"] = ReadBarTime
	Callbacks["HudTextArgs"] = ReadHudTextArgs
	Callbacks["HideWeapon"] = ReadHideWeapon
	Callbacks["SendAudio"] = ReadSendAudio
	Callbacks["Geiger"] = ReadGeiger
	Callbacks["Radar"] = ReadRadar
	Callbacks["ShowMenu"] = ReadShowMenu
	Callbacks["Train"] = ReadTrain
	Callbacks["ResetHUD"] = ReadResetHUD
	Callbacks["InitHUD"] = ReadInitHUD
	Callbacks["GameMode"] = ReadGameMode
	Callbacks["ViewMode"] = ReadViewMode
	Callbacks["ShadowIdx"] = ReadShadowIdx
	Callbacks["AllowSpec"] = ReadAllowSpec
	Callbacks["ItemStatus"] = ReadItemStatus
	Callbacks["ForceCam"] = ReadForceCam
	Callbacks["Crosshair"] = ReadCrosshair
	Callbacks["Spectator"] = ReadSpectator
	Callbacks["NVGToggle"] = ReadNVGToggle
	Callbacks["VGUIMenu"] = ReadVGUIMenu
	Callbacks["ADStop"] = ReadADStop
	Callbacks["BotVoice"] = ReadBotVoice
	Callbacks["Scenario"] = ReadScenario
	Callbacks["ClCorpse"] = ReadClCorpse
	Callbacks["Brass"] = ReadBrass
	Callbacks["BombDrop"] = ReadBombDrop
	Callbacks["BombPickup"] = ReadBombPickup
	Callbacks["ShowTimer"] = ReadShowTimer
	Callbacks["SpecHealth"] = ReadSpecHealth
	Callbacks["StatusText"] = ReadStatusText
	Callbacks["ReloadSound"] = ReadReloadSound
end

function ReadAmmoX(MSG)
	--[[
		This message updates the green bar indicator in the HUD weapons list. It also updates HUD backpack ammo number in the lower right corner of the screen if the given ammo type is compatible with the current weapon.
		Note: See CS Weapons Information for more information.
	]]

	local ammoId = MSG:ReadUInt8()
	local amount = MSG:ReadUInt8()

	LogValueBegin()
	LogValue("AmmoId", ammoId)
	LogValueEnd("Amount", amount)
end

function ReadWeaponList(MSG)
	--[[
		This message configures the HUD weapons list.
		Note: This is fired on map initialization.
		Note: SlotID starts from 0.
		Flags (from HLSDK):

		ITEM_FLAG_SELECTONEMPTY       1
		ITEM_FLAG_NOAUTORELOAD        2
		ITEM_FLAG_NOAUTOSWITCHEMPTY   4
		ITEM_FLAG_LIMITINWORLD        8
		ITEM_FLAG_EXHAUSTIBLE        16 // A player can totally exhaust their ammo supply and lose this weapon.
		Note: See CS Weapons Information for more information.
	]]

	local weaponName = MSG:ReadString()
	local primaryAmmoId = MSG:ReadUInt8()
	local primaryAmmoMaxAmount = MSG:ReadUInt8()
	local secondaryAmmoId = MSG:ReadUInt8()
	local secondaryAmmoMaxAmount = MSG:ReadUInt8()
	local slotId = MSG:ReadUInt8()
	local numberInSlot = MSG:ReadUInt8()
	local weaponId = MSG:ReadUInt8()
	local flags = MSG:ReadUInt8()

	LogValueBegin()
	LogValue("Name", weaponName)
	LogValue("PrimaryAmmoId", primaryAmmoId)
	LogValue("PrimaryAmmoMaxAmount", primaryAmmoMaxAmount)
	LogValue("SecondaryAmmoId", secondaryAmmoId)
	LogValue("SecondaryAmmoMaxAmount", secondaryAmmoMaxAmount)
	LogValue("SlotId", slotId)
	LogValue("NumberInSlot", numberInSlot)
	LogValue("WeaponId", weaponId)
	LogValueEnd("Flags", flags)
end

function ReadReqState(MSG)
	--[[
		Note: No Information is available for this message.
		Note: This message has no arguments.
	]]

	Client.SendCommand("VModEnable 1")
end

function ReadSayText(MSG)
	--[[
		This message prints say HUD text. The second argument can be a predefined string or a custom one. 
		In the latter case, the last two arguments aren't required.
		Examples of predefined Counter-Strike string values include #Cstrike_Chat_AllDead and #Cstrike_Name_Change.
		Note: For #Cstrike_Name_Change String2 is an old name and String3 is a new name.
	]]

    local senderId = MSG:ReadUInt8()
    local s1 = MSG:ReadString()
    local s2 = MSG:ReadString()
	local s3 = MSG:ReadString()
	
	LogValueBegin()
	LogValue("SenderId", senderId)
	LogValue("S1", s1)
	LogValue("S2", s2)
	LogValueEnd("S3", s3)
	
	--[[Log("SenderID: " .. tostring(senderId) .. ", S1: " .. s1 .. ", S2: " .. s2 .. ", S3: " .. s3)
	
	if s1 == "#Cstrike_Chat_All" then
		Log("Player" .. tostring(senderId) .. ": " .. s3)
	end]]
end

function ReadMOTD(MSG)
	--[[
		Note: Max. Text length is 60. 
		A larger MOTD is sent in multiple messages. Flag will be set to 1 for the final segment.
	]]
	local flag = MSG:ReadUInt8()
	local text = MSG:ReadString()

	LogValueBegin()
	LogValue("Flag", flag)
	LogValueEnd("Text", text)
end

function ReadTeamInfo(MSG)
	--[[
		This message sets the team information for the given player.
		Note: In CS TeamName is either "UNASSIGNED", "TERRORIST", "CT" or "SPECTATOR".
	]]

	local playerId = MSG:ReadUInt8()
	local team = MSG:ReadString()

	LogValueBegin()
	LogValue("PlayerId", playerId)
	LogValueEnd("Team", team)
end

function ReadScoreInfo(MSG)
	--[[
		This message updates the scoreboard with the given player's Score and Deaths. 
		In Counter-Strike, the score is based on the number of frags and the bomb detonating or being defused. 
		In Team Fortress Classic, the score is based on the number of kills, suicides, and captures. 
		Day of Defeat uses ScoreShort and ObjScore instead of this message to update score and deaths.
		Note: In CS the 4th argument (ClassID) is always equal to 0.
		See CS Team Constants for team indices constants list.
	]]
	local playerId = MSG:ReadUInt8()
	local score = MSG:ReadInt16()
	local deaths = MSG:ReadInt16()
	local classId = MSG:ReadInt16()
	local teamId = MSG:ReadInt16()

	LogValueBegin()
	LogValue("PlayerId", playerId)
	LogValue("Score", score)
	LogValue("Deaths", deaths)
	LogValue("ClassId", classId)
	LogValueEnd("TeamId", teamId)
end

function ReadTextMsg(MSG)
	--[[
		This message prints a custom or predefined text message.
		There does not necessarily have to be a total of 6 arguments; there could be as little as 2. For example, you can send a message with the following:

		Arg1: 1
		Arg2: #Game_join_ct
		Arg3: Pimp Daddy
	]]

	local destinationType = MSG:ReadUInt8()
	local message = MSG:ReadString()

	local submsgs = {}
	
	while MSG.Position < MSG.Size do 
		table.insert(submsgs, MSG:ReadString())
	end

	LogValueBegin()
	LogValue("DestinationType", destinationType)

	if #submsgs == 0 then
		LogValueEnd("Message", message)
		return
	end

	LogValue("Message", message)
	for I = 1, #submsgs - 1 do
		LogValue("S" .. tostring(I), submsgs[I])
	end
	LogValueEnd("S" .. tostring(#submsgs), submsgs[#submsgs])
end

function ReadServerName(MSG)
	--[[
		This message sends the server name to a client.
	]]

	local name = MSG:ReadString()

	LogValueBegin()
	LogValueEnd("Name", name)
end

function ReadMoney(MSG)
	--[[
		This message updates the amount of money on the HUD. 
		If the Flag is 1, the amount of money added will also be displayed.
	]]

	local amount = MSG:ReadInt32()
	local flag = MSG:ReadUInt8()

	LogValueBegin()
	LogValue("Amount", amount)
	LogValueEnd("Flag", flag)
end

function ReadTeamScore(MSG)
	--[[
		This message updates the team score on the scoreboard.
		Note: This message has different parameters depending upon the mod.
		Note: In CS TeamName is either "TERRORIST" or "CT".
	]]

	local team = MSG:ReadString()
	local score = MSG:ReadInt16()

	LogValueBegin()
	LogValue("Team", team)
	LogValueEnd("Score", score)
end

function ReadScoreAttrib(MSG)
	--[[
		This message updates the scoreboard attribute for the specified player. 
		For the 2nd argument, 0 is nothing, (1<<0) i.e. 1 is dead, (1<<1) i.e. 2 is bomb, (1<<2) i.e. 4 is VIP.
		Note: Flags is a bitwise value so if VIP player is dying with the bomb the Flags will be 7 i.e. bit sum of all flags.
	]]

	local playerId = MSG:ReadUInt8()
	local flags = MSG:ReadUInt8()

	LogValueBegin()
	LogValue("PlayerId", playerId)
	LogValueEnd("Flags", flags)
end

function ReadStatusIcon(MSG)
	--[[
		This message draws/removes the specified status HUD icon. 
		For Status, 0 is Hide Icon, 1 is Show Icon, 2 is Flash Icon. 
		Color arguments are optional and are required only if Status isn't equal to 0.
	]]

	local status = MSG:ReadUInt8()
	local sprite = MSG:ReadString()

	LogValueBegin()
	LogValue("Status", status)

	if status ~= 0 then
		local r = MSG:ReadUInt8()
		local g = MSG:ReadUInt8()
		local b = MSG:ReadUInt8()

		LogValue("Sprite", sprite)
		LogValue("R", r)
		LogValue("G", g)
		LogValueEnd("B", b)	
	else
		LogValueEnd("Sprite", sprite)
	end
end

function ReadStatusValue(MSG)
	--[[
		This message sends/updates the status values. For Flag, 1 is TeamRelation, 2 is PlayerID, and 3 is Health. For TeamRelation, 1 is Teammate player, 2 is Non-Teammate player, 3 is Hostage. If TeamRelation is Hostage, PlayerID will be 0 or will be not sent at all.
		Usually this is fired as a triple message, for example:

		{1,  2}  -  non-teammate player
		{2, 17}  -  player index is 17
		{3, 59}  -  player health is 59
	]]

	local flag = MSG:ReadUInt8()
	local value = MSG:ReadInt16()

	LogValueBegin()
	LogValue("Flag", flag)
	LogValueEnd("Value", value)
end

function ReadFlashBat(MSG)
	--[[
		This message updates the flashlight battery charge on the HUD.
	]]

	local percent = MSG:ReadUInt8()
	LogValueBegin()
	LogValueEnd("Percent", percent)
end

function ReadCurWeapon(MSG)
	--[[
		This message updates the numerical magazine ammo count and the corresponding ammo type icon on the HUD.
		Note: See CS Weapons Information for more information on Counter-Strike weapons.
	]]

	local isActive = MSG:ReadUInt8()
	local weaponId = MSG:ReadUInt8()
	local clipAmmo = MSG:ReadUInt8()

	LogValueBegin()
	LogValue("WeaponId", weaponId)
	LogValueEnd("ClipAmmo", clipAmmo)
end

function ReadHealth(MSG)
	--[[
		This message updates the numerical health value on the HUD.
	]]

	local value = MSG:ReadUInt8()

	LogValueBegin()
	LogValueEnd("Value", value)
end

function ReadRoundTime(MSG)
	--[[
		This message updates the round timer on the HUD. Time is in seconds.
	]]

	local time = MSG:ReadInt16()

	LogValueBegin()
	LogValueEnd("Time", time)
end

function ReadSetFOV(MSG)
	--[[
		This message sets the specified field of view.
	]]

	local degrees = MSG:ReadUInt8()

	LogValueBegin()
	LogValueEnd("Degrees", degrees)
end

function ReadLocation(MSG)
	--[[
		This message is sent when a player changes zones on a map.
	]]
	
	local playerId = MSG:ReadUInt8()
	local locationName = MSG:ReadString()

	LogValueBegin()
	LogValue("PlayerId", playerId)
	LogValueEnd("LocationName", locationName)
end

function ReadWeapPickup(MSG)
	--[[
		This message temporarily draws the corresponding weapon HUD icon in the middle of the right side of the screen.
		Note: Draw time depends on the hud_drawhistory_time client CVar value.
		Note: This is fired right before weapon is picked up (notice "before").
		Note: See CS Weapons Information for more information.
	]]
	
	local weaponId = MSG:ReadUInt8()

	LogValueBegin()
	LogValueEnd("WeaponId", weaponId)
end

function ReadAmmoPickup(MSG)
	--[[
		This message updates the green bar indicator in the HUD weapons list. 
		It also updates HUD backpack ammo number in the lower right corner of the screen if the given ammo 
			type is compatible with the current weapon.
		Note: See CS Weapons Information for more information.
	]]

	local ammoId = MSG:ReadUInt8()
	local amount = MSG:ReadUInt8()

	LogValueBegin()
	LogValue("AmmoId", ammoId)
	LogValueEnd("Amount", amount)
end

function ReadScreenFade(MSG)
	--[[
		This message fades the screen.
		Note: Duration and HoldTime is in special units. 1 second is equal to (1<<12) i.e. 4096 units.
		Flags (from HLSDK):

		FFADE_IN         0x0000 // Just here so we don't pass 0 into the function
		FFADE_OUT        0x0001 // Fade out (not in)
		FFADE_MODULATE   0x0002 // Modulate (don't blend)
		FFADE_STAYOUT    0x0004 // ignores the duration, stays faded out until new ScreenFade message received
	]]

	local duration = MSG:ReadInt16()
	local holdTime = MSG:ReadInt16()
	local flags = MSG:ReadInt16()
	local r = MSG:ReadUInt8()
	local g = MSG:ReadUInt8()
	local b = MSG:ReadUInt8()
	local a = MSG:ReadUInt8()
	
	LogValueBegin()
	LogValue("Duration", duration)
	LogValue("HoldTime", holdTime)
	LogValue("Flags", flags)
	LogValue("R", r)
	LogValue("G", g)
	LogValue("B", b)
	LogValueEnd("A", a)
end

function ReadDamage(MSG)
	--[[
		This message is sent when a player takes damage, to display the red locational indicators. 
		The last three arguments are the origin of the damage inflicter or victim origin if inflicter isn't found. 
		DamageType is a bitwise value which usually consists of a single bit.
		Note: To capture this message, you should use "b" as the third parameter in the register_event() function.
	]]

	local save = MSG:ReadUInt8()
	local take = MSG:ReadUInt8()
	local type = MSG:ReadInt32()
	local x = MSG:ReadCoord()
	local y = MSG:ReadCoord()
	local z = MSG:ReadCoord()

	LogValueBegin()
	LogValue("Save", save)
	LogValue("Take", take)
	LogValue("Type", type)
	LogValue("X", x)
	LogValue("Y", y)
	LogValueEnd("Z", z)
end

function ReadDeathMsg(MSG)
	--[[
		This event is fired to all players (MSG_ALL or MSG_BROADCAST) to notify them of a death. 
		This generates the HUD message the client sees in the upper right corner of their screen.
		It also prints the console text message "KillerName killed VictimName with TruncatedWeaponName" 
			or "*** KillerName killed VictimName with a headshot from TruncatedWeaponName ***"

		Note: This message has different parameters depending upon the mod.
		Note: KillerID may not always be a Player ID. It would be 0 if a player died from 
			fall/acid/radiation/fire/etc damage/lack of oxygen or from touch to a "trigger_hurt" entity, 
			in which cases TruncatedWeaponName will be "worldspawn" and "trigger_hurt" respectively.
		Note: For vehicle kills, TruncatedWeaponName could be "vehicle", "tank", etc.
		Note: In some mods, TruncatedWeaponName is "teammate" for a team kill, which shows a green skull in the HUD message.
	]]

	--[[
		Note: TruncatedWeaponName doesn't contain a "weapon_" prefix. See CS Weapons Information for more information.
		Note: For a grenade kill, TruncatedWeaponName isn't "hegrenade", but rather "grenade", 
		which is the actual classname of a thrown grenade.
	]]

	local killerId = MSG:ReadUInt8()
	local victimId = MSG:ReadUInt8()
	local isHeadshot = MSG:ReadUInt8()
	local weapon = MSG:ReadString()

	LogValueBegin()
	LogValue("KillerId", killerId)
	LogValue("VictimId", victimId)
	LogValue("IsHeadshot", isHeadshot)
	LogValueEnd("Weapon", weapon)
end

function ReadHostagePos(MSG)
	--[[
		This message draws/updates the blue mark on the CT players' radar which indicates the corresponding hostage's position.
		Note: It is called with Flag set to 1 on player HUD full update.
	]]
	
	local flag = MSG:ReadUInt8()
	local hostageId = MSG:ReadUInt8()
	local x = MSG:ReadCoord()
	local y = MSG:ReadCoord()
	local z = MSG:ReadCoord()

	LogValueBegin()
	LogValue("Flag", flag)
	LogValue("HostageId", hostageId)
	LogValue("X", x)
	LogValue("Y", y)
	LogValueEnd("Z", z)
end

function ReadBattery(MSG)
	--[[
		This message updates the icon and numerical armor value on the HUD.
	]]

	local armor = MSG:ReadInt16()

	LogValueBegin()
	LogValueEnd("Armor", armor)
end

function ReadBarTime(MSG)
	--[[
		This message draws a HUD progress bar which is filled from 0% to 100% for the time Duration seconds. 
		Once the bar is fully filled it will be removed from the screen automatically.
		Note: Set Duration to 0 to hide the bar.
	]]

	local duration = MSG:ReadInt16()

	LogValueBegin()
	LogValueEnd("Duration", duration)
end

function ReadHudTextArgs(MSG)
	--[[
		This message prints HUD text.
		Note: An example of TextCode could be "#Hint_you_have_the_bomb".
		Note: Prints message with specified style in titles.txt with Big signs (CS Default)
		Note: If you have problems specifying the last two arguments, use 1 and 0 respectively.
	]]

	local textCode = MSG:ReadString()
	local initHudStyle = MSG:ReadUInt8()
	local numSubMsgs = MSG:ReadUInt8()
	
	local submsgs = {}
	
	for I = 1, numSubMsgs do 
		table.insert(submsgs, MSG:ReadString())
	end
	
	LogValueBegin()
	LogValue("TextCode", textCode)
	LogValue("InitHudStyle", initHudStyle)

	if #submsgs == 0 then
		LogValueEnd("NumSubMsgs", numSubMsgs)
		return
	end

	LogValue("NumSubMsgs", numSubMsgs)
	
	for I = 1, #submsgs - 1 do
		LogValue("S" .. tostring(I), submsgs[I])
	end
	LogValueEnd("S" .. tostring(#submsgs), submsgs[#submsgs])
end

function ReadHideWeapon(MSG)
	--[[
		This message hides the specified HUD elements.
		Flags:
			1   (1<<0)  -  crosshair, ammo, weapons list
			2   (1<<1)  -  flashlight, +
			4   (1<<2)  -  ALL
			8   (1<<3)  -  radar, health, armor, +
			16   (1<<4)  -  timer, +
			32   (1<<5)  -  money, +
			64   (1<<6)  -  crosshair
			128   (1<<7)  -  +
		Symbol + mean that an additional crosshair will be drawn. That crosshair looks exactly like the one from Crosshair message.
	]]

	local flags = MSG:ReadUInt8()

	LogValueBegin()
	LogValueEnd("Flags", flags)
end

function ReadSendAudio(MSG)
	--[[
		This message plays the specified audio. An example of AudioCode could be "%!MRAD_rounddraw".
	]]

	local senderId = MSG:ReadUInt8()
	local audioCode = MSG:ReadString()
	local pitch = MSG:ReadInt16()

	LogValueBegin()
	LogValue("SenderId", senderId)
	LogValue("AudioCode", audioCode)
	LogValueEnd("Pitch", pitch)
end

function ReadGeiger(MSG)
	--[[
		This message signals the client to notify the player of the radiation level through special sound signals. 
		Distance is the distance to the hazard area.
	]]

	local distance = MSG:ReadUInt8()

	LogValueBegin()
	LogValueEnd("Distance", distance)
end

function ReadRadar(MSG)
	--[[
		This message draws/updates the dot on the HUD radar which indicates the given player position.
		Note: This works for teammates only.
	]]

	local playerId = MSG:ReadUInt8()
	local x = MSG:ReadCoord()
	local y = MSG:ReadCoord()
	local z = MSG:ReadCoord()

	LogValueBegin()
	LogValue("PlayerId", playerId)
	LogValue("X", x)
	LogValue("Y", y)
	LogValueEnd("Z", z)
end

function ReadShowMenu(MSG)
	--[[
		This message displays a "menu" to a player (text on the left side of the screen). 
		It acts like AMXX's show_menu (in fact, this is how AMXX shows a menu).
		Note: Multipart should be 1 if your menu takes up multiple messages (i.e.: string is too big to fit into one). 
		On the final message, Multipart should be 0.
	]]

	local keysBitSum = MSG:ReadInt16()
	local time = MSG:ReadUInt8()
	local multipart = MSG:ReadUInt8()
	local text = MSG:ReadString()
	
	LogValueBegin()
	LogValue("KeysBitSum", keysBitSum)
	LogValue("Time", time)
	LogValue("Multipart", multipart)
	LogValueEnd("Text", text)
end

function ReadTrain(MSG)
	--[[
		This message displays the speed bar used for controlling a train.
		Note: Speed is as follows: 0 (disable display), 1 (neutral), 2 (slow speed), 3 (medium speed), 4 (maximum speed), 5 (reverse)
	]]

	local speed = MSG:ReadUInt8()

	LogValueBegin()
	LogValueEnd("Speed", speed)
end

function ReadResetHUD(MSG)
	--[[
		This message resets the HUD.
		Note: This message has no arguments.
	]]
end

function ReadInitHUD(MSG)
	--[[
		This message initializes the HUD.
		Note: This message has no arguments.
	]]
end

function ReadGameMode(MSG)
	--[[
		This message informs the client of the current game mode.
	]]

	local gameMode = MSG:ReadUInt8()

	LogValueBegin()
	LogValueEnd("Value", gameMode)
end

function ReadViewMode(MSG)
	--[[
		Note: No Information is available for this message (HLSDK says this switches to first-person view, but it doesn't seem to function as so).
		Note: This message has no arguments.
	]]
end

function ReadShadowIdx(MSG)
	--[[
		Note: Creates/Hides shadow beneath player.
		Note: Passing 0 as the argument will hide the shadow.
	]]

	local spriteIndex = MSG:ReadInt32()

	LogValueBegin()
	LogValueEnd("SpriteIndex", spriteIndex)
end

function ReadAllowSpec(MSG)
	--[[
		This message changes whether or not "SPECTATE" appears on the change team menu. 
		It is sent whenever the allow_spectators CVar is changed, with its new value sent as the byte.
		Note: This changes how the change team menu appears, but spectating functionality is based on the actual CVar value.
	]]

	local allowed = MSG:ReadUInt8()

	LogValueBegin()
	LogValueEnd("Allowed", allowed)
end

function ReadItemStatus(MSG)
	--[[
		This message notifies the client about carried items.
		Example of some item bits:
			1   (1<<0)  -  nightvision goggles
			2   (1<<1)  -  defusal kit
	]]

	local itemsBitSum = MSG:ReadUInt8()

	LogValueBegin()
	LogValueEnd("ItemsBitSum", itemsBitSum)
end

function ReadForceCam(MSG)
	--[[
		This message is sent whenever mp_forcecam or mp_forcechasecam are changed, with their new values passed. 
		There is presumably a third CVar that this tracks, but which one is currently unknown.
		Note that this message doesn't actually change any of the spectating rules for the client.
		Note: Even if mp_forcechasecam is set to 2, it is sent by this message as 1.
	]]

	local forceCamValue = MSG:ReadUInt8()
	local forceChaseCamValue = MSG:ReadUInt8()
	local unknown = MSG:ReadUInt8()

	LogValueBegin()
	LogValue("ForceCamValue", forceCamValue)
	LogValue("ForceChaseCamValue", forceChaseCamValue)
	LogValueEnd("Unknown", unknown)
end

function ReadCrosshair(MSG)
	--[[
		This message draws/removes a crosshair. If Flag is set to 1 the crosshair will be drawn.
		Note: This crosshair looks not like the regular one, but like the one that is drawn in spectator mode.
	]]

	local flag = MSG:ReadUInt8()

	LogValueBegin()
	LogValueEnd("Flag", flag)
end

function ReadSpectator(MSG)
	--[[
		This message is sent when a player becomes an observer/spectator.
		Note: On join to Spectators this usually is fired twice in a row.
	]]

	local cliendId = MSG:ReadUInt8()
	local unknown = MSG:ReadUInt8()

	LogValueBegin()
	LogValue("ClientId", ClientId)
	LogValueEnd("Unknown", unknown)
end

function ReadNVGToggle(MSG)
	--[[
		This message toggles night vision mode. For Flag: 1 is on, 0 is off.
	]]

	local flag = MSG:ReadUInt8()

	LogValueBegin()
	LogValueEnd("Flag", flag)
end

function ReadVGUIMenu(MSG)
	--[[
		This message displays a predefined VGUI menu.
	]]

	local menuId = MSG:ReadUInt8()
	local keysBitSum = MSG:ReadInt16()
	local time = MSG:ReadUInt8()
	local multipart = MSG:ReadUInt8()
	local name = MSG:ReadString()

	LogValueBegin()
	LogValue("MenuId", menuId)
	LogValue("KeysBitSum", keysBitSum)
	LogValue("Time", time)
	LogValue("Multipart", multipart)
	LogValueEnd("Name", name)
end

function ReadADStop(MSG)
	--[[
		Note: No Information is available for this message.
		Note: This message has no arguments.
	]]
end

function ReadBotVoice(MSG)
	--[[
		This message displays (or hides) the voice icon above a user's head and the talking icon on the right side of the screen. 
		This is called by CZ for bots; it's not called for regular players, 
		although you can specify a regular player (non-bot) for the PlayerIndex. 
		Status is 1 for talking, or 0 for not talking.
	]]

	local status = MSG:ReadUInt8()
	local playerIndex = MSG:ReadUInt8()

	LogValueBegin()
	LogValue("Status", status)
	LogValueEnd("PlayerIndex", playerIndex)
end

function ReadScenario(MSG)
	--[[
		If Active is 0, this display will be hidden. If Active is 1, 
		this displays Sprite (valid names listed in sprites/hud.txt) to the right of the round 
		timer with an alpha value of Alpha (100-255). 
		If FlashRate is nonzero, then the sprite will flash from the given alpha to an alpha of 100, 
		at a rate of FlashRate (measured in ???). This is used by CZ to display how many hostages remain unrescued, 
		and also to display the ticking bomb when it is planted.

		Note: If Active is 0, don't send any other arguments afterwards. 
			Also, you don't need to send either short if FlashRate is just going to be 0.
		Note: This works in both CS and CZ!
		Note: In CZ (and possibly CS), if someone respawns after the bomb has been planted, 
			their Scenario event will not work at all until the next round.	
	]]
			
	local active = MSG:ReadUInt8()

	LogValueBegin()

	if active == 0 then
		LogValueEnd("Active", active)
		return
	end

	LogValue("Active", active)
	
	local sprite = MSG:ReadString()

	LogValue("Sprite", sprite)

	local alpha = MSG:ReadUInt8()
	
	if alpha == 0 then
		LogValueEnd("Alpha", alpha)
		return
	end

	LogValue("Alpha", alpha)

	local flashRate = MSG:ReadInt16()
	local flashDelay = MSG:ReadInt16()

	LogValue("FlashRate", flashRate)
	LogValueEnd("FlashDelay", flashDelay)
end

function ReadClCorpse(MSG)
	--[[
		This message spawns a player's corpse. ModelName is the player's model name, for example: "leet". Delay is a delay before animation playback, which can be a negative value.
		Note: Coord and Delay is multiplied by 128.
		Note: In CS, argument #10 is always equal to 0.
		See CS Team Constants for team indices constants list.
	]]

	local modelName = MSG:ReadString()
	local x = MSG:ReadInt32()
	local y = MSG:ReadInt32()
	local z = MSG:ReadInt32()
	local angle0 = MSG:ReadCoord()
	local angle1 = MSG:ReadCoord()
	local angle2 = MSG:ReadCoord()
	local delay = MSG:ReadInt32()
	local sequence = MSG:ReadUInt8()
	local classId = MSG:ReadUInt8()
	local teamId = MSG:ReadUInt8()
	local playerId = MSG:ReadUInt8()

	LogValueBegin()
	LogValue("ModelName", modelName)
	LogValue("X", x)
	LogValue("Y", y)
	LogValue("Z", z)
	LogValue("Angle0", angle0)
	LogValue("Angle0", angle1)
	LogValue("Angle0", angle2)
	LogValue("Delay", delay)
	LogValue("Sequence", sequence)
	LogValue("ClassId", classId)
	LogValue("TeamId", teamId)
	LogValueEnd("PlayerId", playerId)
end

function ReadBrass(MSG)
	--[[
		This message creates a brass shell. Used, for example, by the AWP, after firing.
	]]

	local messageId = MSG:ReadUInt8()
	local startX = MSG:ReadCoord()
	local startY = MSG:ReadCoord()
	local startZ = MSG:ReadCoord()
	local velocityX = MSG:ReadCoord()
	local velocityY = MSG:ReadCoord()
	local velocityZ = MSG:ReadCoord()
	local unkX = MSG:ReadCoord()
	local unkY = MSG:ReadCoord()
	local unkZ = MSG:ReadCoord()
	local rotation = MSG:ReadAngle()
	local modelIndex = MSG:ReadInt16()
	local bounceSoundType = MSG:ReadUInt8()
	local life = MSG:ReadUInt8()
	local playerId = MSG:ReadUInt8()

	LogValueBegin()
	LogValue("MessageId", messageId)
	LogValue("StartX", startX)
	LogValue("StartY", startY)
	LogValue("StartZ", startZ)
	LogValue("VelocityX", velocityX)
	LogValue("VelocityY", velocityY)
	LogValue("VelocityZ", velocityZ)
	LogValue("UnkX", unkX)
	LogValue("UnkY", unkY)
	LogValue("UnkZ", unkZ)
	LogValue("Rotation", rotation)
	LogValue("ModelIndex", modelIndex)
	LogValue("BounceSoundType", bounceSoundType)
	LogValue("Life", life)
	LogValueEnd("PlayerId", playerId)
end

function ReadBombDrop(MSG)
	--[[
		This message is sent when the bomb is dropped or planted by a player.
		The first three arguments are the origin of the dropped bomb. 
		The last argument is set to 0 if the bomb was dropped due to voluntary dropping or death/disconnect. 
		It is set to 1 if the bomb was planted, which will trigger the round timer to hide. 
		It also will show the dropped bomb on the Terrorist team's radar in the location specified by the 
		first three arguments.
	]]

	local x = MSG:ReadCoord()
	local y = MSG:ReadCoord()
	local z = MSG:ReadCoord()
	local flag = MSG:ReadUInt8()

	LogValueBegin()
	LogValue("X", x)
	LogValue("Y", y)
	LogValue("Z", z)
	LogValueEnd("Flag", flag)
end

function ReadBombPickup(MSG)
	--[[
		This message just tells the clients that the bomb has been picked up. 
		It will cause the dropped bomb to disappear from the Terrorist team's radar.
		Note: This message has no arguments.
	]]
end

function ReadShowTimer(MSG)
	--[[
		This message forces the round timer to display.
		Note: This message has no arguments.
	]]
end

function ReadSpecHealth(MSG)
	--[[
		This message updates a spectator's screen with health of the currently spectated player, on health change (on TakeDamage, doesn't seems to be sent anywhere else).
		Note: Previous information has been checked on cs1.6/cz only
	]]

	local health = MSG:ReadUInt8()
	
	LogValueBegin()
	LogValueEnd("Health", health)
end

function ReadStatusText(MSG)
	--[[
		This message specifies the status text format.
	]]

	local unk = MSG:ReadUInt8()
	local text = MSG:ReadString()

	LogValueBegin()
	LogValue("Unk", unk)
	LogValueEnd("Text", text)
end

function ReadReloadSound(MSG)
	--[[
		This message plays generic reload sounds.
		Note: Setting IsNotShotgun to 1 will play weapons/generic_reload.wav
		Note: Setting IsNotShotgun to 0 will play weapons/generic_shot_reload.wav
	]]

	local volume = MSG:ReadUInt8()
	local isNotShotgun = MSG:ReadUInt8()

	LogValueBegin()
	LogValue("Volume", volume)
	LogValueEnd("IsNotShotgun", isNotShotgun)
end