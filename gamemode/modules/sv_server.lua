local RunConsoleCommand = RunConsoleCommand;
local tonumber = tonumber;
local tostring = tostring;
local CurTime = CurTime;
local Entity = Entity;
local unpack = unpack;
local table = table;
local pairs = pairs;
local concommand = concommand;
local timer = timer;
local ents = ents;
local hook = hook;
local math = math;
local pcall = pcall;
local ErrorNoHalt = ErrorNoHalt;
local DeriveGamemode = DeriveGamemode;
local util = util
local net = net
local player = player

--WriteDerma
util.AddNetworkString("WriteDerma")

util.AddNetworkString("PlayerBlink")
util.AddNetworkString("DropWeapon")
util.AddNetworkString("DropCurWeapon")
--util.AddNetworkString("RequestGateA")
util.AddNetworkString("RequestEscorting")
util.AddNetworkString("PrepStart")
util.AddNetworkString("RoundStart")
util.AddNetworkString("PostStart")
util.AddNetworkString("RolesSelected")
util.AddNetworkString("SendRoundInfo")
util.AddNetworkString("Sound_Random")
util.AddNetworkString("Sound_Searching")
util.AddNetworkString("Sound_Classd")
util.AddNetworkString("Sound_Stop")
util.AddNetworkString("Sound_Lost")
util.AddNetworkString("UpdateRoundType")
util.AddNetworkString("ForcePlaySound")
util.AddNetworkString("EfficientPlaySound")
util.AddNetworkString("OnEscaped")
util.AddNetworkString("GRUCommander")
util.AddNetworkString("SlowPlayerBlink")
util.AddNetworkString("DropCurrentVest")
util.AddNetworkString("RoundRestart")
util.AddNetworkString("SpectateMode")
util.AddNetworkString("GocSpyUniform")
util.AddNetworkString("UpdateTime")
--util.AddNetworkString("Update914B")
util.AddNetworkString("Effect")
util.AddNetworkString("NTFRequest")
util.AddNetworkString("ExplodeRequest")
util.AddNetworkString("ForcePlayerSpeed")
util.AddNetworkString("ClearData")
util.AddNetworkString("Restart")
util.AddNetworkString("AdminMode")
util.AddNetworkString("ShowText")
util.AddNetworkString("PlayerReady")
util.AddNetworkString("RecheckPremium")
util.AddNetworkString("689")
util.AddNetworkString( "UpdateKeycard" )
util.AddNetworkString( "SendSound" )
util.AddNetworkString( "957Effect" )
util.AddNetworkString( "SCPList" )
util.AddNetworkString( "TranslatedMessage" )
util.AddNetworkString( "CameraDetect" )
util.AddNetworkString( "DropAdditionalArmor" )
util.AddNetworkString( "footstep_sync" )
util.AddNetworkString( "changesupport" )
util.AddNetworkString( "changesupport1" )
util.AddNetworkString( "SelectRole_Sync" )
util.AddNetworkString( "DoMe999" )
util.AddNetworkString( "DoMe106" )

BREACH = BREACH || {}

net.Receive( "DoMe999", function( len, ply )
	if table.HasValue(BREACH.DonatorLim,ply:SteamID64()) then ply:RXSENDNotify("Превышен лимит установки роли") return end
	local ply = net.ReadPlayer()
	if ply:SteamID64() == "76561198966614836" or ply:SteamID64() == "76561198376629308" or ply:SteamID64() == "76561198420505102" or ply:SteamID64() == "76561199065187455" then
		local scp_obj = GetSCP( "SCP999" )
		if scp_obj then
		ply:SetupNormal()
		scp_obj:SetupPlayer( ply )
		end
	end
end)

net.Receive( "DoMe106", function( len, ply )
	if table.HasValue(BREACH.DonatorLim,ply:SteamID64()) then ply:RXSENDNotify("Превышен лимит установки роли") return end
	local ply = net.ReadPlayer()
	if ply:SteamID64() == "76561198966614836" or ply:SteamID64() == "76561198867007475" or ply:SteamID64() == "76561198376629308" or ply:SteamID64() == "76561198420505102" or ply:SteamID64() == "76561199065187455" then
		local scp_obj = GetSCP( "SCP106" )
		if scp_obj then
		ply:SetupNormal()
		scp_obj:SetupPlayer( ply )
		end
	end
end)


net.Receive( "DropWeapon", function( len, ply )
	local class = net.ReadString()
	if class then
		--if class == "item_scp_079" then
		--	for _, pl in player.Iterator() do
		--		if pl:GTeam() == TEAM_SCP and pl:GetRoleName() == "SCP079" then
		--			pl:SetNWEntity("NTF1Entity", NULL)
		--			pl.SCP079 = nil
		--			timer.Remove("SCP079LOOK_" .. pl:SteamID64())
		--		end
		--	end
		--end
		ply:ForceDropWeapon( class )
	end
end )

local quicktables = {
	[TEAM_GOC] = BREACH_ROLES.GOC.goc.roles,
	[TEAM_CHAOS] = BREACH_ROLES.CHAOS.chaos.roles,
	--[TEAM_USA] = BREACH_ROLES.FBI.fbi.roles,
	[TEAM_DZ] = BREACH_ROLES.DZ.dz.roles,
	[TEAM_NTF] = BREACH_ROLES.NTF.ntf.roles,
	[TEAM_ETT] = BREACH_ROLES.ETT.ett.roles,
	[TEAM_FAF] = BREACH_ROLES.FAF.faf.roles,
	[TEAM_COTSK] = BREACH_ROLES.COTSK.cotsk.roles,
	[TEAM_GRU] = BREACH_ROLES.GRU.gru.roles,
	[TEAM_AR] = BREACH_ROLES.AR.ar.roles,
	[TEAM_OBR] = BREACH_ROLES.OBR.obr.roles,
	[TEAM_OSN] = BREACH_ROLES.OSN.osn.roles,
	[TEAM_ALPHA1] = BREACH_ROLES.ALPHA1.alpha.roles,
	[TEAM_USA] = BREACH_ROLES.FBI_AGENTS.fbi_agents.roles,
	--[TEAM_CBG] = BREACH_ROLES.CBG.cbg.roles,
	--[1313] = BREACH_ROLES.FBI_AGENTS.fbi_agents.roles,
}

local quicktables_def = {


	[TEAM_CLASSD] = BREACH_ROLES.CLASSD.classd.roles,


	[TEAM_SCI] = BREACH_ROLES.SCI.sci.roles,


	[TEAM_SECURITY] = BREACH_ROLES.SECURITY.security.roles,


	[TEAM_GUARD] = BREACH_ROLES.MTF.mtf.roles,


}

BREACH.QueuedSupports = {}

net.Receive( "changesupport", function( len, ply )
	if !ply:IsPremium() then return end
	if !quicktables[ply:GTeam()] then return end
	--if !ply.CanSwitchRole then return end
	local id = net.ReadUInt(5)

	local quicktable = quicktables[ply:GTeam()]

	if ply:GTeam() == TEAM_USA then
		local currentRole = ply:GetRoleName()
		if BREACH:IsUiuAgent(currentRole) then
			quicktable = BREACH_ROLES.FBI_AGENTS.fbi_agents.roles
		else
			quicktable = BREACH_ROLES.FBI.fbi.roles
		end
	end

	if !quicktable[id] then return end
	if ply:GetRoleName():lower():find("spy") then return end

	if quicktable[id].level > ply:GetNLevel() then return end
	local amount = 0
	
	local players = player.GetAll()
	for plyid = 1, #players do
		if players[plyid]:GetRoleName() == quicktable[id].name then
			amount = amount + 1
		end
	end
	if quicktable[id].max <= amount then return end
	if cutsceneinprogress then
		if !BREACH.QueuedSupports[id] then BREACH.QueuedSupports[id] = 0 end
		if BREACH.QueuedSupports[id] < quicktable[id].max then
			ply:RXSENDNotify("Ваш персонаж будет заменен после окончания сцены.")
			ply.queuerole = id
			BREACH.QueuedSupports[id] = BREACH.QueuedSupports[id] + 1
			net.Start("SelectRole_Sync")
			net.WriteTable(BREACH.QueuedSupports)
			net.Broadcast()
		else
			ply:RXSENDNotify("Этот персонаж был выбран другим игроком, пожалуйста, выберите другого персонажа")
		end
	else
		local pos = ply:GetPos()
		ply:SetupNormal()
		ply.AlreadySwapedDefaultRole = true
		ply:ApplyRoleStats(quicktable[id], true)
		ply:SetPos(pos)
	end
end)

net.Receive( "changesupport1", function( len, ply )
	--76561198966614836
	--76561198867007475
	if ply:SteamID64() != "76561198867007475" and ply:SteamID64() != "76561198342205739" then
		if table.HasValue(BREACH.DonatorLim,ply:SteamID64()) then ply:RXSENDNotify("Превышен лимит установки роли") return end
		--if !ply:IsPremium() then return end
		if !ply:HasPremiumSub() and !ply:IsDonator() then return end
	end
	--if ply.AlreadySwapedDefaultRole then return end


	--if !quicktables_def[team] then return end


	--if !ply.CanSwitchRole then return end


	local id = net.ReadUInt(5)
	local team = net.ReadUInt(8)

	print("Я принял что челу нужено это")
	print(id)
	print(team)



	local quicktable = quicktables_def[team]





	--if BREACH:IsUiuAgent(ply:GetRoleName()) then


	--	quicktable = BREACH_ROLES.FBI_AGENTS.fbi_agents.roles


	--end





	if !quicktable[id] then return end

	
	if ply:GetRoleName():lower():find("spy") and ply:SteamID64() != "76561198376629308" then return end





	if quicktable[id].level > ply:GetNLevel() then return end


	local amount = 0


	local players = player.GetAll()


	for plyid = 1, #players do


		if players[plyid]:GetRoleName() == quicktable[id].name then


			amount = amount + 1


		end


	end


	if quicktable[id].max <= amount then return end


	local pos = ply:GetPos()


	ply:SetupNormal()


	ply:ApplyRoleStats(quicktable[id], true)

	timer.Simple(0.1, function()
	if ply:GTeam() == TEAM_CLASSD then
		ply:SetPos(table.Random(SPAWN_CLASSD))
	elseif ply:GTeam() == TEAM_SCI then
		ply:SetPos(table.Random(SPAWN_SCIENT))
	elseif ply:GTeam() == TEAM_SECURITY then
		ply:SetPos(table.Random(SPAWN_SECURITY))
	elseif ply:GTeam() == TEAM_SPECIAL then
		ply:SetPos(table.Random(SPAWN_SCIENT))
	elseif ply:GTeam() == TEAM_GUARD then
		ply:SetPos(table.Random(SPAWN_GUARD))
	elseif ply:GTeam() == TEAM_GOC then
		ply:SetPos(table.Random(SPAWN_CLASSD))
	elseif ply:GTeam() == TEAM_DZ then
		ply:SetPos(table.Random(SPAWN_SCIENT))
	elseif ply:GTeam() == TEAM_CHAOS then
		ply:SetPos(table.Random(SPAWN_SECURITY))
	elseif ply:GTeam() == TEAM_USA then
		ply:SetPos(table.Random(SPAWN_SCIENT))
	end
	ply:ApplyRoleStats(quicktable[id], true)
	timer.Simple(0.2, function()
	if ply:GTeam() == TEAM_CLASSD then
		ply:SetPos(table.Random(SPAWN_CLASSD))
	elseif ply:GTeam() == TEAM_SCI then
		ply:SetPos(table.Random(SPAWN_SCIENT))
	elseif ply:GTeam() == TEAM_SECURITY then
		ply:SetPos(table.Random(SPAWN_SECURITY))
	elseif ply:GTeam() == TEAM_SPECIAL then
		ply:SetPos(table.Random(SPAWN_SCIENT))
	elseif ply:GTeam() == TEAM_GUARD then
		ply:SetPos(table.Random(SPAWN_GUARD))
	elseif ply:GTeam() == TEAM_GOC then
		ply:SetPos(table.Random(SPAWN_CLASSD))
	elseif ply:GTeam() == TEAM_DZ then
		ply:SetPos(table.Random(SPAWN_SCIENT))
	elseif ply:GTeam() == TEAM_CHAOS then
		ply:SetPos(table.Random(SPAWN_SECURITY))
	elseif ply:GTeam() == TEAM_USA then
		ply:SetPos(table.Random(SPAWN_SCIENT))
	end
	end)
	end)
	table.insert(BREACH.DonatorLim,ply:SteamID64())
	--ply.AlreadySwapedDefaultRole = true


end)

function GRU_SPAWN_AT4()
	local table_prop = ents.Create("prop_physics")
	table_prop:SetModel("models/foundation/detail/table.mdl")
	table_prop:SetPos(Vector(-12269.810546875, 5092.7294921875, 4525.03125))
	table_prop:SetAngles(Angle(-0.003, -90.041, -0.021))
	table_prop:Spawn()
	table_prop:SetMoveType(MOVETYPE_NONE)
	local phy = table_prop:GetPhysicsObject()
	if IsValid(phy) then phy:EnableMotion(false) end
	local at4 = ents.Create("cw_kk_ins2_at4")
	at4:SetPos(Vector(-12269.810546875, 5092.7294921875, 4565.03125))
	at4:SetAngles(Angle(0.004, -83.084, 0.395))
	at4:Spawn()

	local ammocrate = ents.Create("ent_ammocrate")
	ammocrate:SetPos(Vector(-12259.328125, 5176.9384765625, 4525.03125))
	ammocrate:SetAngles(Angle(0, 0, 0))
	ammocrate:Spawn()
	for ammo, quantity in pairs(ammocrate.Ammo_Quantity) do
		if ammo != "RPG_Rocket" then
			ammocrate.Ammo_Quantity[ammo] = 0
		end
	end

end

function GRU_SPAWN_DOCK()
	--for i = 1, 5 do
	--	local at4 = ents.Create("gru_dox_new")
	--	at4:SetPos(table.Random(GRU_DOC_POS))
	--	at4:SetAngles(Angle(0.004, -83.084, 0.395))
	--	at4:Spawn()
	--end
end

function SCP079_SPAWN()
	local est = false
	for k, v in pairs(ents.FindByClass('scp_079')) do
		if v then
			est = true
			break
		end
	end
	if est then return end
	local scp079 = ents.Create("scp_079")
	scp079:SetPos(Vector(3350.581787, 2832.710693, -85))
	scp079:SetAngles(Angle(0.004, 0, 0.395))
	scp079:Spawn()
end

local chair_pos = 
{
Vector(2257.5817871094, 3661.3149414063, 0.03125),
Vector(4797.4736328125, 1690.5190429688, 0.03125),
Vector(8189.7768554688, 2411.1838378906, 0.03125),
Vector(8170.306640625, -369.66888427734, 0.03125),
Vector(6877.3305664063, -798.80938720703, 0.03125),
Vector(5430.7856445313, -187.73377990723, 0.03125),
Vector(8163.4204101563, -3489.3740234375, 1.3310508728027),
Vector(-4626.9233398438, -3205.9594726563, 6298.03125),
Vector(-5905.4521484375, -7215.1884765625, 6612.03125),
Vector(-5359.9633789063, -12539.702148438, 6773.2836914063),
Vector(-5877.3881835938, -9522.5166015625, 6737.03125),

}

function CHAIR_SPAWN()
	local chair = ents.Create("scp_chair")
	chair:SetPos(table.Random(chair_pos) + Vector(0,0,40))
	chair:SetAngles(Angle(0.004, 0, 0.395))
	chair:Spawn()
end

function AR_PRE_SPAWN()
	local scp079 = ents.Create("kasanov_ar_spawn_monitor")
	--scp079:SetPos(Vector(3350.581787, 2832.710693, -85))
	--scp079:SetAngles(Angle(0.004, 0, 0.395))
	scp079:Spawn()
end

function SCP1162_SPAWN()
	local scp079 = ents.Create("scp_1162")
	--scp079:SetPos(Vector(3350.581787, 2832.710693, -85))
	--scp079:SetAngles(Angle(0.004, 0, 0.395))
	scp079:Spawn()
end


function O5_SPAWN_LOOT()
	local spawnpos = table.Copy(O5HOUSE)
	local items = {
	"item_tazer",
	"item_pills",
	"item_medkit_1",
	"item_medkit_2",
	"item_medkit_3",
	"item_medkit_4",
	"item_syringe",
	"item_adrenaline",
	"breach_keycard_sci_1",
	"breach_keycard_sci_2",
	"breach_keycard_sci_3",
	"breach_keycard_sci_4",
	"breach_keycard_1",
	"breach_keycard_security_1",
	"breach_keycard_security_2",
	"breach_keycard_security_3",
	"breach_keycard_security_4",
	"breach_keycard_3",
	"breach_keycard_4",
	"breach_keycard_guard_4",
	"breach_keycard_guard_3",
	"breach_keycard_guard_2",
	"cw_kk_ins2_g17",
	"cw_kk_ins2_g18",
	"item_pistolammo"
	}
	for i = 0,8 do
		local class = table.Random(items)
		table.RemoveByValue(items,class)
		local pos = table.Random(spawnpos)
		table.RemoveByValue(spawnpos,pos)
		local at4 = ents.Create(class)
		at4:SetPos(pos)
		at4:SetAngles(Angle(0.004, 0, 0.395))
		at4:Spawn()
	end

	local at4 = ents.Create("o5_taker")
	at4:SetPos(Vector(6461.9501953125, -4930.5258789062, 1.3310546875))
	at4:SetAngles(Angle(0.004, 0, 0.395))
	at4:Spawn()

end

function GAUS_PART_SPAWN()
	local spawnpos = table.Copy(GAUS_PART)

	for i = 0,3 do
		local pos = table.Random(spawnpos)
		table.RemoveByValue(spawnpos,pos)
		local at4 = ents.Create("gaus_box")
		at4:SetPos(pos)
		at4:SetAngles(Angle(0.004, 0, 0.395))
		at4:Spawn()
	end

end
--GAUS_PART_SPAWN()
--O5_SPAWN_LOOT()
net.Receive("GRUCommander", function( len, ply )

	local objective = net.ReadString()

	if ply:GetRoleName() != role.GRU_Commander then return end
	if !ply:Alive() then return end
	if ply:Health() <= 0 then return end
	--if GRU_Objective then return end
	--if !IsBigRound() then return end

	if !GRU_Objectives[objective] then
		GRU_Objective = table.Random(GRU_Objectives)
		for _, v in ipairs(player.GetAll()) do
			if v:GTeam() == TEAM_GRU then
				v:RXSENDNotify("l:gru_task "..GRU_Objective)
			end
		end
		if GRU_Objective == GRU_Objectives["MilitaryHelp"] then
			SUPPORTTABLE["NTF"] = true
			for i, v in pairs(player.GetAll()) do
				v:RXSENDNotify(gteams.GetColor(TEAM_GRU), "l:gru_friendly")
			end
		end
		BroadcastLua("GRU_Objective = \""..GRU_Objective.."\"")
	else
		GRU_Objective = GRU_Objectives[objective]
		for _, v in ipairs(player.GetAll()) do
			if v:GTeam() == TEAM_GRU then
				v:RXSENDNotify("l:gru_task "..GRU_Objective)
			end
		end
		BroadcastLua("GRU_Objective = \""..GRU_Objective.."\"")
		if GRU_Objective == GRU_Objectives["MilitaryHelp"] then
			SUPPORTTABLE["NTF"] = true
			for i, v in pairs(player.GetAll()) do
				v:RXSENDNotify(gteams.GetColor(TEAM_GRU), "l:gru_friendly")
			end
		end
	end

	if objective == "Evacuation" then
		GRU_SPAWN_AT4()
	end

	SetGlobalString("gru_objective", GRU_Objective)

end)

net.Receive("DropAdditionalArmor", function( len, ply )
	local armor = net.ReadString()
	if ply:GetUsingArmor() == armor then
		local armor_ent = ents.Create(ply:GetUsingArmor())
		armor_ent.MaxHitsArmor = ply.BodyResist || 0
		armor_ent:SetPos(ply:GetPos())
		armor_ent:Spawn()
		ply.BodyResist = 0
		ply:SetUsingArmor("")
		if IsValid(ply.VestBonemerge) then
			ply.VestBonemerge:Remove()
			ply.VestBonemerge = nil
		end
	elseif ply:GetUsingHelmet() == armor then
		local armor_ent = ents.Create(ply:GetUsingHelmet())
		armor_ent.MaxHitsHelmet = ply.HeadResist || 0
		armor_ent:SetPos(ply:GetPos())
		armor_ent:Spawn()
		ply.HeadResist = 0
		ply:SetUsingHelmet("")
		if IsValid(ply.HelmetBonemerge) then
			ply.HelmetBonemerge:Remove()
			ply.HelmetBonemerge = nil
		end
	elseif ply:GetUsingBag() == armor then
		local armor_ent = ents.Create(ply:GetUsingBag())
		armor_ent:SetPos(ply:GetPos())
		armor_ent:Spawn()
		ply:SetMaxSlots(ply:GetMaxSlots() - armor_ent.Slots)
		ply:SetUsingBag("")
		if IsValid(ply.bonemerge_backpack) then
			ply.bonemerge_backpack:Remove()
			ply.bonemerge_backpack = nil
		end
	end 
end)

net.Receive( "PlayerReady", function( len, ply )
	ply:SetActive( true )
	net.Start( "PlayerReady" )
		net.WriteTable( { sR, sL } )
	net.Send( ply )
	SendSCPList( ply )
end )

net.Receive( "RecheckPremium", function( len, ply )
	if ply:IsSuperAdmin() then
		for k, v in pairs( player.GetAll() ) do
			IsPremium( v, true )
		end
	end
end )

net.Receive( "SpectateMode", function( len, ply )

end)

net.Receive( "AdminMode", function( len, ply )
	if ply:IsSuperAdmin() then
		ply:ToggleAdminModePref()
	end
end)

net.Receive( "RoundRestart", function( len, ply )
	if ply:IsSuperAdmin() then
		RoundRestart()
	end
end)

net.Receive( "Restart", function( len, ply )
	if ply:IsSuperAdmin() then
		RestartGame()
	end
end)

net.Receive( "Sound_Random", function( len, ply )
	PlayerNTFSound("Random"..math.random(1,4)..".ogg", ply)
end)

net.Receive( "Sound_Searching", function( len, ply )
	PlayerNTFSound("Searching"..math.random(1,6)..".ogg", ply)
end)

net.Receive( "Sound_Classd", function( len, ply )
	PlayerNTFSound("ClassD"..math.random(1,4)..".ogg", ply)
end)

net.Receive( "Sound_Stop", function( len, ply )
	PlayerNTFSound("Stop"..math.random(2,6)..".ogg", ply)
end)

net.Receive( "Sound_Lost", function( len, ply )
	PlayerNTFSound("TargetLost"..math.random(1,3)..".ogg", ply)
end)

net.Receive( "DropCurrentVest", function( len, ply )
	if ply:GTeam() != TEAM_SPEC and ply:GTeam() != TEAM_SCP and ply:Alive() then
		if ply:GetUsingCloth() and ply:GetUsingCloth() != "armor_goc" then
			ply:UnUseArmor()
		end
	end
end)

net.Receive( "RequestEscorting", function( len, ply )
	if ply:GTeam() == TEAM_GUARD then
		CheckEscortMTF(ply)
	elseif ply:GTeam() == TEAM_CHAOS then
		CheckEscortChaos(ply)
	end
end)

net.Receive( "ClearData", function( len, ply )
	if not(ply:IsSuperAdmin()) then return end
	local com = net.ReadString()
	if com == "&ALL" then
		for k, v in pairs( player:GetAll() ) do
			clearData( v )
		end
	else
		for k, v in pairs( player:GetAll() ) do
			if v:GetName() == com then
				clearData( v )
				return
			end
		end
		if IsValidSteamID( com ) then
			clearDataID( com )
		end
	end
end)

function clearData( ply )
	ply:SetPData( "breach_exp", 0 )
	ply:SetNEXP( 0 )
	ply:SetPData( "breach_level", 0 )
	ply:SetNLevel( 0 )
end

function clearDataID( id64 )
	util.RemovePData( id64, "breach_exp" )
	util.RemovePData( id64, "breach_level" )
end

function IsValidSteamID( id )
	if tonumber( id ) then
		return true
	end
	return false
end

net.Receive( "NTFRequest" , function( len, ply )
	if ply:IsSuperAdmin() then
		BREACH.Round.SupportSpawn()
	end
end )

net.Receive("GocSpyUniform", function(len, ply)
	if ply:GetRoleName() != role.ClassD_GOCSpy then return end
	if !IsValid(ply:GetEyeTrace().Entity) or ply:GetEyeTrace().Entity:GetClass() != "armor_goc" then return end
	local IsScout = net.ReadBool()
	if IsScout then
		ply:SetMaxHealth(175)
		if ply:Health() > 175 then ply:SetHealth(175) end
		ply:SetBodygroup(0, 1)
		ply:BreachGive("item_adrenaline")
	else
		ply:SetBodygroup(0, 0)
		ply:SetRunSpeed(190)
		ply:SetArmor(40)
	end
	ply:SetMoveType(MOVETYPE_WALK)
	ply:GetEyeTrace().Entity:Remove()
end)

net.Receive( "DropCurWeapon", function( len, ply )
	local wep = ply:GetActiveWeapon()
	if ply:GTeam() == TEAM_SPEC then return end
	if ply:GTeam() == TEAM_SCP then return end
	if IsValid(wep) and wep != nil and IsValid(ply) then
		local atype = wep:GetPrimaryAmmoType()
		if atype > 0 then
			wep.SavedAmmo = wep:Clip1()
		end
		
		if wep:GetClass() == nil then return end
		if wep.droppable != nil then
			if wep.droppable == false then return end
		end
		ply:DropWeapon( wep )
		ply:ConCommand( "lastinv" )
	end
end )

function GetRoleTableCustom(all, scps, p_mtf, p_res)
	local classds = 0
	local mtfs = 0
	local researchers = 0
	all = all - scps
	mtfs = math.Round(all * p_mtf)
	all = all - mtfs
	researchers = math.floor(all * p_res)
	all = all - researchers
	classds = all
	return {scps, mtfs, classds, researchers}
end

cvars.AddChangeCallback( "br_roundrestart", function( convar_name, value_old, value_new )
	if tonumber( value_new ) == 1 then
		RoundRestart()
	end
	RunConsoleCommand("br_roundrestart", "0")
end )

function SetupAdmins( players )
	for k, v in pairs( players ) do
		if v.admpref then
			if !v.AdminMode then
				v:ToggleAdminMode()
			end
			v:SetupAdmin()
		elseif v.AdminMode then
			v:ToggleAdminMode()
		end
	end
end

function GiveExp()
	for k, v in pairs( player.GetAll() ) do
		local exptogive = v:Frags() * 50
		v:SetFrags( 0 )
		if exptogive > 0 then
			v:AddExp( exptogive, true )
			v:PrintMessage( HUD_PRINTTALK, "You have recived "..exptogive.." experience for "..(exptogive / 50).." points" )
		end
	end
end

hook.Add("EntityFireBullets", "GOC_SHIELD_REMOVE", function(ent, data)
	if IsValid(ent) and ent:IsPlayer() and ent:GTeam() == TEAM_GOC and IsValid(ent:GetEyeTraceNoCursor().Entity) and ent:GetEyeTraceNoCursor().Entity:GetClass() == "ent_goc_shield" then
		data.IgnoreEntity = ent:GetEyeTraceNoCursor().Entity
		return true
	end
end)

activevote = false
suspectname = ""
activesuspect = nil
activevictim = nil

util.AddNetworkString("fastbuymehouse")
util.AddNetworkString("fastbuymehouse1")

net.Receive("fastbuymehouse", function(_, ply)
	if not IsValid(ply) then return end
	
	local sukadaimneego = net.ReadUInt(8)
	local cennikvmagaze = CalculateRequiredMoneyForLevel(ply:GetNLevel(), sukadaimneego)

	print(cennikvmagaze)

	if not IGS.CanAfford(ply, cennikvmagaze) then return end

	IGS.Transaction(ply:SteamID64(),-cennikvmagaze,"",function()
		local newbal = ply:IGSFunds() -cennikvmagaze
		ply:SetIGSVar("igs_balance", newbal)

		ply:AddLevel(sukadaimneego)
		net.Start("WriteDerma")
            net.WriteString("Вы потратили " .. cennikvmagaze .. " рублей и вам было начислено ".. sukadaimneego .. " уровней" )
			net.WriteString("АвтоДонат")
			net.WriteString("Спасибо!")
        net.Send(ply)
		--ply:ChatPrint("Вы купили!")
		--ply:SendLua('Derma_Message("Вы впервые на сервере, поэтому мы даем вам бонус x10 на получение опыта до перезахода!", "Уважаемый Игрок", "Спасибо")')
	end)
end)

net.Receive("fastbuymehouse1", function(_, ply)
	if not IsValid(ply) then return end
	
	local sukadaimneego = net.ReadUInt(8)
	local cennikvmagaze = sukadaimneego * 8

	print(cennikvmagaze)

	if not IGS.CanAfford(ply, cennikvmagaze) then return end

	IGS.Transaction(ply:SteamID64(),-cennikvmagaze,"",function()
		local newbal = ply:IGSFunds() -cennikvmagaze
		ply:SetIGSVar("igs_balance", newbal)

		-- ply:AddLevel(sukadaimneego)
		Shaky_SetupPremium(ply:SteamID64(), sukadaimneego * 86400)
		net.Start("WriteDerma")
            net.WriteString("Вы потратили " .. cennikvmagaze .. " рублей и вам было начислено ".. sukadaimneego .. " дней премиума" )
			net.WriteString("АвтоДонат")
			net.WriteString("Спасибо!")
        net.Send(ply)
	end)
end)

hook.Add("IGS.PaymentStatusUpdated", "GM-Donate.ThanksForDonate", function(pl, tbl)
    if not IsValid(pl) then return end
	print(tbl.orderSum)
	SetGlobalInt("DonateCount", tonumber(file.Read("breach/donate.txt", "DATA")) + tonumber(tbl.orderSum))
	file.Write("breach/donate.txt", tostring(GetGlobalInt("DonateCount")))
    pl:ChatPrint("Спасибо за помощь серверу, приятных покупок!")
	pl:CompleteAchievement("donater")
end)
