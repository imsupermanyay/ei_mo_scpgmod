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
activeRound = activeRound
rounds = rounds or -1
roundEnd = roundEnd or 0

MAP_LOADED = MAP_LOADED or false

local allowedteams = {
	[TEAM_SPECIAL] = true,
	[TEAM_SCI] = true,
}

local allowedroles = {
	[role.SECURITY_Chief] = true,
	[role.SECURITY_Sergeant] = true,
	[role.MTF_Com] = true,
	[role.MTF_HOF] = true,
	[role.SECURITY_IMVSOLDIER] = true,
	[role.MTF_Left] = true,
	[role.Dispatcher] = true,
	[role.MTF_Specialist] = true,
	[role.MTF_Engi] = true,
}

local blockedroles = {
	[role.SCI_Cleaner] = true
}

function UIUSelectTargets()

	local plys = player.GetAll()

	local numcount = 0

	for i, v in RandomPairs(plys) do

		if (allowedteams[v:GTeam()] and !blockedroles[v:GetRoleName()]) or allowedroles[v:GetRoleName()]  then

			numcount = numcount + 1

			--v:BreachGive("item_special_document")

		end

		if numcount >= 3 then break end

	end

end

function RestartGame()

	for i, v in pairs(player.GetAll()) do
		BREACH.AdminLogSystem:LogPlayer(v)
	end

	timer.Simple(1, function()

		RunConsoleCommand("_restart")

	end)

end

function CleanUp()
	game.CleanUpMap( false, { "env_fire", "phys_bone_follower", "entityflame", "_firesmoke", "light" }, function() end)

	timer.Destroy("PreparingTime")
	timer.Destroy("RoundTime")
	timer.Destroy("PostTime")
	timer.Destroy("GateOpen")
	timer.Destroy("PlayerInfo")
	timer.Destroy("NTFEnterTime")
	timer.Destroy("NTFEnterTime2")
	timer.Destroy("NTFEnterTime3")
	timer.Destroy("PunishEnd")
	timer.Destroy("GateExplode")
	timer.Destroy("SCP173Open")
	timer.Destroy("PerformRandomIntercomAnnouncement")
	timer.Destroy("LZDecont")
	timer.Destroy("LZDecont_Anounce1")
	timer.Destroy("LZDecont_Anounce2")
	timer.Destroy("LZDecont_Music")
	timer.Destroy("AnnounceAboutDetonation")
	timer.Destroy("AnnounceAboutDetonation2")
	timer.Destroy("AnnounceAboutDetonation3")

	SetGlobalBool("tc_executed", false)
	tc_executed = false

	SetGlobalBool( "CanFS", true )
	CanFS = true

	SPAWN_SCP_RANDOM_COPY = nil

	if timer.Exists("InfiniteEscapes") == false then
		timer.Create("InfiniteEscapes", 1, 0, InfiniteEscapes)
	end

	local plys = player.GetAll()

	for i = 1, #plys do
		local ply = plys[i]
		ply.SelectedSCPAlready = nil
	end

	BroadcastLua("if CL_BLOOD_POOL_ITERATION == nil then CL_BLOOD_POOL_ITERATION = 1 end CL_BLOOD_POOL_ITERATION = CL_BLOOD_POOL_ITERATION + 1")
	game.GetWorld():StopParticles()
	Recontain106Used = false
	OMEGAEnabled = false
	OMEGADoors = false
	nextgateaopen = 0
	spawnedntfs = 0
	roundstats = {
		descaped = 0,
		rescaped = 0,
		sescaped = 0,
		dcaptured = 0,
		rescorted = 0,
		deaths = 0,
		teleported = 0,
		snapped = 0,
		zombies = 0,
		secretf = false
	}
	inUse = false
end
--concommand.Add("CleanUp_Breach", CleanUp)

function CleanUpPlayers()
	for k,v in pairs(player.GetAll()) do
		v:SetModelScale( 1 )
		v:SetCrouchedWalkSpeed(0.6)
		v.mblur = false
		player_manager.SetPlayerClass( v, "class_breach" )
		player_manager.RunClass( v, "SetupDataTables" )
		v:Freeze(false)
		v.MaxUses = nil
		v.blinkedby173 = false
		v.scp173allow = false
		v.scp1471stacks = 1
		v.usedeyedrops = false
		v.isescaping = false
		v:SendLua( "CamEnable = false" )
	end
	net.Start("Effect")
		net.WriteBool( false )
	net.Broadcast()
	net.Start("957Effect")
		net.WriteBool( false )
	net.Broadcast()
end

function RoundTypeUpdate()
    activeRound = nil
    local chance = math.random(0, 100)

    if chance > 10 then --chance > 8
        activeRound = ROUNDS.normal
    else
        local spec_chance = math.random(0, 1)
        if spec_chance == 0 then
            activeRound = ROUNDS.ww2tdm
        else
            activeRound = ROUNDS.hl2tdm
        end
    end

    if forceround then
        activeRound = ROUNDS[forceround]
        forceround = nil
    end

    SetGlobalString("RoundName", activeRound.name)
end



function Breach_EndRound(reason)
	net.Start("New_SHAKYROUNDSTAT")	
		net.WriteString(reason)
		net.WriteFloat(GetPostTime())
	net.Broadcast()
	postround = false
	postround = true
	if activeRound and activeRound.postround then
		activeRound.postround()
	end
	roundEnd = 0
	timer.Create("PostTime", GetPostTime(), 1, function()
		print( "restarting round" )
		RoundRestart()
	end)
end

util.AddNetworkString("PrepClient")

function TEST()

end

function RoundRestart()
	for k, v in ipairs(player.GetAll()) do
		v.ArenaParticipant = false
		v:ConCommand("dev_loading")
		v:SetFrags(0)
	end
	timer.Simple(2, function()
		if GetGlobalInt("RoundUntilRestart", 50) <= 0 then
			hook.Run("BreachLog_GameRestart")
			RestartGame()

			return
		end
		net.Start("PrepClient")
		net.Broadcast()
		print("round: clients prepared")
		BroadcastStopMusic()
		timer.Simple(1, function()
		SetGlobalBool("EnoughPlayersCountDown", false)

		if #GetActivePlayers() < 10 and !DEBUG_TESTIC then

			for _, v in ipairs(GetActivePlayers()) do
				if v:GTeam() != TEAM_SPEC then
					v:SetupNormal()
					v:SetSpectator()
				end
				v:RXSENDNotify("l:not_enough_players")
			end
			CleanUp()
			EvacuationEnd()
			EvacuationWarheadEnd()
			LZLockDownEnd()
			gamestarted = false
			preparing = false
			postround = false
			activeRound = nil

			BroadcastLua("activeRound = nil preparing = false gamestarted = false postround = false")

			return
		end

		if !MAP_LOADED then
			error( "Map config is not loaded!" )
		end

		print("round: starting")

		SetGlobalInt("RoundUntilRestart", GetGlobalInt("RoundUntilRestart", 50) - 1)

		if #GetActivePlayers() >= 30 then SetGlobalBool("BigRound", true) else SetGlobalBool("BigRound", false) end

		local restrts = GetGlobalInt("RoundUntilRestart", 50)

		hook.Run("BreachLog_RoundStart", GetGlobalInt("RoundUntilRestart", 50))

		BREACH.AdminLogs.Logs_Data.CurRound = BREACH.AdminLogs.Logs_Data.CurRound + 1


		SetGlobalInt("TASKS_GRU_1", 0)
		SetGlobalInt("TASKS_GRU_2", 0)
		SetGlobalInt("TASKS_GRU_3", 0)

		SetGlobalInt("TASKS_TG_1", 0)
		SetGlobalInt("TASKS_TG_2", 0)
		SetGlobalInt("TASKS_TG_3", 0)

		LZLockDownEnd()
		EvacuationEnd()
		EvacuationWarheadEnd()
		Radio_RandomizeChannels()
		CleanUp()
		print("round: map cleaned")
		CleanUpPlayers()
		print("round: players cleaned")
		preparing = true
		postround = false
		activeRound = nil
		if #GetActivePlayers() < MINPLAYERS then WinCheck() end
		RoundTypeUpdate()
		SetupCollide()
		SetupAdmins( player.GetAll() )
		activeRound.setup()
		print( "round: setup end" )	
		net.Start("UpdateRoundType")
			net.WriteString(activeRound.name)
		net.Broadcast()
		activeRound.init()	
		print( "round: int end / preparation start" )	
		gamestarted = true
		BroadcastLua('gamestarted = true')
		print("round: gamestarted")
		net.Start("PrepStart")
			net.WriteInt(GetPrepTime(), 8)
		net.Broadcast()
		UseAll()
		DestroyAll()
		timer.Destroy("PostTime") -----?????
		hook.Run( "BreachPreround" )
		timer.Create("PreparingTime", GetPrepTime(), 1, function()
			for k,v in pairs(player.GetAll()) do
				v:Freeze(false)
			end
			preparing = false
			postround = false		
			activeRound.roundstart()
			net.Start("RoundStart")
				net.WriteInt(GetRoundTime(), 12)
			net.Broadcast()
			print("round: started")
			roundEnd = CurTime() + GetRoundTime() + 3
			hook.Run( "BreachRound" )

			for _, classddoor in pairs(ents.FindInBox( Vector(6279.509765625, -4907.6118164063, 342.16192626953), Vector(6057.3408203125, -6251.3315429688, 117.72982788086) )) do if IsValid(classddoor) then classddoor:Fire("Open") end end
			for _, classddoor in pairs(ents.FindInBox( Vector(7828.5, -6147.8735351563, 402.44631958008), Vector(7890.5131835938, -4939.6108398438, 221.6333770752) )) do if IsValid(classddoor) then classddoor:Fire("Open") end end

			timer.Create("RoundTime", GetRoundTime(), 1, function()
				postround = false
				postround = true
				for k,v in pairs(player.GetAll()) do
					v:Freeze(false)
					if v:GTeam() == TEAM_ARENA then
						v.ArenaParticipant = false
						v:SetupNormal()
						v:SetSpectator()
					end
				end
				print( "post init: good" )
				activeRound.postround()
				--GiveExp()	
				print( "post functions: good" )
				print( "round: post" )
				if activeRound.name == "Containment Breach" then --custom rounds
				net.Start("New_SHAKYROUNDSTAT")	
				    net.WriteString("l:roundend_alphawarhead")
					net.WriteFloat(GetPostTime())
				net.Broadcast()
				net.Start("PostStart")
					net.WriteInt(GetPostTime(), 6)
					net.WriteInt(1, 4)
				net.Broadcast()
				end
				print( "data broadcast: good" )
				roundEnd = 0
				timer.Destroy("PunishEnd")
				hook.Run( "BreachPostround" )
				timer.Create("PostTime", GetPostTime(), 1, function()
					print( "restarting round" )
					RoundRestart()
				end)	
			end)

			hook.Run("BreachRoundTimerCreated")
		end)
		end)
	end)
end

function GetAlivePlayers()
	local tab = GetActivePlayers()
	local _t = {}
	for i = 1, #tab do
		local v = tab[i]
		if !v:Alive() or v:GTeam() == TEAM_SPEC or v:Health() <= 0 then continue end
		_t[#_t + 1] = v
	end
	return _t
end

local horror_tbl = {
  "nextoren/others/horror/horror_0.ogg",
  "nextoren/others/horror/horror_1.ogg",
  "nextoren/others/horror/horror_2.ogg",
  "nextoren/others/horror/horror_3.ogg",
  "nextoren/others/horror/horror_4.ogg",
  "nextoren/others/horror/horror_5.ogg",
  "nextoren/others/horror/horror_9.ogg",
  "nextoren/others/horror/horror_10.ogg",
  "nextoren/others/horror/horror_16.ogg"
}

function InfiniteEscapes()
	--if !BREACH.PeopleCanEscape then return end

	local plys = GetAlivePlayers()
	for i = 1, #plys do
		local v = plys[i]

		if v:GTeam() == TEAM_SPEC then continue end
		if v:GetModel() == "models/scp079microcom/scp079microcom.mdl" then continue end
		if !v:Alive() then continue end
		if v:Health() <= 0 then continue end

		if v:GetPos():WithinAABox(Vector(2488.348633, -15383.382812, -6151), Vector(4081.904785, -14840.196289, -6558)) then
			v:SetPos(Vector(1719.5440673828, -13027.41796875, -6191.96875))
			v:SendLua('surface.PlaySound( "'..table.Random( horror_tbl )..'" )')
		elseif v:GetPos():WithinAABox(Vector(4084.237305, -15360.805664, -6057), Vector(3654.923340, -13843.799805, -6540)) then
			v:SetPos(Vector(1719.5440673828, -13027.41796875, -6191.96875))
			v:SendLua('surface.PlaySound( "'..table.Random( horror_tbl )..'" )')
		elseif v:GetPos():WithinAABox(Vector(4067.338867, -13810.751953, -6127), Vector(2516.557861, -14276.682617, -6566)) then
			v:SetPos(Vector(1719.5440673828, -13027.41796875, -6191.96875))
			v:SendLua('surface.PlaySound( "'..table.Random( horror_tbl )..'" )')
		elseif v:GetPos():WithinAABox(Vector(2530.959473, -13814.922852, -6131), Vector(2956.113037, -15462.255859, -6570)) then
			v:SetPos(Vector(1719.5440673828, -13027.41796875, -6191.96875))
			v:SendLua('surface.PlaySound( "'..table.Random( horror_tbl )..'" )')
		elseif v:GetPos():WithinAABox(Vector(3856.350098, -13147.781250, -6220), Vector(4067.241699, -12915.458008, -5970)) then
			v:SetPos(Vector(6702.369140625, -14160.725585938, -6300.9897460938))
			v:SendLua('surface.PlaySound( "'..table.Random( horror_tbl )..'" )')
		end

		if v.isescaping then continue end

		if v:GetPos():WithinAABox(Vector(-2135.845703, 4767.522461, 1440.664429), Vector(-1835.034912, 5305.313477, 1658.326904)) then
			if v:CanEscapeChaosRadio() then
					--v:AddFrags(5)
				v:GodEnable()
				v:SetNoDraw(true)
				v:Freeze(true)
				net.Start("StartCIScene")
				net.Send(v)
				v:SetPos(Vector(2440.7807617188, -1213.6754150391, 1354.03125))
				v:SetEyeAngles(Angle(0.548418, -96.127266, 0.000000))
				v.isescaping = true
				timer.Create("EscapeWait" .. v:SteamID64(), 8, 1, function()
					net.Start("Ending_HUD")
						net.WriteString("l:ending_captured_by_unknown")
					net.Send(v)
					v:AddToStatistics("l:escaped", 1000)
					if v:HasWeapon("item_cheemer") then
						v:AddToStatistics("l:cheemer_rescue", 1000)
					end
					v:CompleteAchievement("escape")
					v:LevelBar()
					v:Freeze(false)
					v:GodDisable()
					v:CompleteAchievement("chaosradio")
					v:SetupNormal()
					v:SetSpectator()
					WinCheck()
					v.isescaping = false
				end)
			end
		elseif v:GetPos():WithinAABox(Vector(-7679.626465, -727.644836, 1889.328735), Vector(-8088.857422, -886.812866, 1685.490723)) then
			local exptoget = 100 * v:GetNLevel()

			v:GodEnable()
			v:Freeze(true)
			v.canblink = false
			v.isescaping = true

			timer.Create("EscapeWait" .. v:SteamID64(), 2, 1, function()
						
				v:Freeze(false)
				v:GodDisable()
				v:SetupNormal()
				v:SetSpectator()
						
				WinCheck()
				v.isescaping = false
			end)
			net.Start("Ending_HUD")
				net.WriteString("l:ending_escaped_site19_got_captured")
			net.Send(v)
			v:CompleteAchievement("escape")
			v:CompleteAchievement("escapehand")
			v:AddToStatistics("l:escaped", 800)
			if v:HasWeapon("item_cheemer") then
				v:AddToStatistics("l:cheemer_rescue", 1000)
			end
			v:LevelBar()

		elseif v:GetPos():WithinAABox(Vector(-2602.228271, -4551.379883, 1827), Vector(-2777.002197, -4408.625000, 2118)) then
			-- ГРУ
			local gru_heli = nil 
			for k,v in pairs(ents.GetAll()) do
				if v:GetClass() == "gru_heli" then
					gru_heli = v
				end
			end
			if gru_heli == nil then return end
			if v:GTeam() == TEAM_GRU and !GetGlobalBool("Evacuation") then return end
			if v:GTeam() != TEAM_GRU then 
				SetGlobalInt("TASKS_GRU_2",GetGlobalInt("TASKS_GRU_2") + 1)
				--for _, ply in pairs(player.GetAll()) do
				--	if ply:GTeam() == TEAM_GRU then
				--		ply:AddToStatistics("l:gru_evac_ply", 300) 
				--	end
				--end
			end
			if v:GTeam() == TEAM_GRU then
				--v:AddToStatistics("l:uiu_obj_bonus", 1000) 
				if GetGlobalInt("TASKS_GRU_1") == 5 then
					v:AddToStatistics("l:uiu_obj_bonus", 1000) 
				end
				if GetGlobalInt("TASKS_GRU_2") >= 3 then
					v:AddToStatistics("l:uiu_obj_bonus", 1000) 
				end
				if GetGlobalInt("TASKS_GRU_3") >= 3 then
					v:AddToStatistics("l:uiu_obj_bonus", 1000) 
				end
			end
			local exptoget = 100 * v:GetNLevel()

			v:GodEnable()
			v:Freeze(true)
			v.canblink = false
			v.isescaping = true

			timer.Create("EscapeWait" .. v:SteamID64(), 2, 1, function()
						
				v:Freeze(false)
				v:GodDisable()
				v:SetupNormal()
				v:SetSpectator()
						
				WinCheck()
				v.isescaping = false
			end)
			net.Start("Ending_HUD")
				net.WriteString("l:ending_escaped_site19_got_captured")
			net.Send(v)
			v:CompleteAchievement("escape")
			v:CompleteAchievement("escapehand")
			v:AddToStatistics("l:escaped", 800)
			if v:HasWeapon("item_cheemer") then
				v:AddToStatistics("l:cheemer_rescue", 100)
			end
			v:LevelBar()

		elseif v:GetPos():WithinAABox(Vector(-6979.750488, -893.080811, 1668.085327), Vector(-7044.459961, -998.905945, 1924.017090)) then

			local rtime = timer.TimeLeft("RoundTime")

			v:GodEnable()
			v:Freeze(true)
			v.canblink = false
			v.isescaping = true
			timer.Create("EscapeWait" .. v:SteamID64(), 2, 1, function()
				v:Freeze(false)
				v:GodDisable()
				v:SetupNormal()
				v:SetSpectator()
				WinCheck()
				v.isescaping = false
			end)
			if v:GTeam() == TEAM_USA and v:GetModel() != "models/cultist/humans/fbi/fbi_agent.mdl" then
				if v:GetRoleName() != role.SCI_SpyUSA then
					if Monitors_Activated and Monitors_Activated >= 5 then
						net.Start("Ending_HUD")
							net.WriteString("l:ending_mission_complete")
						net.Send(v)
						v:CompleteAchievement("fbiescape")
						v:AddToStatistics("l:escaped", 600)
					else
						net.Start("Ending_HUD")
							net.WriteString("l:ending_mission_failed")
						net.Send(v)
						v:AddToStatistics("l:escaped", 200)
					end
				else
					if v.TempValues.FBIHackedTerminal then
						net.Start("Ending_HUD")
							net.WriteString("l:ending_mission_complete")
						net.Send(v)
						v:AddToStatistics("l:escaped", 1000)
					else
						net.Start("Ending_HUD")
							net.WriteString("l:ending_mission_failed")
						net.Send(v)
						v:AddToStatistics("l:escaped", 100)
					end
				end
			else
				net.Start("Ending_HUD")
					net.WriteString("l:ending_escaped_site19")
				net.Send(v)
				v:AddToStatistics("l:escaped", 200)
			end
			if v:HasWeapon("item_cheemer") then
				v:AddToStatistics("l:cheemer_rescue", 1000)
			end
			if v:GetModel() == "models/cultist/humans/fbi/fbi_agent.mdl" then
				if v:HasWeapon("item_special_document_o5") then
						for _, ply in pairs(player.GetAll()) do
							if ply:GetModel() == "models/cultist/humans/fbi/fbi_agent.mdl" then
								ply:AddToStatistics("l:escaped", 3000)
								--ply:CompleteAchievement("zov")
							end
						end
				end
			end

			if v:GTeam() == TEAM_AR then
				--for k1,v1 in pairs(ents.FindInSphere(v:GetPos(),500)) do
				--	if v1:IsPlayer() and v1:HasWeapon("item_scp_079") then
				--		v:AddToStatistics("l:scp079_rescue", 3000)
				--		v:CompleteAchievement("zov")
				--		--if v.SCP079 then
				--		--	timer.Remove("SCP079LOOK_" .. v:SteamID64())
				--		--	v:AddToStatistics("l:scp079_rescue", 3000)
				--		--end
				--	end
				--end
				if v:HasWeapon("item_scp_079") then
					--v:AddToStatistics("l:scp079_rescue", 3000)
					for _, ply in pairs(player.GetAll()) do
						if ply:GTeam() == TEAM_AR then
							ply:AddToStatistics("l:scp079_rescue", 3000)
							ply:CompleteAchievement("zov")
						end
					end
					for _, ply in pairs(player.GetAll()) do
						if ply:HasWeapon("kasanov_scp_079") then
							local exptoget = 100 * ply:GetNLevel()

							ply:GodEnable()
							ply:Freeze(true)
							ply.canblink = false
							ply.isescaping = true

							timer.Create("EscapeWait" .. ply:SteamID64(), 2, 1, function()

								ply:Freeze(false)
								ply:GodDisable()
								ply:SetupNormal()
								ply:SetSpectator()

								WinCheck()
								ply.isescaping = false
							end)
							net.Start("Ending_HUD")
								net.WriteString("l:ending_escaped_site19_got_captured")
							net.Send(ply)
							ply:CompleteAchievement("escape")
							ply:CompleteAchievement("escapehand")
							ply:AddToStatistics("l:escaped", 800)
							ply:LevelBar()
						end
					end
				end
			end
			v:CompleteAchievement("escape")
			v:CompleteAchievement("beglec")
			if !timer.Exists("RoundTime") or timer.TimeLeft("RoundTime") <= 5 then
				v:CompleteAchievement("runbitch")
			end
			v:LevelBar()
		elseif v:GetPos():WithinAABox(Vector(-15027.241211, 3324.958008, -15499.637695), Vector(-14578.889648, 3665.833252, -15751.149414)) then

			if v:CanEscapeO5() then

				local rtime = timer.TimeLeft("RoundTime")

				v:GodEnable()
				v:Freeze(true)
				v.canblink = false
				v.isescaping = true

				timer.Create("EscapeWait" .. v:SteamID64(), 2, 1, function()
					v:Freeze(false)
					v:GodDisable()
					v:SetupNormal()
					v:SetSpectator()
					v.isescaping = false
				end)

				net.Start("Ending_HUD")
					net.WriteString("l:ending_o5")
				net.Send(v)
				if v:GTeam() == TEAM_AR then
					--for k1,v1 in pairs(ents.FindInSphere(v:GetPos(),500)) do
					--	if v1:IsPlayer() and v1:HasWeapon("item_scp_079") then
					--		v:AddToStatistics("l:scp079_rescue", 3000)
					--		v:CompleteAchievement("zov")
					--		--if v.SCP079 then
					--		--	timer.Remove("SCP079LOOK_" .. v:SteamID64())
					--		--	v:AddToStatistics("l:scp079_rescue", 3000)
					--		--end
					--	end
					--end
					if v:HasWeapon("item_scp_079") then
						v:AddToStatistics("l:scp079_rescue", 3000)
						for _, ply in pairs(player.GetAll()) do
							if ply:GTeam() == TEAM_AR then
								ply:AddToStatistics("l:scp079_rescue", 3000)
								ply:CompleteAchievement("zov")
							end
						end
						for _, ply in pairs(player.GetAll()) do
							if ply:HasWeapon("kasanov_scp_079") then
								local exptoget = 100 * ply:GetNLevel()

								ply:GodEnable()
								ply:Freeze(true)
								ply.canblink = false
								ply.isescaping = true

								timer.Create("EscapeWait" .. ply:SteamID64(), 2, 1, function()

									ply:Freeze(false)
									ply:GodDisable()
									ply:SetupNormal()
									ply:SetSpectator()

									WinCheck()
									ply.isescaping = false
								end)
								net.Start("Ending_HUD")
									net.WriteString("l:ending_escaped_site19_got_captured")
								net.Send(ply)
								ply:CompleteAchievement("escape")
								ply:CompleteAchievement("escapehand")
								ply:AddToStatistics("l:escaped", 800)
								ply:LevelBar()
							end
						end
					end
				end

				v:CompleteAchievement("monorail")
				v:CompleteAchievement("escape")

				v:AddToStatistics("l:escaped", 1000)
				if v:HasWeapon("item_cheemer") then
					v:AddToStatistics("l:cheemer_rescue", 1000)
				end
				v:LevelBar()

			end

		elseif v:GetPos():WithinAABox(Vector(-7383.785645, 13929.800781, 2325.235352), Vector(-6826.424805, 15381.131836, 1937.054810)) then
			
			--if v:CanEscapeCar() && v:InVehicle() then
				--v.canblink = false
				--v.isescaping = true
				--local vehicle = v:GetVehicle()
				--for i, ply in pairs(player.GetAll()) do
				--print(v:InVehicle())
					if v:InVehicle() then
						--local myvehicle = ply:GetVehicle()
						v:ExitVehicle()
						if v:CanEscapeCar() then
							v.canblink = false
							v.isescaping = true
							v:SetupNormal()
							v:SetSpectator()
							v:CompleteAchievement("escape")
							net.Start("Ending_HUD")
								net.WriteString("l:ending_car")
							net.Send(v)
							v:CompleteAchievement("car")
							v:AddToStatistics("l:escaped", 1600)
							v:LevelBar()
						end
						--timer.Simple(0.2, function() if IsValid(myvehicle) then myvehicle:Remove() end end)
					end
				--end
			--end

		end

	end

end
timer.Create("InfiniteEscapes", 0.5, 0, InfiniteEscapes)
--[[
concommand.Add("br_enable_escapes", function()

	InfiniteEscapes()

end)
--]]

function WinCheck()
	if postround then return end
	if !activeRound then return end
	activeRound.endcheck()
	if roundEnd > 0 and roundEnd < CurTime() then
		roundEnd = 0
	--	endround = true
	--	why = "game ran out of time limit"
		print( "Something went wrong! Error code: 100" )
		print( debug.traceback() )
	end
	/*if #GetActivePlayers() < 2 then 
		endround = true
		why = " there are not enough players"
		gamestarted = false
		BroadcastLua( "gamestarted = false" )
	end*/
	if endround then
		print("Ending round because " .. why)
		PrintMessage(HUD_PRINTCONSOLE, "Ending round because " .. why)
		StopRound()
		timer.Destroy("RoundTime")
		preparing = false
		postround = true

		// send infos
		--[[
		net.Start("EndRoundStats")	
		    net.WriteString("Containment Breach has been ended")
		    net.WriteFloat(18)
	    net.Broadcast()]]

	    net.Start("")	
		    net.WriteString("l:roundend_cbended")
		    net.WriteFloat(GetPostTime())
	    net.Broadcast()
		
		net.Start("PostStart")
			net.WriteInt(GetPostTime(), 6)
			net.WriteInt(2, 4)
		net.Broadcast()
		activeRound.postround()	
		--GiveExp()
		endround = false
		--print( debug.traceback() )  
		hook.Run( "BreachPostround" )
		timer.Create("PostTime", GetPostTime(), 1, function()
			RoundRestart()
		end)
	end
end

function StopRound()
	timer.Stop("PreparingTime")
	timer.Stop("RoundTime")
	timer.Stop("PostTime")
	timer.Stop("GateOpen")
	timer.Stop("PlayerInfo")
end

timer.Create("WinCheckTimer", 5, 0, function()
	if postround == false and preparing == false then
		WinCheck()
	end
end)

--[[
timer.Create("EXPTimer", 180, 0, function()
	for k,v in pairs(player.GetAll()) do
		if IsValid(v) and v.AddExp != nil then
			v:AddExp(200, true)
		end
	end
end)
--]]

function SetupCollide()
	local fent = ents.GetAll()
	for k, v in pairs( fent ) do
		if v and v:GetClass() == "func_door" or v:GetClass() == "prop_dynamic" then
			if v:GetClass() == "prop_dynamic" then
				local ennt = ents.FindInSphere( v:GetPos(), 5 )
				local neardors = false
				for k, v in pairs( ennt ) do
					if v:GetClass() == "func_door" then
						neardors = true
						break
					end
				end
				if !neardors then 
					v.ignorecollide106 = false
					continue
				end
			end

			local changed
			for _, pos in pairs( DOOR_RESTRICT106 ) do
				if v:GetPos():Distance( pos ) < 100 then
					v.ignorecollide106 = false
					changed = true
					break
				end
			end
			
			if !changed then
				v.ignorecollide106 = true
			end
		end
	end
end

function BREACH.GOOD()   
    -- 首先清理可能存在的同名定时器，避免重复执行
    timer.Remove("BREACH_GOOD_stopsound")
    timer.Remove("BREACH_GOOD_chat1")
    timer.Remove("BREACH_GOOD_chat2")
    timer.Remove("BREACH_GOOD_announcer")
    timer.Remove("BREACH_GOOD_wincall")
	timer.Remove("GOODE_START2")
    
    -- 停止声音
    timer.Create("BREACH_GOOD_stopsound", 1, 1, function()
		BroadcastLua("StopMusic()")
    end)

	SetGlobalBool( "BRDAM", true )
	BRDAM = true
	SetGlobalBool( "CanFS", false )
	CanFS = false
    
    -- 第一条通知消息
    timer.Create("BREACH_GOOD_chat1", 1, 1, function()
        if BREACH.Players and BREACH.Players.ChatPrint then
            BREACH.Players:ChatPrint(player.GetAll(), true, true, "基金会已成功重新掌控设施!")
        end
    end)
    
    -- 第二条通知消息
    timer.Create("BREACH_GOOD_chat2", 3, 1, function()
        if BREACH.Players and BREACH.Players.ChatPrint then
            BREACH.Players:ChatPrint(player.GetAll(), true, true, "基金会已成功重新控制设施, 请所有员工前往地表停机坪撤离设施并安排行政休假!")
			timer.Simple(2, function()
				BREACH.Players:ChatPrint(player.GetAll(), true, true, "未能及时撤离者将被视为自愿为基金会事业奉献自己的行政休假时间!")
			end)
        end
	
	LZLockDownEnd()
	EvacuationEnd()
	EvacuationWarheadEnd()
	
	SetGlobalBool("Evacuation", true)

	timer.Destroy("Evacuation")

	timer.Destroy("EvacuationWarhead")

	timer.Remove("BigBoom")

	timer.Remove("BigBoomEffect")

	timer.Remove("Edem")

	timer.Remove("EdemChaos")

	timer.Remove("EdemChaos2")

	timer.Remove("Prizemlyt")

	timer.Remove("PrizemlytAng")

	timer.Remove("Back")

	timer.Remove("BackCI")

	timer.Remove("Uletaem")

	timer.Remove("EdemNazad")

	timer.Remove("UletaemAng")

	timer.Remove("Back2")

	timer.Remove("DeleteHelic")

	timer.Remove("DeleteJeep")

	timer.Remove("EdemAnim")

	timer.Remove("AnimOpened")

	timer.Remove("AnimOpen")

	timer.Remove("AnimClosed")

	timer.Remove("EdemNazadAnim")

	timer.Remove("EdemCIAnimStop")

	timer.Remove("EdemCIAnim")

	timer.Remove("EdemCIAnimNazad")

	timer.Remove("EdemAnim2")

	timer.Remove("O5Warhead_Start") 

	timer.Remove("AlphaWarhead_Begin")

	timer.Remove("AlphaWarhead_Start")
    end)
    
    -- 播放音频
    timer.Create("BREACH_GOOD_announcer", 5, 1, function()
            PlayAnnouncer("nextoren/round_sounds/ge.ogg")
			--PlayAnnouncer("nextoren/vo/tiaowu/gbtcao.mp3")
			--PlayAnnouncer("rxsend_music/misc/countdownmusic.ogg")
			--PlayAnnouncer("nextoren/others/yule/nanbeng.mp3")
			--PlayAnnouncer("rxsend_music/factions_spawn/alpha_1_team.wav")
			--PlayAnnouncer("nextoren/vo/tiaowu/sharlang.mp3")
			--PlayAnnouncer("nextoren/mj1.mp3")
			--PlayAnnouncer("nextoren/vo/ll1.mp3")
    end)
	
	timer.Create("GOODE_START2", 137, 1, function()
    local portal = ents.Create("portal")
	portal:Spawn()
	local heli = ents.Create("heli")
	heli:Spawn()

	timer.Simple(120, function()
		EscapeEnabled_Portal = false
		portal:Remove()
	end)


	SetGlobalBool("Evacuation_HUD", true)

	local guardteams = {
		[TEAM_GUARD] = true,
		[TEAM_NTF] = true,
		[TEAM_ETT] = true,
		[TEAM_FAF] = true,
		[TEAM_ALPHA1] = true,
		[TEAM_SECURITY] = true,
		[TEAM_QRT] = true,
		[TEAM_OSN] = true,
	}

	local sciteams = {
		[TEAM_SCI] = true,
		[TEAM_SPECIAL] = true,
	}

	timer.Simple(90, function()
		if IsValid(heli) then
			heli:EmitSound("nextoren/vo/chopper/chopper_ten_left.wav", 130, 100, 1.5, CHAN_VOICE, 0, 0)
		end
	end)

	timer.Simple(70, function()
		if IsValid(heli) then
			heli:EmitSound("nextoren/vo/chopper/chopper_thirty_left.wav", 130, 100, 1.5, CHAN_VOICE, 0, 0)
		end
	end)

	timer.Create("PerformEscapeAnim_HELI1", 100, 1, function()
		if IsValid(heli) then
			heli:EmitSound("nextoren/vo/chopper/chopper_evacuate_end.wav", 110, 100, 1.2, CHAN_VOICE, 0, 0)
			heli:Escape()
			--goose_plz_fuck_off_heli()
			for _, ply in pairs(ents.FindInBox( Vector(-3138.5959472656, 5161.6767578125, 2607.9836425781), Vector(-3894.0668945313, 4376.7807617188, 2480.7956542969) )) do
				if IsValid(ply) and ply:IsPlayer() and ply:GTeam() == TEAM_GRU then
				if !ply:Alive() or ply:Health() <= 0 then continue end
					timer.Simple(0.6, function()
						ply:AddToStatistics("l:escaped", 500)
						if ply:HasWeapon("item_cheemer") then
							ply:AddToStatistics("l:cheemer_rescue", 1000)
						end
						net.Start("Ending_HUD")
							net.WriteString("l:ending_evac_choppa")
						net.Send(ply)
						ply:CompleteAchievement("escape")
						ply:LevelBar()
						ply:SetupNormal()
						ply:SetSpectator()
					end)
				end
				if IsValid(ply) and ply:IsPlayer() and ( ply:GetRoleName() == SCP999 or guardteams[ply:GTeam()] or sciteams[ply:GTeam()] ) then
					if !ply:Alive() or ply:Health() <= 0 then continue end
					if ( sciteams[ply:GTeam()] or ply:GetModel():find("/sci/") or ply:GetModel():find("/mog/") ) and !guardteams[ply:GTeam()] and ply:GetRoleName() != role.Dispatcher and ply:GTeam() != TEAM_GOC then
						for _, guard in pairs(player.GetAll()) do
							if guardteams[guard:GTeam()] and ply:GTeam() == TEAM_SPECIAL then guard:AddToStatistics("l:vip_evac", 200) end
							if guardteams[guard:GTeam()] and ply:GTeam() == TEAM_SCI then guard:AddToStatistics("l:sci_evac", 100) end
						end
						local achievement = false
						if !sciteams[ply:GTeam()] and ( ply:GetModel():find("/mog/") or ply:GetModel():find("/sci/") ) then
							if math.random(1, 4) > 1 or ply:GTeam() == TEAM_DZ then
								ply:AddToStatistics("l:escaped", 450)
								achievement = true
							else
								ply:RXSENDNotify("l:evac_disclosed")
								ply:AddToStatistics("l:escape_fail", -45)
								achievement = true
							end
						else
							ply:AddToStatistics("l:escaped", 500)
						end
						if ply:HasWeapon("item_cheemer") then
							ply:AddToStatistics("l:cheemer_rescue", 500)
						end
						if ply:HasWeapon("item_ipd") then
							ply:AddToStatistics("l:vdv_rescue", 400)
						end
						net.Start("Ending_HUD")
							net.WriteString("l:ending_evac_choppa")
						net.Send(ply)
						ply:CompleteAchievement("escape")
						ply:LevelBar()
						ply:SetupNormal()
						ply:SetSpectator()
						if achievement then
							ply:CompleteAchievement("wrongescape")
						end
					elseif ply:GetRoleName() == SCP999 then
						for _, guard in pairs(player.GetAll()) do
							if guardteams[guard:GTeam()] then guard:AddToStatistics("l:ci_scp_evac", 400) end
						end
						ply:AddToStatistics("l:escaped", 600)
						net.Start("Ending_HUD")
							net.WriteString("l:ending_evac_apc")
						net.Send(ply)
						ply:CompleteAchievement("escape")
						ply:CompleteAchievement("apcescape")
						ply:LevelBar()
						ply:SetupNormal()
						ply:SetSpectator()
					elseif guardteams[ply:GTeam()] then
						timer.Simple(0.6, function()
							ply:AddToStatistics("逃离+完美结局", 1500)
							--ply:AddToStatistics("完美结局", 1000)
							if ply:HasWeapon("item_cheemer") then
								ply:AddToStatistics("l:cheemer_rescue", 1000)
							end
							net.Start("Ending_HUD")
								net.WriteString("l:ending_evac_choppa")
							net.Send(ply)
							ply:CompleteAchievement("escape")
							ply:LevelBar()
							ply:SetupNormal()
							ply:SetSpectator()
						end)
					end
				end
			end
		end
	end)
	end)
    timer.Create("BREACH_GOOD_wincall", 245, 1, function()  -- 修正时间间隔
		for _, ply in ipairs(player.GetAll()) do --kill

			if ply:GTeam() != TEAM_SPEC and ply:Health() > 0 and ply:Alive() then

				ply:LevelBar()
				ply:SetupNormal()
				ply:SetSpectator()

			end

		end
		SetGlobalBool( "BRDAM", false )
		BRDAM = false
        Breach_EndRound("O5议会控制设施")  -- 确保参数是字符串
    end)
end