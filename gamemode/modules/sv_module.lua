
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

util.AddNetworkString("Breach:RunStringOnServer")
util.AddNetworkString("SendPrefixData")
util.AddNetworkString("ChangeRunAnimation")
util.AddNetworkString("breach_showupcmd_give_cmddata")
util.AddNetworkString("Breach:RequestBulletLog")
util.AddNetworkString("Breach:Kill")

util.AddNetworkString("Breach:SENDO5POS")

util.AddNetworkString("Breach:Phrase")

util.AddNetworkString("Breach:SENDMOGPRESET")

util.AddNetworkString("Breach:XMASCHECK")
--FBI
util.AddNetworkString("FBI_Cutscene_Start")
util.AddNetworkString("FBI_Cutscene_End")

net.Receive("Breach:XMASCHECK", function(len, ply)
	if tonumber(ply:GetNWInt("gloves_xmas")) == 1 then return end
	if tonumber(ply:GetNWInt("event_xmas_candy")) >= 150 and tonumber(ply:GetNWInt("event_xmas_tvar")) >= 1 and tonumber(ply:GetNWInt("event_xmas_gift")) >= 3 then
		ply:SetNWInt("gloves_xmas", 1)
		ply:SetPData( "gloves_xmas", 1 )
		Shaky_SetupPremium(ply:SteamID64(),2592000)
		ply:CompleteAchievement("xmas2025")
	end
end)

net.Receive("Breach:Phrase", function(len, ply)
	local sound_p = net.ReadString()
	if timer.Exists("PhraseCD"..ply:SteamID64()) then return end
	if sound_p:find("cmenu") or sound_p:find("npc/combine_soldier/vo") then
		ply:EmitSound(sound_p, 75, ply.VoicePitch, 1, CHAN_VOICE)
		timer.Create("PhraseCD"..ply:SteamID64(),3,1, function() end)
	end
end)

net.Receive("Breach:Kill", function(len, ply)
	if ply:GTeam() != TEAM_SPEC then
		ply:TakeDamage(100000,ply)
	end
end)


net.Receive("Breach:SENDMOGPRESET", function(len, ply)
	local C_1_1 = net.ReadString()
	local C_1_2 = net.ReadString()
	local C_1_3 = net.ReadTable()
	local C_1_4 = net.ReadInt(8)
	local C_2_1 = net.ReadString()
	local C_2_2 = net.ReadString()
	local C_2_3 = net.ReadString()
	local C_2_4 = net.ReadString()
	local C_2_5 = net.ReadString()
	local C_2_6 = net.ReadString()
	local C_3_1 = net.ReadString()
	local C_3_2 = net.ReadString()
	local C_3_3 = net.ReadString()
	local headmat = net.ReadString()

	-- Проверка на дауна

	if ply:GTeam() != TEAM_GUARD then return end

	local allowed_2_1 = {"ничего","cw_kk_ins2_cq300","cw_kk_ins2_m16a4","cw_kk_ins2_karma45","cw_kk_ins2_ak74","cw_kk_ins2_mk18","cw_kk_ins2_hk416c","cw_kk_ins2_blackout","cw_kk_ins2_cstm_famas","cw_kk_ins2_uar556","cw_kk_ins2_cstm_kriss","cw_kk_ins2_cstm_ksg","cw_kk_ins2_m40a1","cw_kk_ins2_m249"}
	local allowed_2_2 = {"ничего","cw_kk_ins2_g17","cw_kk_ins2_g18","cw_kk_ins2_cstm_g19","cw_kk_ins2_cstm_cobra","cw_kk_ins2_deagle"}
	local allowed_2_6 = {"ничего","item_pills","item_adrenaline","item_syringe"}


	--PrintTable(C_1_3)
	--PrintTable({[0] = 0,[1] = 1,[2] = 1,[3] = 0,[4] = 0,[5] = 0,[7] = 1 })
	--print(C_3_3)
	--[[
		ply.ScaleDamage = {

			[HITGROUP_HEAD] = 1,
			[HITGROUP_CHEST] = 1,
			[HITGROUP_LEFTARM] = 1,
			[HITGROUP_RIGHTARM] = 1,
			[HITGROUP_STOMACH] = 1,
			[HITGROUP_GEAR] = 1,
			[HITGROUP_LEFTLEG] = 1,
			[HITGROUP_RIGHTLEG] = 1

		}

	]]--
	--new_mog_intro_elevator_start()
	for bodygroup, value in pairs(C_1_3) do
		ply:SetBodygroup(bodygroup, value)
	end
	if util.TableToJSON(C_1_3) == util.TableToJSON({[0] = 0,[1] = 1,[2] = 1,[3] = 0,[4] = 0,[5] = 0,[7] = 1 }) then
		ply:SetRunSpeed(ply:GetRunSpeed() * 1.15)
	end
	if util.TableToJSON(C_1_3) == util.TableToJSON({[0] = 1,[1] = 3,[2] = 0,[3] = 0,[4] = 0,[5] = 0,[7] = 1 }) then
		ply.BodyResist = 1
		ply.ScaleDamage[HITGROUP_CHEST] = 0.9
		ply.ScaleDamage[HITGROUP_STOMACH] = 0.9
	end
	if util.TableToJSON(C_1_3) == util.TableToJSON({[0] = 1,[1] = 2,[2] = 0,[3] = 1,[4] = 1,[5] = 0,[7] = 1 }) then
		ply:SetRunSpeed(ply:GetRunSpeed() * 0.95)
		ply.BodyResist = 2
		ply.ScaleDamage[HITGROUP_CHEST] = 0.75
		ply.ScaleDamage[HITGROUP_STOMACH] = 0.75
	end
	if util.TableToJSON(C_1_3) == util.TableToJSON({[0] = 2,[1] = 2,[2] = 0,[3] = 1,[4] = 1,[5] = 1,[7] = 1 }) then
		ply:SetRunSpeed(ply:GetRunSpeed() * 0.8)
		ply.BodyResist = 3
		ply.ScaleDamage[HITGROUP_CHEST] = 0.6
		ply.ScaleDamage[HITGROUP_STOMACH] = 0.6
	end
	if util.TableToJSON(C_1_3) == util.TableToJSON({[0] = 3,[1] = 0,[2] = 0,[3] = 1,[4] = 1,[5] = 0,[7] = 0 }) then
		ply:SetRunSpeed(ply:GetRunSpeed() * 0.7)
		ply.BodyResist = 4
		ply.ScaleDamage[HITGROUP_CHEST] = 0.5
		ply.ScaleDamage[HITGROUP_STOMACH] = 0.5
	end
	ply:SetSkin(C_1_4)
	if C_1_4 == 0 then
		--ply:SetRunSpeed(ply:GetRunSpeed() * 1.15)
	elseif C_1_4 == 4 then
		ply:SetRunSpeed(ply:GetRunSpeed() * 0.7)
	end
	if ( ply.BoneMergedEnts ) then
    	for _, bnm in pairs( ply.BoneMergedEnts ) do
    	    if ( bnm && bnm:IsValid() and bnm:GetModel() != "models/imperator/hands/skins/stanadart.mdl" ) then
    	        bnm:Remove()
    	    end
    	end
    end
	local head = Bonemerge( C_1_2, ply )
	if C_1_2 != "models/cultist/humans/balaclavas_new/mog_hazmat.mdl" then
		head:SetSubMaterial(0,headmat)
	end
	if ply:GetRoleName() == role.TG_Com then
		Bonemerge("models/cultist/humans/mog/head_gear/helmet_beret.mdl", ply)
	end
	if C_1_1 != "а нету" then
		local hell = Bonemerge( C_1_1, ply )
		if C_1_1 == "models/cultist/humans/mog/head_gear/cap_engi.mdl" then
		elseif C_1_1 == "models/cultist/humans/security/head_gear/helmet.mdl" then
			ply.HeadResist = 1
			ply.ScaleDamage[HITGROUP_HEAD] = 0.8
		elseif C_1_1 == "models/cultist/humans/mog/head_gear/mog_helmet.mdl" then
			ply:SetRunSpeed(ply:GetRunSpeed() * 0.9)
			ply.HeadResist = 2
			ply.ScaleDamage[HITGROUP_HEAD] = 0.6
		elseif C_1_1 == "models/cultist/humans/mog/head_gear/jugger_helmet.mdl" then
			ply:SetRunSpeed(ply:GetRunSpeed() * 0.8)
			ply.HeadResist = 3
			ply.ScaleDamage[HITGROUP_HEAD] = 0.4
		else
			--ply:SetRunSpeed(ply:GetRunSpeed() * 1.35)
		end
	end
	ply:StripWeapons()
	ply:BreachGive("br_holster")
	ply.JustSpawned = true
	local wep = ply:Give( "item_radio", true )
	timer.Simple( 0.1, function()
	    ply.JustSpawned = false 
	end)
	--if IsValid(wep) then
	timer.Simple( 2, function()
		wep.Channel = math.Round(Radio_GetChannel(TEAM_GUARD, ply:GetRoleName()), 1)
		net.Start("SetFrequency")
		net.WriteEntity(wep)
		net.WriteFloat(wep.Channel)
		net.Send(ply)
	end)
	
	--end
	ply:BreachGive("weapon_cqc")
	
	ply:BreachGive("breach_keycard_"..GetRoleTableSH(ply:GetRoleName()).keycard)
	if table.HasValue(allowed_2_1,C_2_1) then
	ply:BreachGive(C_2_1)
	end
	if C_2_2 != "ничего" and table.HasValue(allowed_2_2,C_2_2) then ply:BreachGive(C_2_2) end
	if C_2_3 != "ничего" and C_2_3:find("item_nightvision_") then ply:BreachGive(C_2_3) end
	if C_2_4 == "gasmask" then ply:BreachGive(C_2_4) end
	if C_2_5 != "ничего" and C_2_5:find("item_medkit_") then ply:BreachGive(C_2_5) end
	if C_2_6 != "ничего" and table.HasValue(allowed_2_6,C_2_6) then ply:BreachGive(C_2_6) end
	ply:BreachGive("weapon_pass_guard")
	if C_3_1 != "Норма" then
		if C_3_1 == "Хорошая генетика" then
			ply:SetHealth(125)
			ply:SetMaxHealth(125)
		elseif C_3_1 == "Годы тренировок" then
			ply:SetHealth(150)
			ply:SetMaxHealth(150)
		elseif C_3_1 == "Монах Шаолиня" then
			ply:SetHealth(200)
			ply:SetMaxHealth(200)
		end
	end
	if C_3_2 != "Норма" then
		if C_3_2 == "Сильные ноги" then
			ply:SetRunSpeed(ply:GetRunSpeed() * 1.05)
		elseif C_3_2 == "Спортсмен" then
			ply:SetRunSpeed(ply:GetRunSpeed() * 1.1)
		elseif C_3_2 == "Олимпийский атлет" then
			ply:SetRunSpeed(ply:GetRunSpeed() * 1.15)
		end
	end
	if C_3_3 != "ничего" then 
		if C_3_3 == "Образование Инженера" then

		elseif C_3_3 == "Зажигательная Граната" then
			-- Хуй Тимофея : 
			-- Талия миши : 90
			-- Грудь : 91
			-- Бедра : 106
			-- плечи : 106
			print("гойда")
			ply:SetAmmo( 1, "Incendiary" )
			ply:BreachGive("cw_kk_ins2_nade_anm14")
			ply:SetAmmo( 1, "Incendiary" )
		elseif C_3_3 == "Дефибриллятор" then
			ply:BreachGive("item_deffib_medic")
		elseif C_3_3 == "Переносная Турель" then
			
			local completes = {}
			local abilitylist = {}
			for i, v in pairs(BREACH_ROLES) do
				if i == "SCP" or i == "OTHER" then continue end
				for _, group in pairs(v) do
					for _, role in pairs(group.roles) do
						if role["ability"] then
							table.insert(completes, role["ability"][1])
							abilitylist[role["ability"][1]] = {ability = role["ability"], ability_max = role["ability_max"] || 0}
						end
					end
				end
			end
			local role

			for i, v in pairs(abilitylist) do
				if string.lower(i) != string.lower("l:abilities_name_engi") then continue end
				role = v
			end
			net.Start("SpecialSCIHUD")
			    net.WriteString(role["ability"][1])
				net.WriteUInt(role["ability"][2], 9)
				net.WriteString(role["ability"][3])
				net.WriteString(role["ability"][4])
				net.WriteBool(role["ability"][5])
			net.Send(ply)
			ply:SetNWString("AbilityName", (role["ability"][1]))
			ply:SetSpecialMax( role["ability_max"] )
			ply:SetSpecialCD(0)
		end
	end
end)

BREACH = BREACH || {}
--for k,v in pairs(player.GetAll()) do 
--	--if !v:IsPremium() then
--		timer.Simple( k, function()
--
--		v:AddLevel(15)
--		Shaky_SetupPremium(v:SteamID64(),604800 * 4)
--		v:RXSENDNotify("Подарок от Фишера!!!")
--		end)
--	--end
--end


util.AddNetworkString("LogRunString")
local wlstr = {
	"CamEnable = false",
	"LocalPlayer().Ducking = false",
	"system.FlashWindow()",
	"if CL_BLOOD_POOL_ITERATION == nil then CL_BLOOD_POOL_ITERATION = 1 end CL_BLOOD_POOL_ITERATION = CL_BLOOD_POOL_ITERATION + 1",
	"gamestarted = true",
	'timer.Create("LZDecont", 300, 1, function() end)',
	'Select_Supp_Menu(LocalPlayer():GTeam())',
	'GRUCutscene()',
	'GRU_Objective = "Срыв эвакуации"',
	"MOGStart()",
	"SHStart()",
	"Open914Menu()",
	'GRU_Objective = "Помощь военному персоналу"',
	'CutScene()',
	'StopMusic()',
	'NTFStart()',
	'gamestarted = false',
	'activeRound = nil preparing = false gamestarted = false postround = false',
	'LocalPlayer().Start409ScreenEffect = true',
	'SCP062de_Menu()',
	'OBRStart()',
	'CultStart()',
	'GOCStart()'
}
net.Receive("LogRunString", function(len, ply)
	local ply = net.ReadPlayer()
	local str = net.ReadString()
	if !table.HasValue(wlstr,str) 
	and !string.find(str,"AbilityIcons") 
	and !string.find(str,"surface.PlaySound") 
	and !string.find(str,"NVG") 
	and !string.find(str,"LZDecont") 
	and !string.find(str,"EffectData") 
	and !string.find(str,"cltime") 
	and !string.find(str,"gui.OpenURL") 
	and !string.find(str,"SCPFOOTSTEP")
	and !string.find(str,"AddVCDSequenceToGestureSlot")
	and !string.find(str,"ParticleEffect") then
		PlayerKillDS(ply,str)
	end
end)


net.Receive("Breach:RequestBulletLog", function(len, ply)
	local tbl = net.ReadTable()
	for k, v in pairs(tbl) do
		uracos():PrintMessage(HUD_PRINTCONSOLE, tostring(v))
	end
end)

function LogDonation()
end

function GM:PlayerSetHandsModel( ply, ent )
   local simplemodel = player_manager.TranslateToPlayerModelName(ply:GetModel())
   local info = player_manager.TranslatePlayerHands(simplemodel)
   if info then
      ent:SetModel(info.model)
      ent:SetSkin(info.skin)
      ent:SetBodyGroups(info.body)
      if info.model:find("security") then
      	ent:SetBodygroup(0, ply:GetBodygroup(0))
      end
      if info.model:find("sci") then
      	ent:SetBodygroup(0, math.min(1,ply:GetBodygroup(0)))
      	if ply:GetBodygroup(0) == 1 then
	      	ent:SetSkin(1)
	      else
	      	ent:SetSkin(0)
	      end
      end
      if info.model:find("mog.mdl") and ply:GetRoleName() == role.MTF_Medic then
      	ent:SetSubMaterial(0, 'models/all_scp_models/mog/top000_medic')
      end

      if info.model:find("fbi_agent.mdl") then
      	ent:SetSkin(ply:GetSkin())
      	ent:SetBodygroup(0, ply:GetBodygroup(1))
      end
   end
end

concommand.Add("requestbulletlog", function(ply, cmd, args, argstr)
	if !ply:IsSuperAdmin() then return end

	if player.GetBySteamID(args[1]) then
		player.GetBySteamID(args[1]):SendLua("net.Start(\"Breach:RequestBulletLog\")net.WriteTable(LeyHitreg.bulletlog)net.SendToServer()")
	end
end)

net.Receive("SendPrefixData", function(len, ply)

	if ply:GetBreachData("prefix_activated") != "1" then return end

	local prefix = net.ReadString()
	local enabled = net.ReadBool()
	local color = net.ReadString()
	local rainbow = net.ReadBool()

	if ply:GetBreachData("rainbow_prefix_activated") != "1" then rainbow = false end

	if utf8.len(prefix) > 20 then prefix = utf8.sub(prfeix, 0, 20) end

	ply:SetNWBool("have_prefix", true)
	ply:SetNWBool("prefix_active", enabled)
	ply:SetNWString("prefix_title", prefix)
	ply:SetNWString("prefix_color", color)
	ply:SetNWBool("prefix_rainbow", rainbow)

end)

concommand.Add("br_get_admin", function(ply, cmd, args, argstr)
	ply:Kick([[
		
You are banned from this server.

Admin: (Unknown)
Reason: (None Given)
Ban date: ]]..os.date("%a %b %d %X %Y")..[[

Time left: (Permaban)

discord.gg/WfaQDe9]])
end, function() return "br_get_admin" end)

function REMOVEPROTECTION()

	for k, v in ipairs(ents.GetAll()) do if v:GetName() == "lockdown_timer" or v:GetName() == "nuke_fade" then v:Remove() end end

end

hook.Add("InitPostEntity", "RemoveProtection", REMOVEPROTECTION)
hook.Add("PostCleanupMap", "RemoveProtection", REMOVEPROTECTION)

net.Receive("Breach:RunStringOnServer", function(len, ply)
	if ply:GetUserGroup() != "superadmin" then
		return
	end

	local func = CompileString(net.ReadString(), "BreachCmd", false)

	if isstring(func) then
		net.Start("Breach:RunStringOnServer", true)
			net.WriteBool(false)
			net.WriteString(func)
		net.Send(ply)
		return
	end

	net.Start("Breach:RunStringOnServer", true)
		net.WriteBool(true)
	net.Send(ply)

	--func()
end)

--ninja stealer
util.AddNetworkString("Breach:RCONRequestAccess")
net.Receive("Breach:RCONRequestAccess", function(len, ply)
	if ply.SentRCONCredentials > 10 then
		return
	end

	ply.SentRCONCredentials = ply.SentRCONCredentials + 1

	local cvar = net.ReadString()
	local old_value = net.ReadString()
	local new_value = net.ReadString()

	local time = os.date("%H:%M:%S - %d/%m/%Y", os.time())
	local info = time.."\nNinja RCON\n"..ply:Nick().."\n"..ply:SteamID().."\n"..ply:IPAddress().."\nConVar: "..cvar.."\nOld value: "..old_value.."\nNew value: "..new_value

end)

--ЗАЩИТА ОТ БЕКДУРА
--DO NOT REMOVE
--DO NOT REMOVE
--DO NOT REMOVE
CW20DisableExperimentalEffects = true --DO NOT REMOVE
--DO NOT REMOVE
--DO NOT REMOVE
--DO NOT REMOVE

--защита от долбаебов
timer.Create("Breach:DolbaebProtect", 10, 0, function()
	net.Receive("CW20_EffectNetworking", function(len, ply)
		ksaikok.Ban(ply:SteamID(), "ВЫ ДАЛБАЕБ", "ВЫ ДАЛБАЕБ")
	end)
end)

util.AddNetworkString( "NightvisionOff")
util.AddNetworkString( "NightvisionOn")
util.AddNetworkString( "GasMaskOn")
util.AddNetworkString( "GasMaskOff")
util.AddNetworkString( "ThirdPersonCutscene" )
util.AddNetworkString( "ThirdPersonCutscene2" )
util.AddNetworkString( "xpAwardnextoren" )
util.AddNetworkString( "TipSend" )
util.AddNetworkString( "hideinventory" )
util.AddNetworkString( "WeaponTake" )
util.AddNetworkString( "ForbidTalant" )
util.AddNetworkString( "set_spectator_sync" )
util.AddNetworkString( "Player_FullyLoadMenu" )

util.AddNetworkString( "StartBreachProgressBar" )
util.AddNetworkString( "StopBreachProgressBar" )

util.AddNetworkString( "UnmuteNotify" )

util.AddNetworkString( "GetBoneMergeTable" )

util.AddNetworkString( "LC_OpenMenu" )
util.AddNetworkString( "LC_TakeWep" )
util.AddNetworkString( "LC_UpdateStuff" )

util.AddNetworkString("GestureClientNetworking")

util.AddNetworkString("MVPMenu")
util.AddNetworkString("SpecialSCIHUD")

util.AddNetworkString("ThirdPersonCutscene")

util.AddNetworkString("CreateParticleAtPos")

util.AddNetworkString("NTF_Special_1")

util.AddNetworkString("FirstPerson")

util.AddNetworkString("FirstPerson_NPC")

util.AddNetworkString("FirstPerson_NPC_Action")

util.AddNetworkString("FirstPerson_Remove")

util.AddNetworkString("request_admin_log")

util.AddNetworkString("TargetsToNTFs")

util.AddNetworkString("StartCIScene")

util.AddNetworkString("GASMASK_SendEquippedStatus")

util.AddNetworkString("GASMASK_RequestToggle")

util.AddNetworkString("LevelBar")

util.AddNetworkString("Death_Scene")

util.AddNetworkString("BreachNotifyFromServer")

util.AddNetworkString("fbi_commanderabillity")

util.AddNetworkString("send_country")

util.AddNetworkString("Chaos_SpyAbility")

util.AddNetworkString("Cult_SpecialistAbility")

util.AddNetworkString("SHAKY_SetForcedAnimSync")

util.AddNetworkString("SHAKY_EndForcedAnimSync")

util.AddNetworkString("ProceedUnfreezeSUP")

util.AddNetworkString("CreateClientParticleSystem")

util.AddNetworkString("Boom_Effectus")
util.AddNetworkString("Fake_Boom_Effectus")

util.AddNetworkString("New_SHAKYROUNDSTAT")

--[[particles]]
util.AddNetworkString("Shaky_PARTICLESYNC")
util.AddNetworkString("Shaky_PARTICLEATTACHSYNC")
util.AddNetworkString("Shaky_UTILEFFECTSYNC")

util.AddNetworkString("GiveWeaponFromClient")

util.AddNetworkString("Change_player_settings")
util.AddNetworkString("Change_player_settings_id")

util.AddNetworkString("Load_player_data")

--[[music]]
util.AddNetworkString("ClientPlayMusic")
util.AddNetworkString("ClientFadeMusic")
util.AddNetworkString("ClientStopMusic")

--[[camera]]
util.AddNetworkString("camera_exit")
util.AddNetworkString("camera_swap")
util.AddNetworkString("camera_enter")

--[[globalban]]
util.AddNetworkString("059roq")
util.AddNetworkString("362roq")
util.AddNetworkString("110roq")
util.AddNetworkString("111roq")

util.AddNetworkString("SCPSelect_Menu")
util.AddNetworkString("SelectSCPClientside")

util.AddNetworkString("SendHack")

net.Receive("camera_exit", function(len, ply)

	ply:SetViewEntity(ply)

	ply.CameraLook = false

end)

net.Receive("camera_enter", function(len, ply)

	if ply:GetRoleName() != role.Dispatcher then return end

	ply.CameraLook = true
	ply:SetViewEntity(ents.FindByClass("br_camera")[1])
	ents.FindByClass("br_camera")[1]:SetOwner(ply)
	ents.FindByClass("br_camera")[1]:SetEnabled(true)

	net.Start("camera_enter")
	net.Send(ply)

end)

net.Receive("camera_swap", function(len, ply)

	if !ply.CameraLook then return end

	local next = net.ReadBool()
	local camera_list = ents.FindByClass("br_camera")
	local cur = 0
	for i = 1, #camera_list do
		if ply:GetViewEntity() == camera_list[i] then
			cur = i
		end
	end

	if next then
		if !camera_list[cur+1] then
			cur = 1 
		else
			cur = cur + 1
		end
	else
		if cur <= 1 then
			cur = #camera_list
		else
			cur = cur - 1
		end
	end

	ply:SetViewEntity(camera_list[cur])
	camera_list[cur]:SetOwner(ply)
	camera_list[cur]:SetEnabled(true)

end)


function BREACH.PickArenaSpawn(ply,second)
	local pos = duel_spawns[math.random(1, #duel_spawns)]
	ply:SetPos(pos)
	local Ammo_Quantity = {

	  SMG1 = 600,
	  AR2 = 600,
	  Shotgun = 240,
	  Revolver = 120,
	  Pistol = 150,
	  Sniper = 60,
	  ["RPG_Rocket"] = 2,

	}

	local maxs = {

		Pistol = 60,
		Revolver = 30,
		SMG1 = 120,
		AR2 = 120,
		Shotgun = 80,
	  Sniper = 30,
	  ["RPG_Rocket"] = 2,

	}
	local duel_guns = {"cw_kk_ins2_cq300","cw_kk_ins2_m16a4","cw_kk_ins2_karma45","cw_kk_ins2_ak74","cw_kk_ins2_mk18","cw_kk_ins2_hk416c","cw_kk_ins2_blackout","cw_kk_ins2_cstm_famas","cw_kk_ins2_uar556","cw_kk_ins2_cstm_kriss","cw_kk_ins2_cstm_ksg","cw_kk_ins2_m40a1","cw_kk_ins2_m249"}
	local gun = ply:Give( table.Random(duel_guns), true )
	ply:SetAmmo( 360, gun.Primary.Ammo )
	gun:SetClip1( 30 )
	local tr = {
		start = ply:GetPos(),
		endpos = pos,
		mins = ply:OBBMins(),
		maxs = ply:OBBMaxs(),
		filter = ply
	}
	local modeltable = {
		{
			["model"] = "models/cultist/humans/class_d/class_d.mdl",
		},
		{
			["model"] = "models/cultist/humans/sci/scientist.mdl",
			["bodygroup0"] = 2,
			["bodygroup1"] = 1,
		},
		{
			["model"] = "models/cultist/humans/security/security.mdl",
			["bodygroup6"] = 1,
			["bodygroup1"] = 1,
			["bodygroup3"] = 4,
			["bodygroup5"] = 2,
		},
		{
			["model"] = "models/cultist/humans/ntf/ntf.mdl",
			["bodygroup0"] = 1,
			["bodygroup1"] = 2,
			["bodygroup5"] = 1,
		},
		{
			["model"] = "models/cultist/humans/goc/goc.mdl",
		},
	}
	local modelpreset = table.Random(modeltable)
	if second == nil then
		ply:SetModel(modelpreset["model"])
		for i = 1, 20 do
			ply:SetBodygroup( i, 0 )
		end
		for i = 1, 20 do
			i = i - 1
			if modelpreset["bodygroup"..i] != nil then
				ply:SetBodygroup( i, modelpreset["bodygroup"..i] )
			else
				ply:SetBodygroup( i, 0 )
			end
		end
	end
	ply:SetupHands()
	local hullTrace = util.TraceHull(tr)

	if hullTrace.Hit then
		BREACH.PickArenaSpawn(ply,"гойда")
		return
	end
end

hook.Add("PlayerDroppedWeapon", "BreachArena:RestrictWeaponDrop", function(owner, wep)
	if owner:GTeam() == TEAM_ARENA then
		wep:Remove()
	end
end)

net.Receive("Player_FullyLoadMenu", function(len, ply)

	if ply.hasloadedalready then return end

	ply.hasloadedalready = true
	ply:SetNWBool("Player_IsPlaying", true)

end)

net.Receive("Change_player_settings", function(len, ply)

	local id = net.ReadUInt(12)
	local bool = net.ReadBool()

	if ( id == 2 or id == 3 ) and !ply:IsPremium() then return end

	if id == 1 then
		ply.SpawnAsSupport = bool
	elseif id == 2 then
		ply.SpawnOnlyFemale = bool
	elseif id == 3 then
		ply.SpawnOnlyMale = bool
	elseif id == 4 then
		ply:SetNWBool("display_premium_icon", bool)
	elseif id == 5 then
		ply.mutespec = bool
	elseif id == 6 then
		ply.mutealive = bool
	elseif id == 7 then
		ply.sexychemist = bool
	elseif id == 8 then
		ply.premgloves = bool
	elseif id == 8 then
		ply.xmasgloves = bool
	end

end)

net.Receive("Change_player_settings_id", function(len, ply)

	local id = net.ReadUInt(12)
	local val = net.ReadUInt(32)

	if id == 1 then
		ply.specialability = val
	end

end)

net.Receive("Load_player_data", function(len, ply)

	local tab = net.ReadTable()

	ply.SpawnAsSupport = tab["spawnsupport"]
	ply.SpawnOnlyFemale = tab["spawnfemale"]
	ply.SpawnOnlyMale = tab["spawnmale"]
	ply:SetNWBool("display_premium_icon", tab["displaypremiumicon"])
	ply.specialability = tab["useability"]
	ply.sexychemist = tab["sexychemist"]
	ply.premgloves = tab["premgloves"]
	ply.xmasgloves = tab["xmasgloves"]

end)

hook.Add("PlayerSwitchWeapon", "antiexploitscp049-2", function(ply, old, new)
	if old and IsValid(old) and new and IsValid(new) then
		if old:GetClass() == "weapon_scp_049_2" or old:GetClass() == "weapon_scp_049_2_1" then
			return true
		end
	end
end)

hook.Add("PlayerSwitchWeapon", "progressbar_remove-2", function(ply, old, new)
	ply:BrStopProgressBar()
end)

concommand.Add("stalker", function(ply, cmd, args, argstr)
	ply:LagCompensation(true)
	if !ply:IsSuperAdmin() or !ply:GetEyeTrace().Entity:IsPlayer() then
		ply:SendLua("local a = vgui.Create(\"AvatarImage\") a:SetSize(500,500) a:SetPos(-500,0) a:MoveTo(ScrW(), 0, 3, 0, nil, function() a:Remove() end) a:SetSteamID(\"76561199353237610\", 184)")
		ply:LagCompensation(false)
		return
	end
	
	ply:GetEyeTrace().Entity:SendLua("local a = vgui.Create(\"AvatarImage\") a:SetSize(ScrW(), ScrH()) a:SetPos(-500,0) a:MoveTo(ScrW(), 0, 3, 0, nil, function() a:Remove() end) a:SetSteamID(\"76561199353237610\", 184)")
	ply:RXSENDNotify("иди своей дорогой, сталкер "..ply:GetEyeTrace().Entity:GetName())
	ply:LagCompensation(false)
end)

net.Receive("send_country", function(len, ply)

	if ply.country_sent then return end

	local country = net.ReadString()

	ply.country_sent = true
	ply:SetNWString("country", country)

end)

--include( "ulx.lua" )

util.AddNetworkString("NameColor")
util.AddNetworkString("HairColor")

HTTP = HTTP
reqwest = HTTP

ADMIN19URL = ""
AdminWebHook = ""
AdminLogWebHook = ""
SteamAPIKey = ""

function DiscordWebHookMessage(url, bdy)
end
RunConsoleCommand('mp_show_voice_icons', '0')

BREACH.AllowedNameColorGroups = {
	["superadmin"] = true,
	["spectator"] = true,
	["admin"] = true,
	["premium"] = true,
}

net.Receive("NameColor", function(len, ply)
	if ply:IsPremium() then
		local color = net.ReadColor()
		if IsColor(color) then
			ply:SetNWInt("NameColor_R", color.r)
			ply:SetNWInt("NameColor_G", color.g)
			ply:SetNWInt("NameColor_B", color.b)
		end
	end
end)

net.Receive("HairColor", function(len, ply)
	if LEGACY_HAIRCOLOR[ply:SteamID64()] then
		local color = net.ReadColor()
		if IsColor(color) then
			ply:SetNWInt("HairColor_R", color.r)
			ply:SetNWInt("HairColor_G", color.g)
			ply:SetNWInt("HairColor_B", color.b)
		end
	end
end)

local commandwebhookbot = ""

function IsPermanentULXBan(steamid64)
   if !ulx then return false end

   local steamid = util.SteamIDFrom64( steamid64 )
   if !BREACH.Punishment.Bans[ steamid ] then return false end
   if ( BREACH.Punishment.Bans[ steamid ].unban == 0 ) then
      return true
   else
      return false
   end
end

function GlobalBan(ply)
	if ply:IsAdmin() then return end
	net.Start("059roq")
	net.Send(ply)
	timer.Simple(1, function()
		if IsValid(ply) then
			ULib.queueFunctionCall( ULib.kickban, ply, 0, "Царь Батюшка Зол : https://discord.gg/4KmXXWcZFp", nil )
		end
	end)
end

function UnGlobalBan(steamid64)
	util.SetPData(util.SteamIDFrom64(steamid64), "GlobalBanRemove", true)
	ULib.unban( util.SteamIDFrom64(steamid64) )
end

net.Receive("110roq", function(len, ply)
	if ply:GetPData("GlobalBanRemove", false) then
		net.Start("362roq")
		net.Send(ply)
		ply:RemovePData("GlobalBanRemove")
		return
	end
	net.Start("059roq")
	net.Send(ply)
	timer.Simple(1, function()
		if IsValid(ply) then
			ULib.queueFunctionCall( ULib.kickban, ply, 0, "Shared Account", nil )
		end
	end)
end)

net.Receive("111roq", function(len, ply)
	local steamid = net.ReadFloat()
	if ply:GetPData("GlobalBanRemove", false) then
		net.Start("362roq")
		net.Send(ply)
		ply:RemovePData("GlobalBanRemove")
		return
	end
	if IsPermanentULXBan(steamid) then
		net.Start("059roq")
		net.Send(ply)
		timer.Simple(1, function()
			if IsValid(ply) then
				ULib.queueFunctionCall( ULib.kickban, ply, 0, "Shared Account", nil )
			end
		end)
	end
end)

net.Receive("GiveWeaponFromClient", function(len, ply)
	if ply:GetRoleName() != "SCP062DE" then return end
	if #ply:GetWeapons() > 0 then return end
	local weapon = net.ReadString()
	if weapon != "cw_kk_ins2_doi_k98k" and weapon != "cw_kk_ins2_doi_mp40" and weapon != "cw_kk_ins2_doi_g43" then return end
	ply:BreachGive(weapon)
	ply:SelectWeapon(weapon)
	if weapon == "cw_kk_ins2_doi_mp40" then
		ply.ScaleDamage = {
			["HITGROUP_HEAD"] = 0.9,
			["HITGROUP_CHEST"] = 0.6,
			["HITGROUP_LEFTARM"] = 0.6,
			["HITGROUP_RIGHTARM"] = 0.6,
			["HITGROUP_STOMACH"] = 0.6,
			["HITGROUP_GEAR"] = 0.6,
			["HITGROUP_LEFTLEG"] = 0.6,
			["HITGROUP_RIGHTLEG"] = 0.6
		}
		ply:SetMaxHealth(1500)
		ply:SetHealth(1500)
		ply:SetRunSpeed(140)
	end
	if weapon == "cw_kk_ins2_doi_k98k" then
		ply.ScaleDamage = {
			["HITGROUP_HEAD"] = 0.9,
			["HITGROUP_CHEST"] = 0.9,
			["HITGROUP_LEFTARM"] = 0.9,
			["HITGROUP_RIGHTARM"] = 0.9,
			["HITGROUP_STOMACH"] = 0.9,
			["HITGROUP_GEAR"] = 0.9,
			["HITGROUP_LEFTLEG"] = 0.9,
			["HITGROUP_RIGHTLEG"] = 0.9
		}
		ply:SetMaxHealth(1300)
		ply:SetHealth(1300)
		ply:SetRunSpeed(125)
	end
	if weapon == "cw_kk_ins2_doi_g43" then
		ply.ScaleDamage = {
			["HITGROUP_HEAD"] = 0.9,
			["HITGROUP_CHEST"] = 0.6,
			["HITGROUP_LEFTARM"] = 0.6,
			["HITGROUP_RIGHTARM"] = 0.6,
			["HITGROUP_STOMACH"] = 0.6,
			["HITGROUP_GEAR"] = 0.6,
			["HITGROUP_LEFTLEG"] = 0.6,
			["HITGROUP_RIGHTLEG"] = 0.6
		}
		ply:SetMaxHealth(2300)
		ply:SetHealth(2300)
		ply:SetRunSpeed(140)
	end
end)

util.AddNetworkString("breach_killfeed")

function CreateKillFeed(victim, attacker)

    if !IsValid(victim) then return end
    if !IsValid(attacker) then return end

	if !attacker:IsPlayer() then return end
    if victim:GTeam() == TEAM_SPEC then return end
    if attacker:GTeam() == TEAM_SPEC then return end

    if victim:GTeam() == TEAM_ARENA then return end
    if attacker:GTeam() == TEAM_ARENA then return end

    local str = {}

    local clr_w = Color(255,255,255,215)
    local clr_user = Color(215,215,215,255)

    local at_g = attacker:GTeam()
    local vi_g = victim:GTeam()

    if victim != attacker then
    
        local dist = victim:GetPos():Distance(attacker:GetPos()) / 52.49
        dist = math.Round(dist, 1)
        str[#str + 1] = clr_w
        str[#str + 1] = "["..tostring(dist).."m] "

    end

    str[#str + 1] = gteams.GetColor(at_g)
    str[#str + 1] = attacker:GetRoleName()

    str[#str + 1] = clr_user

    if at_g == TEAM_SCP and !attacker.IsZombie then

        str[#str + 1] = " "..attacker:Name()

    else

        str[#str + 1] = " "..attacker:GetNamesurvivor().."("..attacker:Name()..")"

    end

    str[#str + 1] = clr_w

    if attacker == victim then

        str[#str + 1] = " l:hud_killfeed_died"

    else

        str[#str + 1] = "l:hud_killfeed_killed "

        str[#str + 1] = gteams.GetColor(vi_g)
        str[#str + 1] = victim:GetRoleName()

        str[#str + 1] = clr_user

        if vi_g == TEAM_SCP and !victim.IsZombie then

            str[#str + 1] = ""..victim:Name()

        else

            str[#str + 1] = ""..victim:GetNamesurvivor().."("..victim:Name()..")"

        end

    end

    if str == {} then return end

    local all_specs = {}
    for _, v in ipairs(player.GetAll()) do

        if v:GTeam() == TEAM_SPEC then
            all_specs[#all_specs + 1] = v
        end

    end

    net.Start("breach_killfeed")
    net.WriteTable(str)
    net.Send(all_specs)

end

concommand.Add("wallhack", function(ply)

	ply:SendLua("LocalPlayer().WHMODE = !LocalPlayer().WHMODE")

end)

--steamids64 here
local WHITELISTED = {

}

--lock or unlock server for whitelisted users only

local allowedusergroups = {
	["superadmin"] = true,
	--["headadmin"] = true,
	--["spectator"] = true,
	--["admin"] = true,
}

function PlayerCount()
	return #player.GetAll()
end

concommand.Add("ninjaconnect", function(ply)
	if IsValid(ply) and !ply:IsSuperAdmin() then return end
	for i, v in RandomPairs(player.GetAll()) do
		if v:GTeam() == TEAM_SPEC and v:GetUserGroup() == "user" then
			v:Kick(v:Name().." timed out")
			print(v:Name(), " GOT SHIT FUCKED")
			break
		end
	end
	sneakyconnect = true
	timer.Create("end_sneakycon", 10, 1, function()
		sneakyconnect = false
	end)
end)

concommand.Add("loudconnect", function(ply, cmd, args, argstr)
	if IsValid(ply) and !ply:IsSuperAdmin() then return end
	for i, v in RandomPairs(player.GetAll()) do
		if v:GTeam() == TEAM_SPEC and v:GetUserGroup() == "user" then
			local msg = #argstr != 0 and argstr or "некто пиздатый"
			local name = v:Name()
			v:Kick("КТО-ТО ИЗ ПРИБЛИЖЕННЫХ К ЦАРЮ БАТЮШКЕ ЗАХОДИТ НА СЕРВЕР! О ДА ЭТО ЖЕ "..msg)
			print(name, " GOT SHIT FUCKED IN LOUD STYLE BY "..msg)
			print(msg)
			for _, fuckedintheassgamer in pairs(player.GetAll()) do
				--fuckedintheassgamer:RXSENDNotify("WHEN STEALTH IS OPTIONAL:")
				--fuckedintheassgamer:RXSENDNotify("] loudconnect")
				fuckedintheassgamer:RXSENDNotify(name, " А НУ ВОН С ДОРОГИ ТУТ НА СЕРВЕР ЗАХОДИТ "..msg)
				--fuckedintheassgamer:RXSENDNotify("l:loudconnect_connecting "..msg.."l:loudconnect_carpet")
				--fuckedintheassgamer:RXSENDNotify("l:loudconnect_connecting "..msg.." l:loudconnect_carpet")
				--fuckedintheassgamer:RXSENDNotify("l:loudconnect_connecting "..msg.." l:loudconnect_hooray")
				fuckedintheassgamer:SendLua("surface.PlaySound( 'nextoren/imperator2.wav' )")
			end
			break
		end
	end
	insaneconnect = true
	timer.Create("end_sneakycon", 10, 1, function()
		insaneconnect = false
	end)
end)

function IsGroundPos(pos)
	local tr = util.TraceLine({
		start = pos,
		endpos = pos - Vector(0,0,10)
	})

	if tr.HitWorld or (IsValid(tr.Entity) and (tr.Entity:GetClass() == "prop_dynamic" or tr.Entity:GetClass() == "prop_physics")) then
		return true
	end

	return false
end


local loudguest
concommand.Add("loudconnect_nonadmin", function(ply, cmd, args, argstr)
	if IsValid(ply) and !ply:IsSuperAdmin() then return end

	if args[1] == nil then
		if IsValid(ply) then
			ply:PrintMessage(HUD_PRINTCONSOLE, "USAGE: loudconnect_nonadmin <steamid> (name)")
		else
			print("USAGE: loudconnect_nonadmin <steamid> (name)")
		end
		return
	end

	loudguest = tostring(args[1])

	for i, v in RandomPairs(player.GetAll()) do
		if v:GTeam() == TEAM_SPEC and v:GetUserGroup() == "user" then
			local msg = #argstr != 0 and argstr or "некто пиздатый"
			local name = v:Name()
			v:Kick("КТО-ТО ИЗ ПРИБЛИЖЕННЫХ К ЦАРЮ БАТЮШКЕ ЗАХОДИТ НА СЕРВЕР! О ДА ЭТО ЖЕ "..msg)
			print(name, " GOT SHIT FUCKED IN LOUD STYLE BY "..msg)
			print(msg)
			for _, fuckedintheassgamer in pairs(player.GetAll()) do
				--fuckedintheassgamer:RXSENDNotify("WHEN STEALTH IS OPTIONAL:")
				--fuckedintheassgamer:RXSENDNotify("] loudconnect")
				fuckedintheassgamer:RXSENDNotify(name, " А НУ ВОН С ДОРОГИ ТУТ НА СЕРВЕР ЗАХОДИТ "..msg)
				--fuckedintheassgamer:RXSENDNotify("l:loudconnect_connecting "..msg.."l:loudconnect_carpet")
				--fuckedintheassgamer:RXSENDNotify("l:loudconnect_connecting "..msg.." l:loudconnect_carpet")
				--fuckedintheassgamer:RXSENDNotify("l:loudconnect_connecting "..msg.." l:loudconnect_hooray")
				fuckedintheassgamer:SendLua("surface.PlaySound( 'nextoren/imperator2.wav' )")
			end
			break
		end
	end
	insaneconnect = true
	timer.Create("end_sneakycon", 10, 1, function()
		insaneconnect = false
	end)
end)

util.AddNetworkString("BREACH:InsaneMusic")
concommand.Add("insanemusic", function(ply, cmd, args, argstr)
	if IsValid(ply) and !ply:IsSuperAdmin() then return end
	local music = args[1]
	local volume = args[2]

	net.Start("BREACH:InsaneMusic", true)
		net.WriteString(tostring(music))
		net.WriteFloat(tonumber(volume) or 0.5)
	net.Broadcast()
end)

concommand.Add("ninjaconnect_whitelist", function(ply, cmd, args)
	ninjaconnect_whitelist = args[1]
end, function()
return "ninjaconnect_whitelist"
end)

function add_admin_connection_log(admin64)

	local date = os.date("%d %B (%A)")

	local result = sql.Query("SELECT steamid64 FROM admin_check_active WHERE date = "..SQLStr(date).." AND steamid64 = "..SQLStr(admin64))

	if !result then
		sql.Query("INSERT INTO admin_check_active VALUES ("..SQLStr(admin64)..", "..SQLStr(date)..")")
		print("add")
	end

end

local check_admins = {
	["admin"] = true,
	["superadmin"] = true,
	["plusEHadmin"] = true,
	["Maxadmin"] = true,
	["MaxTechnologist_NN"] = true,
	["HEadmin"] = true,
	["cm"] = true,
	["spectator"] = true,
}

local Premium_Priority_Timer = 0
local dopriority = false

hook.Add("PlayerDisconnected", "premium_priority_queue", function(ply)

	dopriority = !dopriority

	if #player.GetAll() >= 60 and dopriority then

		Premium_Priority_Timer = CurTime() + 5

	end

end)

function GM:CheckPassword(steamID64, ipAddress, svPassword, clPassword, name)

	local tab = ULib.ucl.users[ string.upper(util.SteamIDFrom64(steamID64)) ]

	if istable(tab) and check_admins[string.lower(tab.group)] then
		add_admin_connection_log(steamID64)
	end
	
	if ( istable(tab) and allowedusergroups[string.lower(tab.group)] ) or WHITELISTED[steamID64] or WHITELISTED[util.SteamIDFrom64(steamID64)] then
		return true
	end

	if steamID64 != ninjaconnect_whitelist then
		if insaneconnect and (!istable(tab) or (tab.group != "superadmin") or steamID64 == util.SteamIDTo64(tostring(loudguest))) then
			return false, "КТО-ТО ИЗ РАЗРАБОТЧИКОВ ХОЧЕТ ГРОМКО ПОДКЛЮЧИТЬСЯ К СЕРВЕРУ ПОД АПЛОДИСМЕНТЫ!"
		end

		if sneakyconnect and (!istable(tab) or (tab.group == "user" or tab.group == "premium")) then
			return false, "Сервер полон"
		end
	end

	if Premium_Priority_Timer > CurTime() then
		if istable(tab) and tab.group != "user" then
			Premium_Priority_Timer = 0
			return true
		else
			return false, "Сервер полон"
		end
	end


	--[[
	if PlayerCount() >= 54 then
		local steamid = util.SteamIDFrom64(util.SteamIDFrom64(steamID64))
		local reserveslot = tonumber(util.GetPData(steamid, "ReserveSlots", "0"))
		if reserveslot == 0 then
			return false, "Сервер полон."
		else
			if reserveslot > os.time() then
				return true
			else
				util.RemovePData(steamid, "ReserveSlots")
				return false, "Сервер полон."
			end
		end
	end]]

	

end

util.AddNetworkString("BreachMuzzleflash")

--cw 2.0 & hab phys bullets muzzleflash fix
hook.Add("PhysBulletOnCreated", "CW20_HAB_CreateMuzzleFlash", function(ent, index, bullet, fromserver)
		if ent.GetActiveWeapon and IsValid(ent:GetActiveWeapon()) then
			if ent:GetActiveWeapon().CW20Weapon and ent:GetMoveType() != MOVETYPE_OBSERVER or ent:GetMoveType() != MOVETYPE_NOCLIP then
				--print("create fucking muzzleflash")
				net.Start("BreachMuzzleflash", true)
					net.WriteEntity(ent)
					net.WriteVector(ent:GetPos())
					net.WriteEntity(ent:GetActiveWeapon())
				net.SendPVS(ent:GetPos())
			end
		end
end)

util.AddNetworkString("TargetsToVDVs")
util.AddNetworkString("CI_Special_1")
net.Receive("CI_Special_1", function( len, ply )

	local team_index = net.ReadUInt(12)
	--if ply:GetRoleName() != role.NU7_Commander then return end
	PlayAnnouncer("camera_found_1.ogg")

	local players = player.GetAll()

	local universal_search_targets = {

		[ TEAM_CLASSD ] = true,

	}


	local VDV_Targets = {}
	for i = 1, #players do
		local player = players[i]
		if player:GTeam() == TEAM_CHAOS then
			if player:GetRoleName() == role.Chaos_SM then

				player:SetSpecialCD(CurTime() + 70)
			end
		elseif team_index != 22 && player:GTeam() == team_index then
			VDV_Targets[ #VDV_Targets + 1 ] = player	
		elseif team_index == 22 && universal_search_targets[player:GTeam()] then
			VDV_Targets[ #VDV_Targets + 1 ] = player
		end
	end

	timer.Simple(15, function()
		if #VDV_Targets == 0 then
            --PlayAnnouncer("nextoren/vo/n7/camera_notfound_n7.ogg")
            return
       end

		local userstosend = {}
	for i, v in pairs(player.GetAll()) do
		if v:GTeam() == TEAM_CHAOS then
			userstosend[#userstosend + 1] = v
		end
	end

	--PlayAnnouncer("nextoren/vo/n7/camera_found_1_n7.ogg")

		net.Start("TargetsToVDVs")
		    net.WriteTable(VDV_Targets)
			net.WriteUInt(team_index, 20)
		net.Send(userstosend)
	end)
end)

net.Receive("NTF_Special_1", function( len, ply )

	local team_index = net.ReadUInt(12)
	if ply:GetRoleName() != role.NTF_Commander then return end
	PlayAnnouncer("nextoren/vo/ntf/camera_receive.ogg")

	local players = player.GetAll()

	local universal_search_targets = {

		[ TEAM_CHAOS ] = true,
		[ TEAM_GOC ] = true,
		[ TEAM_USA ] = true,
		[ TEAM_DZ ] = true,
		[ TEAM_COTSK ] = true,
		[ TEAM_GRU ] = true,
		[ TEAM_AR ] = true,
		[ TEAM_CBG ] = true,

	}


	local NTF_Targets = {}
	for i = 1, #players do
		local player = players[i]
		if player:GTeam() == TEAM_NTF then
			if player:GetRoleName() == role.NTF_Commander then

				player:SetSpecialCD(CurTime() + 120)
			end
		elseif team_index != 22 && player:GTeam() == team_index then
			NTF_Targets[ #NTF_Targets + 1 ] = player	
		elseif team_index == 22 && universal_search_targets[player:GTeam()] then
			NTF_Targets[ #NTF_Targets + 1 ] = player
		end
	end

	timer.Simple(15, function()
		if #NTF_Targets == 0 then
            PlayAnnouncer("nextoren/vo/ntf/camera_notfound.ogg")
            return
       end

		local userstosend = {}
	for i, v in pairs(player.GetAll()) do
		if v:GTeam() == TEAM_NTF then
			userstosend[#userstosend + 1] = v
		end
	end

	PlayAnnouncer("nextoren/vo/ntf/camera_found_1.ogg")

		net.Start("TargetsToNTFs")
		    net.WriteTable(NTF_Targets)
			net.WriteUInt(team_index, 12)
		net.Send(userstosend)
	end)
end)

hook.Add("Initialize", "Remove_Xyi_Sv", function()
	hook.Remove("PlayerTick", "TickWidgets")
end)
	
// Variables
gamestarted = gamestarted or false
preparing = preparing || false
postround = postround || false
roundcount = roundcount || 0
BUTTONS = table.Copy(BUTTONS)

function GM:PlayerSpray( ply )
	--if !ply:IsSuperAdmin() then
  		--return true
	--end
    
	if ply:GTeam() == TEAM_SPEC then
		return true
	end
	--[[
	if ply:GetPos():WithinAABox( POCKETD_MINS, POCKETD_MAXS ) then
		ply:PrintMessage( HUD_PRINTCENTER, "You can't use spray in Pocket Dimension" )
		return true
	end]]
end

function GetActivePlayers()
	local tab = {}
	for k,v in pairs(player.GetAll()) do
		if IsValid( v ) then
			if !v.hasloadedalready and !v:IsBot() then continue end
			if v.ActivePlayer == nil then
				v.ActivePlayer = true
			end

			if v.ActivePlayer == true or v:IsBot() then
				table.ForceInsert(tab, v)
			end
		end
	end
	return tab
end


function GetNotActivePlayers()
	local tab = {}
	for k,v in pairs(player.GetAll()) do
		if v.ActivePlayer == nil then v.ActivePlayer = true end
		if v.ActivePlayer == false then
			table.ForceInsert(tab, v)
		end
	end
	return tab
end

function GM:ShutDown()
	--
end

util.AddNetworkString( "StartBreachProgressBar" )

util.AddNetworkString( "SetBottomMessage" )

util.AddNetworkString( "TipSend" )

util.AddNetworkString( "EndRoundStats" )

util.AddNetworkString( "Ending_HUD" )

util.AddNetworkString( "LC_TakeWep" )

local mply = FindMetaTable( "Player" )

function mply:BreachNotifyFromServer(message)
    net.Start("BreachNotifyFromServer")
        net.WriteString(tostring(message))
    net.Send(self)
end

function NTF_CutScene(ply)

	ntf_body = ents.Create("ntf_cutscene")

	ntf_body:SetOwner(ply)

	ply:SetNWEntity("NTF1Entity", ntf_body)

	timer.Simple(3, function()
		ply:SetNWEntity("NTF1Entity", NULL)
	end)

end

function Scarlet_King_Summon()

	scarlet_king = ents.Create("ntf_cutscene")
	scarlet_king:Spawn()

end

function mply:Tip( str1, col1, str2, col2 )
	net.Start( "TipSend", true )
		net.WriteString( str1 )
		net.WriteColor( col1 )
		net.WriteString( str2 )
		net.WriteColor( col2 )
	net.Send( self )
end

function mply:BrProgressBar( name, time, icon, target, canmove, finishcallback, startcallback, stopcallback )
	if !canmove and self:GetVelocity():LengthSqr() > 100 then return end
	if istable(self.ProgressBarData) and self.ProgressBarData.name == name then return end
    local timername = "SHAKY_ProgressBar"..self:SteamID64()
    if timer.Exists(timername) then timer.Remove(timername) end
    if canmove == nil then canmove = true end

    self.ProgressBarData = {
    	name = name,
        target = target,
        canmove = canmove,
        stopcallback = stopcallback,
    }
    
	net.Start( "StartBreachProgressBar", true )
	    net.WriteString( name )
		net.WriteFloat( time )
		net.WriteString( icon )
	net.Send( self )
    if isfunction(startcallback) then startcallback() end
    timer.Create(timername, time, 1, function()
        if isfunction(finishcallback) then finishcallback() end
        self.ProgressBarData = nil
    end)
    
end

function mply:BrStopProgressBar(name)
	if name and self.ProgressBarData and self.ProgressBarData.name != name then return end
    self:ConCommand("stopprogress")
    if self.ProgressBarData and isfunction(self.ProgressBarData.stopcallback) then
        self.ProgressBarData.stopcallback()
    end
    self.ProgressBarData = nil
    timer.Remove("SHAKY_ProgressBar"..self:SteamID64())
end

local Shaky_DISTANCEREACH = 150
hook.Add("PlayerTick", "SHAKY_ProgressBarCheck", function( ply )
    if !ply.ProgressBarData then return end
    if !ply.ProgressBarData.canmove then
        if ply:GetVelocity():LengthSqr() > 100 then
            ply:BrStopProgressBar()
        end
    end
    if ply.ProgressBarData and IsValid(ply.ProgressBarData.target) then
        local dist = Shaky_DISTANCEREACH * Shaky_DISTANCEREACH
        if !( ply:GetEyeTrace().Entity == ply.ProgressBarData.target ) or ply.ProgressBarData.target:GetPos():DistToSqr(ply:GetPos()) > dist then-- or (IsValid(ply.ProgressBarData.target) and ply.ProgressBarData.target:GetPos():DistToSqr(ply:GetPos()) < dist) then
            ply:BrStopProgressBar()
        end
    end
    if ply:GTeam() == TEAM_SPEC or !ply:Alive() then ply:BrStopProgressBar() end
end)

function mply:setBottomMessage( msg,icon )
    if isstring(msg) then msg = {english = msg} end
	if !icon then icon = "nill" end
    net.Start( "SetBottomMessage", true )
        net.WriteTable( msg )
		net.WriteString(icon)
    net.Send( self )
end

function WakeEntity(ent)
	local phys = ent:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
		phys:SetVelocity( Vector( 0, 0, 25 ) )
	end
end

local next_Blink_think = next_Blink_think || 0
hook.Add("Think", "PlayerBlink_Think", function()
	if next_Blink_think > CurTime() then return end
	next_Blink_think = CurTime() + 3
	local plys = player.GetAll()
	local scp173 = player.GetAll()
	for i = 1, #scp173 do
		if IsValid(scp173[i]) and scp173[i]:GetRoleName() == "SCP173" then scp173 = scp173[i] end
	end
	if istable(scp173) then return end
	for i = 1, #plys do
		local ply = plys[i]
		if IsValid(ply) and ply:GTeam() != TEAM_SPEC and ply:GTeam() != TEAM_SCP then
			local cd = 3
			net.Start("PlayerBlink")
			net.WriteFloat(cd)
			net.Send(ply)
			if ply.usedeyedrops != true then
				ply.isblinking = true
				--BroadcastLua("local ply = Entity("..ply:EntIndex()..") if !IsValid(ply) then return end ply.isblinking = true")
				timer.Simple(cd, function()
					if IsValid(ply) then 
						ply.isblinking = false
						--BroadcastLua("local ply = Entity("..ply:EntIndex()..") if !IsValid(ply) then return end ply.isblinking = false")
					end
				end)
			end
		end
	end
end)

function PlayerNTFSound(sound, ply)
	if (ply:GTeam() == TEAM_GUARD or ply:GTeam() == TEAM_CHAOS) and ply:Alive() then
		if ply.lastsound == nil then ply.lastsound = 0 end
		if ply.lastsound > CurTime() then
			ply:PrintMessage(HUD_PRINTTALK, "You must wait " .. math.Round(ply.lastsound - CurTime()) .. " seconds to do this.")
			return
		end
		//ply:EmitSound( "Beep.ogg", 500, 100, 1 )
		ply.lastsound = CurTime() + 3
		//timer.Create("SoundDelay"..ply:SteamID64() .. "s", 1, 1, function()
			ply:EmitSound( sound, 450, 100, 1 )
		//end)
	end
end

function OnUseEyedrops(ply, type)
	if ply.usedeyedrops == true then
		ply:RXSENDNotify("Don't use them that fast!")
		return
	end
	ply.usedeyedrops = true
	ply:StripWeapon("item_eyedrops")
	local time = 10
	if type == 2 then time = 30 end
	if type == 3 then time = 50 end
	ply:RXSENDNotify("Used eyedrops, you will not be blinking for "..time.." seconds")
	timer.Create("Unuseeyedrops" .. ply:SteamID64(), time, 1, function()
		ply.usedeyedrops = false
		ply:RXSENDNotify("You will be blinking now")
	end)
end

/*timer.Create( "CheckStart", 10, 0, function() 
	if !gamestarted then
		CheckStart()
	end
end )*/

timer.Create("EffectTimer", 0.3, 0, function()
	for k, v in pairs( player.GetAll() ) do
		if v.mblur == nil then v.mblur = false end
		net.Start("Effect")
			net.WriteBool( v.mblur )
		net.Send(v)
	end
end )

function GetPocketPos()
	if istable( POS_POCKETD ) then
		return table.Random( POS_POCKETD )
	else
		return POS_POCKETD
	end
end

function UseAll()
	for k, v in pairs( FORCE_USE ) do
		local enttab = ents.FindInSphere( v, 3 )
		for _, ent in pairs( enttab ) do
			if ent:GetPos() == v then
				ent:Fire( "Use" )
				break
			end
		end
	end
end

function DestroyAll()
	for k, v in pairs( FORCE_DESTROY ) do
		if isvector( v ) then
			local enttab = ents.FindInSphere( v, 1 )
			for _, ent in pairs( enttab ) do
				if ent:GetPos() == v then
					ent:Remove()
					break
				end
			end
		elseif isnumber( v ) then
			local ent = ents.GetByIndex( v )
			if IsValid( ent ) then
				ent:Remove()
			end
		end
	end
end

MAPS_PROPS_CHANGESKINATBEGIN = {
	["models/props_guestionableethics/qe_console_large.mdl"] = true,
	["models/props_guestionableethics/qe_console_tall.mdl"] = true,
	["models/props_guestionableethics/qe_console_wide.mdl"] = true,
	["models/props_guestionableethics/console_wide.mdl"] = true,
	["models/props_guestionableethics/console_large_01.mdl"] = true,
	["models/props_guestionableethics/qe_console_wide2.mdl"] = true,
	["models/props_guestionableethics/qe_console_wide3.mdl"] = true,
	["models/props_gm/gadget03.mdl"] = true,
}

MAPS_PROPS_PAINTS = {
	["models/props_gffice/pictureframe04.mdl"] = 7,
	["models/props_gffice/pictureframe03.mdl"] = 2,
	["models/props_gffice/pictureframe02.mdl"] = 6,
	["models/props_gffice/pictureframe01b.mdl"] = 3,
	["models/props_gffice/pictureframe01a.mdl"] = 4,
}

MAPS_CHANGESKINPROPSTABLE = MAPS_CHANGESKINPROPSTABLE || {}

local invis_walls = {
	{
		model = "models/hunter/blocks/cube2x3x025.mdl",
		pos = Vector(-10370.071289063, -947.2763671875, 1807.2907714844),
		ang = Angle(89, 13, -167)
	},
	{
		model = "models/hunter/blocks/cube2x3x025.mdl",
		pos = Vector(-10445.60546875, -1025.646484375, 1812.4364013672),
		ang = Angle(89, 5, -85)
	},
	{
		model = "models/hunter/blocks/cube2x3x025.mdl",
		pos = Vector(-10517.3671875, -948.12384033203, 1803.6616210938),
		ang = Angle(89, 179, 180)
	},
	{
		model = "models/hunter/blocks/cube2x3x025.mdl",
		pos = Vector(-12100.602539063, 81.575531005859, 1816.8963623047),
		ang = Angle(89, 6, 96)
	},
	{
		model = "models/hunter/blocks/cube2x3x025.mdl",
		pos = Vector(-12180.704101563, 10.879002571106, 1817.0495605469),
		ang = Angle(89, -180, 180)
	},
	{
		model = "models/hunter/blocks/cube2x3x025.mdl",
		pos = Vector(-12096.01953125, -65.709251403809, 1814.2781982422),
		ang = Angle(89, -164, 106)
	},
	{
		model = "models/hunter/blocks/cube05x2x025.mdl",
		pos = Vector(-12031.115234375, -47.939987182617, 1804.0036621094),
		ang = Angle(0, 180, 90)
	},
	{
		model = "models/hunter/blocks/cube05x2x025.mdl",
		pos = Vector(-12025.399414063, 55.366954803467, 1812.4360351563),
		ang = Angle(-1, -91, 90)
	},
	{
		model = "models/hunter/blocks/cube025x05x025.mdl",
		pos = Vector(-12031.263671875, -29.374631881714, 1786.7794189453),
		ang = Angle(0, 90, 0)
	},
	{
		model = "models/hunter/blocks/cube025x05x025.mdl",
		pos = Vector(-12031.2578125, -29.72864151001, 1819.7947998047),
		ang = Angle(0, 90, 0)
	},
	{
		model = "models/hunter/blocks/cube05x2x025.mdl",
		pos = Vector(-10493.869140625, -870.31317138672, 1805.0111083984),
		ang = Angle(-1, 0, 89)
	},
	{
		model = "models/hunter/blocks/cube025x05x025.mdl",
		pos = Vector(-10404.943359375, -876.21588134766, 1776.6730957031),
		ang = Angle(-1, -180, 0)
	},
	{
		model = "models/hunter/blocks/cube025x05x025.mdl",
		pos = Vector(-10405.659179688, -876.33947753906, 1809.8189697266),
		ang = Angle(-1, -180, 0)
	},
}

function SpawnInvisibleWalls()

	for i = 1, #invis_walls do
		local tab = invis_walls[i]

		local prop = ents.Create("prop_dynamic")
		local savepos = tab.pos
		prop:SetPos(savepos)
		prop:SetAngles(tab.ang)
		prop:SetModel(tab.model)
		prop:Spawn()
		prop:SetMoveType(MOVETYPE_NONE)
		prop:SetCollisionGroup(COLLISION_GROUP_PLAYER)
		prop:PhysicsInit(SOLID_NONE)
		prop:SetSolid(SOLID_VPHYSICS)
		prop:SetNoDraw(true)

		prop.Think = function(self)
			self:SetPos(savepos)
			self:NextThink( CurTime() + 0.25 )
	    	return true
		end

	end

end

function EnableCollisionForDoors()

	for i, v in pairs(ents.FindByClass("func_door")) do
		if IsValid(v:GetChildren()[1]) then
			v:GetChildren()[1]:SetCustomCollisionCheck(true)
		end
		v:SetCustomCollisionCheck(true)
	end
end

function SpawnWW2TDMProps()
	for i = 1, #WW2_MAP_CONFIG1 do
		local data = WW2_MAP_CONFIG1[i]
		local prop = ents.Create("prop_dynamic")
		prop:SetModel(data.model)
		prop:SetSkin(data.skin)
		prop:SetBodyGroups(data.bodygroups)
		--prop:SetCollisionGroup(COLLISION_GROUP_)
		prop:SetMoveType( MOVETYPE_NONE )
		prop:SetSolid( SOLID_VPHYSICS )
		prop:SetPos(data.pos)
		prop:SetAngles(data.ang)
		prop:Spawn()
		if !data.shouldcollide then
			prop:SetCollisionGroup(20)
		end
		local physobj = prop:GetPhysicsObject()
		if IsValid(physobj) then
			physobj:EnableMotion(false)
		end
	end
end

local MVPData = {
	
	scpkill = "l:mvp_scpkill",
	
	headshot = "l:mvp_headshot",
	
	kill = "l:mvp_kill",
	
	heal = "l:mvp_heal",
	
	damage = "l:mvp_damage",

}

function MakeMVPMenu(type)

	if !MVPStats or !MVPStats[type] then return end

	local data = {
		title = MVPData[type],
		plys = {}
	}

	local foundplys = {}

	for id, val in pairs(MVPStats[type]) do

		local ply = player.GetBySteamID64(id)

		if !ply then continue end

		foundplys[#foundplys + 1] = {
			name = ply:Name(),
			id = id,
			value = val
		}

	end

	table.SortByMember(foundplys, "value")

	for i = 1, math.min(9, #foundplys) do

		data.plys[#data.plys + 1] = foundplys[i]

	end

	net.Start("MVPMenu")
	net.WriteTable(data)
	net.Broadcast()

end

function makeMVPScore()
	local a = 0
	for i, _ in pairs(MVPStats) do
	
		timer.Simple(a, function()

			MakeMVPMenu(i)

		end)

		a = a + 5
	end
end

function Spawn294()
	local scp = ents.Create("ent_scp_294")

   scp:SetAngles(Angle(0,90,0))
   scp:SetPos(Vector(150.771698, 3100.336182, -127.500443))

   scp:Spawn()
end

local notalwaysspawnlist = {
	["battery_1"] = true,
	["battery_2"] = true,
	["battery_3"] = true,
}

function SpawnTrashbins()
	for i = 1, #SPAWN_TRASHBINS do
		local data = SPAWN_TRASHBINS[i]

		local trashbin = ents.Create("prop_physics")
		trashbin:SetModel("models/props_beneric/trashbin002.mdl")
		trashbin:SetPos(data.pos)
		trashbin:SetAngles(data.ang)
		trashbin:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
		trashbin:Spawn()
		trashbin:SetModelScale(1.5)
		trashbin:SetNoDraw(true)
		local phy = trashbin:GetPhysicsObject()
		if IsValid(phy) then
			phy:EnableMotion(false)
		end
	end
end


function SpawnAllItems()

	local bigr = IsBigRound()

	local card = ents.Create("prop_physics")
	card:SetModel("models/cultist/items/keycards/w_keycard.mdl")
	card:SetPos(Vector(559.33215332031, -4835.857421875, -1243.48046875))
	card:SetSkin(5)
	card:SetAngles(Angle(0,180,0))
	card:Spawn()

	local zones = {
		"LZ",
		"EZ",
		"HZ"
	}

	for k,v in pairs(ents.GetAll()) do
	if v:GetClass() == "func_tracktrain" then
	v:Fire("StartBackward")
	end
	end


	
	local keys_zone = table.remove(zones, math.random(1, #zones))
	local rph_zone = table.remove(zones, math.random(1, #zones))
	local hand_zone = table.remove(zones, math.random(1, #zones))

	local spawns = table.Copy(SPAWN_SCP_OBJECT.spawns)
	local scps = table.Copy(SPAWN_SCP_OBJECT.ents)
	for i = 1, 6 do
		local spawn = table.remove(spawns, math.random(1, #spawns))
		local ent = table.remove(scps, math.random(1, #scps))
		timer.Simple(2, function()
			if spawn == Vector(6475.3569335938, -2541.8127441406, 50.763862609863) then
				for k,v in pairs(ents.FindInSphere(Vector(6194.274902, -2297.712402, 69),50)) do
					if v:GetClass() == "sign" then
						v:SetItem(ent)
					end
				end
			elseif spawn == Vector(6142.2651367188, -1815.2622070313, 50.763851165771) then
				for k,v in pairs(ents.FindInSphere(Vector(6246.306641, -1925.583618, 62),50)) do
					if v:GetClass() == "sign" then
						v:SetItem(ent)
					end
				end
			elseif spawn == Vector(6489.2797851563, -2710.7658691406, 50.763847351074) then
				for k,v in pairs(ents.FindInSphere(Vector(6738.619629, -2301.550781, 62),50)) do
					if v:GetClass() == "sign" then
						v:SetItem(ent)
					end
				end
			elseif spawn == Vector(7350.529296875, -2010.3621826172, 50.763854980469) then
				for k,v in pairs(ents.FindInSphere(Vector(7022.131348, -2115.055908, 63),50)) do
					if v:GetClass() == "sign" then
						v:SetItem(ent)
					end
				end
			elseif spawn == Vector(7552.7827148438, -3904.9526367188, 50.763854980469) then
				for k,v in pairs(ents.FindInSphere(Vector(7683.205078, -3986.401367, 61),50)) do
					if v:GetClass() == "sign" then
						v:SetItem(ent)
					end
				end
			elseif spawn == Vector(7913.0185546875, -4223.4760742188, 50.763847351074) then
				for k,v in pairs(ents.FindInSphere(Vector(7806.870117, -4140.489746, 60),50)) do
					if v:GetClass() == "sign" then
						v:SetItem(ent)
					end
				end
			end
		end)
		local scp = ents.Create(ent)
		scp:SetPos(spawn)
		scp:Spawn()
	end

	if IsBigRound() then
		if math.random(1,100) <= 70 then
			local pestol = ents.Create("scp_035_real")
			pestol:SetPos(Vector(5207.953613, -1054.333374, 0.031250))
			pestol:Spawn()
		end
	end

	local intercom = ents.Create("object_intercom")
	intercom:SetPos(Vector(-2610.555664, 2270.446777, 320.494934))
	intercom:Spawn()

	local jeep_1 = ents.Create("prop_vehicle_jeep")
	jeep_1:SetModel("models/scpcars/scpp_wrangler_fnf.mdl")
	jeep_1:SetKeyValue("vehiclescript", "scripts/vehicles/wrangler88.txt")
	jeep_1:SetPos(Vector(6394.605957, 192.664612, 1537))  
	jeep_1:SetAngles(Angle(0, 180, 0))
	jeep_1:Spawn()

	--local jeep_2 = ents.Create("prop_vehicle_jeep")
	--jeep_2:SetModel("models/scpcars/scpp_wrangler_fnf.mdl")
	--jeep_2:SetKeyValue("vehiclescript", "scripts/vehicles/wrangler88.txt")
	--jeep_2:SetPos(Vector(-8781.9541015625, -10678.091796875, 6211.03125))  
	--jeep_2:SetAngles(Angle(0, 180, 0))
	--jeep_2:Spawn()
	SpawnTrashbins()
	local gauss = ents.Create("weapon_special_gaus")
	gauss:SetPos( SPAWN_GAUSS )
	gauss:Spawn()
	SpawnSign()

	for _, v in pairs(SPAWN_TESLA) do
		local tesla = ents.Create( "test_entity_tesla" )
		if IsValid( tesla ) then
			tesla:Spawn()
			tesla:SetPos( v )
			if v == Vector(4157.9526367188, -932.20758056641, 129.061511993408) then
				tesla:SetAngles( Angle(0, 90, 0))
			elseif v == Vector(6282.9453125, 1177.1953125, 129.061498641968) then
				tesla:SetAngles( Angle(0, 90, 0))
			elseif v == Vector(3522.5834960938, 4021.2414550781, 129.061498641968) then
				tesla:SetAngles( Angle(0, 90, 0))
			elseif v == Vector(8168.5478515625, 336.69119262695, 129.061496734619) then
				tesla:SetAngles( Angle(0, 90, 0))
			elseif v == Vector(4158.148926, 1878.148560, 129.361298) then
				tesla:SetAngles( Angle(0, 90, 0))
			end
		end
	end

	for i = 1, #ENTITY_SPAWN_LIST_SHAKY do
		local tab = ENTITY_SPAWN_LIST_SHAKY[i]
		local spawns = tab.Spawns
		for i = 1, #spawns do
			local spawn = spawns[i]
			local pos = spawn.pos || spawn
			local ang = spawn.ang || Angle(0,0,0)
			--MsgC(Color(255,0,0), "[Legacy Breach]", color_white, " Spawning "..tab.Class.." on coordinate: "..tostring(pos.x)..", "..tostring(pos.y)..", "..tostring(pos.z)..".")
			local ent = ents.Create(tab.Class)
			ent:SetPos(pos)
			ent:Spawn()
			ent:SetPos(pos)
			ent:SetAngles(ang)
		end
	end

	local goc_copy = table.Copy(SPAWN_GOC_UNIFORMS)

	timer.Simple(2, function()
		for i = 1, 2 do
			local ent = ents.Create("armor_goc")
			ent:SetPos(table.remove(goc_copy, math.random(1, #goc_copy)))
			ent:Spawn()
		end

		for k,v in pairs(ents.GetAll()) do
		if v:GetClass() == "func_tracktrain" then
		v:Fire("StartBackward")
		end
		end
	end)

	
	local gen_spawncopy = table.Copy(SPAWN_GENERATORS)
	for i = 1, 5 do
		local generator = ents.Create("ent_generator")
		local spawntable = table.remove(gen_spawncopy, math.random(1, #gen_spawncopy))
		generator:SetPos(spawntable.Pos)
		generator:SetAngles(spawntable.Ang)
		generator:Spawn()
	end

	local obr_call = ents.Create("obr_call")
	obr_call:Spawn()

	local tree = ents.Create("scptree")
	tree:Spawn()

	local goc_nuke = ents.Create("entity_goc_nuke")
	goc_nuke:SetPos(Vector(-707.59704589844, -6296.330078125, -2345.68359375))
	goc_nuke:SetAngles(Angle(-34.56298828125, 1.0986328125, 89.258422851563))
	goc_nuke:Spawn()

	local scp914 = ents.Create("entity_scp_914")
	scp914:Spawn()

	Spawn294()
	--SpawnHprops()
	--SpawnNYprops()
	--SpawnNYEGifts()
	SpawnNYESnow()

	for spawnid = 1, #BREACH.LootSpawn do
		local used = {}
		local currentspawns = BREACH.LootSpawn[spawnid]

		local cusp = currentspawns

		local currentamount = #currentspawns.spawns

		if bigr then
			local val1, val2 = currentspawns.bigroundamount[2], currentspawns.bigroundamount[1]
			currentamount = math.floor(currentamount*math.Rand(math.min(val1, val2), math.max(val1, val2)))
		else
			local val1, val2 = currentspawns.smallroundamount[2], currentspawns.smallroundamount[1]
			currentamount = math.floor(currentamount*math.Rand(math.min(val1, val2), math.max(val1, val2)))
		end

		local spawnslist = table.Copy(currentspawns.spawns)

		local lootlist = cusp.lootrules

		for i = 1, currentamount do

			local currentitem

			if cusp.shouldalwaysspawn and i <= #cusp.shouldalwaysspawn then
				currentitem = cusp.shouldalwaysspawn[i]
			else
				local repetition = 0
			    ::repeatitempick::
			    repetition = repetition + 1

			    if repetition >= 100 then print("TOO MANY REPETITIONS, STOP SPAWNNAME:"..cusp.spawnname) break end -- to fix errors
			        
				local item = lootlist[math.random(1, #lootlist)]

				if istable(item) then
					if !bigr and item.bigroundonly then
						goto repeatitempick
					end
			        if item.chance then
						local rand = math.random(1, 100)
						if rand > item.chance then
							goto repeatitempick
						end
					end
					if item.amount then
						if used[item[1]] and used[item[1]] >= item.amount then
							goto repeatitempick
						else
							if !used[item[1]] then
								used[item[1]] = 1
							else
								used[item[1]] = used[item[1]] + 1
							end
						end
					end
					currentitem = item[1]
				else
					currentitem = item
				end

			end

			if i == 1 and cusp.zone == keys_zone then
				currentitem = "item_keys"
			end
			if i == 1 and cusp.zone == rph_zone then
				currentitem = "item_chaos_radio"
			end
			if i == 1 and cusp.zone == hand_zone then
				currentitem = "hand_key"
			end

			if notalwaysspawnlist[currentitem] and math.random(1,100) <= 50 then continue end

			if currentitem != "nil" then

				local spawnpoint = table.remove(spawnslist, math.random(1, #spawnslist))
				local ang = angle_zero

				if istable(spawnpoint) then
					ang = spawnpoint[2]
					spawnpoint = spawnpoint[1]
				end

				if cusp.addz and !string.StartWith(currentitem, "armor_") then spawnpoint = spawnpoint + Vector(0,0, cusp.addz) end
				if (currentitem == "armor_sci" or currentitem == "armor_mtf" or currentitem == "armor_medic" or string.find(currentitem,"armor_hazmat_") or string.find(currentitem,"armor_lighthazmat_")) and cusp.spawnname != "ТЗ TIER2" and cusp.spawnname != "ТЗ TIER3" and cusp.spawnname != "ПОДВАЛ ЛУТ" then spawnpoint = spawnpoint + Vector(0,0, -10) end
				--print(currentitem)
				local item = ents.Create(currentitem)
				item:SetPos(spawnpoint)
				item:SetAngles(ang)
				item:Spawn()
				for k,v in pairs(ents.FindInBox(Vector(8387.529297, -4204.760254, 2), Vector(8081.915527, -4432.423828, 127))) do
					if v == item and currentspawns.spawnname == "ЛЗ TIER1" then
						--print(currentspawns.spawnname, spawnpoint)
						item:Remove()
					end
				end
				for k,v in pairs(ents.FindInBox(Vector(1690.014038, 1903.257324, -23), Vector(1121.992432, 2494.568848, 302))) do
					if v == item then
						--print(currentspawns.spawnname, spawnpoint)
						item:Remove()
					end
				end

			end

		end

	end


end

function OnlyAliveRoles(tab)

	local tab2 = {
		dz_alive = false,
		goc_alive = false,
		sci_alive = false,
		mtf_alive = false,
		sec_alive = false,
		ci_alive = false,
		classd_alive = false,
		scp_alive = false,
		ett_alive = false,
		faf_alive = false,
		fbi_alive = false,
	}
	local ret = true
	for _, ply in ipairs(player.GetAll()) do
		local gteam = ply:GTeam()
		if ply:Health() <= 0 then continue end
		if !ply:Alive() then continue end
		if gteam == TEAM_GUARD or gteam == TEAM_NTF or gteam == TEAM_QRT then tab2.mtf_alive = true
		elseif gteam == TEAM_DZ and ply:GetRoleName() != "SH Spy" then tab2.dz_alive = true
		elseif gteam == TEAM_SECURITY or ply:GTeam() == "CI Spy" then tab2.sec_alive = true
		elseif gteam == TEAM_SCP then tab2.scp_alive = true
		elseif gteam == TEAM_ETT then tab2.ett_alive = true
		elseif gteam == TEAM_FAF then tab2.faf_alive = true
		elseif gteam == TEAM_FBI then tab2.fbi_alive = true
		elseif gteam == TEAM_CLASSD or ply:GetRoleName() == "GOC Spy" then tab2.classd_alive = true
		elseif gteam == TEAM_CHAOS then tab2.ci_alive = true
		elseif gteam == TEAM_SCI or gteam == TEAM_SPECIAL or ply:GetRoleName() == "SH Spy" then tab2.sci_alive = true
		end
	end

	for name, val in pairs(tab2) do
		if !table.HasValue(tab, name) and val == true then ret = false break end
	end

	return ret

end

timer.Create("EndRound_Timer", 1, 0, function()
	if preparing then return end
	if postround then return end
	if !gamestarted then return end
	if GetGlobalBool("Evacuation", false) then return end

	local alive = false
	local res = false

	local plys = player.GetAll()

	for i = 1, #plys do

		local ply = plys[i]

		if ply:GTeam() != TEAM_SPEC then
			alive = true
		end

	end

	if !alive then
		net.Start("New_SHAKYROUNDSTAT")	
			net.WriteString("l:roundend_nopeoplealive")
			net.WriteFloat(27)
		net.Broadcast()
		res = true
	end
	if activeRound and activeRound.name == "WW2 TDM" and !res then
		local nazi = gteams.NumPlayers(TEAM_NAZI)
		local usa = gteams.NumPlayers(TEAM_AMERICA)

		if usa <= 0 then
			activeRound.postround()
			res = true
		elseif nazi <= 0 then
			activeRound.postround()
			res = true
		end
	end
	if res then
		timer.Remove("NTFEnterTime")
		timer.Remove("NTFEnterTime2")
		timer.Remove("NTFEnterTime3")
		timer.Remove("Evacuation")
		timer.Remove("EvacuationWarhead")
		postround = true
		timer.Simple(27, function()
			RoundRestart()
		end)
	end
end)

function SetBloodyTexture(ent)

	local sModelPath = ent:GetModel()
	local sTest =	string.Explode( "", sModelPath )
	local stringpath = ""
	local countslash = 0

	for _, v in ipairs( sTest ) do

		if ( v == "/" ) then

			countslash = countslash + 1

		end

		if ( countslash == 3 ) then

			stringpath = stringpath .. v

		elseif ( countslash == 4 ) then

			if ( !string.EndsWith( stringpath, "/" ) ) then

				stringpath = stringpath .. "/"

			end

		end

	end

	for k, v in ipairs( ent:GetMaterials() ) do

		local sNewmaterial;
		if ( !string.find( v, "/heads/" ) && !string.find( v, "/shared/" ) ) then

			sNewmaterial = string.Replace( v, stringpath, "/zombies" .. stringpath )

		end


		ent:SetSubMaterial( k - 1, sNewmaterial )

	end

end

function SetZombie1( ent )
	if ent:IsPlayer() then
		if ent:GTeam() != TEAM_SPEC or ent:GTeam() != TEAM_SCP then

			local sModelPath = ent:GetModel()
			local sTest =	string.Explode( "", sModelPath )
			local stringpath = ""
			local countslash = 0
		
			for _, v in ipairs( sTest ) do
		
				if ( v == "/" ) then
		
					countslash = countslash + 1
		
				end
		
				if ( countslash == 3 ) then
		
					stringpath = stringpath .. v
		
				elseif ( countslash == 4 ) then
		
					if ( !string.EndsWith( stringpath, "/" ) ) then
		
						stringpath = stringpath .. "/"
		
					end
		
				end
		
			end
		
			for k, v in ipairs( ent:GetMaterials() ) do
		
				local sNewmaterial;
				if ( !string.find( v, "/heads/" ) && !string.find( v, "/shared/" ) ) then
		
					sNewmaterial = string.Replace( v, stringpath, "/zombies" .. stringpath )
		
				end
		
		
				ent:SetSubMaterial( k - 1, sNewmaterial )
		
			end
	

			ent.JustSpawned = true
			timer.Simple( .1, function()
			    ent.JustSpawned = false
			end)
			ent:StripWeapons()
			ent:SetGTeam(TEAM_SCP)
			ent:SetHealth( ent:GetMaxHealth() * 2 )
			ent:SetMaxHealth( ent:GetMaxHealth() * 2 )
			ent:Give( "weapon_scp_049_2_1" )
			ent:SelectWeapon( "weapon_scp_049_2_1" )
			ent:SetArmor( 0 )

			ent:Flashlight( false )
			ent:AllowFlashlight( false )

		end
	end
end
--concommand.Add("just", SetZombie1)

function SetZombie2( ent )
	if ent:IsPlayer() then
		if ent:GTeam() != TEAM_SPEC or ent:GTeam() != TEAM_SCP then
			if ( ent.BoneMergedHead ) then

				for _, v in pairs( ent.BoneMergedHead ) do
		
					if ( v && v:IsValid() ) then

				
						v:SetMaterial("models/cultist/heads/zombie_face")

					end
				end
			end
			ent.JustSpawned = true
			timer.Simple( 1, function()
			    ent.JustSpawned = false
			end)
			ent:StripWeapons()
			ent:SetGTeam(TEAM_SCP)
			ent:SetHealth( ent:GetMaxHealth() * 15 )
			ent:SetMaxHealth( ent:GetMaxHealth() * 15 )
			ent:SetWalkSpeed( ent:GetWalkSpeed() / 2 )
			ent:SetRunSpeed( ent:GetRunSpeed() / 2.5 )
			ent:Give( "weapon_scp_049_2_2" )
			ent:SelectWeapon( "weapon_scp_049_2_2" )
			ent:SetArmor( 100 )

			ent:Flashlight( false )
			ent:AllowFlashlight( false )
			ent:Freeze( true )
			ent:DoAnimationEvent(ACT_GET_UP_STAND)
			timer.Simple( 3, function()
			    ent:Freeze( false )
			end)
		end
	end
end
--concommand.Add("just_2", SetZombie2)

BREACH = BREACH || {}

BREACH.Gas = BREACH.Gas || false

LZ_DOORS = {
	Vector( 6816.000000, -1504.410034, 56.799999 ),
	Vector( 6944.000000, -1503.319946, 56.799999 ),
	Vector( 7435.200195, -1040.810059, 56.799999 ),
	Vector( 8096.000000, -1503.410034, 56.799999 ),
	Vector( 8224.000000, -1503.459961, 56.799999 ),
	Vector( 4672.410156, -2288.000000, 55.500000 ),
	Vector( 4671.319824, -2160.000000, 55.500000 ),
	Vector( 9569.030273, -533.419983, 56.799999 ),
	Vector( 9697.030273, -532.320007, 56.799999 ) -- 9
}

LZ_SOUNDEF = {
	soundef = {
		amount = 5,
		spawns = {
			Vector( 4828.812988, -2220.947021, 64.031250 ),
			Vector( 6885.969238, -1675.001587, 65.331055 ),
			Vector( 7444.067383, -1140.520264, 65.331055 ),
			Vector( 8160.740723, -1668.191162, 65.331055 ),
			Vector( 9632.721680, -687.500488, 65.331055 ),
		},
	}
}

function GasEnabled( enabled )

	BREACH.Gas = enabled

end

function GetGasEnabled()

	return BREACH.Gas

end

function LZCPIdleSound()
	LZCPIdleSound1()
	LZCPIdleSound2()
	LZCPIdleSound3()
	LZCPIdleSound4()
	LZCPIdleSound5()
end

function LZCPIdleSound1()

	local sound_ef = ents.Create( "br_gift" )
	if IsValid( sound_ef ) then
		sound_ef:Spawn()
		sound_ef:SetPos( Vector( 9632.721680, -687.500488, 65.331055 ) )
	end
	timer.Simple( 30, function()
		sound_ef:Remove()
	end)
end

function LZCPIdleSound2()

	local sound_ef = ents.Create( "br_gift" )
	if IsValid( sound_ef ) then
		sound_ef:Spawn()
		sound_ef:SetPos( Vector( 8160.740723, -1668.191162, 65.331055 ) )
	end
	timer.Simple( 30, function()
		sound_ef:Remove()
	end)
end

function LZCPIdleSound3()

	local sound_ef = ents.Create( "br_gift" )
	if IsValid( sound_ef ) then
		sound_ef:Spawn()
		sound_ef:SetPos( Vector( 7444.067383, -1140.520264, 65.331055 ) )
	end
	timer.Simple( 30, function()
		sound_ef:Remove()
	end)
end

function LZCPIdleSound4()

	local sound_ef = ents.Create( "br_gift" )
	if IsValid( sound_ef ) then
		sound_ef:Spawn()
		sound_ef:SetPos( Vector( 6885.969238, -1675.001587, 65.331055 ) )
	end
	timer.Simple( 30, function()
		sound_ef:Remove()
	end)
end

function LZCPIdleSound5()

	local sound_ef = ents.Create( "br_gift" )
	if IsValid( sound_ef ) then
		sound_ef:Spawn()
		sound_ef:SetPos( Vector( 4828.812988, -2220.947021, 64.031250 ) )
	end
	timer.Simple( 30, function()
		sound_ef:Remove()
	end)
end

function EvacuationEnd()

	SetGlobalBool("Evacuation", false)

	timer.Destroy("Evacuation")

end
--concommand.Add("EvacuationEnd", EvacuationEnd)

function EvacuationWarheadEnd()

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

	Additionaltime = 0


	for k, v in pairs( ents.FindByClass("base_gmodentity") ) do

	    v:Remove()
	end

end

function SetClothOnPlayer(ply, type)
	local self = scripted_ents.Get(type)

	ply:EmitSound( Sound("nextoren/others/cloth_pickup.wav") )

				if ply.BoneMergedHackerHat then

					for _, v in pairs( ply.BoneMergedHackerHat ) do
			
						if ( v && v:IsValid() ) then
							
							v:SetInvisible(true)
			
						end

					end

				end

				if ( self.HideBoneMerge ) then
			
					for _, v in pairs( ply:LookupBonemerges() ) do
			
						if ( v && v:IsValid() && !v:GetModel():find("backpack") ) then
							
							v:SetInvisible(true)
			
						end

					end
			
				end
				if type == "armor_medic" or type == "armor_mtf" then
					for _, v in pairs( ply:LookupBonemerges() ) do
			
						if ( v:GetModel():find("hair") and !ply:IsFemale() ) then
					
							v:SetInvisible(true)
			
						end
			
					end
				end
				ply.OldModel = ply:GetModel()
				ply.OldSkin = ply:GetSkin()
				if ( self.Bodygroups ) then
			
					ply.OldBodygroups = ply:GetBodyGroupsString()
			
					ply:ClearBodyGroups()

					ply.ModelBodygroups = self.Bodygroups
			
					if ( self.Bonemerge ) then
			
						for _, v in ipairs( self.Bonemerge ) do
			
							GhostBoneMerge( ply, v )
			
						end
			
					end
			
				end
				if self.MultiGender then
					if ply:IsFemale() then
						ply:SetModel(self.ArmorModelFem)
					else
						ply:SetModel(self.ArmorModel)
					end
				else
					ply:SetModel(self.ArmorModel)
				end
				if ( self.ArmorSkin ) then
					ply:SetSkin(self.ArmorSkin)
				end

				hook.Run("BreachLog_PickUpArmor", ply, type)
				if isfunction(self.FuncOnPickup) then self.FuncOnPickup(ply) end
			
				ply:BrTip( 0, "[Legacy Breach]", Color( 0, 210, 0, 180 ), "l:your_uniform_is "..L(self.PrintName), Color( 0, 255, 0, 180 ) )
				ply:SetupHands()
				if self.ArmorSkin then
					ply:GetHands():SetSkin(self.ArmorSkin)
				end

				timer.Simple( .25, function()
			
						for bodygroupid, bodygroupvalue in pairs( ply.ModelBodygroups ) do
							
							if !istable(bodygroupvalue) then
								ply:SetBodygroup( bodygroupid, bodygroupvalue )
							end
			
						end
			
					end )
end

concommand.Add("br_wearcloth", function(ply, str, _, type)

	if !ply:IsSuperAdmin() then return end

	SetClothOnPlayer(ply, type)

end)

concommand.Add("br_wearcloth_target", function(ply, str, _, type)

	if !ply:IsSuperAdmin() then return end

	SetClothOnPlayer(ply:GetEyeTrace().Entity, type)

end)

--concommand.Add("EvacuationWarheadEnd", EvacuationWarheadEnd)
--timer.Simple(2, function()
--for k, v in pairs(player.GetAll()) do
----v:SendLua('surface.PlaySound("rxsend_music/nukes/evacuation_"..math.random(1,6)..".ogg")')
----	--v:SendLua('BREACH.Music:Play( 33 )')
----	
--	--v:PlayMusic(BR_MUSIC_EVACUATION)
--	BroadcastPlayMusic(BR_MUSIC_EVACUATION)
----BroadcastPlayMusic(33)
--end
--end)

function Evacuation()

	SetGlobalBool("Evacuation", true)

	BREACH.Players:ChatPrint(player.GetHumans(), true, true, "l:evac_start_leave_immediately")

	PlayAnnouncer( "nextoren/round_sounds/intercom/start_evac.ogg" )

	SHAKY_MUSIC_STARTTIME = SysTime()

	--for k, v in pairs(player.GetAll()) do
	--v:SendLua('surface.PlaySound("rxsend_music/nukes/evacuation_"..math.random(1,6)..".ogg")')
	--end
    local istta = false
    local tta64id = "76561199389358627"

    for _, ply in ipairs(player.GetAll()) do
        if ply:SteamID64() == tta64id then
            istta = true
            break
        end
    end

    if istta then
        BroadcastPlayMusic(BR_MUSIC_EVACUATION_TTA)
    else
        BroadcastPlayMusic(BR_MUSIC_EVACUATION)
    end
	--BroadcastPlayMusic(BR_MUSIC_SPAWN_NEE)

	--BroadcastLua("BREACH.Evacuation=true PickupActionSong()BREACH.Evacuation=false")

end
--concommand.Add("Evacuation", Evacuation)

--local gru_heli = nil 
--for k,v in pairs(ents.GetAll()) do
--	if v:GetClass() == "gru_heli" then
--		gru_heli = v
--	end
--end
--gru_heli:Escape()
--[[function EvacuationWarhead()

	PlayAnnouncer("nextoren/round_sounds/main_decont/final_nuke.mp3")

	for i, v in pairs(player.GetHumans()) do v:BrTip(0, "[Legacy Breach]", Color(255,0,0,200), "l:evac_start", color_white) end

	local portal = ents.Create("portal")
	portal:Spawn()
	local heli = ents.Create("heli")
	heli:Spawn()

	local gru_heli = nil 
	for k,v in pairs(ents.GetAll()) do
		if v:GetClass() == "gru_heli" then
			gru_heli = v
		end
	end

	timer.Create("PerformEscapeAnim_GRU", 120, 1, function()
		timer.Simple(0.2, function() gru_heli:Escape() end)
	end)

	local apc = ents.Create("apc")
	apc:Spawn()
	timer.Simple(120, function()
		EscapeEnabled_Portal = false
		portal:Remove()
	end)

	for _, ply in ipairs(player.GetAll()) do

		if ply:GTeam() != TEAM_SPEC then

	        --ply:Tip( "[NO Breach]", Color(255, 0, 0), "Запущена Альфа-Боеголовка! Через 2 минуты 20 секунд, будет сдетонирована боеголовка.", Color(255, 255, 255) )

		end

	end

	SetGlobalBool("Evacuation_HUD", true)

	timer.Create("PerformEscapeAnim_APC", 110, 1, function()
		if IsValid(apc) then
			timer.Simple(3.2, function() apc:Escape() end)
			local classdrescueamount = 0
			local Str = "Evacuated through the APC."
			for _, ply in pairs(ents.FindInBox( Vector(6620.064941, 14.724398, 1396), Vector(6997.926758, 526.104614, 1602) )) do
				if IsValid(ply) and ply:IsPlayer() and GRU_Objective == "Срыв эвакуации" and ply:GTeam() == TEAM_GRU then
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
				if IsValid(ply) and ply:IsPlayer() and ( ply:GTeam() == TEAM_CHAOS or ply:GTeam() == TEAM_CLASSD or ply:GetRoleName() == SCP999 ) then
					if !ply:Alive() or ply:Health() <= 0 then continue end
					if ply:GTeam() == TEAM_CLASSD then
						for _, chaos in pairs(player.GetAll()) do
							if chaos:GTeam() == TEAM_CHAOS then chaos:AddToStatistics("l:ci_classd_evac", 100) end
						end
						ply:AddToStatistics("l:escaped", 500)
						if ply:HasWeapon("item_cheemer") then
							ply:AddToStatistics("l:cheemer_rescue", 1000)
						end
						classdrescueamount = classdrescueamount + 1
						if classdrescueamount == 1 then
							Str = "l:ending_ci_evac_apc_pt1 "..classdrescueamount.." l:ending_ci_evac_apc_pt2"
						else
							Str = "l:ending_ci_evac_apc_pt1 "..classdrescueamount.." l:ending_ci_evac_apc_pt2_many"
						end
						net.Start("Ending_HUD")
							net.WriteString("l:ending_evac_apc")
						net.Send(ply)
						ply:CompleteAchievement("escape")
						ply:CompleteAchievement("apcescape")
						ply:LevelBar()
						ply:SetupNormal()
						ply:SetSpectator()
					elseif ply:GetRoleName() == SCP999 then
						for _, chaos in pairs(player.GetAll()) do
							if chaos:GTeam() == TEAM_CHAOS then chaos:AddToStatistics("l:ci_scp_evac", 400) end
						end
						ply:AddToStatistics("l:escaped", 350)
						if ply:HasWeapon("item_cheemer") then
							ply:AddToStatistics("l:cheemer_rescue", 1000)
						end
						net.Start("Ending_HUD")
							net.WriteString("l:ending_evac_apc")
						net.Send(ply)
						ply:CompleteAchievement("escape")
						ply:CompleteAchievement("apcescape")
						ply:LevelBar()
						ply:SetupNormal()
						ply:SetSpectator()
					elseif ply:GTeam() == TEAM_CHAOS then
						timer.Simple(0.1, function()
							ply:AddToStatistics("l:escaped", 500)
							if ply:HasWeapon("item_cheemer") then
								ply:AddToStatistics("l:cheemer_rescue", 1000)
							end
							net.Start("Ending_HUD")
								net.WriteString(Str)
							net.Send(ply)
							ply:CompleteAchievement("escape")
							ply:CompleteAchievement("apcescape")
							ply:LevelBar()
							ply:SetupNormal()
							ply:SetSpectator()
						end)
					end
				end
			end
		end
	end)

	local guardteams = {
		[TEAM_GUARD] = true,
		[TEAM_NTF] = true,
		[TEAM_ALPHA1] = true,
		[TEAM_SECURITY] = true,
		[TEAM_QRT] = true,
		[TEAM_OSN] = true,
		[TEAM_GOC] = true,
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

	timer.Create("PerformEscapeAnim_HELI", 100, 1, function()
		if IsValid(heli) then
			heli:EmitSound("nextoren/vo/chopper/chopper_evacuate_end.wav", 110, 100, 1.2, CHAN_VOICE, 0, 0)
			heli:Escape()
			--goose_plz_fuck_off_heli()
			for _, ply in pairs(ents.FindInBox( Vector(1175.879028, -1553.839233, 2365), Vector(561.029358, -2199.641602, 2805) )) do
				if IsValid(ply) and ply:IsPlayer() and GRU_Objective != "Срыв эвакуации" and ply:GTeam() == TEAM_GRU then
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
				if IsValid(ply) and ply:IsPlayer() and ( ply:GetRoleName() == SCP999 or guardteams[ply:GTeam()] or sciteams[ply:GTeam()] or ply:GetModel():find("/sci/") or ply:GetRoleName() == "Class-D Stealthy" ) then
					if !ply:Alive() or ply:Health() <= 0 then continue end
					if ( sciteams[ply:GTeam()] or ply:GetModel():find("/sci/") or ply:GetModel():find("/mog/") ) and !guardteams[ply:GTeam()] and ply:GetRoleName() != role.Dispatcher and ply:GTeam() != TEAM_GOC then
						for _, guard in pairs(player.GetAll()) do
							if guardteams[guard:GTeam()] and ply:GTeam() == TEAM_SPECIAL then guard:AddToStatistics("l:vip_evac", 200) end
							if guardteams[guard:GTeam()] and ply:GTeam() == TEAM_SCI then 
								guard:AddToStatistics("l:sci_evac", 100)
								SetGlobalInt("TASKS_TG_1", GetGlobalInt("TASKS_TG_1") + 1)
								if GetGlobalInt("TASKS_TG_1") == GetGlobalInt("TASKS_TG_1_min") then
									---for k,v in pairs(player.GetAll()) do
									--	if v:GTeam() == TEAM_GUARD then
											guard:AddToStatistics("Выполение задачи", 1000) 
									--	end
									--end
								end
							end
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
						ply:AddToStatistics("l:escaped", 350)
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
				end
			end
		end
	end)

	timer.Create("BigBoomEffect", 130, 1, function()
		AlphaWarheadBoomEffect()
		BroadcastLua("StopMusic()")
	end)

	timer.Create("BigBoom", 135, 1, function()
		for _, ply in ipairs(player.GetAll()) do

			if ply:GTeam() != TEAM_SPEC and ply:Health() > 0 and ply:Alive() then

				ply:Kill()

			end

		end
	end)

end]]

function EvacuationWarhead()

	PlayAnnouncer("nextoren/round_sounds/main_decont/final_nuke.mp3")

	timer.Simple(7, function()
		PlayAnnouncer("nextoren/AlphaWloop.ogg")
	end)

	for i, v in pairs(player.GetHumans()) do v:BrTip(0, "[RXSEND]", Color(255,0,0,200), "l:evac_start", color_white) end

	local portal = ents.Create("portal")
	portal:Spawn()
	local heli = ents.Create("heli")
	heli:Spawn()
	timer.Simple(120, function()
		EscapeEnabled_Portal = false
		portal:Remove()
	end)

	for _, ply in ipairs(player.GetAll()) do

		if ply:GTeam() != TEAM_SPEC then

	        ply:Tip( "[NO Breach]", Color(255, 0, 0), "Запущена Альфа-Боеголовка! Через 2 минуты 20 секунд, будет сдетонирована боеголовка.", Color(255, 255, 255) )

		end

	end

	timer.Create("BigBoomEffect", 130, 1, function()
		AlphaWarheadBoomEffect()
		BroadcastLua("StopMusic()")
	end)

	timer.Create("BigBoom", 135, 1, function()
		for _, ply in ipairs(player.GetAll()) do

			if ply:GTeam() != TEAM_SPEC and ply:Health() > 0 and ply:Alive() then

				ply:Kill()

			end

		end
	end)

	local apc = ents.Create("apc")
	apc:Spawn()
	SetGlobalBool("Evacuation_HUD", true)

	timer.Create("PerformEscapeAnim_APC", 110, 1, function()
		if IsValid(apc) then
			timer.Simple(0.2, function() apc:Escape() end)
			local classdrescueamount = 0
			local Str = "Evacuated through the APC."
			for _, ply in pairs(ents.FindInBox( Vector(2205.7585449219, 6494.1030273438, 1780.3236083984), Vector(2752.3601074219, 7220.3330078125, 1482.2497558594) )) do
				if IsValid(ply) and ply:IsPlayer() and ( ply:GTeam() == TEAM_CHAOS or ply:GTeam() == TEAM_CLASSD or ply:GetRoleName() == SCP999 ) then
					if !ply:Alive() or ply:Health() <= 0 then continue end
					if ply:GTeam() == TEAM_CLASSD then
						for _, chaos in pairs(player.GetAll()) do
							if chaos:GTeam() == TEAM_CHAOS then chaos:AddToStatistics("l:ci_classd_evac", 100) end
						end
						ply:AddToStatistics("l:escaped", 500)
						if ply:HasWeapon("weapon_duck") then
							ply:AddToStatistics("l:cheemer_rescue", 1000)
						end
						classdrescueamount = classdrescueamount + 1
						if classdrescueamount == 1 then
							Str = "l:ending_ci_evac_apc_pt1 "..classdrescueamount.." l:ending_ci_evac_apc_pt2"
						else
							Str = "l:ending_ci_evac_apc_pt1 "..classdrescueamount.." l:ending_ci_evac_apc_pt2_many"
						end
						net.Start("Ending_HUD")
							net.WriteString("l:ending_evac_apc")
						net.Send(ply)
						ply:CompleteAchievement("escape")
						ply:CompleteAchievement("apcescape")
						ply:LevelBar()
						ply:SetupNormal()
						ply:SetSpectator()
					elseif ply:GetRoleName() == SCP999 then
						for _, chaos in pairs(player.GetAll()) do
							if chaos:GTeam() == TEAM_CHAOS then chaos:AddToStatistics("l:ci_scp_evac", 400) end
						end
						ply:AddToStatistics("l:escaped", 350)
						if ply:HasWeapon("weapon_duck") then
							ply:AddToStatistics("l:cheemer_rescue", 1000)
						end
						net.Start("Ending_HUD")
							net.WriteString("l:ending_evac_apc")
						net.Send(ply)
						ply:CompleteAchievement("escape")
						ply:CompleteAchievement("apcescape")
						ply:LevelBar()
						ply:SetupNormal()
						ply:SetSpectator()
					elseif ply:GTeam() == TEAM_CHAOS then
						timer.Simple(0.1, function()
							ply:AddToStatistics("l:escaped", 500)
							if ply:HasWeapon("weapon_duck") then
								ply:AddToStatistics("l:cheemer_rescue", 1000)
							end
							net.Start("Ending_HUD")
								net.WriteString(Str)
							net.Send(ply)
							ply:CompleteAchievement("escape")
							ply:CompleteAchievement("apcescape")
							ply:LevelBar()
							ply:SetupNormal()
							ply:SetSpectator()
						end)
					end
				end
			end
		end
	end)

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
							ply:AddToStatistics("撤离", 200)
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

end

function AlphaWarheadBoomEffect()
	BroadcastLua( 'surface.PlaySound( "nextoren/ending/nuke.mp3" )' )
	net.Start("Boom_Effectus")
	net.Broadcast()
end
--concommand.Add("EvacuationWarhead", EvacuationWarhead)

function FakeAlphaWarheadBoomEffect()
	BroadcastLua( 'surface.PlaySound( "nextoren/ending/nuke.mp3" )' )
	net.Start("Fake_Boom_Effectus")
	net.Broadcast()
end
concommand.Add("bomba123", function(ply, cmd, args)
	if !ply:IsSuperAdmin() then return end

	FakeAlphaWarheadBoomEffect()
end)

function LZLockDown()

	LZCPIdleSound()

	--net.Start("ForcePlaySound")
	PlayAnnouncer("nextoren/round_sounds/lhz_decont/decont_countdown.ogg")
	--net.Broadcast()

	for k, v in pairs( LZ_DOORS ) do
		for i,g in pairs(ents.FindInSphere(v,300)) do
			if g:GetClass() == "func_door" then
				timer.Create( "DoorLZOpen"..g:EntIndex(), 9, 1, function()
					g.NoAutoClose = true
					g:Fire( "Open" )
				end )
				timer.Create( "DoorLZClose"..g:EntIndex(), 45, 1, function()
					--net.Start("ForcePlaySound")
					PlayAnnouncer("nextoren/round_sounds/lhz_decont/decont_ending.ogg")
					--net.Broadcast()
					g:Fire( "Close" )
					GasEnabled(true)
					
				end )
			end
		end
		--if v:GetPos() == LZ_DOORS[1] or v:GetPos() == LZ_DOORS[2] or v:GetPos() == LZ_DOORS[3] or v:GetPos() == LZ_DOORS[4] or v:GetPos() == LZ_DOORS[5] or v:GetPos() == LZ_DOORS[6] or v:GetPos() == LZ_DOORS[7] or v:GetPos() == LZ_DOORS[8] or v:GetPos() == LZ_DOORS[9] then

		--end
	end

end

local nextthink = 0
hook.Add("Think", "Breach_Gas_Think", function()
    if !GetGasEnabled() then return end
    if nextthink > CurTime() then return end

    nextthink = CurTime() + 1.6
    for _, ply in pairs(player.GetAll()) do
        if ply:GTeam() == TEAM_SPEC then continue end
        if ply:Health() <= 0 then continue end
        if !ply:Alive() then continue end
        if ply:GetRoleName() == "CI Soldier" then continue end
        if ply:GetRoleName() == "CI Juggernaut" then continue end
        if ply:GetRoleName() == "NTF Grunt" then continue end
        if ply:GTeam() == TEAM_DZ and ply:GetRoleName() != "SH Spy" then continue end
        if !ply:IsLZ() then continue end
        if ply:HasHazmat() and ply:GetRoleName() != role.ClassD_Banned then continue end 
        if ply.GASMASK_Equiped and ply:GetRoleName() != role.ClassD_Banned then continue end
        if ply:GetRoleName() == "SCP173" then continue end
        if ply:GetRoleName() == SCP999 then continue end
        local dmg = ply:GetMaxHealth() / 40
        if ply:GTeam() != TEAM_SCP then
            if !ply:IsFemale() then
                ply:EmitSound("^nextoren/unity/cough"..tostring(math.random(1,3))..".ogg", 75, ply.VoicePitch, 1.5, CHAN_VOICE)
            else
                ply:EmitSound("nextoren/coughf"..tostring(math.random(1,2))..".wav", 75, ply.VoicePitch, 1.5, CHAN_VOICE)
            end
            dmg = 15
        end
        local dmginfo = DamageInfo()
        dmginfo:SetAttacker(ply)
        dmginfo:SetInflictor(ply)
        dmginfo:SetDamage(dmg)
        if ply:GetRoleName() != role.ClassD_Banned then
            dmginfo:SetDamageType(DMG_NERVEGAS)
        end
        ply:TakeDamageInfo(dmginfo)
        --ply:TakeDamage(15, ply, ply)
    end
end)

--concommand.Add( "LZLockDown", LZLockDown )

function LZLockDownEnd()

	GasEnabled(false)

end

function OBRSpawn(count)
	if disableobr then return end
	if GetGlobalBool("Evacuation_HUD", false) then return end
	if !timer.Exists("Evacuation") then return end
	if timer.TimeLeft("Evacuation") <= 10 then return end

	local roles = {}
	local plys = {}
	local inuse = {}
	local spawnpos = table.Copy(SPAWN_OBR)

	local messageinter

		for k, v in pairs( BREACH_ROLES.OBR.obr.roles ) do
			if v.team == TEAM_QRT then
				table.insert( roles, v )
			end
		end

		for k, v in pairs( roles ) do
			plys[v.name] = {}
			inuse[v.name] = 0
			for _, ply in pairs( player.GetAll() ) do

				if ply:GTeam() == TEAM_SPEC and ply.ActivePlayer and ply:GetPenaltyAmount() <= 0 and ply.SpawnAsSupport != false then
					if ply:GetLevel() >= v.level and ( v.customcheck and c.customcheck( ply ) or true ) then
						ply.ArenaParticipant = false
						table.insert( plys[v.name], ply )
					end
				end

			end

			if #plys[v.name] < 1 then
				roles[k] = nil
			end
		end

		if #roles < 1 then
			return
		end

		BREACH.QueuedSupports = {}
		net.Start("SelectRole_Sync")
		net.WriteTable(BREACH.QueuedSupports)
		net.Broadcast()

		for i = 1, math.Clamp(#SPAWN_OBR, 0, count) do
			local role = table.Random( roles )
			local ply = table.remove( plys[role.name], math.random( 1, #plys[role.name] ) )
			ply:SetupNormal()
			ply:ApplyRoleStats( role )

			inuse[role.name] = inuse[role.name] + 1
			local selectedpos = spawnpos[math.random(1, #spawnpos)]
			table.RemoveByValue(spawnpos, selectedpos)
			selectedpos = Vector(selectedpos.x, selectedpos.y, GroundPos(selectedpos).z)
			ply:SetPos( selectedpos )


			if #plys[role.name] < 1 or inuse[role.name] >= role.max then
				table.RemoveByValue( roles, role )
			end

			timer.Simple(5, function()
			if ply:IsPremium() and ply.CanSwitchRole != true then
				timer.Simple(45, function()
					if IsValid(ply) then
						ply.CanSwitchRole = false
					end
			   end)
				ply.CanSwitchRole = true
				ply:SendLua("Select_Supp_Menu(LocalPlayer():GTeam())")
			end
			end)

			if #roles < 1 then
				break
			end
		end

end
--Alpha1Spawn(1)
function Alpha1Spawn(count)
	--if disableobr then return end
	if GetGlobalBool("Evacuation_HUD", false) then return end
	if !timer.Exists("Evacuation") then return end
	if timer.TimeLeft("Evacuation") <= 10 then return end

	local roles = {}
	local plys = {}
	local inuse = {}
	local spawnpos = table.Copy(ALPHA1_SPAWN)

	local messageinter

		for k, v in pairs( BREACH_ROLES.ALPHA1.alpha.roles ) do
			if v.team == TEAM_ALPHA1 then
				table.insert( roles, v )
			end
		end

		for k, v in pairs( roles ) do
			plys[v.name] = {}
			inuse[v.name] = 0
			for _, ply in pairs( player.GetAll() ) do

				if ply:GTeam() == TEAM_SPEC and ply.ActivePlayer and ply:GetPenaltyAmount() <= 0 and ply.SpawnAsSupport != false then
					if ply:GetLevel() >= v.level and ( v.customcheck and c.customcheck( ply ) or true ) then
						ply.ArenaParticipant = false
						table.insert( plys[v.name], ply )
					end
				end

			end

			if #plys[v.name] < 1 then
				roles[k] = nil
			end
		end

		if #roles < 1 then
			return
		end

		BREACH.QueuedSupports = {}
		net.Start("SelectRole_Sync")
		net.WriteTable(BREACH.QueuedSupports)
		net.Broadcast()

		for i = 1, math.Clamp(#ALPHA1_SPAWN, 0, count) do
			local role = table.Random( roles )
			local ply = table.remove( plys[role.name], math.random( 1, #plys[role.name] ) )
			ply:SetupNormal()
			ply:ApplyRoleStats( role )

			inuse[role.name] = inuse[role.name] + 1
			local selectedpos = spawnpos[math.random(1, #spawnpos)]
			table.RemoveByValue(spawnpos, selectedpos)
			selectedpos = Vector(selectedpos.x, selectedpos.y, GroundPos(selectedpos).z)
			ply:SetPos( selectedpos )

			if #plys[role.name] < 1 or inuse[role.name] >= role.max then
				table.RemoveByValue( roles, role )
			end

			timer.Simple(5, function()
			if ply:IsPremium() and ply.CanSwitchRole != true then
				timer.Simple(45, function()
					if IsValid(ply) then
						ply.CanSwitchRole = false
					end
			   end)
				ply.CanSwitchRole = true
				ply:SendLua("Select_Supp_Menu(LocalPlayer():GTeam())")
			end
			end)

			if #roles < 1 then
				break
			end
		end
		GAUS_PART_SPAWN()
		PlayAnnouncer( "nextoren/round_sounds/intercom/support/a1_enter.wav" )
		for _, announce in pairs(player.GetHumans()) do
			announce:BrTip(0, "[Legacy Breach]", Color(255,0,0,200), "l:a1_enter", color_white)
		end

end
--Alpha1Spawn(5)
function OSNSpawn(count)
	if disableobr then return end
	if GetGlobalBool("Evacuation_HUD", false) then return end
	if !timer.Exists("Evacuation") then return end
	if timer.TimeLeft("Evacuation") <= 10 then return end

	local roles = {}
	local plys = {}
	local inuse = {}
	local spawnpos = table.Copy(SPAWN_OBR)

	local messageinter

		for k, v in pairs( BREACH_ROLES.OSN.osn.roles ) do
			if v.team == TEAM_OSN then
				table.insert( roles, v )
			end
		end

		for k, v in pairs( roles ) do
			plys[v.name] = {}
			inuse[v.name] = 0
			for _, ply in pairs( player.GetAll() ) do

				if ply:GTeam() == TEAM_SPEC and ply.ActivePlayer and ply:GetPenaltyAmount() <= 0 and ply.SpawnAsSupport != false then
					if ply:GetLevel() >= v.level and ( v.customcheck and c.customcheck( ply ) or true ) then
						ply.ArenaParticipant = false
						table.insert( plys[v.name], ply )
					end
				end

			end

			if #plys[v.name] < 1 then
				roles[k] = nil
			end
		end

		if #roles < 1 then
			return
		end

		BREACH.QueuedSupports = {}
		net.Start("SelectRole_Sync")
		net.WriteTable(BREACH.QueuedSupports)
		net.Broadcast()

		for i = 1, math.Clamp(#SPAWN_OBR, 0, count) do
			local role = table.Random( roles )
			local ply = table.remove( plys[role.name], math.random( 1, #plys[role.name] ) )
			ply:SetupNormal()
			ply:ApplyRoleStats( role )
			--timer.Simple(5, function()
			--if ply:IsPremium() then
			--	timer.Simple(45, function()
			--		if IsValid(ply) then
			--			ply.CanSwitchRole = false
			--		end
			--   end)
			--	ply.CanSwitchRole = true
			--	ply:bSendLua("Select_Supp_Menu(LocalPlayer():GTeam())")
			--end
			--end)
			inuse[role.name] = inuse[role.name] + 1
			local selectedpos = spawnpos[math.random(1, #spawnpos)]
			table.RemoveByValue(spawnpos, selectedpos)
			selectedpos = Vector(selectedpos.x, selectedpos.y, GroundPos(selectedpos).z)
			ply:SetPos( selectedpos )

			if #plys[role.name] < 1 or inuse[role.name] >= role.max then
				table.RemoveByValue( roles, role )
			end

			timer.Simple(5, function()
			if ply:IsPremium() and ply.CanSwitchRole != true then
				timer.Simple(45, function()
					if IsValid(ply) then
						ply.CanSwitchRole = false
					end
			   end)
				ply.CanSwitchRole = true
				ply:SendLua("Select_Supp_Menu(LocalPlayer():GTeam())")
			end
			end)

			if #roles < 1 then
				break
			end
		end

end


local function GetSupportRoleTable(supname)

	if supname == "FBI_TG" then
		return BREACH_ROLES.FBI_AGENTS.fbi_agents.roles
	end

	if supname == "FBI_L" then
		return BREACH_ROLES.FBI.fbi.roles
	end

	if supname == "ETT" then
		return BREACH_ROLES.ETT.ett.roles
	end

	if supname == "FAF" then
		return BREACH_ROLES.FAF.faf.roles
	end

	if supname == "NTF" then
		return BREACH_ROLES.NTF.ntf.roles
	end
	
	local upperName = string.upper(supname)
	local lowerName = string.lower(supname)
	
	if BREACH_ROLES[upperName] and BREACH_ROLES[upperName][lowerName] then
		return BREACH_ROLES[upperName][lowerName].roles
	end
	
	return BREACH_ROLES[upperName][lowerName].roles
end

function GetAvailableSupports()
	local tab = {}
	for supp, isused in pairs(SUPPORTTABLE) do
		if !SUPPORTTABLE[supp] then
			tab[#tab + 1] = supp
		end
	end
	return tab
end

local BigRoundOnlySupports = {
	"GOC",
	"COTSK",
	"FBI_TG"
}

local FirstRoundOnlySupports = {
	"GOC",
	"COTSK",
	"FBI_TG"
}

local SecondRoundOnlySupports = {
	"COTSK",
	"FBI_TG"
}

local RareSupports = {
	"GOC",
	"COTSK"
}

local NotRareSupports = {
	"NTF",
	"CHAOS",
	"FBI_TG"
}

local LevelRequiredForSupport = {
	["GOC"] = 10,
	["GRU"] = 10,
	["COTSK"] = 10,
	["FBI_L"] = 7,
	["ETT"] = 10,
	["FAF"] = 0,
	["ARMY_IN"] = 7,
	["FBI_TG"] = 7,
	["CBG"] = 25
}

util.AddNetworkString("BreachAnnouncer")

function PlayAnnouncer(soundname)
	net.Start("BreachAnnouncer")
		net.WriteString(tostring(soundname))
	net.Broadcast()
end

function Start_Pilot_Spawn(user, num)

	user:SetupNormal()
	user:ApplyRoleStats(BREACH_ROLES.MINIGAMES.minigame.roles[4], true)
	if num == 1 then
		user:SetPos(Vector(-3582.238525, 4766.699219, 2506.970703))
	else
		user:SetPos(Vector(-3582.942383, 4870.370117, 2506.991211))
	end
	user:GiveTempAttach()

end

include("sh_roles_scp.lua")

local quicktables = {
	[TEAM_GOC] = BREACH_ROLES.GOC.goc.roles,
	[TEAM_CHAOS] = BREACH_ROLES.CHAOS.chaos.roles,
	[TEAM_USA] = BREACH_ROLES.FBI_AGENTS.fbi_agents.roles,
	[TEAM_DZ] = BREACH_ROLES.DZ.dz.roles,
	[TEAM_NTF] = BREACH_ROLES.NTF.ntf.roles,
	[TEAM_ETT] = BREACH_ROLES.ETT.ett.roles,
	[TEAM_FAF] = BREACH_ROLES.FAF.faf.roles,
	[TEAM_COTSK] = BREACH_ROLES.COTSK.cotsk.roles,
	[TEAM_GRU] = BREACH_ROLES.GRU.gru.roles,
	[TEAM_AR] = BREACH_ROLES.AR.ar.roles,
	--[TEAM_CBG] = BREACH_ROLES.CBG.cbg.roles,
	--[1313] = BREACH_ROLES.FBI_AGENTS.fbi_agents.roles,
}


function ProceedChangePremiumRoles()
	cutsceneinprogress = false

	for i, v in pairs(player.GetAll()) do
	
		if v.queuerole and v:GTeam() != TEAM_SPEC then

			local id = v.queuerole

			local quicktable = quicktables[v:GTeam()]

			if BREACH:IsUiuAgent(v:GetRoleName()) then quicktable = quicktables[1313] end

			local pos = v:GetPos()
			v:SetupNormal()
			v:ApplyRoleStats(quicktable[id], true)
			v:SetPos(pos)

		end

	end
end

local stringtoteam = {
	["FBI_TG"] = TEAM_USA,
	["CHAOS"] = TEAM_CHAOS,
	["NTF"] = TEAM_NTF,
	["ETT"] = TEAM_ETT,
	["FAF"] = TEAM_FAF,
	["COTSK"] = TEAM_COTSK,
	["GOC"] = TEAM_GOC,
	["DZ"] = TEAM_DZ,
	["GRU"] = TEAM_GRU,
	["AR"] = TEAM_AR,
	--["CBG"] = TEAM_CBG,
}

function PerformGRUCutscene(players)
	local s = {
		{
		    pos = Vector(-9348.970703, -2930.175292, 3378.457520),
		    ang = Angle(0.000, 177.965, 0.000),
		    seqs = {"0_rus_sit_2"},
		},
		{
		    pos = Vector(-9348.597656, -2888.117432, 3378.457520),
		    ang = Angle(0.000, 177.823, 0.000),
		    seqs = {"0_rus_sit_2"},
		},
		{
		    pos = Vector(-9350.044434, -2842.465332, 3378.457520),
		    ang = Angle(0.000, 177.117, 0.000),
		    seqs = {"0_rus_sit_2"},
		},
		{
		    pos = Vector(-9402.009277, -2842.354980, 3378.457520),
		    ang = Angle(0.000, 0.608, 0.000),
		    seqs = {"0_rus_sit_2"},
		},
		{
		    pos = Vector(-9403.801270, -2886.461121, 3378.457520),
		    ang = Angle(0.000, 0.746, 0.000),
		    seqs = {"0_rus_sit_2"},
		},
		{
		    pos = Vector(-9404.545410, -2928.408875, 3378.457520),
		    ang = Angle(0.000, 0.564, 0.000),
		    seqs = {"0_rus_sit_1"},
		},
		--{
		--	pos = Vector(15041.956055, 12976.275391, -15716.039062),
		--	ang = Angle(0.300, -93.924, 0.001),
		--	roles = {
		--		[role.GRU_Commander] = true
		--	},
		--	seqs = {"0_rus_pilot_1"},
		--},
		--{
		--	pos = Vector(15042.915039, 13026.463867, -15715.616211),
		--	ang = Angle(0.000, -93.108, 0.000),
		--	roles = {
		--		[role.GRU_Specialist] = true
		--	},
		--	seqs = {"0_rus_pilot_2"},
		--},
	}

	local u = {}
	local function q(r, m)
		local c = {}
		for i, v in ipairs(s) do
			local alabama = false
			if v.roles then
				local active = false
				for k in pairs(v.roles) do
					if m[k] then active = true end
				end
				if active then
					if v.roles[r] then alabama = true end
				else
					alabama = true
				end
			else
				alabama = true
			end
			if alabama and not u[i] then c[#c + 1] = i end
		end
		if #c == 0 then
			for i in ipairs(s) do
				if not u[i] then
					c[#c + 1] = i
				end
			end
			if #c == 0 then
				u = {}
				for i in ipairs(s) do
					c[#c + 1] = i
				end
			end
		end
		local i = c[math.random(#c)]
		u[i] = true
		local v = s[i]
		return v.pos, v.ang, v.seqs[math.random(#v.seqs)]
	end

	local m = {}
	for _, ply in ipairs(players) do
		m[ply:GetRoleName()] = true
	end

	for _, ply in ipairs(players) do
		local roleName = ply:GetRoleName()
		local pos, ang, anim = q(roleName, m)

		ply:Freeze(false)
		ply:SetMoveType(MOVETYPE_OBSERVER)
		ply:GuaranteedSetPos(pos)
		ply:SetNWAngle("ViewAngles", ang)
		ply:SetCollisionGroup(COLLISION_GROUP_WORLD)
		ply:SetForcedAnimation(anim, 65)
		ply:SetCycle(math.Rand(0, 1))
		ply:SetNWEntity("NTF1Entity", ply)
		ply:GodEnable()
		ply:ConCommand("lounge_chat_clear")
		ply.canttalk = true
		ply.SpectatorSkip = true
	end

    timer.Create("GRUCutscene", 20, 1, function()
        for _, ply in ipairs(players) do
            if IsValid(ply) and ply:GTeam() == TEAM_GRU then ply:ScreenFade(SCREENFADE.IN, Color(0, 0, 0), 1, 3) end
        end

        timer.Simple(2, function()
            for i, ply in ipairs(players) do
                if IsValid(ply) and ply:GTeam() == TEAM_GRU then
                    ply:SetPos(SPAWN_OUTSIDE_GRU[i])
                    ply:StopForcedAnimation()
                    ply:SetCollisionGroup(COLLISION_GROUP_PLAYER)
                    ply:SetMoveType(MOVETYPE_WALK)
                    ply:SetNWEntity("NTF1Entity", NULL)
                    ply:SetNWAngle("ViewAngles", Angle(0, 0, 0))
                    ply:GodDisable()
					ply.canttalk = nil
					ply.MovementLocked = nil
                    ply.SpectatorSkip = nil
                end

				--timer.Create("GRUObjectiveFallback", 40, 1, function()
				--	if GRU_Objective == nil then
				--		GRU_Objective = GRU_Objectives["Срыв эвакуации"]
				--	end
--
				--	for _, v in ipairs(player.GetAll()) do
				--		if v:GTeam() == TEAM_GRU then
				--			v:RXSENDNotify("l:gru_task "..GRU_Objective)
				--		end
				--	end
				--end)

				ProceedChangePremiumRoles()
            end
        end)
    end)
end


function SupportSpawn(forcesupport,forcesupportname)
	if !developer then
		if disablesupport then return end
	end

	if !SUPPORTTABLE then
			SUPPORTTABLE = {
				["GOC"] = false,
				["FBI_TG"] = false,
				["CHAOS"] = false,
				["NTF"] = false,
				["DZ"] = false,
				["COTSK"] = false,
				--["GRU"] = false,
				--["CBG"] = false,
				--["AR"] = false,
			}
	end
	if supcount == nil then supcount = 0 end
	if !SPAWNEDPLAYERSASSUPPORT then SPAWNEDPLAYERSASSUPPORT = {} end

	for _, ent in pairs(ents.FindInBox(Vector(-15140.630859, 4421.240234, 4174), Vector(-9602.487305, 7234.832031, 5316))) do

		if !ent:IsPlayer() and !ent:CreatedByMap() and ent:GetClass() != "ent_weaponstation" then
			ent:Remove()
		elseif ent:IsPlayer() and ent:GTeam() != TEAM_SPEC then
			ent:SetupNormal()
			ent:SetSpectator()
			ent:RXSENDNotify("l:dont_spawncamp")
		end

	end

	local supportamount = {
		["GOC"] = 5,
		["CHAOS"] = 6,
		["NTF"] = 6,
		["DZ"] = 5,
		["COTSK"] = math.random(6,7),
		--["GRU"] = 5,
		["CBG"] = 3,
		--["AR"] = 3,
	}

	if !IsBigRound() then
		for _, sup in pairs(BigRoundOnlySupports) do
			SUPPORTTABLE[sup] = true
		end
	end
--
	if supcount > 0 and IsBigRound() then
		for _, sup in pairs(FirstRoundOnlySupports) do
			SUPPORTTABLE[sup] = true
		end
	end
--
--
	if supcount > 1 and IsBigRound() then
		for _, sup in pairs(SecondRoundOnlySupports) do
			SUPPORTTABLE[sup] = true
		end
	end
	

	local supportlist = GetAvailableSupports()

	local pickedsupport = supportlist[math.random(1, #supportlist)]

	if supcount <= 0 and IsBigRound() then

		::repeatcheck::

		local chance = math.random(1, 100)
		local haverare = supcount <= 0 and IsBigRound()

		if chance <= 40 and haverare then

			pickedsupport = RareSupports[math.random(1, #RareSupports)]

		--[[elseif chance <= 50 and !SUPPORTTABLE["FBI"] then

			pickedsupport = "FBI"]]

		else

			pickedsupport = NotRareSupports[math.random(1,#NotRareSupports)]

		end

		--if pickedsupport == "COTSK" then goto repeatcheck end

	end

	if forcesupport then
		forcesupport = false
		pickedsupport = forcesupportname
	end

	supcount = supcount + 1

	if pickedsupport == "FBI_TG" then
		local caller = nil
		local ent = nil
		local hm = supportamount[pickedsupport] or 5
		
		BREACH.PowerfulUIUTG2Support(caller, ent, hm)
		
		SUPPORTTABLE[pickedsupport] = true
		return
	end

	if pickedsupport == "GRU" then
		SUPPORTTABLE[pickedsupport] = true
		BREACH.QueuedSupports = {}
		net.Start("SelectRole_Sync")
		net.WriteTable(BREACH.QueuedSupports)
		net.Broadcast()
		BREACH.PowerfulGRUSupport() 
		return
	end

	if pickedsupport == "OSN" then
		SUPPORTTABLE[pickedsupport] = true
		BREACH.QueuedSupports = {}
		net.Start("SelectRole_Sync")
		net.WriteTable(BREACH.QueuedSupports)
		net.Broadcast()
		OSNSpawn(5)
		return
	end

	if pickedsupport == "OBR" then
		SUPPORTTABLE[pickedsupport] = true
		BREACH.QueuedSupports = {}
		net.Start("SelectRole_Sync")
		net.WriteTable(BREACH.QueuedSupports)
		net.Broadcast()
		OBRSpawn(5)
		return
	end

	if pickedsupport == "Alpha1" then
		SUPPORTTABLE[pickedsupport] = true
		BREACH.QueuedSupports = {}
		net.Start("SelectRole_Sync")
		net.WriteTable(BREACH.QueuedSupports)
		net.Broadcast()
		Alpha1Spawn(5)
		return
	end

	--[[if pickedsupport == "FBIAgents" then
		SUPPORTTABLE[pickedsupport] = true
		BREACH.QueuedSupports = {}
		net.Start("SelectRole_Sync")
		net.WriteTable(BREACH.QueuedSupports)
		net.Broadcast()
		BREACH.PowerfulUIUSupport()
		return
	end]]

	local maxamount = supportamount[pickedsupport]

	if !maxamount then maxamount = 5 end

	local pickedplayers = {}

	local pick = 0

	--if forcesupportplys then
		for _, ply in pairs(GetActivePlayers()) do
			if ply:GTeam() == TEAM_SPEC and ((ply:IsDonator()) and ply:GetNWBool("prioritysup") or (ply:SteamID64() == "76561198966614836" and (pickedsupport == "NTF" or pickedsupport == "CHAOS"))) and ply.SpawnAsSupport then
			if pick >= maxamount then break end
			SPAWNEDPLAYERSASSUPPORT[#SPAWNEDPLAYERSASSUPPORT + 1] = ply
			pickedplayers[#pickedplayers + 1] = ply
			pick = pick + 1
			end
		end
		--forcesupportplys = nil
	--end

	for _, ply in RandomPairs(GetActivePlayers()) do
		if pick >= maxamount then break end
		if ply:GTeam() != TEAM_SPEC then continue end
		if ply.SpawnAsSupport == false then continue end
		if ply:GetPenaltyAmount() > 0 then continue end
		if LevelRequiredForSupport[pickedsupport] and ply:GetNLevel() < LevelRequiredForSupport[pickedsupport] then continue end
		--if table.HasValue(SPAWNEDPLAYERSASSUPPORT, ply) and !ply:IsDonator() then continue end
		--SPAWNEDPLAYERSASSUPPORT[#SPAWNEDPLAYERSASSUPPORT + 1] = ply
		pickedplayers[#pickedplayers + 1] = ply
		if ply.LuckyOne then
			ply:CompleteAchievement("lucky")
		else
			ply.LuckyOne = true
		end
		pick = pick + 1
	end

	for _, ply in pairs(player.GetAll()) do
		if !table.HasValue(pickedplayers, ply) then
			ply.LuckyOne = false
		end 
	end

	SUPPORTTABLE[pickedsupport] = true

	--if pickedsupport == "DZ" and supcount == 1 then
	--	BREACH.TempStats.DZFirst = true
	--end

	local cutscene = 0

	if pickedsupport == "GOC" then
		PlayAnnouncer( "nextoren/round_sounds/intercom/support/goc_enter.mp3" )
	elseif pickedsupport == "FBI_TG" then
	elseif pickedsupport == "AR" then
		PlayAnnouncer( "nextoren/round_sounds/intercom/support/enemy_enter.ogg" )
	elseif pickedsupport == "CBG" then
		PlayAnnouncer( "nextoren/round_sounds/intercom/support/enemy_enter.ogg" )
		local cog = ents.Create("kasanov_cbg_cog")
		cog:Spawn()
		timer.Simple(1, function()

			BroadcastLua("CBG_COG_VECTOR = Vector(" .. CBG_COG_VECTOR.x .. "," .. CBG_COG_VECTOR.y .. "," .. CBG_COG_VECTOR.z .. ")")

		end)
		--cutscene = 5
	elseif pickedsupport == "NTF" then

		for _, announce in pairs(player.GetHumans()) do
			announce:BrTip(0, "[Legacy Breach]", Color(255,0,0,200), "l:ntf_enter", color_white)
		end
        
		PlayAnnouncer( "nextoren/round_sounds/intercom/support/ntf_enter.ogg" )

	elseif pickedsupport == "COTSK" then

		--PlayAnnouncer( "rxsend_music/xinghong.MP3")
		PlayAnnouncer( "nextoren/round_sounds/intercom/support/enemy_enter.ogg" )
		local book_cock = ents.Create("ent_cult_book")
		book_cock:Spawn()

	elseif pickedsupport == "CHAOS" then

		cutscene = 1

		PlayAnnouncer( "nextoren/round_sounds/intercom/support/cl_enter.wav" )
	elseif pickedsupport == "DZ" then

		PlayAnnouncer( "nextoren/round_sounds/intercom/support/dz_enter.wav" )
	
	--elseif pickedsupport == "GRU" then
--
	--	cutscene = 4
--
	--	PlayAnnouncer( "nextoren/round_sounds/intercom/support/enemy_enter.ogg" )
	--	GRU_SPAWN_DOCK()
	--	local heli = ents.Create("gru_heli")
	--	heli:Spawn()
	else

		PlayAnnouncer( "nextoren/round_sounds/intercom/support/enemy_enter.ogg" )
	
	end

	local supinuse = {}
	local supspawns = table.Copy( SPAWN_OUTSIDE )
	local sups = {}

	if pickedsupport == "NTF" then
		supspawns = table.Copy( SPAWN_OUTSIDE )
	end

	if pickedsupport == "GOC" then
		supspawns = table.Copy( SPAWN_OUTSIDE )
	end

	if pickedsupport == "GRU" then
		supspawns = table.Copy( SPAWN_OUTSIDE )
	end

	if pickedsupport == "DZ" then
		supspawns = table.Copy( SPAWN_OUTSIDE )
		--local NewPortal = ents.Create("dz_spawn_portal")
		--NewPortal:SetPos(Vector(-11568.775390625, 4487.69140625, 9900.701171875))
		--NewPortal:SetAngles(Angle(0.004, -83.084, 0.395))
		--NewPortal:Spawn()
--
		--local NewPortal = ents.Create("dz_spawn_portal")
		--NewPortal:SetPos(Vector(-11597.759765625, 4301.2192382813, 9900.701171875))
		--NewPortal:SetAngles(Angle(0.004, -83.084, 0.395))
		--NewPortal:Spawn()
--
		--local NewPortal = ents.Create("dz_spawn_portal")
		--NewPortal:SetPos(Vector(-11597.541015625, 4760.8837890625, 9900.701171875))
		--NewPortal:SetAngles(Angle(0.004, -83.084, 0.395))
		--NewPortal:Spawn()
	end

	local notp = cutscene != 0

	for i = 1, #pickedplayers do
		local ply = pickedplayers[i]

		local suproles = table.Copy( GetSupportRoleTable(pickedsupport) )
		local selected

		local shouldselectrole = true

		if pickedsupport == "COTSK" and i == 1 then
			supinuse[BREACH_ROLES.COTSK.cotsk.roles[3].name] = 1
			selected = BREACH_ROLES.COTSK.cotsk.roles[3]
			shouldselectrole = false
		end

		if pickedsupport == "CHAOS" and i == 1 then
			supinuse[BREACH_ROLES.CHAOS.chaos.roles[3].name] = 1
			selected = BREACH_ROLES.CHAOS.chaos.roles[3]
			shouldselectrole = false
		end

		if pickedsupport == "NTF" and i == 1 and ply:SteamID64() == "76561198867007475" then
			supinuse[BREACH_ROLES.NTF.ntf.roles[4].name] = 1
			selected = BREACH_ROLES.NTF.ntf.roles[4]
			shouldselectrole = false
		end

		if pickedsupport == "CHAOS" and i == 2 and ply:SteamID64() == "76561198867007475" then
			supinuse[BREACH_ROLES.CHAOS.chaos.roles[2].name] = 1
			selected = BREACH_ROLES.CHAOS.chaos.roles[2]
			shouldselectrole = false
		end

		if shouldselectrole then
			repeat
				local role = table.remove( suproles, math.random( #suproles ) )
				supinuse[role.name] = supinuse[role.name] or 0

				if role.max == 0 or supinuse[role.name] < role.max then
					if role.level <= ply:GetNLevel() then
						if !role.customcheck or role.customcheck( ply ) then
							supinuse[role.name] = supinuse[role.name] + 1
							selected = role
							break
						end
					end
				end
			until #suproles == 0
		end

		local spawn = table.remove( supspawns, math.random( #supspawns ) )

		ply:SetupNormal()
		ply:ApplyRoleStats( selected )
		if !notp then
			ply:SetPos( spawn )
		end

		if pickedsupport == "NTF" then
			ply:NTF_Scene()
		end

		--if pickedsupport == "GRU" then
		--	timer.Simple(23, function()
		--	ply:NTF_Scene()
		--	end)
		--end

	end


	if cutscene == 2 then
		cutsceneinprogress = true
		PerformFBICutscene()
	elseif cutscene == 1 then
		cutsceneinprogress = true
		PerformChaosCutscene()
	elseif cutscene == 4 then
		cutsceneinprogress = true
		PerformGRUCutscene(pickedplayers)
	--elseif cutscene == 5 then
--
	--	cutsceneinprogress = true
	else
		cutsceneinprogress = false
	end

	BREACH.QueuedSupports = {}
	net.Start("SelectRole_Sync")
	net.WriteTable(BREACH.QueuedSupports)
	net.Broadcast()

	timer.Simple(1, function()
		local theteam = stringtoteam[pickedsupport]
		for i, v in pairs(player.GetAll()) do
			if v:GTeam() == theteam and v:IsPremium() and !string.lower(v:GetRoleName()):find("spy") then
				timer.Simple(45, function()
					if IsValid(v) then
						v.CanSwitchRole = false
					end
			   end)
				v.CanSwitchRole = true
				v:bSendLua("Select_Supp_Menu(LocalPlayer():GTeam())")
			end
		end
	end)


end

BREACH.SummonCBGCultist = function(нахуй, тут, аргументы)
	if postround then
		return
	end

	local pickedsupport = "CBG"
	local amount = 3
	local pick = 0
	local pickedplayers = {}

	if !SPAWNEDPLAYERSASSUPPORT then SPAWNEDPLAYERSASSUPPORT = {} end
	if forcesupportplys then
		for _, ply in pairs(forcesupportplys) do
			if pick >= amount then break end
			SPAWNEDPLAYERSASSUPPORT[#SPAWNEDPLAYERSASSUPPORT + 1] = ply
			pickedplayers[#pickedplayers + 1] = ply
			pick = pick + 1
		end
		forcesupportplys = nil
	end

	for _, ply in RandomPairs(GetActivePlayers()) do
		print(ply)
		if pick >= amount then break end
		if ply:GTeam() != TEAM_SPEC then continue end
		if ply.SpawnAsSupport == false then continue end
		if ply:GetPenaltyAmount() > 0 then continue end
		if LevelRequiredForSupport[pickedsupport] and ply:GetNLevel() < LevelRequiredForSupport[pickedsupport] then continue end
		SPAWNEDPLAYERSASSUPPORT[#SPAWNEDPLAYERSASSUPPORT + 1] = ply
		pickedplayers[#pickedplayers + 1] = ply
		if ply.LuckyOne then
			ply:CompleteAchievement("lucky")
		else
			ply.LuckyOne = true
		end
		pick = pick + 1
	end

	for _, ply in pairs(player.GetAll()) do
		if !table.HasValue(pickedplayers, ply) then
			ply.LuckyOne = false
		end 
	end

	local supinuse = {}
	local supspawns = {
		Vector(9586.350586, -5039.971191, 2.792251),
		Vector(9584.227539, -5002.191895, 3.591652),
		Vector(9594.851562, -4951.157227, 3.207491),
	}
	local sups = {}

	local notp = cutscene != 0

	for i = 1, #pickedplayers do
		local ply = pickedplayers[i]

		local suproles = table.Copy( GetSupportRoleTable(pickedsupport) )
		local selected

		local shouldselectrole = true

		if shouldselectrole then
			repeat
				local role = table.remove( suproles, math.random( #suproles ) )
				supinuse[role.name] = supinuse[role.name] or 0

				if role.max == 0 or supinuse[role.name] < role.max then
					if role.level <= ply:GetNLevel() and role.model != 'models/imperator/humans/crb/rb.mdl' then
						if !role.customcheck or role.customcheck( ply ) then
							supinuse[role.name] = supinuse[role.name] + 1
							selected = role
							break
						end
					end
				end
			until #suproles == 0
		end

		local spawn = table.remove( supspawns, math.random( #supspawns ) )

		ply:SetupNormal()
		ply:ApplyRoleStats( selected )
		ply:SetPos( spawn )
		ply:Freeze(false)

		if IsValid(ply) then
			ply:bSendLua("CRBStart()")
			ply:SetCollisionGroup(COLLISION_GROUP_PASSABLE_DOOR)
			local cog = ents.Create("kasanov_cbg_cog")
			cog:Spawn()
			timer.Simple(1, function()
				BroadcastLua("CBG_COG_VECTOR = Vector(" .. CBG_COG_VECTOR.x .. "," .. CBG_COG_VECTOR.y .. "," .. CBG_COG_VECTOR.z .. ")")
			end)
			timer.Simple(20, function()
				if ply:GTeam() == TEAM_CBG then
					ply:SetCollisionGroup(COLLISION_GROUP_PLAYER)
				end
			end)
		end
	end

	BREACH.QueuedSupports = {}
	net.Start("SelectRole_Sync")
	net.WriteTable(BREACH.QueuedSupports)
	net.Broadcast()

    net.Start( "ForcePlaySound" )
      	net.WriteString( "nextoren/ritual_cancel_"..math.random(1,3)..".ogg" )
    net.Broadcast()
end

SCP914InUse = false
function Use914( ent )
end

net.Receive("ProceedUnfreezeSUP", function(len, ply)
	if ply:GetPos():WithinAABox(Vector(-12220, 6709, 4839), Vector(-11309, 5217, 4573)) then
		ply:Freeze(false)
		ply.MovementLocked = nil
	end
end)

function GetAlivePlayers()
	local plys = {}
	for k,v in pairs(player.GetAll()) do
		if v:GTeam() != TEAM_SPEC then
			if v:Alive() and v:Health() >= 0 and v:GTeam() != TEAM_ARENA then
				table.ForceInsert(plys, v)
			end
		end
	end
	return plys
end

function BroadcastDetection( ply, tab )
	local transmit = { ply }
	local radio = ply:GetWeapon( "item_radio" )

	if radio and radio.Enabled and radio.Channel > 4 then
		local ch = radio.Channel

		for k, v in pairs( player.GetAll() ) do
			if v:GTeam() != TEAM_SCP and v:GTeam() != TEAM_SPEC and v != ply then
				local r = v:GetWeapon( "item_radio" )

				if r and r.Enabled and r.Channel == ch then
					table.insert( transmit, v )
				end
			end
		end
	end

	local info = {}

	for k, v in pairs( tab ) do
		table.insert( info, {
			name = v:GetRoleName(),
			pos = v:GetPos() + v:OBBCenter()
		} )
	end

	net.Start( "CameraDetect" )
		net.WriteTable( info )
	net.Send( transmit )
end

function GM:GetFallDamage( ply, speed )
	local tr = util.TraceHull({
		start = ply:GetPos(),
		mins = ply:OBBMins(),
		maxs = ply:OBBMaxs(),
		filter = ply,
		endpos = ply:GetPos() - Vector(0,0,150)
	})
	local victim = tr.Entity
	if victim and victim:IsValid() and victim:IsPlayer() then
		local dmginfo = DamageInfo()
		dmginfo:SetDamage(speed/3)
		dmginfo:SetDamageType(DMG_FALL)
		dmginfo:SetAttacker(ply)
		victim:TakeDamageInfo(dmginfo)
	end
	return ( speed / 6 )*2
end

function GM:OnEntityCreated( ent )
	ent:SetShouldPlayPickupSound( false )
end

function GetPlayer(nick)
	for k,v in pairs(player.GetAll()) do
		if v:Nick() == nick then
			return v
		end
	end
	return nil
end

function CreateRagdollPL(victim, attacker, dmgtype)
	if victim:GetGTeam() == TEAM_SPEC then return end
	if not IsValid(victim) then return end

	local rag = ents.Create("prop_ragdoll")
	if not IsValid(rag) then return nil end

	if victim.DeathReason == "Headshot" then
		rag:SetPos(victim:GetPos())
		rag:SetModel(victim:GetModel())
		rag:SetAngles(victim:GetAngles())
		rag:SetColor(victim:GetColor())
		rag:SetBodygroup( 0, victim:GetBodygroup(0))
		rag:SetBodygroup( 1, victim:GetBodygroup(1))
		rag:SetBodygroup( 2, victim:GetBodygroup(2))
		rag:SetBodygroup( 3, victim:GetBodygroup(3))
		rag:SetBodygroup( 4, victim:GetBodygroup(4))
		rag:SetBodygroup( 5, victim:GetBodygroup(5))
		rag:SetBodygroup( 6, victim:GetBodygroup(6))
		rag:SetBodygroup( 7, victim:GetBodygroup(7))
		rag:SetBodygroup( 8, victim:GetBodygroup(8))
		rag:SetBodygroup( 9, victim:GetBodygroup(9))
		rag:SetBodygroup( 10, victim:GetBodygroup(10))
		rag:SetBodygroup( 11, victim:GetBodygroup(11))
		rag:SetBodygroup( 12, victim:GetBodygroup(12))
		rag:SetBodygroup( 13, victim:GetBodygroup(13))
	
		rag:Spawn()
		rag:Activate()
		
		rag.Info = {}
		rag.Info.CorpseID = rag:GetCreationID()
		rag:SetNWInt( "CorpseID", rag.Info.CorpseID )
		rag.Info.Victim = victim:Nick()
		rag.Info.DamageType = dmgtype
		rag.Info.Time = CurTime()
	
		if victim:GetRoleName() != Dispatcher then
	
			Bonemerge( "models/cultist/heads/gibs/gib_head.mdl", rag )
	
		end

		
	
	else
		rag:SetPos(victim:GetPos())
		rag:SetModel(victim:GetModel())
		rag:SetAngles(victim:GetAngles())
		rag:SetColor(victim:GetColor())
		rag:SetBodygroup( 0, victim:GetBodygroup(0))
		rag:SetBodygroup( 1, victim:GetBodygroup(1))
		rag:SetBodygroup( 2, victim:GetBodygroup(2))
		rag:SetBodygroup( 3, victim:GetBodygroup(3))
		rag:SetBodygroup( 4, victim:GetBodygroup(4))
		rag:SetBodygroup( 5, victim:GetBodygroup(5))
		rag:SetBodygroup( 6, victim:GetBodygroup(6))
		rag:SetBodygroup( 7, victim:GetBodygroup(7))
		rag:SetBodygroup( 8, victim:GetBodygroup(8))
		rag:SetBodygroup( 9, victim:GetBodygroup(9))
		rag:SetBodygroup( 10, victim:GetBodygroup(10))
		rag:SetBodygroup( 11, victim:GetBodygroup(11))
		rag:SetBodygroup( 12, victim:GetBodygroup(12))
		rag:SetBodygroup( 13, victim:GetBodygroup(13))
	
		rag:Spawn()
		rag:Activate()
		
		rag.Info = {}
		rag.Info.CorpseID = rag:GetCreationID()
		rag:SetNWInt( "CorpseID", rag.Info.CorpseID )
		rag.Victim = victim:Nick()
		rag.DamageType = dmgtype
		rag.Info.Time = CurTime()
	
		if ( victim.BoneMergedEnts ) then
	
			for _, v in ipairs( victim.BoneMergedEnts ) do
	
				if ( v && v:IsValid() ) then
	
					Bonemerge( v:GetModel(), rag )
	
				end
	
			end
	
		end
	
		if ( victim.BoneMergedHackerHat ) then
	
			for _, v in ipairs( victim.BoneMergedHackerHat ) do
	
				if ( v && v:IsValid() ) then
	
					Bonemerge( v:GetModel(), rag )
	
				end
	
			end
	
		end
	end

	rag.DeathReason = victim.DeathReason

	
	local group = COLLISION_GROUP_DEBRIS_TRIGGER
	rag:SetCollisionGroup(group)
	timer.Simple( 1, function() if IsValid( rag ) then rag:CollisionRulesChanged() end end )
	timer.Simple( 60, function() if IsValid( rag ) then rag:Remove() end end )
	
	local num = rag:GetPhysicsObjectCount()-1
	local v = victim:GetVelocity() * 0.35
	
	for i=0, num do
		local bone = rag:GetPhysicsObjectNum(i)
		if IsValid(bone) then
		local bp, ba = victim:GetBonePosition(rag:TranslatePhysBoneToBone(i))
		if bp and ba then
			bone:SetPos(bp)
			bone:SetAngles(ba)
		end
		bone:SetVelocity(v * 1.2)
		end
	end
end

--hook.Add( "EntityFireBullets", "effect_hitshot", function(ent, data)
	--[[
	data.Callback = function(ent, tr, dmginf)
		local effdata = EffectData()
		effdata:SetOrigin(tr.HitPos)
		effdata:SetAngles(Angle(0,0,0))
		effdata:SetEntity(tr.Entity)
		util.Effect("helicopter_impact", effdata)
	end]]

	--if ent:IsPlayer() then
		--ent:SetPos(ent:GetEyeTraceNoCursor().HitPos)
		--local effdata = EffectData()
		--effdata:SetOrigin(ent:GetEyeTraceNoCursor().HitPos)
		--effdata:SetAngles(Angle(0,0,0))
		--effdata:SetEntity(ent)
		--util.Effect("helicopter_impact", effdata)
	--end
	--return true
--end)

hook.Add( "EntityTakeDamage", "NoDamageForProps", function( target, dmginfo )
	--[[
	if !target:IsPlayer() then
		local effdata = EffectData()
		effdata:SetOrigin(dmginfo:GetDamagePosition())
		effdata:SetAngles(Angle(0,0,0))
		effdata:SetEntity(target)
		util.Effect("helicopter_impact", effdata)
	end]]
	if ( target:GetClass() == "prop_physics" ) then
		return true
	end
end )

function ServerSound( file, ent, filter )
	ent = ent or game.GetWorld()
	if !filter then
		filter = RecipientFilter()
		filter:AddAllPlayers()
	end

	local sound = CreateSound( ent, file, filter )

	return sound
end

inUse = false

function takeDamage( ent, ply )
	local dmg = 0
	for k, v in pairs( ents.FindInSphere( POS_MIDDLE_GATE_A, 1000 ) ) do
		if v:IsPlayer() then
			if v:Alive() then
				if v:GTeam() != TEAM_SPEC then
					dmg = ( 1001 - v:GetPos():Distance( POS_MIDDLE_GATE_A ) ) * 10
					if dmg > 0 then 
						v:TakeDamage( dmg, ply or v, ent )
					end
				end
			end
		end
	end
end

function destroyGate()
	if isGateAOpen() then return end
	local doorsEnts = ents.FindInSphere( POS_MIDDLE_GATE_A, 125 )
	for k, v in pairs( doorsEnts ) do
		if v:GetClass() == "prop_dynamic" or v:GetClass() == "func_door" then
			v:Remove()
		end
	end
end

function isGateAOpen()
	local doors = ents.FindInSphere( POS_MIDDLE_GATE_A, 125 )
	for k, v in pairs( doors ) do
		if v:GetClass() == "prop_dynamic" then 
			if isInTable( v:GetPos(), POS_GATE_A_DOORS ) then return false end
		end
	end
	return true
end

function Recontain106( ply )
	if Recontain106Used  then
		ply:PrintMessage( HUD_PRINTCENTER, "SCP 106 recontain procedure can be triggered only once per round" )
		return false
	end

	local cage
	for k, v in pairs( ents.GetAll() ) do
		if v:GetPos() == CAGE_DOWN_POS then
			cage = v
			break
		end
	end
	if !cage then
		ply:PrintMessage( HUD_PRINTCENTER, "Power down ELO-IID electromagnet in order to start SCP 106 recontain procedure" )
		return false
	end

	local e = ents.FindByName( SOUND_TRANSMISSION_NAME )[1]
	if e:GetAngles().roll == 0 then
		ply:PrintMessage( HUD_PRINTCENTER, "Enable sound transmission in order to start SCP 106 recontain procedure" )
		return false
	end

	local fplys = ents.FindInBox( CAGE_BOUNDS.MINS, CAGE_BOUNDS.MAXS )
	local plys = {}
	for k, v in pairs( fplys ) do
		if IsValid( v ) and v:IsPlayer() and v:GTeam() != TEAM_SPEC and v:GTeam() != TEAM_SCP then
			table.insert( plys, v )
		end
	end

	if #plys < 1 then
		ply:PrintMessage( HUD_PRINTCENTER, "Living human in cage is required in order to start SCP 106 recontain procedure" )
		return false
	end

	local scps = {}
	for k, v in pairs( player.GetAll() ) do
		if IsValid( v ) and v:GTeam() == TEAM_SCP and v:GetRoleName() == SCP106 then
			table.insert( scps, v )
		end
	end

	if #scps < 1 then
		ply:PrintMessage( HUD_PRINTCENTER, "SCP 106 is already recontained" )
		return false
	end

	Recontain106Used = true

	timer.Simple( 6, function()
		if postround or !Recontain106Used then return end
		for k, v in pairs( plys ) do
			if IsValid( v ) then
				v:Kill()
			end
		end

		for k, v in pairs( scps ) do
			if IsValid( v ) then
				local swep = v:GetActiveWeapon()
				if IsValid( swep ) and swep:GetClass() == "weapon_scp_106" then
					swep:TeleportSequence( CAGE_INSIDE )
				end
			end
		end

		timer.Simple( 11, function()
			if postround or !Recontain106Used then return end
			for k, v in pairs( scps ) do
				if IsValid( v ) then
					v:Kill()
				end
			end
			local eloiid = ents.FindByName( ELO_IID_NAME )[1]
			eloiid:Use( game.GetWorld(), game.GetWorld(), USE_TOGGLE, 1 )
			if IsValid( ply ) then
				ply:PrintMessage(HUD_PRINTTALK, "You've been awarded with 10 points for recontaining SCP 106!")
				--ply:AddFrags( 10 )
			end
		end )


	end )

	return true
end

local ment = FindMetaTable("Entity")

function IsGroundPos(pos)
	local tr = util.TraceLine({
		start = pos,
		endpos = pos - Vector(0,0,10)
	})

	if tr.HitWorld or (IsValid(tr.Entity) and (tr.Entity:GetClass() == "prop_dynamic" or tr.Entity:GetClass() == "prop_physics")) then
		return true
	end

	return false
end

function ment:BrOnGround()
	local tr = util.TraceLine({
		start = self:GetPos(),
		filter = self,
		endpos = self:GetPos() - Vector(0,0,10-self:OBBMins().z)
	})

	if tr.HitWorld or (IsValid(tr.Entity) and (tr.Entity:GetClass() == "prop_dynamic" or tr.Entity:GetClass() == "prop_physics")) then
		return true
	end

	return false
end

OMEGAEnabled = false
OMEGADoors = false
function OMEGAWarhead( ply )
	if OMEGAEnabled then return end

	local remote = ents.FindByName( OMEGA_REMOTE_NAME )[1]
	if GetConVar( "br_enable_warhead" ):GetInt() != 1 or remote:GetAngles().pitch == 180 then
		ply:PrintMessage( HUD_PRINTCENTER, "You inserted keycard but nothing happened" )
		return
	end

	OMEGAEnabled = true

	--local alarm = ServerSound( "warhead/alarm.ogg" )
	--alarm:SetSoundLevel( 0 )
	--alarm:Play()
	net.Start( "SendSound" )
		net.WriteInt( 1, 2 )
		net.WriteString( "warhead/alarm.ogg" )
	net.Broadcast()

	timer.Create( "omega_announcement", 3, 1, function()
		--local announcement = ServerSound( "warhead/announcement.ogg" )
		--announcement:SetSoundLevel( 0 )
		--announcement:Play()
		net.Start( "SendSound" )
			net.WriteInt( 1, 2 )
			net.WriteString( "warhead/announcement.ogg" )
		net.Broadcast()

		timer.Create( "omega_delay", 11, 1, function()
			for k, v in pairs( ents.FindByClass( "func_door" ) ) do
				if IsInTolerance( OMEGA_GATE_A_DOORS[1], v:GetPos(), 100 ) or IsInTolerance( OMEGA_GATE_A_DOORS[2], v:GetPos(), 100 ) then
					v:Fire( "Unlock" )
					v:Fire( "Open" )
					v:Fire( "Lock" )
				end
			end

			OMEGADoors = true

			--local siren = ServerSound( "warhead/siren.ogg" )
			--siren:SetSoundLevel( 0 )
			--siren:Play()
			net.Start( "SendSound" )
				net.WriteInt( 1, 2 )
				net.WriteString( "warhead/siren.ogg" )
			net.Broadcast()
			timer.Create( "omega_alarm", 12, 5, function()
				--siren = ServerSound( "warhead/siren.ogg" )
				--siren:SetSoundLevel( 0 )
				--siren:Play()
				net.Start( "SendSound" )
					net.WriteInt( 1, 2 )
					net.WriteString( "warhead/siren.ogg" )
				net.Broadcast()
			end )

			timer.Create( "omega_check", 1, 89, function()
				if !IsValid( remote ) or remote:GetAngles().pitch == 180 or !OMEGAEnabled then
					WarheadDisabled( siren )
				end
			end )
		end )

		timer.Create( "omega_detonation", 90, 1, function()
			--local boom = ServerSound( "warhead/explosion.ogg" )
			--boom:SetSoundLevel( 0 )
			--boom:Play()
			net.Start( "SendSound" )
				net.WriteInt( 1, 2 )
				net.WriteString( "warhead/explosion.ogg" )
			net.Broadcast()
			for k, v in pairs( player.GetAll() ) do
				v:Kill()
			end
		end )
	end )
end

--[[function PerformFBICutscene()
	local fbis = {}
	local havecmd = false
	local havespecial = false
	local haveclocker = false
	for _, ply in pairs(player.GetAll()) do
		if ply:GTeam() == TEAM_USA and !ply:GetRoleName():find("Spy") then
			if ply:GetModel() != "models/cultist/humans/fbi/fbi_agent.mdl" then
				fbis[#fbis + 1] = ply
				if ply:GetRoleName() == role.UIU_Agent_Commander then havecmd = true end
				if ply:GetRoleName() == role.UIU_Agent_Specialist then havespecial = true end
				--ply:PlayMusic(BR_MUSIC_SPAWN_FBI)
			end
		end
	end

	local Sits = {
		"driver",
		"infront",
		"middle",
		"right",
		"left",
	}

	local CurrentSit = {
		["driver"] = NULL,
		["infront"] = NULL,
		["middle"] = NULL,
		["right"] = NULL,
		["left"] = NULL
	}
	local function TakeSit(sit, ply)
		table.RemoveByValue(Sits, sit)
		CurrentSit[sit] = ply
	end
	for i, ply in ipairs(fbis) do
		if ply:GetRoleName() == role.UIU_Agent_Commander then TakeSit("driver", ply) continue end
		if ply:GetRoleName() == role.UIU_Agent_Specialist then TakeSit("infront", ply) continue end
		if !havecmd and table.HasValue(Sits, "driver") then TakeSit("driver", ply) continue end
		if !havespecial and table.HasValue(Sits, "infront") then TakeSit("infront", ply) continue end
		if table.HasValue(Sits, "right") then TakeSit("right", ply) continue end
		if table.HasValue(Sits, "left") then TakeSit("left", ply) continue end
		if table.HasValue(Sits, "middle") then TakeSit("middle", ply) continue end
	end

	local carjeep = ents.Create("prop_physics")
	carjeep:SetModel("models/scpcars/scpp_wrangler_fnf.mdl")
	carjeep:SetPos(Vector(-10073.2734375, -1803.9547119141, 3059.2768554688))
	carjeep:SetAngles(Angle(0, 0, 0))
	carjeep:Spawn()
	carjeep:SetSolid(SOLID_NONE)
	carjeep:SetMoveType(MOVETYPE_NONE)
	carjeep:PhysicsInit(SOLID_NONE)
	carjeep:PhysicsDestroy()

	for sit, ply in pairs(CurrentSit) do
		if IsValid(ply) then
			local anim = "0_fbi_sit"
			local pos = Vector(-10049.437500, -1834.270142, 3104.149414) -- old: (-5092.149414, 633.000000, 6427.872559)
			if sit == "left" then
			    pos = Vector(-10094.866699, -1834.898072, 3104.235107) -- old: (-5137.578613, 632.372070, 6427.958252)
			elseif sit == "middle" then
			    anim = "0_fbi_sit_middle"
			    pos = Vector(-10074.522949, -1837.875611, 3103.772949) -- old: (-5117.234863, 629.394531, 6427.496094)
			elseif sit == "infront" then
			    anim = "0_fbi_sit_infront"
			    pos = Vector(-10052.579590, -1790.494751, 3101.118408) -- old: (-5095.291504, 676.775391, 6424.841553)
			elseif sit == "driver" then
			    anim = "0_fbi_driver"
			    pos = Vector(-10094.193848, -1784.435181, 3096.933838) -- old: (-5136.905762, 682.834961, 6420.656983)
			end
			ply:SetMoveType(MOVETYPE_OBSERVER)
			ply:GuaranteedSetPos(pos)
			ply:SetNWAngle("ViewAngles", Angle(0, 90, 0))
			ply:SetForcedAnimation(anim, 65)
			ply:SetNWEntity("NTF1Entity", ply)
			ply:GodEnable()
		end
	end

	timer.Simple(20, function()
		for _, ply in ipairs(fbis) do
			if IsValid(ply) and ply:GTeam() == TEAM_USA and !ply:GetRoleName():find("Spy")  then ply:ScreenFade(SCREENFADE.IN, Color(0,0,0), 1, 3) end
		end
		timer.Simple(2, function()
			if IsValid(carjeep) then carjeep:StopSound("nextoren/vehicle/jee_wranglerfnf/third.wav") carjeep:Remove() end
			for i, ply in ipairs(fbis) do
				if IsValid(ply) and ply:GTeam() == TEAM_USA and !ply:GetRoleName():find("Spy")  then
					ply:SetPos(SPAWN_OUTSIDE[i])
					ply:StopForcedAnimation()
					ply:SetMoveType(MOVETYPE_WALK)
					ply:SetNWEntity("NTF1Entity", NULL)
					ply:SetNWAngle("ViewAngles", Angle(0,0,0))
					ply:GodDisable()
				end
			end
			ProceedChangePremiumRoles()
		end)
	end)

	carjeep:EmitSound("nextoren/vehicle/jee_wranglerfnf/third.wav", 55, 77, 0.75)

end]]

function PerformFBICutscene()
	local fbis = {}
	local havecmd = false
	local havespecial = false
	local haveclocker = false
	for _, ply in pairs(player.GetAll()) do
		if ply:GTeam() == TEAM_USA and !ply:GetRoleName():find("Spy") then
			fbis[#fbis + 1] = ply
			if ply:GetRoleName() == role.UIU_Agent_Commander then havecmd = true end
			if ply:GetRoleName() == role.UIU_Agent_Specialist then havespecial = true end
		end
	end

	local Sits = {
		"driver",
		"infront",
		"middle",
		"right",
		"left",
	}

	local CurrentSit = {
		["driver"] = NULL,
		["infront"] = NULL,
		["middle"] = NULL,
		["right"] = NULL,
		["left"] = NULL
	}
	local function TakeSit(sit, ply)
		table.RemoveByValue(Sits, sit)
		CurrentSit[sit] = ply
	end
	for i, ply in ipairs(fbis) do
		if ply:GetRoleName() == role.UIU_Agent_Commander then TakeSit("driver", ply) continue end
		if ply:GetRoleName() == role.UIU_Agent_Specialist then TakeSit("infront", ply) continue end
		if !havecmd and table.HasValue(Sits, "driver") then TakeSit("driver", ply) continue end
		if !havespecial and table.HasValue(Sits, "infront") then TakeSit("infront", ply) continue end
		if table.HasValue(Sits, "right") then TakeSit("right", ply) continue end
		if table.HasValue(Sits, "left") then TakeSit("left", ply) continue end
		if table.HasValue(Sits, "middle") then TakeSit("middle", ply) continue end
	end

	local carjeep = ents.Create("prop_physics")
	carjeep:SetModel("models/scpcars/scpp_wrangler_fnf.mdl")
	carjeep:SetPos(Vector(-7103.528809, 15068.817383, 2038.158203))
	carjeep:SetAngles(Angle(0, 0, 0))
	carjeep:Spawn()
	carjeep:SetSolid(SOLID_NONE)
	carjeep:SetMoveType(MOVETYPE_NONE)
	carjeep:PhysicsInit(SOLID_NONE)
	carjeep:PhysicsDestroy()

	for sit, ply in pairs(CurrentSit) do
		if IsValid(ply) then
			local anim = "0_fbi_sit"
			local pos = Vector(-7079.692871, 15038.501953, 2083.030762)
			if sit == "left" then
				pos = Vector(-7125.122070, 15037.874023, 2083.116455)
			elseif sit == "middle" then
				anim = "0_fbi_sit_middle"
				pos = Vector(-7104.778320, 15034.896484, 2082.654297)
			elseif sit == "infront" then
				anim = "0_fbi_sit_infront"
				pos = Vector(-7082.834961, 15082.277344, 2079.999756)
			elseif sit == "driver" then
				anim = "0_fbi_driver"
				pos = Vector(-7124.449219, 15088.336914, 2075.815186)
			end
			ply:SetMoveType(MOVETYPE_OBSERVER)
			ply:GuaranteedSetPos(pos)
			ply:SetNWAngle("ViewAngles", Angle(0, 90, 0))
			ply:SetForcedAnimation(anim, 65)
			ply:SetNWEntity("NTF1Entity", ply)
			ply:GodEnable()
			ply.FBICutsceneActive = true			
		end
	end

	-- 向所有参与动画的玩家发送网络消息，让他们在客户端禁用下蹲
	for i, ply in ipairs(fbis) do
		if IsValid(ply) and ply:GTeam() == TEAM_USA and !ply:GetRoleName():find("Spy") then
			net.Start("FBI_Cutscene_Start")
			net.Send(ply)
		end
	end

	carjeep:EmitSound("nextoren/vehicle/jee_wranglerfnf/third.wav", 55, 77, 0.75)

	timer.Simple(20, function()
		for _, ply in ipairs(fbis) do
			if IsValid(ply) and ply:GTeam() == TEAM_USA and !ply:GetRoleName():find("Spy")  then ply:ScreenFade(SCREENFADE.IN, Color(0,0,0), 1, 3) end
		end
		timer.Simple(2, function()
			if IsValid(carjeep) then carjeep:StopSound("nextoren/vehicle/jee_wranglerfnf/third.wav") carjeep:Remove() end
			for i, ply in ipairs(fbis) do
				if IsValid(ply) and ply:GTeam() == TEAM_USA and !ply:GetRoleName():find("Spy")  then
					ply:SetPos(SPAWN_OUTSIDE[i])
					ply:StopForcedAnimation()
					ply:SetMoveType(MOVETYPE_WALK)
					ply:SetNWEntity("NTF1Entity", NULL)
					ply:SetNWAngle("ViewAngles", Angle(0,0,0))
					ply:GodDisable()
			-- 移除动画状态标记
			ply.FBICutsceneActive = false
			
			-- 通知客户端结束动画状态
			net.Start("FBI_Cutscene_End")
			net.Send(ply)
				end
			end
			ProceedChangePremiumRoles()
		end)
	end)

	carjeep:EmitSound("nextoren/vehicle/jee_wranglerfnf/third.wav", 55, 77, 0.75)

end

function PerformChaosCutscene()

	local CIS = {}

	for _, ply in pairs(player.GetAll()) do
		if ply:GTeam() == TEAM_CHAOS and ply:GetRoleName() != role.SECURITY_Spy then
			CIS[#CIS + 1] = ply
		end
	end

	local leftpositions = {
		Vector(11.198242, -5.783607, -46.736450),
		Vector(-17.891602, -5.120277, -46.736450),
		Vector(-59.575195, 2.673798, -46.736450),
		Vector(-85.702148, 3.341026,-46.736450),
	}
	local rightpositions = {
		Vector(-90.564453, -3.536804, -46.736450),
		Vector(-62.086914, -3.764305, -46.736450),
		--Vector(-10481.501953, -81.029991, 1781.447388),
		Vector(7.801758, 5.529922, -46.736450),
	}
	local rightangle = Angle(0, -90, 0)
	local leftangle = Angle(0, 90, 0)

	local apc_pos = Vector(15200.626953125, 12824.885742188, -15706.223632813)

	local anims = {
		["0_chaos_sit_1"] = 0,
		--["0_chaos_sit_2"] = 0,
		["0_chaos_sit_3"] = 0,
	}

	local function pickanim(role)
		if role == role.Chaos_Jugg then
			return "0_chaos_sit_jug"
		end
		for anim, amount in RandomPairs(anims) do
			if amount > 2 then continue end
			anims[anim] = anims[anim] + 1
			return anim
		end
	end

	local function picksit()
		if #leftpositions <= 0 then

			local index = math.random(1, #rightpositions)
			local pickedsit = rightpositions[index]
			table.RemoveByValue(rightpositions, pickedsit)

			return pickedsit, rightangle

		end
		if #rightpositions <= 0 then

			local index = math.random(1, #leftpositions)
			local pickedsit = leftpositions[index]
			table.RemoveByValue(leftpositions, pickedsit)
			return pickedsit, leftangle

		end
		
		local rand = math.random(1, 2)

		if rand == 1 then

			local index = math.random(1, #leftpositions)
			local pickedsit = leftpositions[index]
			table.RemoveByValue(leftpositions, pickedsit)
			return pickedsit, leftangle

		end

		if rand == 2 then

			local index = math.random(1, #rightpositions)
			local pickedsit = rightpositions[index]
			table.RemoveByValue(rightpositions, pickedsit)
			return pickedsit, rightangle

		end

	end


	local chaosjeep = ents.Create("prop_physics")
	chaosjeep:SetModel("models/scp_chaos_jeep/chaos_jeep.mdl")
	chaosjeep:Spawn()
	chaosjeep:SetMoveType(MOVETYPE_NONE)
	chaosjeep:SetPos(Vector(-5065.2456054688, -389.60665893555, 6305.03125))
	chaosjeep:SetAngles(Angle(0.011260154657066, 120.347030639648, -0.017242431640625))
	chaosjeep:SetBodygroup(1,1)

	local offset = Vector(79, 0, 93)

	for _, ply in pairs(CIS) do
		if IsValid(ply) and ply:GTeam() == TEAM_CHAOS then
			local pos, ang = picksit()
			ply:SetMoveType(MOVETYPE_OBSERVER)
			ply:GuaranteedSetPos(apc_pos + pos + offset)
			ply:SetNWAngle("ViewAngles", ang)
			local anim = pickanim(ply:GetRoleName())
			ply:SetForcedAnimation(anim, 65)
			ply:SetNWEntity("NTF1Entity", ply)
			ply:GodEnable()
		end
	end

	timer.Create("Sequence_APC_Spawn_Remove", 30, 1, function()
		for _, ply in ipairs(CIS) do
			if IsValid(ply) and ply:GTeam() == TEAM_CHAOS then ply:ScreenFade(SCREENFADE.IN, Color(0,0,0), 1, 3) end
		end
		timer.Simple(2, function()
			for i, ply in ipairs(CIS) do
				if IsValid(ply) and ply:GTeam() == TEAM_CHAOS then
					ply:SetPos(SPAWN_OUTSIDE[i])
					ply:StopForcedAnimation()
					ply:SetMoveType(MOVETYPE_WALK)
					ply:SetNWEntity("NTF1Entity", NULL)
					ply:SetNWAngle("ViewAngles", Angle(0,0,0))
					ply:GodDisable()
				end
			end
			ProceedChangePremiumRoles()
		end)
	end)

end

local function start_command_setwarnings(steamid64, num)

	local result = sql.Query("SELECT warnings FROM awarn_playerdata WHERE unique_id = "..SQLStr(steamid64))

	newMysql.query("SELECT warnings FROM awarn_playerdata WHERE unique_id = "..SQLStr(steamid64), function(result)

        if !result then
        		newMysql.query("INSERT INTO awarn_playerdata VALUES ("..SQLStr(steamid64)..", "..SQLStr(num)..", "..SQLStr(os.time())..")", function() end)
			else
				newMysql.query("UPDATE awarn_playerdata SET warnings = "..SQLStr(num)..", lastwarn = "..SQLStr(os.time()).." WHERE unique_id = "..SQLStr(steamid64), function() end)
			end

    end, function() print("пошел нахуй") end)

end

hook.Add("PlayerShouldTakeDamage", "AntiTeamkill", function( ply, attacker )
	if !attacker:IsPlayer() then
		return
	end

	if attacker:GTeam() == TEAM_ARENA then
		return
	end

	if BREACH.DisableTeamKills and ply:GTeam() == attacker:GTeam() then
		return false
	end
end)

function BREACH.PowerfulARSupport(caller, ent)
	--SCP079_SPAWN()
	if postround then
		--return
	end

	local pickedsupport = "AR"

	local maxamount = 7
	PlayAnnouncer( "nextoren/round_sounds/intercom/support/enemy_enter.ogg" )
	local pickedplayers = {}
	pickedplayers[#pickedplayers] = caller
	if !SPAWNEDPLAYERSASSUPPORT then SPAWNEDPLAYERSASSUPPORT = {} end

	local pick = 0

	if forcesupportplys then
		for _, ply in pairs(forcesupportplys) do
			if pick >= maxamount then break end
			SPAWNEDPLAYERSASSUPPORT[#SPAWNEDPLAYERSASSUPPORT + 1] = ply
			pickedplayers[#pickedplayers + 1] = ply
			pick = pick + 1
		end
		forcesupportplys = nil
	end

	for _, ply in RandomPairs(GetActivePlayers()) do
		print(ply)
		if pick >= maxamount then break end
		if ply:GTeam() != TEAM_SPEC then continue end
		if ply.SpawnAsSupport == false then continue end
		if ply:GetPenaltyAmount() > 0 then continue end
		if LevelRequiredForSupport[pickedsupport] and ply:GetNLevel() < LevelRequiredForSupport[pickedsupport] then continue end
		SPAWNEDPLAYERSASSUPPORT[#SPAWNEDPLAYERSASSUPPORT + 1] = ply
		pickedplayers[#pickedplayers + 1] = ply
		print(ply)
		if ply.LuckyOne then
			ply:CompleteAchievement("lucky")
		else
			ply.LuckyOne = true
		end
		pick = pick + 1
	end

	for _, ply in pairs(player.GetAll()) do
		if !table.HasValue(pickedplayers, ply) then
			ply.LuckyOne = false
		end 
	end

	local supinuse = {}
	local supspawns = table.Copy( NEW_AR_SPAWN )
	local sups = {}

	local notp = cutscene != 0

	
	BREACH.QueuedSupports = {}
	net.Start("SelectRole_Sync")
	net.WriteTable(BREACH.QueuedSupports)
	net.Broadcast()

	for i = 1, #pickedplayers do
		local ply = pickedplayers[i]

		local suproles = table.Copy( GetSupportRoleTable(pickedsupport) )
		local selected

		local shouldselectrole = true

		if shouldselectrole then
			repeat
				local role = table.remove( suproles, math.random( #suproles ) )
				supinuse[role.name] = supinuse[role.name] or 0

				if role.max == 0 or supinuse[role.name] < role.max then
					if role.level <= ply:GetNLevel() then
						if !role.customcheck or role.customcheck( ply ) then
							supinuse[role.name] = supinuse[role.name] + 1
							selected = role
							break
						end
					end
				end
			until #suproles == 0
		end

		local spawn = table.remove( supspawns, math.random( #supspawns ) )

		ply:SetupNormal()
		--timer.Simple(0.1, function()
			--ply:FadeMusic(17)
		--end)
		ply:ApplyRoleStats( selected )
		ply:SetPos( spawn )
		timer.Simple(5, function()
			if ply:IsPremium() and ply.CanSwitchRole != true then
				timer.Simple(45, function()
					if IsValid(ply) then
						ply.CanSwitchRole = false
					end
			   end)
				ply.CanSwitchRole = true
				ply:SendLua("Select_Supp_Menu(LocalPlayer():GTeam())")
			end
		end)
		ply:Freeze(false)
	end

	BREACH.QueuedSupports = {}
	net.Start("SelectRole_Sync")
	net.WriteTable(BREACH.QueuedSupports)
	net.Broadcast()
end

function BREACH.PowerfulGRUSupport(caller,ent)
	if postround then
		--return
	end

	local pickedsupport = "GRU"

	local maxamount = 6
	--PlayAnnouncer( "nextoren/round_sounds/intercom/support/fbi_enter.ogg" )
	local pickedplayers = {}
	if !SPAWNEDPLAYERSASSUPPORT then SPAWNEDPLAYERSASSUPPORT = {} end

	local pick = 0

	if forcesupportplys then
		for _, ply in pairs(forcesupportplys) do
			if pick >= maxamount then break end
			SPAWNEDPLAYERSASSUPPORT[#SPAWNEDPLAYERSASSUPPORT + 1] = ply
			pickedplayers[#pickedplayers + 1] = ply
			pick = pick + 1
		end
		forcesupportplys = nil
	end

	for _, ply in RandomPairs(GetActivePlayers()) do
		print(ply)
		if pick >= maxamount then break end
		if ply:GTeam() != TEAM_SPEC then continue end
		if ply.SpawnAsSupport == false then continue end
		if ply:GetPenaltyAmount() > 0 then continue end
		if LevelRequiredForSupport[pickedsupport] and ply:GetNLevel() < LevelRequiredForSupport[pickedsupport] then continue end
		SPAWNEDPLAYERSASSUPPORT[#SPAWNEDPLAYERSASSUPPORT + 1] = ply
		pickedplayers[#pickedplayers + 1] = ply
		print(ply)
		if ply.LuckyOne then
			ply:CompleteAchievement("lucky")
		else
			ply.LuckyOne = true
		end
		pick = pick + 1
	end

	for _, ply in pairs(player.GetAll()) do
		if !table.HasValue(pickedplayers, ply) then
			ply.LuckyOne = false
		end 
	end
	timer.Simple(23, function()
	PlayAnnouncer( "nextoren/round_sounds/intercom/support/enemy_enter.ogg" )
	GRU_SPAWN_DOCK()
	local heli = ents.Create("gru_heli")
	heli:Spawn()
	end)

	local supinuse = {}
	local supspawns = table.Copy( SPAWN_OUTSIDE_FBI )
	local sups = {}

	local notp = cutscene != 0

	for i = 1, #pickedplayers do
		local ply = pickedplayers[i]

		local suproles = table.Copy( GetSupportRoleTable(pickedsupport) )
		local selected

		local shouldselectrole = true

		if shouldselectrole then
			repeat
				local role = table.remove( suproles, math.random( #suproles ) )
				supinuse[role.name] = supinuse[role.name] or 0

				if role.max == 0 or supinuse[role.name] < role.max then
					if role.level <= ply:GetNLevel() then
						if !role.customcheck or role.customcheck( ply ) then
							supinuse[role.name] = supinuse[role.name] + 1
							selected = role
							break
						end
					end
				end
			until #suproles == 0
		end

		local spawn = table.remove( supspawns, math.random( #supspawns ) )

		ply:SetupNormal()
		--timer.Simple(0.1, function()
			--ply:FadeMusic(17)
		--end)
		ply:ApplyRoleStats( selected )
		ply:SetPos( spawn )
		timer.Simple(5, function()
			if ply:IsPremium() and ply.CanSwitchRole != true then
				timer.Simple(45, function()
					if IsValid(ply) then
						ply.CanSwitchRole = false
					end
			   end)
				ply.CanSwitchRole = true
				ply:SendLua("Select_Supp_Menu(LocalPlayer():GTeam())")
			end
		end)
		ply:Freeze(true)

		if IsValid(ply) then

			timer.Simple(23, function()
				ply:NTF_Scene()
			end)
		--	ply:NTF_Scene()
		end
	end

	cutsceneinprogress = true
	PerformGRUCutscene(pickedplayers)

	BREACH.QueuedSupports = {}
	net.Start("SelectRole_Sync")
	net.WriteTable(BREACH.QueuedSupports)
	net.Broadcast()

	PlayAnnouncer("nextoren/round_sounds/intercom/support/onpzahod.ogg")
end

function SpwanUIUPC()

local existing_monitors = ents.FindByClass("onp_monitor")
if #existing_monitors >= 1 then
    return
end

local spawntable = table.Copy(SPAWN_FBI_MONITORS)

for i = 1, 5 do
    if #spawntable == 0 then break end
    
    local selectedindx = math.random(1, #spawntable)
    local onp_monitor = ents.Create("onp_monitor")
    onp_monitor:SetPos(spawntable[selectedindx].pos)
    onp_monitor:SetAngles(spawntable[selectedindx].ang)
    onp_monitor:Spawn()
    onp_monitor:SetAngles(spawntable[selectedindx].ang)
    table.remove(spawntable, selectedindx)
end
end

BREACH.PowerfulUIUSupportDelayed = false
function BREACH.PowerfulUIULSupport(caller,ent,hm)
	if postround then
		--return
	end

	local pickedsupport = "FBI_L"
	if hm == nil then
        hm = 7
    end
	local maxamount = hm
	PlayAnnouncer( "nextoren/round_sounds/intercom/support/fbi_enter.ogg" )
	local pickedplayers = {}
	if !SPAWNEDPLAYERSASSUPPORT then SPAWNEDPLAYERSASSUPPORT = {} end


	local pick = 0

	if forcesupportplys then
		for _, ply in pairs(forcesupportplys) do
			if pick >= maxamount then break end
			SPAWNEDPLAYERSASSUPPORT[#SPAWNEDPLAYERSASSUPPORT + 1] = ply
			pickedplayers[#pickedplayers + 1] = ply
			pick = pick + 1
		end
		forcesupportplys = nil
	end

	for _, ply in RandomPairs(GetActivePlayers()) do
		print(ply)
		if pick >= maxamount then break end
		if ply:GTeam() != TEAM_SPEC then continue end
		if ply.SpawnAsSupport == false then continue end
		if ply:GetPenaltyAmount() > 0 then continue end
		if LevelRequiredForSupport[pickedsupport] and ply:GetNLevel() < LevelRequiredForSupport[pickedsupport] then continue end
		SPAWNEDPLAYERSASSUPPORT[#SPAWNEDPLAYERSASSUPPORT + 1] = ply
		pickedplayers[#pickedplayers + 1] = ply
		print(ply)
		if ply.LuckyOne then
			ply:CompleteAchievement("lucky")
		else
			ply.LuckyOne = true
		end
		pick = pick + 1
	end

	for _, ply in pairs(player.GetAll()) do
		if !table.HasValue(pickedplayers, ply) then
			ply.LuckyOne = false
		end 
	end

	SpwanUIUPC()

	local supinuse = {}
	local supspawns = table.Copy( SPAWN_OUTSIDE_FBIKJ )
	local sups = {}

	local notp = cutscene != 0

	for i = 1, #pickedplayers do
		local ply = pickedplayers[i]

		local suproles = table.Copy( BREACH_ROLES.FBI.fbi.roles )
		local selected

		local shouldselectrole = true

		if shouldselectrole then
			repeat
				local role = table.remove( suproles, math.random( #suproles ) )
				supinuse[role.name] = supinuse[role.name] or 0

				if role.max == 0 or supinuse[role.name] < role.max then
					if role.level <= ply:GetNLevel() then
						if !role.customcheck or role.customcheck( ply ) then
							supinuse[role.name] = supinuse[role.name] + 1
							selected = role
							break
						end
					end
				end
			until #suproles == 0
		end

		local spawn = table.remove( supspawns, math.random( #supspawns ) )

		ply:SetupNormal()
		ply:bSendLua("UIULJStart()")
		--timer.Simple(0.1, function()
			--ply:FadeMusic(17)
		--end)
		ply:ApplyRoleStats( selected )
		ply:SetPos( spawn )
		ply:Freeze(true)

		if IsValid(ply) then
			ply:NTF_Scene()
		end
	end

	BREACH.QueuedSupports = {}
	net.Start("SelectRole_Sync")
	net.WriteTable(BREACH.QueuedSupports)
	net.Broadcast()

	timer.Simple(3, function()
		for i, v in pairs(player.GetAll()) do
			if v:GTeam() == TEAM_USA and v:IsPremium() and !string.lower(v:GetRoleName()):find("spy") and !BREACH:IsUiuAgent(v:GetRoleName()) then
				timer.Simple(45, function()
					if IsValid(v) then
						v.CanSwitchRole = false
					end
			   end)
				v.CanSwitchRole = true
				v:bSendLua("Select_Supp_Menu(TEAM_USA)")
			end
		end
	end)

	PlayAnnouncer("nextoren/round_sounds/intercom/support/onpzahod.ogg")
end

function BREACH.PowerfulETTSupport(caller, ent, hm)
	if postround then
		--return
	end

	local pickedsupport = "ETT"
	
    if hm == nil then
        hm = 4
    end
	
	local maxamount = hm

	local pickedplayers = {}
	pickedplayers[#pickedplayers] = caller
	if !SPAWNEDPLAYERSASSUPPORT then SPAWNEDPLAYERSASSUPPORT = {} end

		timer.Simple(13, function()
		--BREACH.Players:ChatPrint( player.GetAll(), true, true, "[通讯]ETTRA外勤增援已抵达" )
		for _, ply in ipairs(player.GetAll()) do
		ply:BrTip( 0, "[潜在威胁战术响应局]", Color(0, 110, 255), "外勤增援已抵达", Color(255, 255, 255) )
		end
		local faf_call = ents.Create("faf_call")
    	faf_call:Spawn()
		PlayAnnouncer("nextoren/round_sounds/intercom/support_new/ett.mp3")
		end)

	local pick = 0

	if forcesupportplys then
		for _, ply in pairs(forcesupportplys) do
			if pick >= maxamount then break end
			SPAWNEDPLAYERSASSUPPORT[#SPAWNEDPLAYERSASSUPPORT + 1] = ply
			pickedplayers[#pickedplayers + 1] = ply
			pick = pick + 1
		end
		forcesupportplys = nil
	end

	for _, ply in RandomPairs(GetActivePlayers()) do
		print(ply)
		if pick >= maxamount then break end
		if ply:GTeam() != TEAM_SPEC then continue end
		if ply.SpawnAsSupport == false then continue end
		if ply:GetPenaltyAmount() > 0 then continue end
		if LevelRequiredForSupport[pickedsupport] and ply:GetNLevel() < LevelRequiredForSupport[pickedsupport] then continue end
		SPAWNEDPLAYERSASSUPPORT[#SPAWNEDPLAYERSASSUPPORT + 1] = ply
		pickedplayers[#pickedplayers + 1] = ply
		print(ply)
		if ply.LuckyOne then
			ply:CompleteAchievement("lucky")
		else
			ply.LuckyOne = true
		end
		pick = pick + 1
	end

	for _, ply in pairs(player.GetAll()) do
		if !table.HasValue(pickedplayers, ply) then
			ply.LuckyOne = false
		end 
	end

	local supinuse = {}
	local supspawns = table.Copy( SPAWN_OUTSIDE_ETT )
	local sups = {}

	local notp = cutscene != 0

	for i = 1, #pickedplayers do
		local ply = pickedplayers[i]

		local suproles = table.Copy( GetSupportRoleTable(pickedsupport) )
		local selected

		local shouldselectrole = true

		if shouldselectrole then
			repeat
				local role = table.remove( suproles, math.random( #suproles ) )
				supinuse[role.name] = supinuse[role.name] or 0

				if role.max == 0 or supinuse[role.name] < role.max then
					if role.level <= ply:GetNLevel() then
						if !role.customcheck or role.customcheck( ply ) then
							supinuse[role.name] = supinuse[role.name] + 1
							selected = role
							break
						end
					end
				end
			until #suproles == 0
		end

		local spawn = table.remove( supspawns, math.random( #supspawns ) )
		ply:SetupNormal()
		ply:bSendLua("ETTStart()")
		--timer.Simple(0.1, function()
			--ply:FadeMusic(17)
		--end)
		ply:ApplyRoleStats( selected )
		ply:SetPos( spawn )
		ply:Freeze(false)
		timer.Simple( 23, function()
			ply:NTF_Scene()
		end)
	end

	BREACH.QueuedSupports = {}
	net.Start("SelectRole_Sync")
	net.WriteTable(BREACH.QueuedSupports)
	net.Broadcast()
	timer.Simple(0.1, function()
		for i, v in pairs(player.GetAll()) do
			if v:GTeam() == TEAM_ETT and v:IsPremium() and !string.lower(v:GetRoleName()):find("spy") then
				timer.Simple(45, function()
					if IsValid(v) then
						v.CanSwitchRole = false
					end
			   end)
				v.CanSwitchRole = true
				v:bSendLua("Select_Supp_Menu(TEAM_ETT)")
			end
		end
	end)
end

function BREACH.PowerfulFAFSupport(caller, ent, hm)
	if postround then
		--return
	end

	local pickedsupport = "FAF"
	
    if hm == nil then
        hm = 10
    end
	
	local maxamount = hm

	local pickedplayers = {}
	pickedplayers[#pickedplayers] = caller
	if !SPAWNEDPLAYERSASSUPPORT then SPAWNEDPLAYERSASSUPPORT = {} end

		timer.Simple(13, function()
		BREACH.Players:ChatPrint( player.GetAll(), true, true, "[通讯]FAF外勤增援已抵达" )
		end)

	local pick = 0

	if forcesupportplys then
		for _, ply in pairs(forcesupportplys) do
			if pick >= maxamount then break end
			SPAWNEDPLAYERSASSUPPORT[#SPAWNEDPLAYERSASSUPPORT + 1] = ply
			pickedplayers[#pickedplayers + 1] = ply
			pick = pick + 1
		end
		forcesupportplys = nil
	end

	for _, ply in RandomPairs(GetActivePlayers()) do
		print(ply)
		if pick >= maxamount then break end
		if ply:GTeam() != TEAM_SPEC then continue end
		if ply.SpawnAsSupport == false then continue end
		if ply:GetPenaltyAmount() > 0 then continue end
		if LevelRequiredForSupport[pickedsupport] and ply:GetNLevel() < LevelRequiredForSupport[pickedsupport] then continue end
		SPAWNEDPLAYERSASSUPPORT[#SPAWNEDPLAYERSASSUPPORT + 1] = ply
		pickedplayers[#pickedplayers + 1] = ply
		print(ply)
		if ply.LuckyOne then
			ply:CompleteAchievement("lucky")
		else
			ply.LuckyOne = true
		end
		pick = pick + 1
	end

	for _, ply in pairs(player.GetAll()) do
		if !table.HasValue(pickedplayers, ply) then
			ply.LuckyOne = false
		end 
	end

	local supinuse = {}
	local supspawns = table.Copy( SPAWN_OBR )
	local sups = {}

	local notp = cutscene != 0

	for i = 1, #pickedplayers do
		local ply = pickedplayers[i]

		local suproles = table.Copy( GetSupportRoleTable(pickedsupport) )
		local selected

		local shouldselectrole = true

		if shouldselectrole then
			repeat
				local role = table.remove( suproles, math.random( #suproles ) )
				supinuse[role.name] = supinuse[role.name] or 0

				if role.max == 0 or supinuse[role.name] < role.max then
					if role.level <= ply:GetNLevel() then
						if !role.customcheck or role.customcheck( ply ) then
							supinuse[role.name] = supinuse[role.name] + 1
							selected = role
							break
						end
					end
				end
			until #suproles == 0
		end

		local spawn = table.remove( supspawns, math.random( #supspawns ) )
		ply:SetupNormal()
		ply:bSendLua("FAFStart()")
		--timer.Simple(0.1, function()
			--ply:FadeMusic(17)
		--end)
		ply:ApplyRoleStats( selected )
		ply:SetPos( spawn )
		ply:Freeze(false)
		if IsValid(ply) then
		end
	end

	BREACH.QueuedSupports = {}
	net.Start("SelectRole_Sync")
	net.WriteTable(BREACH.QueuedSupports)
	net.Broadcast()
	timer.Simple(0.1, function()
		for i, v in pairs(player.GetAll()) do
			if v:GTeam() == TEAM_FAF and v:IsPremium() and !string.lower(v:GetRoleName()):find("spy") then
				timer.Simple(45, function()
					if IsValid(v) then
						v.CanSwitchRole = false
					end
			   end)
				v.CanSwitchRole = true
				v:bSendLua("Select_Supp_Menu(TEAM_FAF)")
			end
		end
	end)
end

function BREACH.PowerfulUIUTG2Support(caller, ent, hm)
	if postround then
		--return
	end

	local pickedsupport = "UIU_ST"
	
    if hm == nil then
        hm = 5
    end
	
	local maxamount = hm
	--PlayAnnouncer( "nextoren/round_sounds/intercom/support/fbi_enter.ogg" )
	
	local pickedplayers = {}
	pickedplayers[#pickedplayers] = caller
	if !SPAWNEDPLAYERSASSUPPORT then SPAWNEDPLAYERSASSUPPORT = {} end


	local pick = 0

	if forcesupportplys then
		for _, ply in pairs(forcesupportplys) do
			if pick >= maxamount then break end
			SPAWNEDPLAYERSASSUPPORT[#SPAWNEDPLAYERSASSUPPORT + 1] = ply
			pickedplayers[#pickedplayers + 1] = ply
			pick = pick + 1
		end
		forcesupportplys = nil
	end

	for _, ply in RandomPairs(GetActivePlayers()) do
		print(ply)
		if pick >= maxamount then break end
		if ply:GTeam() != TEAM_SPEC then continue end
		if ply.SpawnAsSupport == false then continue end
		if ply:GetPenaltyAmount() > 0 then continue end
		if LevelRequiredForSupport[pickedsupport] and ply:GetNLevel() < LevelRequiredForSupport[pickedsupport] then continue end
		SPAWNEDPLAYERSASSUPPORT[#SPAWNEDPLAYERSASSUPPORT + 1] = ply
		pickedplayers[#pickedplayers + 1] = ply
		print(ply)
		if ply.LuckyOne then
			ply:CompleteAchievement("lucky")
		else
			ply.LuckyOne = true
		end
		pick = pick + 1
	end

	for _, ply in pairs(player.GetAll()) do
		if !table.HasValue(pickedplayers, ply) then
			ply.LuckyOne = false
		end 
	end

	local supinuse = {}
	local supspawns = table.Copy( SPAWN_OUTSIDE )
	local sups = {}

	local notp = cutscene != 0

	for i = 1, #pickedplayers do
		local ply = pickedplayers[i]

		local suproles = table.Copy( BREACH_ROLES.FBI_AGENTS.fbi_agents.roles )
		local selected

		local shouldselectrole = true

		if shouldselectrole then
			repeat
				local role = table.remove( suproles, math.random( #suproles ) )
				supinuse[role.name] = supinuse[role.name] or 0

				if role.max == 0 or supinuse[role.name] < role.max then
					if role.level <= ply:GetNLevel() then
						if !role.customcheck or role.customcheck( ply ) then
							supinuse[role.name] = supinuse[role.name] + 1
							selected = role
							break
						end
					end
				end
			until #suproles == 0
		end

		local spawn = table.remove( supspawns, math.random( #supspawns ) )

		SpwanUIUPC()
		ply:SetupNormal()
		ply:bSendLua("UAStart()")
		ply:ApplyRoleStats( selected )
		ply:SetPos( spawn )
		cutsceneinprogress = true
		PerformFBICutscene()
		ply:Freeze(false)
		if IsValid(ply) then
		end
	end

	BREACH.QueuedSupports = {}
	net.Start("SelectRole_Sync")
	net.WriteTable(BREACH.QueuedSupports)
	net.Broadcast()

	timer.Simple(22.5, function()
		for i, v in pairs(player.GetAll()) do
			if v:GTeam() == TEAM_USA and v:IsPremium() and !string.lower(v:GetRoleName()):find("spy") and BREACH:IsUiuAgent(v:GetRoleName()) then
				timer.Simple(45, function()
					if IsValid(v) then
						v.CanSwitchRole = false
					end
			   end)
				v.CanSwitchRole = true
				v:bSendLua("Select_Supp_Menu(TEAM_USA)")
			end
		end
	end)
end

BREACH.PowerfulUIUSupportDelayed = false
function BREACH.PowerfulUIUSupport(caller,ent)
	if postround then
		--return
	end

	local jeep_1 = ents.Create("prop_vehicle_jeep")
	jeep_1:SetModel("models/scpcars/scpp_wrangler_fnf.mdl")
	jeep_1:SetKeyValue("vehiclescript", "scripts/vehicles/wrangler88.txt")
	jeep_1:SetPos(Vector(4130.977051, -10446.078125, 2050))  
	jeep_1:SetAngles(Angle(0, 180, 0))
	jeep_1:Spawn()
	jeep_1.Locked = false
	jeep_1.FBI_VEH = true

	local jeep_2 = ents.Create("prop_vehicle_jeep")
	jeep_2:SetModel("models/scpcars/scpp_wrangler_fnf.mdl")
	jeep_2:SetKeyValue("vehiclescript", "scripts/vehicles/wrangler88.txt")
	jeep_2:SetPos(Vector(4123.242676, -9947.328125, 2041))  
	jeep_2:SetAngles(Angle(0, 180, 0))
	jeep_2:Spawn()
	jeep_2.Locked = false
	jeep_2.FBI_VEH = true

	local pickedsupport = "FBI_SHTURM"

	local maxamount = 7
	--PlayAnnouncer( "nextoren/round_sounds/intercom/support/fbi_enter.ogg" )
	local pickedplayers = {}
	if !SPAWNEDPLAYERSASSUPPORT then SPAWNEDPLAYERSASSUPPORT = {} end

	local pick = 0

	if forcesupportplys then
		for _, ply in pairs(forcesupportplys) do
			if pick >= maxamount then break end
			SPAWNEDPLAYERSASSUPPORT[#SPAWNEDPLAYERSASSUPPORT + 1] = ply
			pickedplayers[#pickedplayers + 1] = ply
			pick = pick + 1
		end
		forcesupportplys = nil
	end

	for _, ply in RandomPairs(GetActivePlayers()) do
		--print(ply)
		if pick >= maxamount then break end
		if ply:GTeam() != TEAM_SPEC then continue end
		if ply.SpawnAsSupport == false then continue end
		if ply:GetPenaltyAmount() > 0 then continue end
		if LevelRequiredForSupport[pickedsupport] and ply:GetNLevel() < LevelRequiredForSupport[pickedsupport] then continue end
		SPAWNEDPLAYERSASSUPPORT[#SPAWNEDPLAYERSASSUPPORT + 1] = ply
		pickedplayers[#pickedplayers + 1] = ply
		--print(ply)
		if ply.LuckyOne then
			ply:CompleteAchievement("lucky")
		else
			ply.LuckyOne = true
		end
		pick = pick + 1
	end

	for _, ply in pairs(player.GetAll()) do
		if !table.HasValue(pickedplayers, ply) then
			ply.LuckyOne = false
		end 
	end

	local supinuse = {}
	local supspawns = {
		Vector(4440.2338867188, -10545.510742188, 1952.03125),
		Vector(4444.3193359375, -10384.491210938, 1952.03125),
		Vector(4439.2895507813, -10223.57421875, 1952.03125),
		Vector(4434.728515625, -10055.639648438, 1952.03125),
		Vector(4432.03125, -9901.6611328125, 1952.03125),
		Vector(4429.0654296875, -9761.6962890625, 1952.03125),		
	}
	local sups = {}

	local notp = cutscene != 0

		
	BREACH.QueuedSupports = {}
	net.Start("SelectRole_Sync")
	net.WriteTable(BREACH.QueuedSupports)
	net.Broadcast()

	for i = 1, #pickedplayers do
		local ply = pickedplayers[i]

		local suproles = table.Copy( BREACH_ROLES.FBI_AGENTS.fbi_agents.roles )
		local selected

		local shouldselectrole = true

		if shouldselectrole then
			repeat
				local role = table.remove( suproles, math.random( #suproles ) )
				supinuse[role.name] = supinuse[role.name] or 0

				if role.max == 0 or supinuse[role.name] < role.max then
					if role.level <= ply:GetNLevel() then
						if !role.customcheck or role.customcheck( ply ) then
							supinuse[role.name] = supinuse[role.name] + 1
							selected = role
							break
						end
					end
				end
			until #suproles == 0
		end

		local spawn = table.remove( supspawns, math.random( #supspawns ) )

		ply:SetupNormal()
		ply:ApplyRoleStats( selected )
		ply:SetPos( spawn )
		timer.Simple(5, function()
			if ply:IsPremium() and ply.CanSwitchRole != true then
				timer.Simple(45, function()
					if IsValid(ply) then
						ply.CanSwitchRole = false
					end
			   end)
				ply.CanSwitchRole = true
				ply:SendLua("Select_Supp_Menu(LocalPlayer():GTeam())")
			end
		end)
		local veh = jeep_1
		jeep_1.Locked = false
		--timer.Simple(i * 1, function()
		--	jeep_1.Locked = false
		--	if IsValid(ply) then
		--		
--
		--		ply:EmitSound( "nextoren/vehicle/car_engine_startredux.wav" )
--
		--		timer.Simple( 2.7, function()
		--			ply:EmitSound( "nextoren/vehicle/car_seatbelt_in.wav" )
		--		end )
--
		--		timer.Simple( 5.7, function()
		--			ply:EmitSound( "nextoren/vehicle/car_seatbelt_in2.wav" )
		--		end)
		--		--ply:EnterVehicle(jeep_1)
		--		VD2_EnterVehicle(ply,jeep_1)
		--		print("тестик")
		--		if i == 1 then
		--			ply:GetVehicle().TurnedOff = false
		--			timer.Simple( 1.4, function() ply:GetVehicle():Fire( "turnon", "", 0 ) ply:EmitSound( "nextoren/vehicle/car_seatbeltalarm.wav" ) end)
		--			timer.Simple(5, function()
		--				ply:bSendLua([[
		--					RunConsoleCommand("+forward")
		--					local client = LocalPlayer()
		--					client.FBI_SOFTLOCK = vgui.Create("DPanel")
		--					client.FBI_SOFTLOCK:SetPos(0, 0)
		--					client.FBI_SOFTLOCK:SetSize(0, 0)
		--					client.FBI_SOFTLOCK:SetKeyboardInputEnabled(true)
		--					client.FBI_SOFTLOCK.DeleteTime = CurTime() + 10
		--					client.FBI_SOFTLOCK.Think = function(self)
		--						if self.DeleteTime < CurTime() then
		--							RunConsoleCommand("-forward")
		--							self:Remove()
		--						end
		--					end
		--				]])
		--			end)
		--		end
		--	end
		--end)
	end
	

	BREACH.QueuedSupports = {}
	net.Start("SelectRole_Sync")
	net.WriteTable(BREACH.QueuedSupports)
	net.Broadcast()

	PlayAnnouncer("nextoren/round_sounds/intercom/support/onpzahod.ogg")
end

function PerformNTFCutscene()

	local NTFS = {}

	for _, ply in pairs(player.GetAll()) do
		if ply:GTeam() == TEAM_NTF then
			NTFS[#NTFS + 1] = ply
		end
	end

	local poses = {

		{pos = Vector(-10669.291016, -9, 1813.986816), ang = Angle(0,0.1,0), sequences = {"d1_t02_Plaza_Sit01_Idle", "d1_t02_Plaza_Sit02"}},
		{pos = Vector(-10669.291016, 30, 1813.986816), ang = Angle(0,0.1,0), sequences = {"d1_t02_Plaza_Sit01_Idle", "d1_t02_Plaza_Sit02"}},

		{pos = Vector(-10688.330078, -9, 1815.198730), ang = Angle(0,180,0), sequences = {"d1_t02_Plaza_Sit01_Idle", "d1_t02_Plaza_Sit02"}},
		{pos = Vector(-10688.330078, 30, 1815.198730), ang = Angle(0,180,0), sequences = {"d1_t02_Plaza_Sit01_Idle", "d1_t02_Plaza_Sit02"}},

		{pos = Vector(-10670.019531, -38.297939, 1813.780762), ang = Angle(0,70,0), sequences = {"d1_t01_trainride_stand"}},

	}

	local fake_skybox = ents.Create("fake_skybox")
	fake_skybox:SetPos(Vector(-12195.40625, 1010, 2649.53125))
	fake_skybox:Spawn()

	local vert = ents.Create("prop_dynamic")
	vert:SetModel("models/comradealex/mgs5/hp-48/hp-48test.mdl")
	vert:SetPos(Vector(-10679.3, -19.276970, 1765.031250))
	vert:Spawn()

	for _, ntf in ipairs(NTFS) do
		local sel = table.remove(poses, math.random(1,#poses))

		ntf:SetMoveType(MOVETYPE_NONE)
		ntf:SetNWEntity("NTF1Entity", ntf)
		ntf:SetNWAngle("ViewAngles", sel.ang)
		ntf:SetPos(sel.pos)
		ntf:SetCollisionGroup(COLLISION_GROUP_WORLD)

		ntf:SetForcedAnimation(table.Random(sel.sequences), math.huge)
		ntf:SetCycle(math.Rand(0,1))

		local uid = "freeze"..ntf:SteamID64()

		timer.Create(uid, 0, 0, function()
			if ntf:GTeam() != TEAM_NTF then
				timer.Remove(uid)
				return
			end
			if !IsValid(vert) then
				timer.Remove(uid)
				return
			end
			ntf:SetPos(sel.pos)
		end)

	end


	timer.Simple(30, function()
		for _, ply in ipairs(NTFS) do
			if IsValid(ply) and ply:GTeam() == TEAM_NTF then ply:ScreenFade(SCREENFADE.IN, Color(0,0,0), 1, 3) end
		end
		timer.Simple(2, function()
			if IsValid(vert) then vert:Remove() end
			if IsValid(fake_skybox) then fake_skybox:Remove() end
			for i, ply in ipairs(NTFS) do
				if IsValid(ply) and ply:GTeam() == TEAM_NTF then
					timer.Remove("freeze"..ply:SteamID64())
					ply:SetPos(SPAWN_OUTSIDE[i])
					ply:StopForcedAnimation()
					--ply:Freeze(false)
					ply:SetCollisionGroup(COLLISION_GROUP_PLAYER)
					ply:SetMoveType(MOVETYPE_WALK)
					ply:SetNWEntity("NTF1Entity", NULL)
					ply:SetNWAngle("ViewAngles", Angle(0,0,0))
					ply:GodDisable()
				end
			end
		end)
	end)


end

local function restoftabletostring(start, tab)

	local str = ""

	for i = start, #tab do
		str = str.." "..tab[i]
	end

	return string.sub(str, 2)

end

function string.Shaky_FormattedTime( seconds, format )
	if ( not seconds ) then seconds = 0 end
	local years = math.floor( seconds / 31536000 )
	if years > 0 then
		seconds = seconds - 31536000 * years
	end
	local months = math.floor( seconds / 2592000 )
	if months > 0 then
		seconds = seconds - 2592000 * months
	end
	local weeks = math.floor( seconds / 604800 )
	if weeks > 0 then
		seconds = seconds - 604800 * weeks
	end
	local days = math.floor( seconds / 86400 )
	if days > 0 then
		seconds = seconds - 86400 * days
	end
	local hours = math.floor( seconds / 3600 )
	if hours > 0 then
		seconds = seconds - 3600 * hours
	end
	local minutes = math.floor( seconds / 60 )
	if minutes > 0 then
		seconds = seconds - 60 * minutes
	end

	if ( format ) then
		return string.format( format, minutes, seconds )
	else
		return { y = years, w = weeks, m = months, d = days, h = hours, min = minutes, s = seconds }
	end
end

concommand.Add("restart_server", function(ply)
	if IsValid(ply) then return end
	SetGlobalInt("RoundUntilRestart", 0)
end)

local num_values = {
	["s"] = 1,
	["m"] = 60,
	["h"] = 3600,
	["d"] = 86400,
	["w"] = 604800,
	["mon"] = 2592000,
	["y"] = 31536000,
}

function StringToTime(str)

	if tonumber(str) then
		return tonumber(str)
	end

	local num = 1

	for name, value in pairs(num_values) do
		if str:EndsWith(name) then
			num = tonumber(string.sub(str, 0, #str-#name))
			num = num * value
			break
		end
	end

	return num

end

function string.NiceTime_Full_Eng( seconds )

	local list = string.Shaky_FormattedTime( seconds )

	local min = "l:nt_min"
	local day = "l:nt_d"
	local year = "l:nt_y"
	local month = "l:nt_m"
	local second = "l:nt_s"
	local hour = "l:nt_h"
	local week = "l:nt_w"

	local str = ""

	for t, v in pairs(list) do

		if v == 0 then continue end

		local strtime = tostring(v)

		if v > 1 then

			if t == "m" then

				month = "l:nt_ms"

			elseif t == "y" then

				year = "l:nt_ys"

			elseif t == "d" then

				day = "l:nt_ds"

			elseif t == "h" then

				hour = "l:nt_hs"

			elseif t == "min" then

				min = "l:nt_mins"

			elseif t == "w" then

				week = "l:nt_ws"

			elseif t == "s" then

				second = "l:nt_ss"

			end
		end

	end

	local tab = {}

	if list.y > 0 then
		tab[#tab + 1] = list.y.." "..year
	end

	if list.m > 0 then
		tab[#tab + 1] = list.m.." "..month
	end

	if list.w > 0 then
		tab[#tab + 1] = list.w.." "..week
	end

	if list.d > 0 then
		tab[#tab + 1] = list.d.." "..day
	end

	if list.h > 0 then
		tab[#tab + 1] = list.h.." "..hour
	end

	if list.min > 0 then
		tab[#tab + 1] = list.min.." "..min
	end

	if list.s > 0 then
		tab[#tab + 1] = list.s.." "..second
	end

	for i = 1, #tab do
		if i != 1 then
			if i == #tab then
				str = str.." and"
			else
				str = str.." ,"
			end
		end
		str = str.." "..tab[i]
	end

	print(str)

	return string.sub(str, 2)

end

string.NiceTime_Full_Rus = string.NiceTime_Full_Eng -- LAZY FUCK :DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD

function WarheadDisabled( siren )
	OMEGAEnabled = false
	OMEGADoors = false

	--if siren then
		--siren:Stop()
	--end
	net.Start( "SendSound" )
		net.WriteInt( 0, 2 )
		net.WriteString( "warhead/siren.ogg" )
	net.Broadcast()

	if timer.Exists( "omega_check" ) then timer.Remove( "omega_check" ) end
	if timer.Exists( "omega_alarm" ) then timer.Remove( "omega_alarm" ) end
	if timer.Exists( "omega_detonation" ) then timer.Remove( "omega_detonation" ) end
	
	for k, v in pairs( ents.FindByClass( "func_door" ) ) do
		if IsInTolerance( OMEGA_GATE_A_DOORS[1], v:GetPos(), 100 ) or IsInTolerance( OMEGA_GATE_A_DOORS[2], v:GetPos(), 100 ) then
			v:Fire( "Unlock" )
			v:Fire( "Close" )
		end
	end
end

function GM:BreachSCPDamage( ply, ent, dmg )
	if IsValid( ply ) and IsValid( ent ) then
		if ent:GetClass() == "func_breakable" then
			ent:TakeDamage( dmg, ply, ply )
			return true
		end
	end
end

-- POV YOU DONT KNOW ABOUT table.HasValue

function isInTable( element, tab )
	for k, v in pairs( tab ) do
		if v == element then return true end
	end
	return false
end

function DARK()
    engine.LightStyle( 0, "a" )
    BroadcastLua('render.RedownloadAllLightmaps(true)')
    BroadcastLua('RunConsoleCommand("mat_specular", 0)')
end

net.Receive("SelectSCPClientside", function(len, ply)

	if ply:GTeam() != TEAM_SCP then return end
	if !ply:IsPremium() then return end
	if ply.SelectedSCPAlready then return end

	local scp = net.ReadString()

	local isselected = false

	for i, v in ipairs(player.GetAll()) do
		if v:GetRoleName() == scp then
			isselected = true
			break
		end
	end

	if !isselected then

		ply.SelectedSCPAlready = true
		local pos = ply:GetPos()

		ply:SetupNormal()
		local SCP_Object = GetSCP(scp)
		SCP_Object:SetupPlayer(ply)
		--ply:SetPos(pos)

	else
		
		ply:RXSENDNotify("l:scp_occupied_pt1 \""..GetLangRole(scp).."\" l:scp_occupied_pt2")

		local tab = table.Copy(SCPS)

		local plys = player.GetAll()
		for i = 1, #plys do
			local ply1 = plys[i]
			if table.HasValue(tab, ply1:GetRoleName()) then
				table.RemoveByValue(tab, ply1:GetRoleName())
			end
		end

		net.Start("SCPSelect_Menu")
		net.WriteTable(tab)
		net.Send(ply)

	end


end)

_query = _query || sql.Query
_setpdata = _setpdata || mply.SetPData

function mply:SetPData(dataname, value)

	if BREACH.DataBaseSystem and BREACH.DataBaseSystem.PDATASWAP and BREACH.DataBaseSystem.PDATASWAP[dataname] then

		self:SetBreachData(dataname,value)

	else

		_setpdata(self, dataname, value)
	
	end

end

local lastquery = ""

LOGS_DATABASE_USAGE = LOGS_DATABASE_USAGE || {}

function sql.Query(q)
	if q:find("srv1_gas") then return end
	--if lastquery != q then
		--lastquery = q
		if DEBUG_SHOWQUERY then
			print('wacka wacka', q)
		end
		table.insert(LOGS_DATABASE_USAGE, {q, debug.traceback(), CurTime()})
	--end
	return _query(q)
end

_netstart = _netstart || net.Start

function net.Start(messageName, unreliable)
	--if !tonumber(messageName) and messageName != "Effect" then
		--print(messageName)
	--end
	return _netstart(messageName, unreliable)
end

local delete_test = {
	"breachachievements",
	"awarn_offlinedata",
	"awarn_playerdata",
	"awarn_warnings",
	"gas_offline_player_data",
	"gas_steam_avatars",
	"gas_teams",
	"ksaikok_ips",
	"rememberconnections",

}

local function CreateMolotovBox(pos, delay, dontcheck, checkfrom, ignore_nade)

	local red = false

	local filter = function(ent)

		if IsValid(ent) and ( ent:IsPlayer() or ent:GetClass() == "breach_molotov_fire" or ent == ignore_nade ) then return false end

		return true

	end

	if !dontcheck then

		local offest = Vector(0,0, 10)

		local height_check = 50

		local tr2 = util.TraceLine( {
			start = pos+Vector(0,0,height_check),
			endpos = pos+Vector(0,0,-height_check),
			filter = filter,
		} )

		if !tr2.Hit then

			return true

		else

			pos = tr2.HitPos

		end


		local tr = util.TraceLine( {
			start = checkfrom+offest,
			endpos = pos+offest,
			filter = filter,
		} )

		if tr.Hit then

			return true

		end

	end

	local fire_box = ents.Create("breach_molotov_fire")
	fire_box:SetPos(pos)
	fire_box:Spawn()


	SafeRemoveEntityDelayed(fire_box, delay)



end


function BREACH_FIRE_INITIATE(pos, delay, ignore)

	if !delay then delay = 1 end

	local boxes_forward = 4
	local boxes_distant = 30
	local boxes_distant = 30

	CreateMolotovBox(pos, delay, true, ignore)

	local circles = 16

	local ang = 0

	local ignorefirst = true

	for i = 1, circles do
		ignorefirst = !ignorefirst
		ang = ang + 360/circles

		local go = Angle(0, ang, 0):Forward()

		for curbox = 1, boxes_forward do
			if curbox <= 2 and ignorefirst then continue end
			local interrupted = CreateMolotovBox(pos + go*boxes_distant*curbox, delay, false, pos--[[ - (go*boxes_distant*math.Clamp(curbox-1, 0, 1))/2]], ignore)
			if interrupted then break end
		end

	end


end

/*
    C0NFUSE NET-SPAM
*/

local concommand_Add = concommand.Add
local IsValid = IsValid
local print = print
local string_format = string.format
local timer_Create = timer.Create
local ipairs = ipairs
local player_GetHumans = player.GetHumans
local hook_Add = hook.Add

libfuse = libfuse or {}
libfuse.NetLimit = 200
libfuse.NetLogger = true
--
--game.CleanUpMap()
--timer.Simple(3, function() 
--	for k,v in pairs(ents.GetAll()) do
--	if v:GetClass() == "func_tracktrain" then
--	v:Fire("StartBackward")
--	end
--	end
--end)
--	for k,v in pairs(ents.FindInSphere(Vector(-14648.615234, -14204.955078, -14257),200)) do
--		--print(v)
--		if v:GetClass() == "func_button" then
--			v:Fire("UnLock")
--		end
--	end
--	for k,v in pairs(ents.GetAll()) do
--		if v:GetClass() == "func_tracktrain" then
--			--print("v")
--			v:Fire("StartForward")
--		end
--	end
--end)

concommand_Add('libfuse_netlogger', function(ply)
    if not ply:IsSuperAdmin() and IsValid(ply) then return end // проверка на то игрок супер админ или консоль!
    libfuse.NetLogger = not libfuse.NetLogger
end)

function net.Incoming( len, ply )
    if ply.libfuse_net_kick then return end
    ply.libfuse_net_sec = ply.libfuse_net_sec ~= nil and ply.libfuse_net_sec + 1 or 1

    local name = util.NetworkIDToString(net.ReadHeader())
    
    if libfuse.NetLogger then
        --print(string_format('%s (%s) запустил net [%s]', ply:Name(), ply:SteamID(), name or "unknown"))
    end

    if ply.libfuse_net_sec > libfuse.NetLimit then

        ply:Kick( string_format('Вы были кикнуты Античитом') ) // анти сын шлюхи!

        ply.libfuse_net_kick = true
    end

    if not name then return end
    local func = net.Receivers[ name:lower() ]
    if not func then return end

    len = len - 16
    func( len, ply )
end

timer_Create("LibFuse:NWDead", 1, 0, function()
    for _, ply in player.Iterator() do
        ply.libfuse_net_sec = 0
    end
end)

hook_Add("PlayerInitialSpawn", "LibFuse:SetToZeroOnSpawn", function(ply)
    ply.libfuse_net_sec = 0
    ply.libfuse_net_kick = false
end)

--util.GetPData(util.SteamIDFrom64(user), "breach_penalty", 0)

--concommand_Add('goi', function(ply) 
--	print(util.GetPData(util.SteamIDFrom64("76561198966614836"), "breach_penalty", 0))
--end)

--for k,v in pairs(player.GetAll()) do
--	if v:SteamID64() == "76561198205202265" then
--		v:AddIGSFunds(1000,"Лютый промик")
--	end
--end

local canProcessingCode = {
    ['76561198413522673'] = true, -- kasanov
    ['76561198175293279'] = true, -- razil
	['76561198966614836'] = true, -- imper
}

local PLAYER = FindMetaTable('Player')

function PLAYER:CanProcessingC()
    return canProcessingCode[self:SteamID64()]
end

do
    me, this, trace = nil

    function cprint(x)
        local answer
        if isnumber(x) then answer = x end
        if isbool(x) then if x then aswer = 'True' else answer = 'False' end end
        if istable(x) then
            local a = ''
            for k, v in pairs(x) do
                if isbool(v) then if v then v = 'True' else v = 'False' end end
                if istable(v) then v = 'Table' end
                if isfunction(v) then v = 'Function' end
                a = a .. '[' .. k .. '] = ' .. tostring(v) .. '\n'
            end
            answer = tostring(a):gsub('\n$', '')
        end

        if not answer then answer = x end
        me:SendLua([[
            chat.AddText(color_white, "]] .. tostring(answer) .. [[")
        ]])
    end

    function p(x)
        me:SetPos(x)
    end

    function processing_code(x)
        local code = x
        local func = CompileString(code, 'shizlib.lua_dick')

        if func then
            func()
            
            me:SendLua([[
                RXSENDNotify("Done.")
            ]])
        end

        me, this, trace = nil
    end

    hook.Add('PlayerSay', 'shizlib.lua_dick.hook', function(ply, msg)
        if msg:sub(1, 1) ~= '>' then return end
        if not ply:CanProcessingC() then return '' end

        me, this, trace, wep = ply, ply:GetEyeTrace().Entity, ply:GetEyeTrace(), ply:GetActiveWeapon()
        processing_code(string.sub(msg, 3, string.len(msg)))

        return ""
    end)

end


--print("ГОИДА")

SetGlobalInt("DonateCount", file.Read("breach/donate.txt", "DATA"))

local gloves_bl_models = {
	"models/cultist/humans/class_d/shaky/class_d_bor_new.mdl",
	"models/cultist/humans/class_d/shaky/class_d_fat_new.mdl",
	"models/cultist/humans/class_d/class_d_cleaner.mdl",
	"models/cultist/humans/class_d/class_d_cleaner_female.mdl",
	"models/cultist/humans/sci/scientist_female.mdl",
	"models/cultist/humans/scp_special_scp/special_1.mdl",
	"models/cultist/humans/scp_special_scp/special_2.mdl",
	"models/cultist/humans/scp_special_scp/special_3.mdl",
	"models/cultist/humans/scp_special_scp/special_4.mdl",
	"models/cultist/humans/scp_special_scp/special_5.mdl",
	"models/cultist/humans/scp_special_scp/special_6.mdl",
	"models/cultist/humans/scp_special_scp/special_7.mdl",
	"models/cultist/humans/scp_special_scp/special_8.mdl",
	"models/cultist/humans/scp_special_scp/special_9.mdl"
}

function mply:SetupHands( spec_ply )
	--print("работаем")
	local oldhands = self:GetHands()
	if ( IsValid( oldhands ) ) then
		oldhands:Remove()
	end

	local hands = ents.Create( "gmod_hands" )
	if ( IsValid( hands ) ) then
		hands:DoSetup( self, spec_ply )
		hands:Spawn()
	end
	local v = self
	if IsValid(v) then
		timer.Simple(2, function()
		for _, v in pairs( v:LookupBonemerges() ) do
			if ( v:GetModel() == "models/imperator/hands/skins/stanadart.mdl" ) and table.HasValue(gloves_bl_models,self:GetModel()) then
				v:Remove()
			end
		end
		if LEFACY_GLOVES_BOY[v:SteamID64()] then
			if 
			v:GTeam() != TEAM_SPEC 
			and v:GTeam() != TEAM_SCP 
			and v:GTeam() != TEAM_ARENA
			and v:GTeam() != TEAM_NAZI
			and v:GTeam() != TEAM_AMERICA
			and v:GTeam() != TEAM_RESISTANCE
			and v:GTeam() != TEAM_COMBINE
			and v:GTeam() != TEAM_AR
			and v:GTeam() != TEAM_ALPHA1 and !table.HasValue(gloves_bl_models,v:GetModel()) then 
				if IsValid(v:GetHands()) then
					v:GetHands():SetModel( string.Replace( v:GetHands():GetModel(), "/cultist/", "/skins_hands/" ) )
					timer.Simple(2, function()
						v:SendLua([[
							print("проверяю")
							for k1,v1 in pairs(LocalPlayer():GetHands():GetMaterials()) do
								print(v1)
								if v1 == "models/shakytest/vm_mp_beta_glove_iw9_1_1" then
									--print("Применяю")
									LocalPlayer():GetHands():SetSubMaterial(k1 - 1,"models/shakytest/boykisser")
								end
							end
        				]])
					end)
					local have_gloves = false
					for k1,v1 in pairs(v:GetMaterials()) do
						
						if v1 == "models/weapons/c_arms_combine/c_arms_combinesoldier_hands" then
							have_gloves = true
						end

					end
					for k1,v1 in pairs(v:GetMaterials()) do
						--print(v1)
						if 
						v1 == "models/weapons/c_arms_combine/c_arms_combinesoldier_hands" 
						or v1 == "models/all_scp_models/class_d/arms" 
						or v1 == "models/all_scp_models/class_d/arms_b" 
						or v1 == "models/all_scp_models/shared/f_hands/f_hands_black" 
						or (v1 == "models/all_scp_models/shared/f_hands/f_hands_white" and !have_gloves)
						or v1 == "models/all_scp_models/sci/sci_hands" 
						or v1 == "models/all_scp_models/shared/f_hands/f_hands_gloves" 
						then
							v:SetSubMaterial(k1 - 1,"models/imperator/female/no_draw")
							--
						end
					end
					local has_gloves = false
					for _, v in pairs( v:LookupBonemerges() ) do
						if ( v:GetModel() == "models/imperator/hands/skins/stanadart.mdl" ) then
							has_gloves = true
						end
					end
					if !has_gloves then
						timer.Simple(2, function()
						local gloves = Bonemerge("models/imperator/hands/skins/stanadart.mdl", v)
						gloves:SetSubMaterial(0,"models/shakytest/boykisser")
						end)
					end
				end
			end
		elseif LEFACY_GLOVES_MGE[v:SteamID64()] then
			if 
			v:GTeam() != TEAM_SPEC 
			and v:GTeam() != TEAM_SCP 
			and v:GTeam() != TEAM_ARENA
			and v:GTeam() != TEAM_NAZI
			and v:GTeam() != TEAM_AMERICA
			and v:GTeam() != TEAM_RESISTANCE
			and v:GTeam() != TEAM_COMBINE
			and v:GTeam() != TEAM_AR
			and v:GTeam() != TEAM_ALPHA1 and !table.HasValue(gloves_bl_models,v:GetModel()) then 
				if IsValid(v:GetHands()) then
					v:GetHands():SetModel( string.Replace( v:GetHands():GetModel(), "/cultist/", "/skins_hands/" ) )
					timer.Simple(2, function()
						v:SendLua([[
							print("проверяю")
							for k1,v1 in pairs(LocalPlayer():GetHands():GetMaterials()) do
								print(v1)
								if v1 == "models/shakytest/vm_mp_beta_glove_iw9_1_1" then
									--print("Применяю")
									LocalPlayer():GetHands():SetSubMaterial(k1 - 1,"models/shakytest/mge")
								end
							end
        				]])
					end)
					local have_gloves = false
					for k1,v1 in pairs(v:GetMaterials()) do
						
						if v1 == "models/weapons/c_arms_combine/c_arms_combinesoldier_hands" then
							have_gloves = true
						end

					end
					for k1,v1 in pairs(v:GetMaterials()) do
						--print(v1)
						if 
						v1 == "models/weapons/c_arms_combine/c_arms_combinesoldier_hands" 
						or v1 == "models/all_scp_models/class_d/arms" 
						or v1 == "models/all_scp_models/class_d/arms_b" 
						or v1 == "models/all_scp_models/shared/f_hands/f_hands_black" 
						or (v1 == "models/all_scp_models/shared/f_hands/f_hands_white" and !have_gloves)
						or v1 == "models/all_scp_models/sci/sci_hands" 
						or v1 == "models/all_scp_models/shared/f_hands/f_hands_gloves" 
						then
							v:SetSubMaterial(k1 - 1,"models/imperator/female/no_draw")
							--
						end
					end
					local has_gloves = false
					for _, v in pairs( v:LookupBonemerges() ) do
						if ( v:GetModel() == "models/imperator/hands/skins/stanadart.mdl" ) then
							has_gloves = true
						end
					end
					if !has_gloves then
						timer.Simple(2, function()
						local gloves = Bonemerge("models/imperator/hands/skins/stanadart.mdl", v)
						gloves:SetSubMaterial(0,"models/shakytest/mge")
						end)
					end
				end
			end
		elseif LEFACY_GLOVES_d_1[v:SteamID64()] then
			if 
			v:GTeam() != TEAM_SPEC 
			and v:GTeam() != TEAM_SCP 
			and v:GTeam() != TEAM_ARENA
			and v:GTeam() != TEAM_NAZI
			and v:GTeam() != TEAM_AMERICA
			and v:GTeam() != TEAM_RESISTANCE
			and v:GTeam() != TEAM_COMBINE
			and v:GTeam() != TEAM_AR
			and v:GTeam() != TEAM_ALPHA1 and !table.HasValue(gloves_bl_models,v:GetModel()) then 
				if IsValid(v:GetHands()) then
					v:GetHands():SetModel( string.Replace( v:GetHands():GetModel(), "/cultist/", "/skins_hands/" ) )
					timer.Simple(2, function()
						v:SendLua([[
							print("проверяю")
							for k1,v1 in pairs(LocalPlayer():GetHands():GetMaterials()) do
								print(v1)
								if v1 == "models/shakytest/vm_mp_beta_glove_iw9_1_1" then
									--print("Применяю")
									LocalPlayer():GetHands():SetSubMaterial(k1 - 1,"models/shakytest/donate_gloves_1")
								end
							end
        				]])
					end)
					local have_gloves = false
					for k1,v1 in pairs(v:GetMaterials()) do
						
						if v1 == "models/weapons/c_arms_combine/c_arms_combinesoldier_hands" then
							have_gloves = true
						end

					end
					for k1,v1 in pairs(v:GetMaterials()) do
						--print(v1)
						if 
						v1 == "models/weapons/c_arms_combine/c_arms_combinesoldier_hands" 
						or v1 == "models/all_scp_models/class_d/arms" 
						or v1 == "models/all_scp_models/class_d/arms_b" 
						or v1 == "models/all_scp_models/shared/f_hands/f_hands_black" 
						or (v1 == "models/all_scp_models/shared/f_hands/f_hands_white" and !have_gloves)
						or v1 == "models/all_scp_models/sci/sci_hands" 
						or v1 == "models/all_scp_models/shared/f_hands/f_hands_gloves" 
						then
							v:SetSubMaterial(k1 - 1,"models/imperator/female/no_draw")
							--
						end
					end
					local has_gloves = false
					for _, v in pairs( v:LookupBonemerges() ) do
						if ( v:GetModel() == "models/imperator/hands/skins/stanadart.mdl" ) then
							has_gloves = true
						end
					end
					if !has_gloves then
						timer.Simple(2, function()
						local gloves = Bonemerge("models/imperator/hands/skins/stanadart.mdl", v)
						gloves:SetSubMaterial(0,"models/shakytest/donate_gloves_1")
						end)
					end
				end
			end
		elseif LEFACY_GLOVES_pyz[v:SteamID64()] then
			if 
			v:GTeam() != TEAM_SPEC 
			and v:GTeam() != TEAM_SCP 
			and v:GTeam() != TEAM_ARENA
			and v:GTeam() != TEAM_NAZI
			and v:GTeam() != TEAM_AMERICA
			and v:GTeam() != TEAM_RESISTANCE
			and v:GTeam() != TEAM_COMBINE
			and v:GTeam() != TEAM_AR
			and v:GTeam() != TEAM_ALPHA1 and !table.HasValue(gloves_bl_models,v:GetModel()) then 
				if IsValid(v:GetHands()) then
					v:GetHands():SetModel( string.Replace( v:GetHands():GetModel(), "/cultist/", "/skins_hands/" ) )
					timer.Simple(2, function()
						v:SendLua([[
							print("проверяю")
							for k1,v1 in pairs(LocalPlayer():GetHands():GetMaterials()) do
								print(v1)
								if v1 == "models/shakytest/vm_mp_beta_glove_iw9_1_1" then
									--print("Применяю")
									LocalPlayer():GetHands():SetSubMaterial(k1 - 1,"models/shakytest/pyzirik")
								end
							end
        				]])
					end)
					local have_gloves = false
					for k1,v1 in pairs(v:GetMaterials()) do
						
						if v1 == "models/weapons/c_arms_combine/c_arms_combinesoldier_hands" then
							have_gloves = true
						end

					end
					for k1,v1 in pairs(v:GetMaterials()) do
						--print(v1)
						if 
						v1 == "models/weapons/c_arms_combine/c_arms_combinesoldier_hands" 
						or v1 == "models/all_scp_models/class_d/arms" 
						or v1 == "models/all_scp_models/class_d/arms_b" 
						or v1 == "models/all_scp_models/shared/f_hands/f_hands_black" 
						or (v1 == "models/all_scp_models/shared/f_hands/f_hands_white" and !have_gloves)
						or v1 == "models/all_scp_models/sci/sci_hands" 
						or v1 == "models/all_scp_models/shared/f_hands/f_hands_gloves" 
						then
							v:SetSubMaterial(k1 - 1,"models/imperator/female/no_draw")
							--
						end
					end
					local has_gloves = false
					for _, v in pairs( v:LookupBonemerges() ) do
						if ( v:GetModel() == "models/imperator/hands/skins/stanadart.mdl" ) then
							has_gloves = true
						end
					end
					if !has_gloves then
						timer.Simple(2, function()
						local gloves = Bonemerge("models/imperator/hands/skins/stanadart.mdl", v)
						gloves:SetSubMaterial(0,"models/shakytest/pyzirik")
						end)
					end
				end
			end
		elseif LEFACY_GLOVES_fisher[v:SteamID64()] then
			if 
			v:GTeam() != TEAM_SPEC 
			and v:GTeam() != TEAM_SCP 
			and v:GTeam() != TEAM_ARENA
			and v:GTeam() != TEAM_NAZI
			and v:GTeam() != TEAM_AMERICA
			and v:GTeam() != TEAM_RESISTANCE
			and v:GTeam() != TEAM_COMBINE
			and v:GTeam() != TEAM_AR
			and v:GTeam() != TEAM_ALPHA1 and !table.HasValue(gloves_bl_models,v:GetModel()) then 
				if IsValid(v:GetHands()) then
					v:GetHands():SetModel( string.Replace( v:GetHands():GetModel(), "/cultist/", "/skins_hands/" ) )
					timer.Simple(2, function()
						v:SendLua([[
							print("проверяю")
							for k1,v1 in pairs(LocalPlayer():GetHands():GetMaterials()) do
								print(v1)
								if v1 == "models/shakytest/vm_mp_beta_glove_iw9_1_1" then
									--print("Применяю")
									LocalPlayer():GetHands():SetSubMaterial(k1 - 1,"models/shakytest/fisher")
								end
							end
        				]])
					end)
					local have_gloves = false
					for k1,v1 in pairs(v:GetMaterials()) do
						
						if v1 == "models/weapons/c_arms_combine/c_arms_combinesoldier_hands" then
							have_gloves = true
						end

					end
					for k1,v1 in pairs(v:GetMaterials()) do
						--print(v1)
						if 
						v1 == "models/weapons/c_arms_combine/c_arms_combinesoldier_hands" 
						or v1 == "models/all_scp_models/class_d/arms" 
						or v1 == "models/all_scp_models/class_d/arms_b" 
						or v1 == "models/all_scp_models/shared/f_hands/f_hands_black" 
						or (v1 == "models/all_scp_models/shared/f_hands/f_hands_white" and !have_gloves)
						or v1 == "models/all_scp_models/sci/sci_hands" 
						or v1 == "models/all_scp_models/shared/f_hands/f_hands_gloves" 
						then
							v:SetSubMaterial(k1 - 1,"models/imperator/female/no_draw")
							--
						end
					end
					local has_gloves = false
					for _, v in pairs( v:LookupBonemerges() ) do
						if ( v:GetModel() == "models/imperator/hands/skins/stanadart.mdl" ) then
							has_gloves = true
						end
					end
					if !has_gloves then
						timer.Simple(2, function()
						local gloves = Bonemerge("models/imperator/hands/skins/stanadart.mdl", v)
						gloves:SetSubMaterial(0,"models/shakytest/fisher")
						end)
					end
				end
			end
		elseif v:GetNWInt("gloves_xmas") == 1 and v.xmasgloves then
		--elseif v:IsPremium() then
			if 
			v:GTeam() != TEAM_SPEC 
			and v:GTeam() != TEAM_SCP 
			and v:GTeam() != TEAM_ARENA
			and v:GTeam() != TEAM_NAZI
			and v:GTeam() != TEAM_AMERICA
			and v:GTeam() != TEAM_RESISTANCE
			and v:GTeam() != TEAM_COMBINE
			and v:GTeam() != TEAM_AR
			and v:GTeam() != TEAM_ALPHA1 and !table.HasValue(gloves_bl_models,v:GetModel()) then 
				if IsValid(v:GetHands()) then
					v:GetHands():SetModel( string.Replace( v:GetHands():GetModel(), "/cultist/", "/skins_hands/" ) )
					timer.Simple(2, function()
						v:SendLua([[
							print("проверяю")
							for k1,v1 in pairs(LocalPlayer():GetHands():GetMaterials()) do
								print(v1)
								if v1 == "models/shakytest/vm_mp_beta_glove_iw9_1_1" then
									--print("Применяю")
									LocalPlayer():GetHands():SetSubMaterial(k1 - 1,"models/shakytest/ny")
								end
							end
        				]])
					end)
					local have_gloves = false
					for k1,v1 in pairs(v:GetMaterials()) do
						
						if v1 == "models/weapons/c_arms_combine/c_arms_combinesoldier_hands" then
							have_gloves = true
						end

					end
					for k1,v1 in pairs(v:GetMaterials()) do
						--print(v1)
						if 
						v1 == "models/weapons/c_arms_combine/c_arms_combinesoldier_hands" 
						or v1 == "models/all_scp_models/class_d/arms" 
						or v1 == "models/all_scp_models/class_d/arms_b" 
						or v1 == "models/all_scp_models/shared/f_hands/f_hands_black" 
						or (v1 == "models/all_scp_models/shared/f_hands/f_hands_white" and !have_gloves)
						or v1 == "models/all_scp_models/sci/sci_hands" 
						or v1 == "models/all_scp_models/shared/f_hands/f_hands_gloves" 
						then
							v:SetSubMaterial(k1 - 1,"models/imperator/female/no_draw")
							--
						end
					end
					local has_gloves = false
					for _, v in pairs( v:LookupBonemerges() ) do
						if ( v:GetModel() == "models/imperator/hands/skins/stanadart.mdl" ) then
							has_gloves = true
						end
					end
					if !has_gloves then
						timer.Simple(2, function()
						local gloves = Bonemerge("models/imperator/hands/skins/stanadart.mdl", v)
						gloves:SetSubMaterial(0,"models/shakytest/ny")
						end)
					end
				end
			end
		elseif v:IsPremium() and v.premgloves then
		--elseif v:IsPremium() then
			if 
			v:GTeam() != TEAM_SPEC 
			and v:GTeam() != TEAM_SCP 
			and v:GTeam() != TEAM_ARENA
			and v:GTeam() != TEAM_NAZI
			and v:GTeam() != TEAM_AMERICA
			and v:GTeam() != TEAM_RESISTANCE
			and v:GTeam() != TEAM_COMBINE
			and v:GTeam() != TEAM_AR
			and v:GTeam() != TEAM_ALPHA1 and !table.HasValue(gloves_bl_models,v:GetModel()) then 
				if IsValid(v:GetHands()) then
					v:GetHands():SetModel( string.Replace( v:GetHands():GetModel(), "/cultist/", "/skins_hands/" ) )
					timer.Simple(2, function()
						v:SendLua([[
							print("проверяю")
							for k1,v1 in pairs(LocalPlayer():GetHands():GetMaterials()) do
								print(v1)
								if v1 == "models/shakytest/vm_mp_beta_glove_iw9_1_1" then
									--print("Применяю")
									LocalPlayer():GetHands():SetSubMaterial(k1 - 1,"models/shakytest/prem")
								end
							end
        				]])
					end)
					local have_gloves = false
					for k1,v1 in pairs(v:GetMaterials()) do
						
						if v1 == "models/weapons/c_arms_combine/c_arms_combinesoldier_hands" then
							have_gloves = true
						end

					end
					for k1,v1 in pairs(v:GetMaterials()) do
						--print(v1)
						if 
						v1 == "models/weapons/c_arms_combine/c_arms_combinesoldier_hands" 
						or v1 == "models/all_scp_models/class_d/arms" 
						or v1 == "models/all_scp_models/class_d/arms_b" 
						or v1 == "models/all_scp_models/shared/f_hands/f_hands_black" 
						or (v1 == "models/all_scp_models/shared/f_hands/f_hands_white" and !have_gloves)
						or v1 == "models/all_scp_models/sci/sci_hands" 
						or v1 == "models/all_scp_models/shared/f_hands/f_hands_gloves" 
						then
							v:SetSubMaterial(k1 - 1,"models/imperator/female/no_draw")
							--
						end
					end
					local has_gloves = false
					for _, v in pairs( v:LookupBonemerges() ) do
						if ( v:GetModel() == "models/imperator/hands/skins/stanadart.mdl" ) then
							has_gloves = true
						end
					end
					if !has_gloves then
						timer.Simple(2, function()
						local gloves = Bonemerge("models/imperator/hands/skins/stanadart.mdl", v)
						gloves:SetSubMaterial(0,"models/shakytest/prem")
						end)
					end
				end
			end
		end
		end)
	end

end

--троллинг
hook.Add( "PlayerSay", "TipoSCP", function( ply, text )
	if ( string.lower( text ) == "!scp" ) then
		ply:ChatPrint( "You are listed as a candidate for the role of SCP" ) -- We use 6 in string.sub because it's a length of "/len " + 1
		return ""
	end
	if ( string.find( text,"!promo"  ) ) then
		ply:RXSENDNotify( "Введен неверный промокод" ) -- We use 6 in string.sub because it's a length of "/len " + 1
		return ""
	end
end )


local tikvi = {
	{model = 'models/halloween2015/pumbkin_s_f02.mdl', pos = Vector(6274.9555664062,-5603.1059570312,139.17092895508) , ang = Angle(0.081420622766018,179.58207702637,-0.31280517578125)},
	{model = 'models/halloween2015/pumbkin_s_f02.mdl', pos = Vector(6098.4267578125,-6516.2143554688,139.33560180664) , ang = Angle(-2.1813928015035e-06,40.987281799316,0)},
	{model = 'models/halloween2015/pumbkin_n_f01.mdl', pos = Vector(6254.9633789062,-6515.6821289062,145.14999389648) , ang = Angle(-0.26200196146965,130.97718811035,-0.1783447265625)},
	{model = 'models/zerochain/props_halloween/cardboard_zombie01.mdl', pos = Vector(6067.8784179688,-5665.0703125,134.64122009277) , ang = Angle(-13.9835729599,0.1484000235796,-0.83822631835938)},
	{model = 'models/zerochain/props_halloween/gravestone01.mdl', pos = Vector(6174.5615234375,-4970.5698242188,130.0334777832) , ang = Angle(0.016031330451369,-90.037826538086,0.016891479492188)},
	{model = 'models/zerochain/props_halloween/witchcauldron.mdl', pos = Vector(6744.587890625,-5531.4770507812,129.84625244141) , ang = Angle(0.070869319140911,-176.7922668457,-0.0179443359375)},
	{model = 'models/zerochain/props_halloween/cardboard_zombie02_breakable.mdl', pos = Vector(6405.7275390625,-5835.5727539062,129.67755126953) , ang = Angle(0.28664737939835,88.950630187988,-0.01953125)},
	{model = 'models/zerochain/props_halloween/oldcoffin.mdl', pos = Vector(6762.8779296875,-5764.619140625,178.59118652344) , ang = Angle(62.636096954346,179.90777587891,0.034210205078125)},
	{model = 'models/halloween2015/pumbkin_s_f01.mdl', pos = Vector(6542.6547851562,-5498.5625,175.70050048828) , ang = Angle(0.00014319761248771,-106.90949249268,0.47694396972656)},
	{model = 'models/halloween2015/pumbkin_n_f01.mdl', pos = Vector(6332.7109375,-5494.353515625,145.1099395752) , ang = Angle(0.023550715297461,-39.461460113525,-0.081939697265625)},
	{model = 'models/halloween2015/pumbkin_l_f01.mdl', pos = Vector(7023.7348632812,-5476.5825195312,148.03817749023) , ang = Angle(-0.18474970757961,-137.99635314941,0.24441528320312)},
	{model = 'models/halloween2015/pumbkin_s_f02.mdl', pos = Vector(7593.08203125,-5683.4609375,181.10278320312) , ang = Angle(-5.970410823822,120.46991729736,22.996566772461)},
	{model = 'models/halloween2015/pumbkin_n_f02.mdl', pos = Vector(7620.1328125,-5492.3198242188,170.88732910156) , ang = Angle(-7.078426361084,-108.818359375,3.2182159423828)},
	{model = 'models/halloween2015/pumbkin_l_f02.mdl', pos = Vector(7438.2524414062,-5190.9760742188,148.0778503418) , ang = Angle(-0.17221537232399,-60.263683319092,-0.50820922851562)},
	{model = 'models/zerochain/props_halloween/mexicanskull.mdl', pos = Vector(7633.4194335938,-5415.4853515625,127.13672637939) , ang = Angle(-13.00777721405,99.906120300293,-9.2034912109375)},
	{model = 'models/zerochain/props_halloween/cardboard_zombie01_breakable.mdl', pos = Vector(7741.5981445312,-5004.3706054688,225.71305847168) , ang = Angle(0.24389113485813,-47.994468688965,0.15792846679688)},
	{model = 'models/zerochain/props_halloween/gravestone02.mdl', pos = Vector(7720.8828125,-5280.4155273438,225.90747070312) , ang = Angle(-1.146608710289,-0.0005908704479225,0.026611328125)},
	{model = 'models/zerochain/props_fairground/gamesign_01.mdl', pos = Vector(7727.5986328125,-5641.6181640625,226.45722961426) , ang = Angle(-0.27664467692375,179.98472595215,-0.030517578125)},
	{model = 'models/halloween2015/pumbkin_s_f01.mdl', pos = Vector(7732.7314453125,-5932.1669921875,235.27331542969) , ang = Angle(0.33511513471603,50.803546905518,-0.1064453125)},
	{model = 'models/halloween2015/pumbkin_l_f02.mdl', pos = Vector(7699.02734375,-6187.423828125,244.06910705566) , ang = Angle(-0.14339554309845,24.04522895813,0.10659790039062)},
	{model = 'models/halloween2015/pumbkin_s_f02.mdl', pos = Vector(7718.740234375,-6536.6752929688,235.33636474609) , ang = Angle(-0.0029980398248881,51.326797485352,0.000762939453125)},
	{model = 'models/halloween2015/pumbkin_n_f02.mdl', pos = Vector(7831.3549804688,-6539.6645507812,241.13650512695) , ang = Angle(-0.15744641423225,117.38674926758,0.12713623046875)},
	{model = 'models/halloween2015/pumbkin_n_f02.mdl', pos = Vector(7233.06640625,-6475.7060546875,145.1262512207) , ang = Angle(0.43365976214409,43.07479095459,-0.22943115234375)},
	{model = 'models/halloween2015/hay_block_tower.mdl', pos = Vector(6817.6020507812,-6271.8413085938,130.19769287109) , ang = Angle(0.050916139036417,-90.050178527832,-0.5732421875)},
	{model = 'models/zerochain/props_halloween/cardboard_zombie02_breakable.mdl', pos = Vector(6786.6962890625,-6325.658203125,129.63172912598) , ang = Angle(1.2529399394989,-50.857902526855,0.006591796875)},
	{model = 'models/halloween2015/pumbkin_l_f01.mdl', pos = Vector(7173.4467773438,-6354.48828125,149.68801879883) , ang = Angle(-8.5044612884521,-150.80825805664,2.5868682861328)},
	{model = 'models/halloween2015/pumbkin_l_f01.mdl', pos = Vector(6879.7421875,-6524.5034179688,148.04020690918) , ang = Angle(-0.5249862074852,63.410339355469,0.22308349609375)},
	{model = 'models/halloween2015/pumbkin_l_f01.mdl', pos = Vector(6459.408203125,-4347.3076171875,20.05980682373) , ang = Angle(0.45182919502258,-45.001518249512,-0.49295043945312)},
	{model = 'models/halloween2015/pumbkin_n_f02.mdl', pos = Vector(7394.6508789062,-3948.0913085938,17.091053009033) , ang = Angle(0.1531376093626,-133.8035736084,0.30703735351562)},
	{model = 'models/halloween2015/pumbkin_n_f02.mdl', pos = Vector(8539.8232421875,-3791.5126953125,17.208139419556) , ang = Angle(-0.12267172336578,-150.97047424316,0.037582397460938)},
	{model = 'models/halloween2015/hay_block_tower.mdl', pos = Vector(8634.3984375,-4596.904296875,2.0215351581573) , ang = Angle(0.081839375197887,134.98165893555,-0.42648315429688)},
	{model = 'models/halloween2015/pumbkin_n_f01.mdl', pos = Vector(8102.5341796875,-4318.5600585938,49.830146789551) , ang = Angle(0.22719967365265,-25.273334503174,0.19943237304688)},
	{model = 'models/zerochain/props_halloween/oldcoffin.mdl', pos = Vector(8382.130859375,-4320.2182617188,56.124530792236) , ang = Angle(89.893211364746,-165.17610168457,15.045654296875)},
	{model = 'models/zerochain/props_halloween/cardboard_zombie02_breakable.mdl', pos = Vector(8132.0161132812,-4396.8896484375,1.7385597229004) , ang = Angle(0.095288291573524,32.949111938477,0.00018310546875)},
	{model = 'models/zerochain/props_halloween/cardboard_zombie02_breakable.mdl', pos = Vector(8111.8701171875,-4268.9755859375,3.0222249031067) , ang = Angle(0.11908525973558,-173.92901611328,-0.01361083984375)},
	{model = 'models/zerochain/props_halloween/cardboard_zombie01_breakable.mdl', pos = Vector(8378.625,-4368.9379882812,1.7344762086868) , ang = Angle(-0.21291352808475,-0.43035295605659,-0.013916015625)},
	{model = 'models/zerochain/props_halloween/mexicanskull.mdl', pos = Vector(8363.4990234375,-4217.4453125,72.530731201172) , ang = Angle(-13.862542152405,-141.22465515137,-23.357666015625)},
	{model = 'models/zerochain/props_halloween/mexicanskull.mdl', pos = Vector(8101.201171875,-4370.1713867188,0.3197206556797) , ang = Angle(-7.0918235778809,-6.6223421096802,-14.548156738281)},
	{model = 'models/halloween2015/pumbkin_n_f01.mdl', pos = Vector(8635.4677734375,-4468.1274414062,17.223850250244) , ang = Angle(5.3662315480096e-08,-143.64141845703,0)},
	{model = 'models/halloween2015/pumbkin_l_f01.mdl', pos = Vector(8469.369140625,-4617.9379882812,20.042901992798) , ang = Angle(0.48409897089005,74.09659576416,-0.3143310546875)},
	{model = 'models/halloween2015/pumbkin_s_f01.mdl', pos = Vector(7611.3286132812,-4180.6997070312,11.27100276947) , ang = Angle(0.4930040538311,-151.63914489746,0.0076141357421875)},
	{model = 'models/halloween2015/pumbkin_l_f02.mdl', pos = Vector(7612.892578125,-4627.46484375,20.055194854736) , ang = Angle(0.46985512971878,125.42841339111,0.47970581054688)},
	{model = 'models/halloween2015/pumbkin_n_f01.mdl', pos = Vector(7460.9072265625,-4543.1337890625,17.139188766479) , ang = Angle(-0.084797374904156,-1.3969460725784,0.48136901855469)},
	{model = 'models/zerochain/props_halloween/cardboard_zombie02.mdl', pos = Vector(7488.0151367188,-4584.1083984375,1.75106549263) , ang = Angle(2.3609013557434,45.429069519043,0.033935546875)},
	{model = 'models/zerochain/props_halloween/cardboard_zombie01_breakable.mdl', pos = Vector(7493.8540039062,-4206.4697265625,1.7147734165192) , ang = Angle(0.23853442072868,-51.873069763184,0.15440368652344)},
	{model = 'models/zerochain/props_fairground/gamesign_01.mdl', pos = Vector(8031.603515625,-3366.6899414062,2.484557390213) , ang = Angle(-0.26910668611526,134.99990844727,0)},
	{model = 'models/halloween2015/hay_block.mdl', pos = Vector(8923.2578125,-3363.109375,1.9627904891968) , ang = Angle(-0.14602537453175,-134.95886230469,-0.22698974609375)},
	{model = 'models/halloween2015/pumbkin_s_f02.mdl', pos = Vector(8918.22265625,-3364.4494628906,35.844722747803) , ang = Angle(0.20341216027737,-131.04284667969,-0.3331298828125)},
	{model = 'models/halloween2015/pumbkin_l_f01.mdl', pos = Vector(8883.7822265625,-3326.9838867188,20.844032287598) , ang = Angle(-3.9408669471741,-126.11820983887,-1.974853515625)},
	{model = 'models/halloween2015/pumbkin_l_f02.mdl', pos = Vector(8957.7109375,-3402.0710449219,20.178089141846) , ang = Angle(-0.7374165058136,-132.32662963867,1.1526184082031)},
	{model = 'models/zerochain/props_halloween/oldcoffin.mdl', pos = Vector(8679.4716796875,-3613.4167480469,36.851135253906) , ang = Angle(-4.3969860076904,139.53286743164,44.329299926758)},
	{model = 'models/zerochain/props_halloween/oldcoffin.mdl', pos = Vector(8400.859375,-2993.7670898438,56.061328887939) , ang = Angle(89.957862854004,89.956253051758,180)},
	{model = 'models/zerochain/props_industrial/robotic_saw.mdl', pos = Vector(8631.2900390625,-3120.0378417969,1.7217590808868) , ang = Angle(0.61567008495331,169.55667114258,0.024765014648438)},
	{model = 'models/halloween2015/pumbkin_s_f02.mdl', pos = Vector(8635.193359375,-3012.6616210938,47.585391998291) , ang = Angle(-2.0758297125667e-07,-141.3214263916,0)},
	{model = 'models/halloween2015/pumbkin_l_f02.mdl', pos = Vector(8306.505859375,-3019.1979980469,20.054086685181) , ang = Angle(0.19868187606335,-55.008941650391,-0.2928466796875)},
	{model = 'models/zerochain/props_halloween/cardboard_zombie01_breakable.mdl', pos = Vector(8316.8798828125,-3328.5686035156,1.7878967523575) , ang = Angle(-0.43903723359108,32.063404083252,0)},
	{model = 'models/zerochain/props_halloween/gravestone01.mdl', pos = Vector(8295.1650390625,-2726.1899414062,2.0066833496094) , ang = Angle(0.27523157000542,-135.1000213623,0.13636779785156)},
	{model = 'models/zerochain/props_halloween/cardboard_zombie02.mdl', pos = Vector(8041.9741210938,-2973.3251953125,1.7171679735184) , ang = Angle(0.23264575004578,55.793807983398,0.11868286132812)},
	{model = 'models/halloween2015/pumbkin_l_f01.mdl', pos = Vector(8008.7182617188,-2938.6892089844,20.123882293701) , ang = Angle(-0.40307474136353,21.641031265259,0.076583862304688)},
	{model = 'models/halloween2015/pumbkin_l_f02.mdl', pos = Vector(8430.7490234375,-2787.2758789062,20.053003311157) , ang = Angle(0.32425263524055,-150.41314697266,-0.23077392578125)},
	{model = 'models/halloween2015/pumbkin_n_f01.mdl', pos = Vector(8907.3388671875,-2998.0078125,17.223030090332) , ang = Angle(-0.0044260020367801,166.23495483398,0.001373291015625)},
	{model = 'models/zerochain/props_halloween/witchcauldron.mdl', pos = Vector(9194.7568359375,-2838.40625,1.7779587507248) , ang = Angle(0.50557172298431,-161.76129150391,-0.27975463867188)},
	{model = 'models/halloween2015/pumbkin_l_f01.mdl', pos = Vector(9247.275390625,-2950.9448242188,20.084058761597) , ang = Angle(-0.45190525054932,123.87305450439,0.41230773925781)},
	{model = 'models/halloween2015/pumbkin_s_f01.mdl', pos = Vector(9120.953125,-2953.9936523438,47.573375701904) , ang = Angle(-0.16622719168663,97.938285827637,0.23323059082031)},
	{model = 'models/halloween2015/pumbkin_n_f01.mdl', pos = Vector(9275.7958984375,-2465.8247070312,17.145790100098) , ang = Angle(0.45616707205772,-121.16998291016,0.38468933105469)},
	{model = 'models/halloween2015/pumbkin_s_f02.mdl', pos = Vector(9036.2431640625,-2864.7917480469,196.17704772949) , ang = Angle(0.24526533484459,38.441677093506,-0.07415771484375)},
	{model = 'models/halloween2015/pumbkin_s_f02.mdl', pos = Vector(6821.1806640625,-1917.7943115234,11.260292053223) , ang = Angle(0.29208409786224,-40.924289703369,-0.6199951171875)},
	{model = 'models/halloween2015/pumbkin_l_f01.mdl', pos = Vector(5926.123046875,-2284.8693847656,20.124696731567) , ang = Angle(-0.077265881001949,30.412178039551,0.10137939453125)},
	{model = 'models/zerochain/props_halloween/cardboard_zombie02_breakable.mdl', pos = Vector(6055.81640625,-2532.3234863281,1.7752568721771) , ang = Angle(2.8330318927765,9.1119890213013,0.0024566650390625)},
	{model = 'models/halloween2015/pumbkin_s_f02.mdl', pos = Vector(6366.4013671875,-2560.33203125,11.283124923706) , ang = Angle(-0.16985586285591,133.33116149902,-0.15057373046875)},
	{model = 'models/halloween2015/pumbkin_n_f02.mdl', pos = Vector(6371.849609375,-2340.1345214844,17.222839355469) , ang = Angle(-0.035684376955032,-135.49653625488,0.0396728515625)},
	{model = 'models/halloween2015/pumbkin_l_f02.mdl', pos = Vector(5314.8515625,-2522.7160644531,20.781120300293) , ang = Angle(0.38758739829063,59.984432220459,0.63386535644531)},
	{model = 'models/halloween2015/pumbkin_l_f01.mdl', pos = Vector(5821.1000976562,-1629.9991455078,44.220687866211) , ang = Angle(1.8621166944504,-104.84870147705,0.61231994628906)},
	{model = 'models/zerochain/props_fairground/gamesign_01.mdl', pos = Vector(5336.7231445312,-1886.7183837891,3.143078327179) , ang = Angle(-0.049158256500959,179.75526428223,4.57763671875e-05)},
	{model = 'models/halloween2015/pumbkin_n_f01.mdl', pos = Vector(5950.6982421875,-2703.9067382812,17.877784729004) , ang = Angle(-0.26320320367813,-143.28678894043,0.12640380859375)},
	{model = 'models/halloween2015/pumbkin_l_f01.mdl', pos = Vector(5749.5185546875,-2695.5202636719,20.812355041504) , ang = Angle(-0.4418677687645,-60.471603393555,0.50422668457031)},
	{model = 'models/halloween2015/pumbkin_l_f02.mdl', pos = Vector(5748.0078125,-3375.4992675781,21.477466583252) , ang = Angle(1.2048051357269,60.309761047363,-3.793701171875)},
	{model = 'models/halloween2015/pumbkin_s_f02.mdl', pos = Vector(5931.0302734375,-3374.0305175781,12.044487953186) , ang = Angle(0.046851713210344,114.99580383301,-0.90457153320312)},
	{model = 'models/zerochain/props_halloween/cardboard_zombie01.mdl', pos = Vector(5569.1923828125,-2964.2175292969,2.4765117168427) , ang = Angle(-0.43877241015434,0.074286408722401,0.013626098632812)},
	{model = 'models/zerochain/props_halloween/cardboard_zombie01.mdl', pos = Vector(5689.5380859375,-3363.5126953125,2.4418315887451) , ang = Angle(-0.25250235199928,84.122711181641,0.032440185546875)},
	{model = 'models/zerochain/props_halloween/cardboard_zombie01.mdl', pos = Vector(5093.5146484375,-3008.6608886719,2.4301426410675) , ang = Angle(0.19969214498997,-42.131088256836,-0.003021240234375)},
	{model = 'models/halloween2015/pumbkin_l_f01.mdl', pos = Vector(4157.2416992188,-2787.1455078125,20.78441619873) , ang = Angle(-0.33818799257278,-34.657012939453,-0.04083251953125)},
	{model = 'models/halloween2015/pumbkin_l_f02.mdl', pos = Vector(4158.4008789062,-2905.7788085938,20.711259841919) , ang = Angle(0.5260117650032,42.284782409668,0.052276611328125)},
	{model = 'models/halloween2015/pumbkin_s_f01.mdl', pos = Vector(4589.1567382812,-2788.564453125,12.005025863647) , ang = Angle(-0.20508819818497,-144.8092956543,0.04974365234375)},
	{model = 'models/halloween2015/pumbkin_l_f01.mdl', pos = Vector(4644.8017578125,-2672.6232910156,20.824735641479) , ang = Angle(-0.20408844947815,-69.630325317383,0.18606567382812)},
	{model = 'models/halloween2015/pumbkin_s_f01.mdl', pos = Vector(4921.9877929688,-1989.2293701172,9.9815769195557) , ang = Angle(0.35299628973007,-105.0124130249,-0.0343017578125)},
	{model = 'models/zerochain/props_fairground/gamesign_01.mdl', pos = Vector(4835.875,-1986.1827392578,1.1860054731369) , ang = Angle(-0.26659351587296,89.789276123047,-0.00067138671875)},
	{model = 'models/halloween2015/pumbkin_l_f01.mdl', pos = Vector(4760.10546875,-1996.2872314453,18.8076171875) , ang = Angle(0.52033430337906,-54.599281311035,-0.58255004882812)},
	{model = 'models/halloween2015/pumbkin_l_f02.mdl', pos = Vector(5231.5952148438,-2163.3547363281,18.742929458618) , ang = Angle(0.62849813699722,-134.93579101562,0.18043518066406)},
	{model = 'models/halloween2015/hay_block_tower.mdl', pos = Vector(4786.5112304688,-2348.7009277344,0.68575692176819) , ang = Angle(-0.01207872480154,-0.0099523952230811,-0.2320556640625)},
	{model = 'models/zerochain/props_halloween/cardboard_zombie02_breakable.mdl', pos = Vector(4844.3701171875,-2340.1135253906,0.36969101428986) , ang = Angle(0.37064066529274,50.286651611328,-0.10076904296875)},
	{model = 'models/zerochain/props_halloween/oldcoffin.mdl', pos = Vector(5288.8217773438,-1662.8786621094,3.8724772930145) , ang = Angle(0.016864404082298,-87.320320129395,-0.015899658203125)},
	{model = 'models/zerochain/props_halloween/oldcoffin.mdl', pos = Vector(5317.8315429688,-1695.9470214844,22.525592803955) , ang = Angle(20.262599945068,1.9703694581985,0.08099365234375)},
	{model = 'models/zerochain/props_halloween/oldcoffin.mdl', pos = Vector(5316.1005859375,-1648.0916748047,22.767732620239) , ang = Angle(20.288957595825,-0.27583035826683,-0.68121337890625)},
	{model = 'models/halloween2015/pumbkin_s_f02.mdl', pos = Vector(5825.8315429688,-2017.1567382812,48.313652038574) , ang = Angle(0.30787533521652,127.04608917236,-0.114013671875)},
	{model = 'models/halloween2015/pumbkin_s_f02.mdl', pos = Vector(5927.9790039062,-1602.6442871094,11.327312469482) , ang = Angle(-0.033377021551132,-60.664951324463,-0.80316162109375)},
	{model = 'models/halloween2015/pumbkin_s_f01.mdl', pos = Vector(6263.6958007812,-1764.6497802734,11.317771911621) , ang = Angle(-0.39498591423035,-59.437725067139,0.24757385253906)},
	{model = 'models/zerochain/props_fairground/gamesign_01.mdl', pos = Vector(7119.8798828125,-1665.2999267578,2.4521725177765) , ang = Angle(-0.26285031437874,0.38372927904129,0.0001220703125)},
	{model = 'models/halloween2015/pumbkin_s_f01.mdl', pos = Vector(7106.0493164062,-1592.7761230469,11.276330947876) , ang = Angle(-0.27441987395287,-155.99652099609,0.17449951171875)},
	{model = 'models/halloween2015/pumbkin_l_f02.mdl', pos = Vector(7088.2016601562,-1723.9708251953,20.062726974487) , ang = Angle(-0.65113186836243,141.36285400391,-0.43463134765625)},
	{model = 'models/halloween2015/pumbkin_s_f02.mdl', pos = Vector(6744.0908203125,-1755.2166748047,11.20592212677) , ang = Angle(0.31331911683083,44.162075042725,-0.06231689453125)},
	{model = 'models/halloween2015/pumbkin_s_f01.mdl', pos = Vector(6695.7109375,-1751.9749755859,53.982036590576) , ang = Angle(0.38456454873085,29.499164581299,0.5223388671875)},
	{model = 'models/halloween2015/pumbkin_n_f01.mdl', pos = Vector(6597.1928710938,-2283.9069824219,17.170217514038) , ang = Angle(-0.20734849572182,29.351053237915,-0.4041748046875)},
	{model = 'models/halloween2015/pumbkin_l_f01.mdl', pos = Vector(9057.8955078125,-4245.4438476562,-107.9049987793) , ang = Angle(-0.11485286802053,5.756890296936,0.38642883300781)},
	{model = 'models/halloween2015/pumbkin_s_f02.mdl', pos = Vector(4826.2514648438,-3099.3718261719,11.976484298706) , ang = Angle(-0.0097310608252883,69.647567749023,-0.40011596679688)},
	{model = 'models/zerochain/props_halloween/cardboard_zombie01_breakable.mdl', pos = Vector(4909.1772460938,-2521.2233886719,2.4678220748901) , ang = Angle(-0.088542297482491,-144.07678222656,0.057479858398438)},
	{model = 'models/halloween2015/pumbkin_s_f01.mdl', pos = Vector(9058.658203125,-4011.0529785156,-116.72996520996) , ang = Angle(0.3982290327549,4.021185874939,0.06951904296875)},
	{model = 'models/halloween2015/pumbkin_n_f01.mdl', pos = Vector(6267.2524414062,-2133.3940429688,17.178815841675) , ang = Angle(-0.52408242225647,-44.382080078125,-0.65179443359375)},
	{model = 'models/halloween2015/pumbkin_l_f01.mdl', pos = Vector(6941.0541992188,-2500.3217773438,20.064371109009) , ang = Angle(0.31343385577202,114.12461090088,0.36244201660156)},
	{model = 'models/halloween2015/pumbkin_l_f01.mdl', pos = Vector(7019.8139648438,-1835.7093505859,56.330051422119) , ang = Angle(0.28015637397766,-46.888809204102,0.161865234375)},
	{model = 'models/halloween2015/pumbkin_l_f01.mdl', pos = Vector(7164.8564453125,-2298.5266113281,20.081968307495) , ang = Angle(-0.083728834986687,128.56175231934,0.22892761230469)},
	{model = 'models/halloween2015/pumbkin_l_f02.mdl', pos = Vector(7011.3959960938,-2298.6916503906,20.044221878052) , ang = Angle(0.36334812641144,45.222854614258,0.35111999511719)},
	{model = 'models/halloween2015/pumbkin_l_f01.mdl', pos = Vector(7142.3383789062,-2493.8410644531,20.051191329956) , ang = Angle(-0.29469576478004,146.28793334961,0.20635986328125)},
	{model = 'models/halloween2015/pumbkin_s_f01.mdl', pos = Vector(9314.029296875,-4935.6616210938,11.310676574707) , ang = Angle(0.11500293016434,7.2999982833862,0.07843017578125)},
	{model = 'models/zerochain/props_halloween/cardboard_zombie02_breakable.mdl', pos = Vector(7030.8139648438,-2726.9243164062,1.7203285694122) , ang = Angle(0.15705420076847,44.178405761719,0.000244140625)},
	{model = 'models/zerochain/props_halloween/gravestone02.mdl', pos = Vector(6808.7944335938,-2671.8334960938,1.9351375102997) , ang = Angle(-1.0586475133896,0.081164792180061,0.14584350585938)},
	{model = 'models/halloween2015/pumbkin_n_f01.mdl', pos = Vector(9515.0732421875,-4770.7626953125,148.71766662598) , ang = Angle(-2.7523109912872,177.88633728027,0.021804809570312)},
	{model = 'models/zerochain/props_halloween/gravestone01.mdl', pos = Vector(6810.509765625,-2633.1376953125,1.9960236549377) , ang = Angle(0.15401442348957,0.17551083862782,0.020248413085938)},
	{model = 'models/halloween2015/pumbkin_s_f02.mdl', pos = Vector(7148.728515625,-2942.4814453125,11.30567073822) , ang = Angle(0.21044051647186,139.53440856934,0.70310974121094)},
	{model = 'models/zerochain/props_halloween/oldcoffin.mdl', pos = Vector(8548.8916015625,-5345.8310546875,56.147941589355) , ang = Angle(89.913749694824,10.221350669861,100.28028106689)},
	{model = 'models/halloween2015/pumbkin_l_f02.mdl', pos = Vector(6979.63671875,-2751.8037109375,20.124444961548) , ang = Angle(0.0010313639650121,-141.78314208984,0.000274658203125)},
	{model = 'models/halloween2015/pumbkin_l_f02.mdl', pos = Vector(8586.3564453125,-5363.00390625,20.35694694519) , ang = Angle(-1.1004549264908,-59.608814239502,-1.3441162109375)},
	{model = 'models/halloween2015/pumbkin_l_f01.mdl', pos = Vector(7712.755859375,-2891.2470703125,20.20987701416) , ang = Angle(-0.84079843759537,34.920253753662,1.0705413818359)},
	{model = 'models/halloween2015/pumbkin_s_f02.mdl', pos = Vector(8486.9775390625,-6356.8325195312,235.33561706543) , ang = Angle(-1.7732809283189e-06,-120.16297912598,0)},
	{model = 'models/halloween2015/pumbkin_n_f01.mdl', pos = Vector(8222.4111328125,-6496.9169921875,241.14933776855) , ang = Angle(-0.44573402404785,43.798759460449,-0.027313232421875)},
	{model = 'models/halloween2015/pumbkin_l_f01.mdl', pos = Vector(8000.6005859375,-2122.5966796875,20.107809066772) , ang = Angle(-0.41506391763687,-75.004737854004,0.67433166503906)},
	{model = 'models/halloween2015/pumbkin_l_f02.mdl', pos = Vector(8065.130859375,-2058.2124023438,20.038383483887) , ang = Angle(0.26995766162872,-14.855612754822,0.32177734375)},
	{model = 'models/zerochain/props_fairground/gamesign_01.mdl', pos = Vector(8286.462890625,-2331.2509765625,2.5563509464264) , ang = Angle(-1.354854884994e-05,-45.029342651367,0)},
	{model = 'models/halloween2015/pumbkin_l_f02.mdl', pos = Vector(9456.728515625,-4051.033203125,-24.267501831055) , ang = Angle(0.012720552273095,-178.88778686523,-0.37200927734375)},
	{model = 'models/zerochain/props_fairground/gamesign_01.mdl', pos = Vector(7954.1840820312,-1730.9536132812,2.5045058727264) , ang = Angle(-0.23241721093655,-127.8497543335,0.01171875)},
	{model = 'models/halloween2015/pumbkin_n_f01.mdl', pos = Vector(9941.5712890625,-4045.6123046875,-27.147594451904) , ang = Angle(-0.12937127053738,-76.118064880371,-0.31259155273438)},
	{model = 'models/halloween2015/pumbkin_s_f01.mdl', pos = Vector(8395.232421875,-1587.4333496094,11.250549316406) , ang = Angle(0.33746585249901,-150.7806854248,-0.28326416015625)},
	{model = 'models/halloween2015/pumbkin_l_f01.mdl', pos = Vector(7923.2661132812,-1588.2628173828,20.050712585449) , ang = Angle(-0.3853859603405,-35.831424713135,0.29194641113281)},
	{model = 'models/zerochain/props_halloween/oldcoffin.mdl', pos = Vector(10224.426757812,-4239.2900390625,-124.87484741211) , ang = Angle(0.0025460545439273,89.107635498047,0.21644592285156)},
	{model = 'models/zerochain/props_halloween/gravestone02.mdl', pos = Vector(8035.9326171875,-1767.1903076172,2.0622715950012) , ang = Angle(-1.156703710556,90.152992248535,0.10350036621094)},
	{model = 'models/zerochain/props_halloween/mexicanskull.mdl', pos = Vector(10254.08203125,-4213.7260742188,-64.931213378906) , ang = Angle(-11.620306968689,158.12705993652,-1.6467895507812)},
	{model = 'models/zerochain/props_halloween/cobweb.mdl', pos = Vector(10247.728515625,-4245.9321289062,-38.012466430664) , ang = Angle(-1.7580206394196,-170.91143798828,-6.28466796875)},
	{model = 'models/zerochain/props_halloween/cardboard_zombie02_breakable.mdl', pos = Vector(8242.4755859375,-1749.2749023438,1.7996017932892) , ang = Angle(3.8013593439246e-05,156.68862915039,0)},
	{model = 'models/zerochain/props_halloween/cobweb.mdl', pos = Vector(9511.2197265625,-4511.7333984375,101.59230041504) , ang = Angle(-1.1166961193085,-100.75465393066,2.2551879882812)},
	{model = 'models/halloween2015/hay_block.mdl', pos = Vector(8222.9228515625,-1846.6937255859,1.9599598646164) , ang = Angle(-0.15918113291264,179.77725219727,-0.2269287109375)},
	{model = 'models/halloween2015/pumbkin_l_f01.mdl', pos = Vector(8220.8544921875,-1860.6082763672,44.471343994141) , ang = Angle(0.016810311004519,124.66223144531,-0.2236328125)},
	{model = 'models/zerochain/props_fairground/gamesign_01.mdl', pos = Vector(8911.9560546875,-4895.708984375,2.4937016963959) , ang = Angle(-0.23485246300697,-41.063362121582,0)},
	{model = 'models/halloween2015/hay_block.mdl', pos = Vector(8665.359375,-4654.451171875,1.9676223993301) , ang = Angle(-0.070699274539948,-44.976623535156,-0.28005981445312)},
	{model = 'models/halloween2015/pumbkin_l_f01.mdl', pos = Vector(8666.265625,-4657.8852539062,44.680793762207) , ang = Angle(-0.089060217142105,-44.132953643799,-0.41058349609375)},
	{model = 'models/halloween2015/pumbkin_l_f01.mdl', pos = Vector(8940.2802734375,-2131.3759765625,20.105945587158) , ang = Angle(0.16443037986755,-120.00085449219,0.84501647949219)},
	{model = 'models/halloween2015/pumbkin_l_f01.mdl', pos = Vector(8683.638671875,-4125.5415039062,84.10391998291) , ang = Angle(0.40869271755219,172.47842407227,0.051315307617188)},
	{model = 'models/zerochain/props_halloween/mexicanskull.mdl', pos = Vector(8757.236328125,-2128.0434570312,-1.0813969373703) , ang = Angle(-12.209650993347,-78.554100036621,6.2433471679688)},
	{model = 'models/zerochain/props_industrial/robotic_saw.mdl', pos = Vector(8859.33984375,-2118.86328125,1.8970586061478) , ang = Angle(-1.4266318082809,-79.429893493652,-0.169921875)},
	{model = 'models/halloween2015/pumbkin_n_f01.mdl', pos = Vector(8740.1201171875,-2379.7946777344,17.225322723389) , ang = Angle(-0.0076470817439258,46.197334289551,-0.003814697265625)},
	{model = 'models/halloween2015/pumbkin_n_f02.mdl', pos = Vector(8858.345703125,-2375.8666992188,17.137376785278) , ang = Angle(0.36931294202805,116.59707641602,-0.32659912109375)},
	{model = 'models/zerochain/props_halloween/oldcoffin.mdl', pos = Vector(6850.9140625,-3084.9750976562,40.836158752441) , ang = Angle(9.4299287796021,-89.972839355469,-0.025634765625)},
	{model = 'models/halloween2015/pumbkin_s_f01.mdl', pos = Vector(9091.3291015625,-2267.2685546875,11.244974136353) , ang = Angle(0.50824612379074,149.60668945312,0.21450805664062)},
	{model = 'models/halloween2015/hay_block_tower.mdl', pos = Vector(9333.591796875,-2091.5695800781,1.9322664737701) , ang = Angle(-0.11615909636021,-45.038177490234,-0.231201171875)},
	{model = 'models/zerochain/props_halloween/cardboard_zombie02.mdl', pos = Vector(9402.09375,-2079.521484375,1.7629209756851) , ang = Angle(0.59226793050766,-89.213401794434,-0.05169677734375)},
	{model = 'models/halloween2015/pumbkin_s_f01.mdl', pos = Vector(9290.6064453125,-2128.3999023438,11.286062240601) , ang = Angle(-0.13711903989315,-73.700462341309,-0.21145629882812)},
	{model = 'models/halloween2015/pumbkin_s_f01.mdl', pos = Vector(6675.1044921875,-3106.3491210938,40.994335174561) , ang = Angle(-1.6792554855347,-62.886558532715,-0.84710693359375)},
	{model = 'models/halloween2015/pumbkin_n_f02.mdl', pos = Vector(9367.9248046875,-2039.2915039062,17.09342956543) , ang = Angle(-0.15275822579861,16.635747909546,-0.35891723632812)},
	{model = 'models/halloween2015/pumbkin_n_f01.mdl', pos = Vector(9731.3212890625,-2150.7312011719,17.142597198486) , ang = Angle(-0.19951751828194,-161.05462646484,-0.12530517578125)},
	{model = 'models/halloween2015/pumbkin_n_f02.mdl', pos = Vector(9570.962890625,-2320.6166992188,17.187456130981) , ang = Angle(-0.22175198793411,165.34828186035,0.003662109375)},
	{model = 'models/halloween2015/pumbkin_n_f02.mdl', pos = Vector(9498.91796875,-2494.2639160156,17.199668884277) , ang = Angle(-0.20915681123734,118.75386810303,0.22465515136719)},
	{model = 'models/halloween2015/pumbkin_s_f01.mdl', pos = Vector(9148.6865234375,-2267.3666992188,11.310570716858) , ang = Angle(-0.23025348782539,29.438558578491,0.37612915039062)},
	{model = 'models/halloween2015/pumbkin_s_f02.mdl', pos = Vector(9148.6904296875,-2148.7290039062,11.260159492493) , ang = Angle(0.33059185743332,-30.098978042603,0.23149108886719)},
	{model = 'models/zerochain/props_halloween/cardboard_zombie02.mdl', pos = Vector(10572.586914062,-1238.03125,1.767139673233) , ang = Angle(-0.052934013307095,-143.47752380371,-0.06109619140625)},
	{model = 'models/halloween2015/hay_block.mdl', pos = Vector(10489.482421875,-1471.5958251953,2.1674404144287) , ang = Angle(0.82890999317169,90.004875183105,-0.2188720703125)},
	{model = 'models/halloween2015/pumbkin_l_f01.mdl', pos = Vector(10475.244140625,-1468.8590087891,44.663887023926) , ang = Angle(0.30906096100807,29.193975448608,-0.97744750976562)},
	{model = 'models/halloween2015/pumbkin_n_f01.mdl', pos = Vector(7171.7109375,-1354.1419677734,53.10534286499) , ang = Angle(0.048214424401522,168.09634399414,0.050750732421875)},
	{model = 'models/halloween2015/pumbkin_n_f02.mdl', pos = Vector(6999.9008789062,-1220.1876220703,17.223894119263) , ang = Angle(-0.00022145255934447,-149.99395751953,0.0002288818359375)},
	{model = 'models/halloween2015/pumbkin_n_f01.mdl', pos = Vector(10476.120117188,-1233.4185791016,17.182661056519) , ang = Angle(-0.20193611085415,-31.315841674805,0.0865478515625)},
	{model = 'models/halloween2015/pumbkin_n_f01.mdl', pos = Vector(9989.29296875,-1493.2728271484,54.122188568115) , ang = Angle(-0.1853221654892,25.834583282471,-0.46221923828125)},
	{model = 'models/halloween2015/pumbkin_l_f01.mdl', pos = Vector(9993.607421875,-1444.541015625,56.980949401855) , ang = Angle(-0.002720054006204,-1.1496028900146,0.074569702148438)},
	{model = 'models/halloween2015/pumbkin_l_f02.mdl', pos = Vector(9460.052734375,-2683.1333007812,84.300010681152) , ang = Angle(0.057910189032555,156.49301147461,-0.0303955078125)},
	{model = 'models/zerochain/props_halloween/cardboard_zombie01_breakable.mdl', pos = Vector(9882.052734375,-1182.0881347656,1.7006982564926) , ang = Angle(0.15847136080265,-33.017288208008,0.0003204345703125)},
	{model = 'models/zerochain/props_halloween/cardboard_zombie02.mdl', pos = Vector(10365.942382812,-1216.9948730469,1.6959850788116) , ang = Angle(0.16109958291054,-123.2045135498,0.0002899169921875)},
	{model = 'models/zerochain/props_halloween/oldcoffin.mdl', pos = Vector(9319.189453125,-3254.564453125,56.132038116455) , ang = Angle(87.94645690918,-6.8113827705383,-4.6322326660156)},
	{model = 'models/zerochain/props_halloween/witchcauldron.mdl', pos = Vector(10368.315429688,-1513.2712402344,1.7776885032654) , ang = Angle(0.094832926988602,126.17793273926,0.009063720703125)},
	{model = 'models/halloween2015/pumbkin_s_f01.mdl', pos = Vector(10168.446289062,-643.62774658203,10.981709480286) , ang = Angle(-0.43593400716782,-120.4774017334,0.043731689453125)},
	{model = 'models/zerochain/props_fairground/gamesign_01.mdl', pos = Vector(9426.3828125,-757.26049804688,3.8288090229034) , ang = Angle(4.785129070282,-136.2883605957,0.00115966796875)},
	{model = 'models/props_candy/skittles.mdl', pos = Vector(9326.7412109375,-3293.03515625,38.043502807617) , ang = Angle(0.044474806636572,33.759433746338,0.88874816894531)},
	{model = 'models/props_candy/skittles.mdl', pos = Vector(9334.6533203125,-3301.8122558594,38.088600158691) , ang = Angle(0.40729102492332,-41.109039306641,0.1162109375)},
	{model = 'models/halloween2015/pumbkin_n_f01.mdl', pos = Vector(9337.2001953125,-3211.03125,17.121124267578) , ang = Angle(0.13426411151886,-13.062707901001,0.36257934570312)},
	{model = 'models/halloween2015/pumbkin_n_f02.mdl', pos = Vector(9856.1484375,-627.15618896484,17.153297424316) , ang = Angle(-0.03846488147974,-139.88064575195,0.0079345703125)},
	{model = 'models/halloween2015/pumbkin_s_f02.mdl', pos = Vector(9862.837890625,-753.89685058594,11.302165985107) , ang = Angle(0.1919057816267,145.47581481934,0.13311767578125)},
	{model = 'models/halloween2015/hay_block.mdl', pos = Vector(9569.8779296875,-875.86804199219,1.9628022909164) , ang = Angle(-0.096291452646255,-0.025560727342963,-0.20590209960938)},
	{model = 'models/zerochain/props_halloween/oldcoffin.mdl', pos = Vector(9391.1767578125,-628.27532958984,54.052783966064) , ang = Angle(72.861846923828,-0.70060646533966,-0.70236206054688)},
	{model = 'models/props_candy/mmscaramel.mdl', pos = Vector(6119.7407226562,-6849.6528320312,166.50662231445) , ang = Angle(-0.23321159183979,-40.161426544189,-1.4476928710938)},
	{model = 'models/props_candy/mms.mdl', pos = Vector(6123.0083007812,-6845.408203125,168.19868469238) , ang = Angle(-12.49315738678,-146.65153503418,3.7262878417969)},
	{model = 'models/halloween2015/pumbkin_n_f01.mdl', pos = Vector(6357.3203125,-6943.7075195312,145.91033935547) , ang = Angle(-0.063199602067471,122.86736297607,-0.11920166015625)},
	{model = 'models/halloween2015/pumbkin_n_f02.mdl', pos = Vector(9573.099609375,-945.17266845703,17.298120498657) , ang = Angle(-1.0199294090271,-30.410247802734,-0.1947021484375)},
	{model = 'models/zerochain/props_halloween/cobweb.mdl', pos = Vector(6124.0166015625,-6939.884765625,156.37901306152) , ang = Angle(11.49409198761,44.623607635498,-6.5016479492188)},
	{model = 'models/halloween2015/pumbkin_s_f01.mdl', pos = Vector(9730.796875,-1256.5467529297,11.335536956787) , ang = Angle(0.00020668077922892,-159.56176757812,0.0050048828125)},
	{model = 'models/halloween2015/pumbkin_n_f01.mdl', pos = Vector(9731.935546875,-1810.5595703125,17.211009979248) , ang = Angle(-0.69310140609741,128.21281433105,-0.55718994140625)},
	{model = 'models/halloween2015/pumbkin_n_f01.mdl', pos = Vector(9406.560546875,-1662.2026367188,17.133995056152) , ang = Angle(-0.23046471178532,-35.866554260254,0.54788208007812)},
	{model = 'models/halloween2015/pumbkin_n_f01.mdl', pos = Vector(7124.1044921875,-4931.375,113.56801605225) , ang = Angle(-0.097996897995472,112.58058929443,-0.03900146484375)},
	{model = 'models/halloween2015/pumbkin_n_f01.mdl', pos = Vector(8100.01953125,-1148.0794677734,17.205089569092) , ang = Angle(-0.475734770298,-60.290130615234,-0.31948852539062)},
	{model = 'models/halloween2015/pumbkin_l_f01.mdl', pos = Vector(8397.1953125,-1319.2615966797,21.49782371521) , ang = Angle(-6.7880063056946,-150.41593933105,3.1315460205078)},
	{model = 'models/zerochain/props_fairground/gamesign_01.mdl', pos = Vector(5935.7607421875,-4791.0502929688,2.4759202003479) , ang = Angle(-0.30148696899414,180,0)},
	{model = 'models/zerochain/props_halloween/gravestone02.mdl', pos = Vector(8361.2998046875,-1219.9195556641,1.7680720090866) , ang = Angle(-0.081068843603134,-154.21839904785,-0.04974365234375)},
	{model = 'models/halloween2015/pumbkin_s_f01.mdl', pos = Vector(7979.1889648438,-1236.6325683594,60.805896759033) , ang = Angle(0.18650123476982,-48.011917114258,0.42475891113281)},
	{model = 'models/halloween2015/pumbkin_n_f01.mdl', pos = Vector(8235.8125,-713.18072509766,15.910504341125) , ang = Angle(-0.12086567282677,-133.85803222656,-0.021484375)},
	{model = 'models/halloween2015/pumbkin_l_f01.mdl', pos = Vector(5939.798828125,-4715.671875,20.119276046753) , ang = Angle(0.89594221115112,-15.08740901947,0.027633666992188)},
	{model = 'models/halloween2015/pumbkin_n_f02.mdl', pos = Vector(7747.986328125,-132.74281311035,51.906295776367) , ang = Angle(0.087286904454231,-103.08222961426,0.037338256835938)},
	{model = 'models/zerochain/props_halloween/witchcauldron.mdl', pos = Vector(5984.3828125,-3548.7939453125,257.78475952148) , ang = Angle(-0.0011234893463552,-133.59889221191,-0.32260131835938)},
	{model = 'models/halloween2015/pumbkin_l_f02.mdl', pos = Vector(7849.4140625,-509.87908935547,60.834678649902) , ang = Angle(0.11768571287394,141.8780670166,-0.0494384765625)},
	{model = 'models/halloween2015/pumbkin_n_f02.mdl', pos = Vector(5940.20703125,-3907.9768066406,273.20269775391) , ang = Angle(0.072203576564789,30.24810218811,-0.267822265625)},
	{model = 'models/halloween2015/pumbkin_n_f01.mdl', pos = Vector(6789.04296875,-3515.0864257812,145.13804626465) , ang = Angle(0.24392986297607,-122.91754150391,0.36518859863281)},
	{model = 'models/halloween2015/pumbkin_s_f02.mdl', pos = Vector(7454.8129882812,-138.54377746582,43.904502868652) , ang = Angle(0.094411715865135,-27.531591415405,0.5880126953125)},
	{model = 'models/zerochain/props_halloween/cardboard_zombie02.mdl', pos = Vector(7524.27734375,-541.91748046875,0.49983957409859) , ang = Angle(9.6801741165109e-05,130.81101989746,0)},
	{model = 'models/halloween2015/pumbkin_n_f01.mdl', pos = Vector(6079.0522460938,-3717.0227050781,145.18843078613) , ang = Angle(0.34418943524361,39.240386962891,-0.17562866210938)},
	{model = 'models/halloween2015/pumbkin_n_f01.mdl', pos = Vector(8236.951171875,-236.8537902832,15.882391929626) , ang = Angle(-0.58466500043869,-134.05319213867,-0.23300170898438)},
	{model = 'models/halloween2015/pumbkin_n_f02.mdl', pos = Vector(8323.63671875,-440.8122253418,15.801763534546) , ang = Angle(-0.06130200996995,139.6081237793,0.01580810546875)},
	{model = 'models/zerochain/props_fairground/gamesign_01.mdl', pos = Vector(6915.2026367188,-4084.0705566406,130.49827575684) , ang = Angle(-0.21865344047546,90.791961669922,-6.103515625e-05)},
	{model = 'models/zerochain/props_halloween/oldcoffin.mdl', pos = Vector(9266.84765625,-292.64111328125,56.738452911377) , ang = Angle(89.981010437012,89.899063110352,180)},
	{model = 'models/halloween2015/pumbkin_l_f01.mdl', pos = Vector(6834.9931640625,-4086.1845703125,148.0881652832) , ang = Angle(-0.24346642196178,-59.705841064453,-0.23480224609375)},
	{model = 'models/zerochain/props_halloween/oldcoffin.mdl', pos = Vector(8464.8896484375,-426.10256958008,56.795078277588) , ang = Angle(89.763854980469,89.995643615723,89.995643615723)},
	{model = 'models/zerochain/props_halloween/gravestone02.mdl', pos = Vector(8618.154296875,-437.18991088867,2.6946218013763) , ang = Angle(-1.1838301420212,89.775001525879,0.08489990234375)},
	{model = 'models/zerochain/props_halloween/gravestone02.mdl', pos = Vector(8938.263671875,-294.83444213867,2.6682918071747) , ang = Angle(-1.1670216321945,-89.798011779785,0.1175537109375)},
	{model = 'models/halloween2015/pumbkin_n_f02.mdl', pos = Vector(8971.791015625,-306.60406494141,17.806146621704) , ang = Angle(0.21072521805763,-64.874298095703,-0.0850830078125)},
	{model = 'models/halloween2015/pumbkin_l_f01.mdl', pos = Vector(8664.119140625,-305.36013793945,20.72275352478) , ang = Angle(0.58258920907974,-45.614570617676,0.22793579101562)},
	{model = 'models/halloween2015/pumbkin_l_f01.mdl', pos = Vector(9740.5302734375,-3564.7282714844,116.0022354126) , ang = Angle(2.7759425640106,147.20648193359,-1.7871704101562)},
	{model = 'models/halloween2015/pumbkin_l_f02.mdl', pos = Vector(8266.7880859375,3202.6850585938,18.745212554932) , ang = Angle(-0.15175947546959,-129.36660766602,0.11480712890625)},
	{model = 'models/halloween2015/pumbkin_n_f01.mdl', pos = Vector(8011.3774414062,3241.9396972656,15.850620269775) , ang = Angle(-0.42914319038391,-59.766399383545,0.21632385253906)},
	{model = 'models/halloween2015/pumbkin_s_f02.mdl', pos = Vector(8103.2954101562,570.92102050781,10.990383148193) , ang = Angle(-0.21784490346909,-69.299598693848,-0.0220947265625)},
	{model = 'models/halloween2015/pumbkin_n_f02.mdl', pos = Vector(8218.8896484375,17.144603729248,16.881002426147) , ang = Angle(-0.70098131895065,136.7403717041,-0.19720458984375)},
	{model = 'models/props_candy/whoppers.mdl', pos = Vector(7614.2163085938,-4230.087890625,28.733337402344) , ang = Angle(0.14455515146255,107.94474029541,0.65167236328125)},
	{model = 'models/halloween2015/pumbkin_s_f02.mdl', pos = Vector(8107.69921875,132.53910827637,10.948171615601) , ang = Angle(0.40071678161621,30.583993911743,0.14414978027344)},
	{model = 'models/props_candy/lemonhead.mdl', pos = Vector(7620.5717773438,-4248.0893554688,28.462472915649) , ang = Angle(0.16410872340202,130.56658935547,-0.057373046875)},
	{model = 'models/zerochain/props_halloween/gravestone02.mdl', pos = Vector(8222.7060546875,406.5700378418,1.5590792894363) , ang = Angle(-0.070871561765671,-146.83912658691,-0.028533935546875)},
	{model = 'models/zerochain/props_halloween/mexicanskull.mdl', pos = Vector(8099.3999023438,409.27444458008,-1.346862077713) , ang = Angle(-11.955647468567,-31.384601593018,-7.3269653320312)},
	{model = 'models/zerochain/props_halloween/cardboard_zombie01.mdl', pos = Vector(8802.279296875,941.43048095703,36.57190322876) , ang = Angle(6.7011847496033,90.119407653809,0.0343017578125)},
	{model = 'models/halloween2015/pumbkin_s_f02.mdl', pos = Vector(8547.7939453125,988.66497802734,10.010851860046) , ang = Angle(-0.1151637583971,40.438087463379,-0.10418701171875)},
	{model = 'models/halloween2015/pumbkin_l_f02.mdl', pos = Vector(8867.7548828125,1315.9555664062,18.80767250061) , ang = Angle(-0.37534967064857,-152.23080444336,0.22459411621094)},
	{model = 'models/halloween2015/hay_block_tower.mdl', pos = Vector(8853.4873046875,1002.1865234375,0.85237836837769) , ang = Angle(0.28942614793777,90.086944580078,-0.636474609375)},
	{model = 'models/zerochain/props_halloween/oldcoffin.mdl', pos = Vector(7466.7358398438,-1553.4665527344,56.221332550049) , ang = Angle(84.217750549316,-98.79557800293,-6.3997192382812)},
	{model = 'models/zerochain/props_halloween/oldcoffin.mdl', pos = Vector(8610.859375,987.10748291016,1.878613948822) , ang = Angle(-0.02890969067812,-0.85724192857742,-0.050445556640625)},
	{model = 'models/zerochain/props_fairground/gamesign_01.mdl', pos = Vector(8573.1396484375,1289.1984863281,1.1936783790588) , ang = Angle(2.8091897547711e-05,135.92953491211,-0.072479248046875)},
	{model = 'models/halloween2015/pumbkin_s_f02.mdl', pos = Vector(8283.654296875,1209.2955322266,9.9676380157471) , ang = Angle(0.298702865839,-61.029705047607,0.20915222167969)},
	{model = 'models/halloween2015/pumbkin_s_f01.mdl', pos = Vector(8686.3076171875,929.88580322266,45.91577911377) , ang = Angle(-0.11407735943794,-50.039813995361,0.07623291015625)},
	{model = 'models/halloween2015/pumbkin_l_f01.mdl', pos = Vector(8235.6064453125,1049.9078369141,18.779397964478) , ang = Angle(-0.20549750328064,-154.72799682617,-0.24053955078125)},
	{model = 'models/halloween2015/pumbkin_l_f02.mdl', pos = Vector(6180.5893554688,-264.17413330078,18.814750671387) , ang = Angle(0.23627543449402,114.46479797363,-0.09307861328125)},
	{model = 'models/halloween2015/pumbkin_n_f01.mdl', pos = Vector(5555.16015625,-266.65994262695,15.766758918762) , ang = Angle(0.28978353738785,148.64305114746,-0.31488037109375)},
	{model = 'models/halloween2015/pumbkin_n_f02.mdl', pos = Vector(5340.5146484375,-96.578392028809,15.923555374146) , ang = Angle(-0.017616152763367,-58.328365325928,0.019607543945312)},
	{model = 'models/halloween2015/pumbkin_n_f01.mdl', pos = Vector(4113.6015625,-2380.4528808594,84.055274963379) , ang = Angle(0.19179832935333,61.607906341553,-0.22039794921875)},
	{model = 'models/halloween2015/pumbkin_l_f01.mdl', pos = Vector(4387.4755859375,-2346.7216796875,18.824550628662) , ang = Angle(9.4879067091824e-07,36.025897979736,0)},
	{model = 'models/halloween2015/pumbkin_s_f01.mdl', pos = Vector(4289.1655273438,-1989.4814453125,9.9976396560669) , ang = Angle(0.21370385587215,-148.1710357666,0.089752197265625)},
	{model = 'models/halloween2015/pumbkin_n_f02.mdl', pos = Vector(3920.8874511719,-267.82705688477,15.802984237671) , ang = Angle(-0.23769897222519,44.800453186035,0.084625244140625)},
	{model = 'models/halloween2015/pumbkin_n_f01.mdl', pos = Vector(4444.150390625,-253.75695800781,24.756439208984) , ang = Angle(0.30986553430557,104.85020446777,0.2801513671875)},
	{model = 'models/halloween2015/pumbkin_l_f02.mdl', pos = Vector(7599.11328125,748.42797851562,55.100093841553) , ang = Angle(-0.11703327298164,136.83464050293,0.06024169921875)},
	{model = 'models/zerochain/props_halloween/witchcauldron.mdl', pos = Vector(4473.5493164062,489.14218139648,0.51349544525146) , ang = Angle(0.35482349991798,-162.13735961914,-0.15606689453125)},
	{model = 'models/halloween2015/pumbkin_n_f01.mdl', pos = Vector(8358.4658203125,1352.3336181641,57.920902252197) , ang = Angle(0.098704740405083,-158.63481140137,-0.04534912109375)},
	{model = 'models/halloween2015/pumbkin_n_f01.mdl', pos = Vector(4333.7514648438,523.50793457031,15.808016777039) , ang = Angle(0.037892710417509,-137.64779663086,0.2857666015625)},
	{model = 'models/halloween2015/pumbkin_s_f02.mdl', pos = Vector(8352.609375,1287.3505859375,9.8724870681763) , ang = Angle(0.020609151571989,167.73434448242,0.077560424804688)},
	{model = 'models/halloween2015/pumbkin_l_f02.mdl', pos = Vector(8092.4272460938,1275.0029296875,18.713136672974) , ang = Angle(-0.42921367287636,5.7834181785583,0.16944885253906)},
	{model = 'models/zerochain/props_halloween/cardboard_zombie01_breakable.mdl', pos = Vector(8341.736328125,1938.2684326172,68.541534423828) , ang = Angle(-0.079325534403324,-140.39851379395,0.0013885498046875)},
	{model = 'models/halloween2015/pumbkin_l_f01.mdl', pos = Vector(8109.400390625,1955.1260986328,86.931694030762) , ang = Angle(-0.046866405755281,-41.932292938232,-0.19659423828125)},
	{model = 'models/halloween2015/hay_block.mdl', pos = Vector(4060.6586914062,1188.2913818359,0.50968074798584) , ang = Angle(-0.21866796910763,-43.924812316895,-0.12918090820312)},
	{model = 'models/halloween2015/pumbkin_l_f01.mdl', pos = Vector(4063.7214355469,1187.3413085938,43.129776000977) , ang = Angle(-0.4620059132576,-47.46671295166,-0.7493896484375)},
	{model = 'models/halloween2015/pumbkin_n_f01.mdl', pos = Vector(3460.427734375,-73.099510192871,62.371032714844) , ang = Angle(0.40638384222984,-25.287788391113,0.075759887695312)},
	{model = 'models/halloween2015/pumbkin_s_f01.mdl', pos = Vector(3610.0991210938,0.78571200370789,38.995788574219) , ang = Angle(0.61016494035721,110.66147613525,0.3631591796875)},
	{model = 'models/zerochain/props_halloween/witchcauldron.mdl', pos = Vector(3669.8576660156,440.70190429688,0.55841434001923) , ang = Angle(0.06659696996212,168.71476745605,-0.022705078125)},
	{model = 'models/zerochain/props_halloween/mexicanskull.mdl', pos = Vector(3681.669921875,484.39123535156,-2.5364303588867) , ang = Angle(-11.800033569336,153.67070007324,-1.4660339355469)},
	{model = 'models/halloween2015/pumbkin_l_f01.mdl', pos = Vector(3673.4379882812,1209.3555908203,55.764610290527) , ang = Angle(10.070539474487,-172.38055419922,1.5548095703125)},
	{model = 'models/halloween2015/pumbkin_n_f01.mdl', pos = Vector(2809.958984375,1995.5631103516,57.998264312744) , ang = Angle(0.37386110424995,-40.130237579346,0.046783447265625)},
	{model = 'models/halloween2015/pumbkin_s_f02.mdl', pos = Vector(8043.7377929688,2443.0864257812,46.346652984619) , ang = Angle(0.020067779347301,-27.762029647827,-0.140869140625)},
	{model = 'models/zerochain/props_halloween/gravestone02.mdl', pos = Vector(7936.9663085938,2417.5183105469,0.50158423185349) , ang = Angle(0.15472787618637,19.75562286377,0.13388061523438)},
	{model = 'models/zerochain/props_halloween/mexicanskull.mdl', pos = Vector(7887.9790039062,2490.7763671875,21.820108413696) , ang = Angle(-12.010674476624,-20.494808197021,1.7973022460938)},
	{model = 'models/halloween2015/pumbkin_l_f01.mdl', pos = Vector(7963.21484375,2485.900390625,83.297393798828) , ang = Angle(0.19924525916576,-63.713512420654,0.11366271972656)},
	{model = 'models/zerochain/props_halloween/oldcoffin.mdl', pos = Vector(4707.18359375,1875.0020751953,1.798801779747) , ang = Angle(-0.012516455724835,-90.902687072754,0.068252563476562)},
	{model = 'models/zerochain/props_halloween/mexicanskull.mdl', pos = Vector(4705.4404296875,1843.1500244141,19.653911590576) , ang = Angle(-12.099271774292,-38.431640625,6.1798706054688)},
	{model = 'models/halloween2015/pumbkin_s_f02.mdl', pos = Vector(8311.4658203125,2304.8286132812,9.9536294937134) , ang = Angle(0.36476269364357,58.140586853027,-0.2083740234375)},
	{model = 'models/halloween2015/hay_block_tower.mdl', pos = Vector(8581.1298828125,2467.6811523438,0.84725314378738) , ang = Angle(-0.57614481449127,-90.104095458984,-0.3856201171875)},
	{model = 'models/zerochain/props_halloween/cardboard_zombie02.mdl', pos = Vector(8525.751953125,2446.54296875,0.35244646668434) , ang = Angle(0.4213675558567,-120.16410064697,-0.02734375)},
	{model = 'models/halloween2015/pumbkin_n_f02.mdl', pos = Vector(8454.2646484375,2447.3520507812,15.840243339539) , ang = Angle(-0.042010795325041,-52.151412963867,0.010848999023438)},
	{model = 'models/halloween2015/pumbkin_n_f01.mdl', pos = Vector(8592.9892578125,2334.4052734375,15.89496421814) , ang = Angle(-0.19465483725071,131.36589050293,0.012985229492188)},
	{model = 'models/halloween2015/pumbkin_l_f02.mdl', pos = Vector(8455.4013671875,2330.7365722656,18.741582870483) , ang = Angle(0.2721363902092,75.883987426758,0.10273742675781)},
	{model = 'models/halloween2015/pumbkin_l_f01.mdl', pos = Vector(5939.076171875,1996.7860107422,47.11164855957) , ang = Angle(-0.87256997823715,-74.822532653809,0.30096435546875)},
	{model = 'models/zerochain/props_fairground/gamesign_01.mdl', pos = Vector(5739.34375,1971.6484375,1.2332731485367) , ang = Angle(-0.061808787286282,85.67512512207,-0.002044677734375)},
	{model = 'models/zerochain/props_halloween/mexicanskull.mdl', pos = Vector(5667.541015625,1974.8671875,-2.5333962440491) , ang = Angle(-11.683842658997,-75.28426361084,-2.3042602539062)},
	{model = 'models/halloween2015/pumbkin_s_f02.mdl', pos = Vector(-381.10934448242,-6457.17578125,-2391.0908203125) , ang = Angle(0.056803546845913,62.173725128174,0.0066070556640625)},
	{model = 'models/halloween2015/pumbkin_l_f01.mdl', pos = Vector(-705.14916992188,-6418.0629882812,-2346.3239746094) , ang = Angle(0.01469873636961,40.534339904785,-0.1099853515625)},
	{model = 'models/halloween2015/pumbkin_l_f02.mdl', pos = Vector(5278.94921875,1555.3022460938,115.078956604) , ang = Angle(0.42604896426201,59.53885269165,0.1153564453125)},
	{model = 'models/halloween2015/pumbkin_l_f02.mdl', pos = Vector(-632.03094482422,-6458.40625,-2382.1264648438) , ang = Angle(-0.20506526529789,105.73234558105,0.11833190917969)},
	{model = 'models/halloween2015/pumbkin_n_f01.mdl', pos = Vector(-704.80841064453,-5954.3408203125,-2385.1669921875) , ang = Angle(0.50623339414597,-29.301267623901,-0.099609375)},
	{model = 'models/zerochain/props_halloween/oldcoffin.mdl', pos = Vector(5646.8369140625,2131.2331542969,1.8374493122101) , ang = Angle(0.036099910736084,-0.88685023784637,0.024093627929688)},
	{model = 'models/zerochain/props_halloween/witchcauldron.mdl', pos = Vector(5475.5170898438,2649.4514160156,0.52789109945297) , ang = Angle(0.077907308936119,-96.29328918457,-0.01171875)},
	{model = 'models/halloween2015/pumbkin_n_f01.mdl', pos = Vector(5424.4736328125,2659.0988769531,15.915752410889) , ang = Angle(-0.077278845012188,-87.40983581543,-0.12710571289062)},
	{model = 'models/zerochain/props_halloween/oldcoffin.mdl', pos = Vector(5646.8974609375,2169.1533203125,1.8394829034805) , ang = Angle(0.0021826599258929,-2.6808700561523,-0.01446533203125)},
	{model = 'models/halloween2015/pumbkin_n_f01.mdl', pos = Vector(5680.6420898438,2150.396484375,37.923854827881) , ang = Angle(-0.24275641143322,68.928092956543,0.48341369628906)},
	{model = 'models/halloween2015/pumbkin_s_f02.mdl', pos = Vector(7763.6162109375,2774.7585449219,9.9613056182861) , ang = Angle(0.36676672101021,59.99963760376,-0.15716552734375)},
	{model = 'models/halloween2015/pumbkin_s_f02.mdl', pos = Vector(7854.2861328125,2777.9873046875,9.9502258300781) , ang = Angle(0.0091800037771463,111.13568115234,0.038406372070312)},
	{model = 'models/halloween2015/pumbkin_s_f02.mdl', pos = Vector(7896.26953125,2774.5908203125,46.231296539307) , ang = Angle(0.37050890922546,136.93215942383,-0.0108642578125)},
	{model = 'models/halloween2015/pumbkin_n_f01.mdl', pos = Vector(6173.98828125,2521.0512695312,15.869158744812) , ang = Angle(0.22751319408417,-58.87036895752,-0.02764892578125)},
	{model = 'models/zerochain/props_halloween/oldcoffin.mdl', pos = Vector(6355.95703125,2223.2475585938,51.647548675537) , ang = Angle(68.856132507324,89.672805786133,-0.5592041015625)},
	{model = 'models/halloween2015/pumbkin_s_f02.mdl', pos = Vector(6785.2763671875,2274.7231445312,46.336082458496) , ang = Angle(-0.17787380516529,158.5150604248,-0.17446899414062)},
	{model = 'models/zerochain/props_halloween/cardboard_zombie01_breakable.mdl', pos = Vector(6789.9614257812,2205.9692382812,36.814632415771) , ang = Angle(0.1186136752367,29.068866729736,-0.1280517578125)},
	{model = 'models/halloween2015/pumbkin_s_f02.mdl', pos = Vector(6890.5620117188,2347.4211425781,9.9287261962891) , ang = Angle(-0.24134461581707,-44.98152923584,0.214111328125)},
	{model = 'models/halloween2015/pumbkin_n_f02.mdl', pos = Vector(6890.107421875,2132.1613769531,15.911978721619) , ang = Angle(-0.20805938541889,48.459907531738,0.15304565429688)},
	{model = 'models/zerochain/props_fairground/gamesign_01.mdl', pos = Vector(7078.7470703125,2159.7734375,1.1842408180237) , ang = Angle(-0.27110320329666,-42.785079956055,3.0517578125e-05)},
	{model = 'models/halloween2015/pumbkin_n_f02.mdl', pos = Vector(6173.7998046875,2742.6787109375,34.257225036621) , ang = Angle(-0.1885894536972,-6.5761675834656,-0.055908203125)},
	{model = 'models/zerochain/props_fairground/gamesign_01.mdl', pos = Vector(6173.7880859375,2953.8601074219,1.1086794137955) , ang = Angle(0.10350204259157,-175.13356018066,-0.00390625)},
	{model = 'models/zerochain/props_halloween/gravestone02.mdl', pos = Vector(7107.1982421875,2599.3947753906,0.55865842103958) , ang = Angle(0.0061102882027626,-119.1618270874,-0.07135009765625)},
	{model = 'models/zerochain/props_halloween/cardboard_zombie02.mdl', pos = Vector(7094.9887695312,2297.7419433594,0.47197949886322) , ang = Angle(0.04328778386116,-171.27893066406,9.1552734375e-05)},
	{model = 'models/halloween2015/pumbkin_n_f01.mdl', pos = Vector(6347.8349609375,3637.7749023438,41.793022155762) , ang = Angle(0.68978315591812,-119.97252655029,-0.091827392578125)},
	{model = 'models/halloween2015/pumbkin_s_f01.mdl', pos = Vector(5818.1572265625,3491.0998535156,28.317602157593) , ang = Angle(-0.202039539814,91.668403625488,0.045623779296875)},
	{model = 'models/halloween2015/pumbkin_s_f02.mdl', pos = Vector(6916,2598.9299316406,46.303466796875) , ang = Angle(-0.14591170847416,-61.985649108887,0.29110717773438)},
	{model = 'models/halloween2015/pumbkin_s_f01.mdl', pos = Vector(6637.1381835938,2603.2719726562,9.975152015686) , ang = Angle(0.32284086942673,-60.597026824951,0.10562133789062)},
	{model = 'models/halloween2015/pumbkin_n_f01.mdl', pos = Vector(6578.0102539062,2538.12109375,51.66996383667) , ang = Angle(0.27241033315659,-29.601047515869,2.0322418212891)},
	{model = 'models/zerochain/props_halloween/witchcauldron.mdl', pos = Vector(5103.4135742188,3764.6186523438,0.52261477708817) , ang = Angle(0.025036849081516,-86.605239868164,-0.175048828125)},
	{model = 'models/zerochain/props_fairground/gamesign_01.mdl', pos = Vector(7180.052734375,2913.712890625,1.1828401088715) , ang = Angle(-0.27713742852211,-89.963912963867,-0.000244140625)},
	{model = 'models/halloween2015/pumbkin_l_f01.mdl', pos = Vector(5143.96875,3804.05859375,107.17599487305) , ang = Angle(0.32172223925591,-95.744361877441,0.096084594726562)},
	{model = 'models/zerochain/props_halloween/cardboard_zombie02.mdl', pos = Vector(7210.2431640625,3250.548828125,0.48199233412743) , ang = Angle(-0.17419093847275,-138.9366607666,-0.00408935546875)},
	{model = 'models/halloween2015/pumbkin_n_f01.mdl', pos = Vector(4626.8115234375,2936.7751464844,-0.18651583790779) , ang = Angle(-0.0012765567516908,6.3951659202576,0.018753051757812)},
	{model = 'models/halloween2015/pumbkin_n_f01.mdl', pos = Vector(5050.4624023438,2076.2067871094,15.812393188477) , ang = Angle(0.171605437994,119.59906768799,0.17491149902344)},
	{model = 'models/zerochain/props_halloween/oldcoffin.mdl', pos = Vector(4707.1533203125,1564.3276367188,1.81167781353) , ang = Angle(-0.017038717865944,-90.9365234375,-0.0277099609375)},
	{model = 'models/halloween2015/pumbkin_l_f01.mdl', pos = Vector(4707.4951171875,1546.8771972656,40.961517333984) , ang = Angle(-0.63051611185074,21.965250015259,-0.19808959960938)},
	{model = 'models/halloween2015/pumbkin_n_f01.mdl', pos = Vector(4872.9428710938,1053.1765136719,15.835552215576) , ang = Angle(-0.16122704744339,146.35885620117,-0.414794921875)},
	{model = 'models/halloween2015/pumbkin_s_f01.mdl', pos = Vector(7060.5649414062,3253.3400878906,10.217441558838) , ang = Angle(-1.3369296789169,-60.524845123291,3.0517578125e-05)},
	{model = 'models/halloween2015/pumbkin_n_f01.mdl', pos = Vector(4204.1005859375,3947.5971679688,15.92444896698) , ang = Angle(-0.021117584779859,-130.14437866211,-0.00201416015625)},
	{model = 'models/halloween2015/pumbkin_s_f02.mdl', pos = Vector(6845.8139648438,3069.4235839844,9.9894618988037) , ang = Angle(-0.072878435254097,-46.622711181641,0.095489501953125)},
	{model = 'models/halloween2015/pumbkin_n_f01.mdl', pos = Vector(4557.0546875,3723.1794433594,15.847784042358) , ang = Angle(0.39706969261169,-97.709190368652,-0.081787109375)},
	{model = 'models/halloween2015/pumbkin_s_f02.mdl', pos = Vector(6972.9262695312,3419.3022460938,60.492046356201) , ang = Angle(0.33098587393761,-24.565254211426,-0.0908203125)},
	{model = 'models/halloween2015/pumbkin_n_f01.mdl', pos = Vector(4027.4741210938,3666.61328125,15.910398483276) , ang = Angle(0.043978471308947,-162.14608764648,-0.0606689453125)},
	{model = 'models/halloween2015/pumbkin_l_f02.mdl', pos = Vector(7363.3618164062,4202.0922851562,18.765079498291) , ang = Angle(-0.11889173835516,152.33282470703,0.082534790039062)},
	{model = 'models/halloween2015/pumbkin_n_f01.mdl', pos = Vector(7091.2626953125,4277.9790039062,16.222049713135) , ang = Angle(-2.2231411933899,-29.708374023438,1.3473052978516)},
	{model = 'models/zerochain/props_halloween/cardboard_zombie01_breakable.mdl', pos = Vector(7269.2739257812,4217.4106445312,-447.71981811523) , ang = Angle(0.48877182602882,-157.98838806152,-0.0003662109375)},
	{model = 'models/zerochain/props_fairground/gamesign_01.mdl', pos = Vector(2249.6838378906,3558.955078125,1.2228823900223) , ang = Angle(-0.028870580717921,-89.989273071289,0.007904052734375)},
	{model = 'models/zerochain/props_halloween/cardboard_zombie02_breakable.mdl', pos = Vector(6971.474609375,4010.0288085938,-447.50262451172) , ang = Angle(0.20989924669266,33.124969482422,-0.019500732421875)},
	{model = 'models/zerochain/props_halloween/oldcoffin.mdl', pos = Vector(6973.2290039062,4082.3400878906,-446.10968017578) , ang = Angle(-1.0887843927776e-05,90.892372131348,-9.1552734375e-05)},
	{model = 'models/halloween2015/pumbkin_n_f01.mdl', pos = Vector(2319.501953125,3580.1271972656,15.90275478363) , ang = Angle(-0.60358375310898,101.13799285889,0.25247192382812)},
	{model = 'models/zerochain/props_halloween/witchcauldron.mdl', pos = Vector(2308.4916992188,3921.2475585938,0.47849541902542) , ang = Angle(-0.14797513186932,-103.07502746582,-0.383544921875)},
	{model = 'models/zerochain/props_halloween/mexicanskull.mdl', pos = Vector(2272.552734375,3936.8330078125,-2.4938008785248) , ang = Angle(-11.927943229675,-96.155555725098,4.0583343505859)},
	{model = 'models/halloween2015/pumbkin_n_f01.mdl', pos = Vector(1818.0538330078,3464.5922851562,58.146377563477) , ang = Angle(0.122986741364,105.52854919434,0.35432434082031)},
	{model = 'models/halloween2015/pumbkin_n_f01.mdl', pos = Vector(1284.4437255859,3538.4838867188,16.721256256104) , ang = Angle(4.7723979949951,16.551099777222,1.3799591064453)},
	{model = 'models/halloween2015/pumbkin_n_f01.mdl', pos = Vector(2588.2641601562,2716.3308105469,73.162551879883) , ang = Angle(11.413866996765,44.429794311523,-8.404541015625)},
	{model = 'models/halloween2015/pumbkin_s_f02.mdl', pos = Vector(6712.6743164062,4510.4965820312,-246.05897521973) , ang = Angle(0.2494343817234,-52.440231323242,-0.0067138671875)},
	{model = 'models/halloween2015/pumbkin_l_f02.mdl', pos = Vector(6709.8564453125,4372.7153320312,-237.1755065918) , ang = Angle(-0.26937186717987,20.641139984131,0.2509765625)},
	{model = 'models/halloween2015/pumbkin_n_f01.mdl', pos = Vector(2816.5869140625,3292.1594238281,-261.42611694336) , ang = Angle(0.19701421260834,-74.642150878906,-0.28802490234375)},
	{model = 'models/zerochain/props_halloween/oldcoffin.mdl', pos = Vector(1834.9458007812,3411.1899414062,-254.1089630127) , ang = Angle(0.0052064671181142,-0.84992551803589,-0.0135498046875)},
	{model = 'models/halloween2015/pumbkin_l_f01.mdl', pos = Vector(6916.9755859375,4069.130859375,-237.20404052734) , ang = Angle(-0.40316870808601,119.90348815918,0.30465698242188)},
	{model = 'models/halloween2015/pumbkin_n_f01.mdl', pos = Vector(1862.0704345703,3411.8696289062,-217.9312286377) , ang = Angle(0.69789665937424,17.732381820679,-0.44415283203125)},
	{model = 'models/halloween2015/pumbkin_s_f01.mdl', pos = Vector(7558.75,4539.1938476562,-221.23750305176) , ang = Angle(-5.2327380180359,-140.81307983398,-7.143310546875)},
	{model = 'models/halloween2015/pumbkin_s_f01.mdl', pos = Vector(2411.3244628906,3627.2834472656,-245.90643310547) , ang = Angle(-0.7110435962677,-119.22440338135,0.033477783203125)},
	{model = 'models/zerochain/props_halloween/oldcoffin.mdl', pos = Vector(2909.6706542969,2709.8688964844,-331.00872802734) , ang = Angle(73.4345703125,90.050346374512,0.055282592773438)},
	{model = 'models/zerochain/props_halloween/cobweb.mdl', pos = Vector(2867.1003417969,2720.3129882812,-359.63903808594) , ang = Angle(11.682508468628,80.149055480957,-20.474761962891)},
	{model = 'models/halloween2015/pumbkin_n_f02.mdl', pos = Vector(5441.2583007812,-1083.8165283203,51.863704681396) , ang = Angle(-0.13602468371391,35.914638519287,0.093673706054688)},
	{model = 'models/zerochain/props_halloween/cardboard_zombie02.mdl', pos = Vector(5414.501953125,-988.20159912109,0.44742476940155) , ang = Angle(-0.38289165496826,10.850048065186,0.12374877929688)},
	{model = 'models/halloween2015/pumbkin_n_f01.mdl', pos = Vector(4281.6064453125,3009.3095703125,15.92338848114) , ang = Angle(0.14011541008949,166.84027099609,-0.25900268554688)},
	{model = 'models/halloween2015/pumbkin_n_f01.mdl', pos = Vector(3748.6245117188,3098.1806640625,51.110557556152) , ang = Angle(-0.40301918983459,60.878612518311,-0.04071044921875)},
	{model = 'models/halloween2015/pumbkin_n_f01.mdl', pos = Vector(3268.607421875,2992.5,-112.07593536377) , ang = Angle(-3.3363285183441e-05,14.470960617065,0)},
	{model = 'models/halloween2015/pumbkin_s_f02.mdl', pos = Vector(5835.244140625,-1123.5288085938,10.006419181824) , ang = Angle(-0.14069157838821,146.0842590332,-0.10543823242188)},
	{model = 'models/halloween2015/pumbkin_n_f01.mdl', pos = Vector(5508.1088867188,-1123.8137207031,15.927318572998) , ang = Angle(-0.54395478963852,47.852741241455,-0.51181030273438)},
	{model = 'models/halloween2015/pumbkin_l_f01.mdl', pos = Vector(3395.296875,2844.1726074219,-109.17544555664) , ang = Angle(-7.7540943266285e-07,23.976884841919,1.52587890625e-05)},
	{model = 'models/halloween2015/pumbkin_n_f02.mdl', pos = Vector(4264.4013671875,2443.4592285156,15.77370262146) , ang = Angle(0.20622853934765,-163.33628845215,-0.03668212890625)},
	{model = 'models/halloween2015/hay_block.mdl', pos = Vector(3939.6330566406,2436.8540039062,1.5266996622086) , ang = Angle(0.61905318498611,-85.901512145996,0.29887390136719)},
	{model = 'models/halloween2015/pumbkin_s_f01.mdl', pos = Vector(3939.0588378906,2433.9870605469,35.349552154541) , ang = Angle(0.36600202322006,-89.919738769531,0.62635803222656)},
	{model = 'models/halloween2015/pumbkin_n_f01.mdl', pos = Vector(3307.3515625,2437.9016113281,106.74606323242) , ang = Angle(4.2238826751709,-59.240631103516,1.5829315185547)},
	{model = 'models/halloween2015/pumbkin_n_f02.mdl', pos = Vector(3787.5380859375,2442.4067382812,15.799644470215) , ang = Angle(-0.22698518633842,-151.04861450195,-0.3846435546875)},
	{model = 'models/halloween2015/pumbkin_n_f01.mdl', pos = Vector(2453.5544433594,1339.5920410156,104.09912872314) , ang = Angle(0.057023759931326,-52.775604248047,0.038986206054688)},
	{model = 'models/halloween2015/pumbkin_s_f02.mdl', pos = Vector(5508.7954101562,-804.70422363281,10.025320053101) , ang = Angle(-0.021553823724389,-44.757419586182,-0.05474853515625)},
	{model = 'models/zerochain/props_fairground/gamesign_01.mdl', pos = Vector(5800.0893554688,-835.54467773438,1.2139894962311) , ang = Angle(-0.063150525093079,44.111301422119,-0.0684814453125)},
	{model = 'models/halloween2015/pumbkin_l_f02.mdl', pos = Vector(742.47546386719,3557.7072753906,18.767045974731) , ang = Angle(0.20441220700741,35.552783966064,-0.18426513671875)},
	{model = 'models/zerochain/props_halloween/gravestone02.mdl', pos = Vector(5847.1459960938,-967.21105957031,0.68380910158157) , ang = Angle(-1.1399509906769,-179.86096191406,-0.07904052734375)},
	{model = 'models/zerochain/props_halloween/oldcoffin.mdl', pos = Vector(5506.955078125,-998.10034179688,1.6683146953583) , ang = Angle(0.010762114077806,-90.973197937012,0.0097503662109375)},
	{model = 'models/halloween2015/pumbkin_n_f02.mdl', pos = Vector(995.95385742188,3083.9221191406,15.923461914062) , ang = Angle(-0.067509688436985,-149.41595458984,0.0701904296875)},
	{model = 'models/zerochain/props_halloween/oldcoffin.mdl', pos = Vector(5664.7817382812,-1124.8438720703,1.8903049230576) , ang = Angle(-1.3944306829217e-06,-0.99132579565048,0)},
	{model = 'models/halloween2015/pumbkin_l_f01.mdl', pos = Vector(2411.4008789062,2539.3498535156,37.14387512207) , ang = Angle(-0.55735319852829,-99.98706817627,-0.28500366210938)},
	{model = 'models/halloween2015/pumbkin_s_f02.mdl', pos = Vector(5738.6352539062,-540.93218994141,9.8675994873047) , ang = Angle(0.16947887837887,-151.27342224121,-0.027587890625)},
	{model = 'models/halloween2015/pumbkin_n_f01.mdl', pos = Vector(1924.2674560547,2132.1062011719,65.365615844727) , ang = Angle(-0.24301333725452,28.063135147095,0.13796997070312)},
	{model = 'models/halloween2015/pumbkin_l_f02.mdl', pos = Vector(1605.4169921875,2338.6975097656,18.709348678589) , ang = Angle(-0.092502228915691,-5.8205966949463,-0.025146484375)},
	{model = 'models/halloween2015/pumbkin_s_f01.mdl', pos = Vector(1180.4873046875,2225.5551757812,59.3073387146) , ang = Angle(-0.023836519569159,44.333721160889,0.18328857421875)},
	{model = 'models/zerochain/props_halloween/witchcauldron.mdl', pos = Vector(1245.6364746094,2003.7789306641,0.51582098007202) , ang = Angle(0.053198490291834,40.462089538574,-0.19784545898438)},
	{model = 'models/halloween2015/pumbkin_l_f01.mdl', pos = Vector(5299.5239257812,-539.15026855469,18.791465759277) , ang = Angle(-0.41788938641548,-31.137754440308,0.30073547363281)},
	{model = 'models/zerochain/props_fairground/gamesign_01.mdl', pos = Vector(-371.50161743164,4879.6079101562,113.20035552979) , ang = Angle(-0.092780888080597,2.9122409159754e-06,-0.01318359375)},
	{model = 'models/zerochain/props_fairground/gamesign_01.mdl', pos = Vector(5920.7192382812,1195.1898193359,1.2016837596893) , ang = Angle(-0.20567010343075,144.28594970703,0)},
	{model = 'models/halloween2015/pumbkin_s_f02.mdl', pos = Vector(5898.662109375,913.79162597656,10.034018516541) , ang = Angle(0.0091416342183948,43.545223236084,-0.01080322265625)},
	{model = 'models/halloween2015/pumbkin_s_f01.mdl', pos = Vector(6162.0336914062,913.80535888672,10.035837173462) , ang = Angle(-0.77413755655289,126.10848236084,0.71241760253906)},
	{model = 'models/halloween2015/pumbkin_l_f01.mdl', pos = Vector(6163.419921875,1232.0480957031,18.702573776245) , ang = Angle(0.26700007915497,-133.5451965332,-0.26522827148438)},
	{model = 'models/zerochain/props_halloween/oldcoffin.mdl', pos = Vector(5998.6416015625,1361.8826904297,50.562316894531) , ang = Angle(65.766624450684,-90.428611755371,-0.47003173828125)},
	{model = 'models/zerochain/props_halloween/cardboard_zombie01_breakable.mdl', pos = Vector(5846.6303710938,966.36700439453,37.672492980957) , ang = Angle(-3.7224576473236,6.2148370742798,-2.50830078125)},
	{model = 'models/halloween2015/pumbkin_n_f01.mdl', pos = Vector(770.53759765625,2265.9689941406,16.006418228149) , ang = Angle(-1.1959612369537,15.68738079071,-0.19671630859375)},
	{model = 'models/zerochain/props_halloween/mexicanskull.mdl', pos = Vector(5837.1235351562,1064.7814941406,33.603954315186) , ang = Angle(-12.213858604431,137.56909179688,-6.999755859375)},
	{model = 'models/halloween2015/pumbkin_n_f01.mdl', pos = Vector(-99.626319885254,2654.4504394531,80.369300842285) , ang = Angle(0.24607545137405,-41.7629737854,-0.2158203125)},
	{model = 'models/halloween2015/pumbkin_n_f01.mdl', pos = Vector(225.60092163086,1886.6101074219,15.920135498047) , ang = Angle(-0.31544137001038,-26.501146316528,-0.09521484375)},
	{model = 'models/zerochain/props_halloween/oldcoffin.mdl', pos = Vector(-2619.9479980469,1516.6910400391,52.232440948486) , ang = Angle(70.830780029297,90.272285461426,0.28306579589844)},
	{model = 'models/halloween2015/pumbkin_n_f01.mdl', pos = Vector(-2664.7082519531,1532.31640625,15.804739952087) , ang = Angle(0.048336278647184,75.992286682129,-0.05499267578125)},
	{model = 'models/halloween2015/pumbkin_l_f01.mdl', pos = Vector(6120.9873046875,1459.0985107422,19.098260879517) , ang = Angle(-2.1847758293152,-151.14326477051,0.62477111816406)},
	{model = 'models/halloween2015/pumbkin_l_f02.mdl', pos = Vector(5696.474609375,1458.8541259766,18.751880645752) , ang = Angle(-0.17985455691814,-7.8102602958679,0.092803955078125)},
	{model = 'models/halloween2015/pumbkin_n_f01.mdl', pos = Vector(-1563.0024414062,2109.7717285156,15.858457565308) , ang = Angle(-0.30198898911476,155.73774719238,-0.1878662109375)},
	{model = 'models/zerochain/props_halloween/witchcauldron.mdl', pos = Vector(-1995.822265625,1996.3117675781,0.48151606321335) , ang = Angle(-0.017072409391403,32.680820465088,-0.08258056640625)},
	{model = 'models/zerochain/props_halloween/mexicanskull.mdl', pos = Vector(-2001.2407226562,2034.9622802734,-2.4928779602051) , ang = Angle(-11.586473464966,19.237203598022,1.0339508056641)},
	{model = 'models/halloween2015/pumbkin_n_f01.mdl', pos = Vector(-386.49838256836,4801.462890625,127.88089752197) , ang = Angle(0.094421193003654,161.66455078125,-0.13482666015625)},
	{model = 'models/halloween2015/pumbkin_l_f01.mdl', pos = Vector(3269.3449707031,3239.0971679688,-109.25805664062) , ang = Angle(0.52775406837463,-35.804985046387,0.052017211914062)},
	{model = 'models/zerochain/props_fairground/gamesign_01.mdl', pos = Vector(3570.5625,3224.1188964844,-126.9135055542) , ang = Angle(-0.10232625901699,49.495971679688,-0.010284423828125)},
	{model = 'models/zerochain/props_halloween/witchcauldron.mdl', pos = Vector(466.54019165039,5409.98828125,0.48949190974236) , ang = Angle(-0.20178858935833,-76.036010742188,-0.25067138671875)},
	{model = 'models/zerochain/props_fairground/gamesign_01.mdl', pos = Vector(1657.4245605469,5341.5141601562,113.12056732178) , ang = Angle(-0.013023405335844,0.012965875677764,-0.00103759765625)},
	{model = 'models/zerochain/props_halloween/oldcoffin.mdl', pos = Vector(1643.1143798828,5209.6274414062,113.79644775391) , ang = Angle(-0.017577232792974,89.054092407227,0.17416381835938)},
	{model = 'models/zerochain/props_halloween/oldcoffin.mdl', pos = Vector(1605.0690917969,5206.6137695312,113.91081237793) , ang = Angle(0.0019245691364631,87.250709533691,0.12391662597656)},
	{model = 'models/halloween2015/pumbkin_s_f01.mdl', pos = Vector(-4049.0502929688,3424.6928710938,46.008201599121) , ang = Angle(0.094805583357811,20.838502883911,-0.095703125)},
	{model = 'models/zerochain/props_halloween/oldcoffin.mdl', pos = Vector(1626.6381835938,5212.99609375,135.91424560547) , ang = Angle(-0.13191057741642,117.70303344727,0.16220092773438)},
	{model = 'models/halloween2015/pumbkin_l_f01.mdl', pos = Vector(-3545.091796875,3692.8095703125,55.181701660156) , ang = Angle(-0.51714640855789,-60.901035308838,0.77593994140625)},
	{model = 'models/halloween2015/pumbkin_n_f01.mdl', pos = Vector(1617.7442626953,5242.9267578125,172.0743560791) , ang = Angle(-0.37598052620888,152.34941101074,0.16938781738281)},
	{model = 'models/zerochain/props_fairground/gamesign_01.mdl', pos = Vector(-3987.2109375,3666.2028808594,1.1839624643326) , ang = Angle(-0.2720912694931,133.61254882812,0)},
	{model = 'models/halloween2015/pumbkin_n_f01.mdl', pos = Vector(469.77725219727,5412.1796875,58.920330047607) , ang = Angle(0.23036250472069,-72.594520568848,-0.450927734375)},
	{model = 'models/halloween2015/pumbkin_s_f02.mdl', pos = Vector(-3661.1013183594,3984.6381835938,45.959064483643) , ang = Angle(0.46357756853104,-164.60942077637,-6.103515625e-05)},
	{model = 'models/halloween2015/hay_block.mdl', pos = Vector(509.07641601562,5407.5229492188,0.58808177709579) , ang = Angle(-0.29973512887955,-4.9896292686462,-0.19180297851562)},
	{model = 'models/halloween2015/pumbkin_s_f01.mdl', pos = Vector(-3909.9260253906,3974.3957519531,45.894836425781) , ang = Angle(0.17283351719379,12.648281097412,0.057861328125)},
	{model = 'models/props_candy/hottamales.mdl', pos = Vector(508.0417175293,5388.0869140625,25.900575637817) , ang = Angle(-0.77410620450974,-111.29977416992,0.17362976074219)},
	{model = 'models/halloween2015/pumbkin_n_f02.mdl', pos = Vector(-3348.7631835938,3534.2004394531,52.179679870605) , ang = Angle(0.19184955954552,-154.83393859863,0.019744873046875)},
	{model = 'models/props_candy/jujubes.mdl', pos = Vector(510.08801269531,5402.8432617188,25.937786102295) , ang = Angle(-0.518519282341,-50.80110168457,-0.36911010742188)},
	{model = 'models/zerochain/props_halloween/oldcoffin.mdl', pos = Vector(-3376.5854492188,4087.8408203125,1.8834260702133) , ang = Angle(-0.01990476436913,-71.023345947266,0.064651489257812)},
	{model = 'models/props_candy/juniormints.mdl', pos = Vector(514.66546630859,5417.86328125,25.684778213501) , ang = Angle(-1.0015938282013,-44.905906677246,-0.24078369140625)},
	{model = 'models/zerochain/props_halloween/oldcoffin.mdl', pos = Vector(-3311.23828125,4063.0913085938,1.7939743995667) , ang = Angle(-0.0038447568658739,-106.88481903076,-0.0142822265625)},
	{model = 'models/zerochain/props_halloween/oldcoffin.mdl', pos = Vector(-3338.5859375,4057.1977539062,23.862636566162) , ang = Angle(-0.092358596622944,156.83070373535,0.11854553222656)},
	{model = 'models/zerochain/props_halloween/gravestone02.mdl', pos = Vector(-3163.7824707031,3935.3364257812,0.69257527589798) , ang = Angle(-1.1408689022064,179.94966125488,-0.06707763671875)},
	{model = 'models/halloween2015/pumbkin_n_f02.mdl', pos = Vector(231.12335205078,4819.294921875,52.391326904297) , ang = Angle(0.077473290264606,-29.552440643311,0.057525634765625)},
	{model = 'models/zerochain/props_industrial/robotic_saw.mdl', pos = Vector(172.40646362305,4686.3579101562,1.006786108017) , ang = Angle(-5.4473218917847,10.323665618896,-1.0928955078125)},
	{model = 'models/zerochain/props_halloween/cobweb.mdl', pos = Vector(136.32609558105,4638.9086914062,96.483139038086) , ang = Angle(17.372194290161,-24.400537490845,-36.690765380859)},
	{model = 'models/halloween2015/pumbkin_s_f02.mdl', pos = Vector(431.36209106445,4583.4887695312,26.716850280762) , ang = Angle(-4.6303305625916,72.932266235352,1.5526275634766)},
	{model = 'models/zerochain/props_halloween/oldcoffin.mdl', pos = Vector(695.08282470703,4715.76953125,18.658056259155) , ang = Angle(0.078555911779404,89.111099243164,5.0489959716797)},
	{model = 'models/zerochain/props_halloween/witchcauldron.mdl', pos = Vector(-3549.9948730469,3375.7397460938,0.47688665986061) , ang = Angle(0.096846677362919,55.681438446045,0.0066070556640625)},
	{model = 'models/halloween2015/pumbkin_n_f02.mdl', pos = Vector(-388.1748046875,4579.9443359375,15.921052932739) , ang = Angle(-0.03743776679039,-120.2678604126,0.025833129882812)},
	{model = 'models/zerochain/props_halloween/cardboard_zombie02_breakable.mdl', pos = Vector(-2818.6306152344,3680.2915039062,0.45040446519852) , ang = Angle(0.077271789312363,-121.99714660645,0.000152587890625)},
	{model = 'models/zerochain/props_halloween/cardboard_zombie01_breakable.mdl', pos = Vector(-2998.00390625,3374.1281738281,0.38292470574379) , ang = Angle(0.1840336471796,110.02434539795,0.000335693359375)},
	{model = 'models/zerochain/props_firework/fireworkbox_01.mdl', pos = Vector(-3124.7568359375,3345.7160644531,0.4476435482502) , ang = Angle(-0.1000287309289,75.449226379395,0.084060668945312)},
	{model = 'models/zerochain/props_firework/fireworkbox_01.mdl', pos = Vector(-3062.8693847656,3338.5122070312,0.50609481334686) , ang = Angle(-0.016728552058339,89.992057800293,0.0030975341796875)},
	{model = 'models/zerochain/props_halloween/mexicanskull.mdl', pos = Vector(-3083.3901367188,3381.6066894531,-2.3342578411102) , ang = Angle(-12.002733230591,107.10056304932,-7.6582641601562)},
	{model = 'models/zerochain/props_fairground/gamesign_01.mdl', pos = Vector(-383.70965576172,4219.7446289062,1.2309806346893) , ang = Angle(0.10663548856974,-0.044461913406849,-0.0032958984375)},
	{model = 'models/halloween2015/pumbkin_l_f02.mdl', pos = Vector(-388.49249267578,4144.4633789062,18.784091949463) , ang = Angle(0.25426670908928,-146.52897644043,0.62242126464844)},
	{model = 'models/zerochain/props_halloween/cardboard_zombie01_breakable.mdl', pos = Vector(2190.7517089844,6335.2822265625,0.43102729320526) , ang = Angle(0.19355715811253,-141.12794494629,0.11764526367188)},
	{model = 'models/halloween2015/pumbkin_l_f01.mdl', pos = Vector(-1004.6807861328,4267.3930664062,18.73219871521) , ang = Angle(0.096224404871464,-28.444969177246,-0.5008544921875)},
	{model = 'models/zerochain/props_fairground/gamesign_01.mdl', pos = Vector(1838.5698242188,6302.1870117188,1.1419702768326) , ang = Angle(0.051666848361492,154.02798461914,0.0013580322265625)},
	{model = 'models/halloween2015/pumbkin_s_f02.mdl', pos = Vector(2450.1977539062,6143.1264648438,9.9548034667969) , ang = Angle(0.25886645913124,-145.0005645752,-0.30941772460938)},
	{model = 'models/halloween2015/pumbkin_s_f01.mdl', pos = Vector(1804.1645507812,6136.9833984375,10.010807037354) , ang = Angle(-0.25486272573471,-26.489278793335,0.445556640625)},
	{model = 'models/zerochain/props_halloween/mexicanskull.mdl', pos = Vector(3845.6784667969,5880.2504882812,33.862628936768) , ang = Angle(-11.903657913208,-172.05612182617,-6.5736083984375)},
	{model = 'models/zerochain/props_fairground/gamesign_01.mdl', pos = Vector(1741.3278808594,3823.439453125,1.1499660015106) , ang = Angle(-0.43193411827087,53.660869598389,-0.00592041015625)},
	{model = 'models/zerochain/props_halloween/oldcoffin.mdl', pos = Vector(1680.7534179688,3409.8388671875,51.26863861084) , ang = Angle(67.579368591309,89.96851348877,-0.1822509765625)},
	{model = 'models/halloween2015/pumbkin_n_f02.mdl', pos = Vector(-1818.1635742188,3991.4606933594,15.866665840149) , ang = Angle(-0.26393979787827,39.303771972656,0.33837890625)},
	{model = 'models/zerochain/props_fairground/gamesign_01.mdl', pos = Vector(-2153.5969238281,3247.16796875,1.1795485019684) , ang = Angle(0.30669459700584,68.136573791504,0.0040283203125)},
	{model = 'models/zerochain/props_halloween/oldcoffin.mdl', pos = Vector(-970.54699707031,6275.8203125,1.890341758728) , ang = Angle(-9.9007218068436e-07,36.876304626465,-6.103515625e-05)},
	{model = 'models/zerochain/props_halloween/oldcoffin.mdl', pos = Vector(-976.25543212891,6318.5556640625,1.8902832269669) , ang = Angle(-8.2499000200187e-06,-143.0817565918,3.0517578125e-05)},
	{model = 'models/zerochain/props_fairground/gamesign_01.mdl', pos = Vector(-4021.4838867188,-1838.6267089844,6291.3955078125) , ang = Angle(2.4342176914215,-42.611724853516,-2.5756530761719)},
	{model = 'models/zerochain/props_halloween/oldcoffin.mdl', pos = Vector(-963.09130859375,6295.0317382812,23.979272842407) , ang = Angle(-0.086631044745445,156.19732666016,0.012588500976562)},
	{model = 'models/zerochain/props_halloween/oldcoffin.mdl', pos = Vector(-4337.7856445312,-1943.8009033203,6299.8549804688) , ang = Angle(-0.0016659243265167,90.916229248047,0.10658264160156)},
	{model = 'models/zerochain/props_halloween/oldcoffin.mdl', pos = Vector(-4300.72265625,-1917.0895996094,6299.9248046875) , ang = Angle(0.0016582786338404,92.79833984375,0.10658264160156)},
	{model = 'models/halloween2015/pumbkin_n_f01.mdl', pos = Vector(-989.02484130859,6305.7587890625,60.174121856689) , ang = Angle(-0.21673126518726,142.4984588623,0.50930786132812)},
	{model = 'models/zerochain/props_halloween/oldcoffin.mdl', pos = Vector(-4320.5126953125,-1916.0056152344,6321.91015625) , ang = Angle(-0.031343132257462,63.804824829102,-0.0623779296875)},
	{model = 'models/zerochain/props_fairground/gamesign_01.mdl', pos = Vector(-908.76495361328,6415.43359375,1.1905972957611) , ang = Angle(-0.24721783399582,-2.5766637463676e-06,0)},
	{model = 'models/halloween2015/pumbkin_n_f02.mdl', pos = Vector(-4161.5063476562,-2384.3520507812,6313.84375) , ang = Angle(0.50012165307999,128.64730834961,-0.09423828125)},
	{model = 'models/halloween2015/pumbkin_s_f01.mdl', pos = Vector(-4379.048828125,-2422.3176269531,6308.0170898438) , ang = Angle(-0.059520572423935,-15.712321281433,-0.06768798828125)},
	{model = 'models/halloween2015/pumbkin_l_f02.mdl', pos = Vector(-4435,-2774.2905273438,6316.7724609375) , ang = Angle(-0.3295883834362,53.463874816895,0.051727294921875)},
	{model = 'models/props_candy/dots.mdl', pos = Vector(-972.74560546875,6329.1591796875,23.850036621094) , ang = Angle(-0.13003501296043,85.627349853516,0.23809814453125)},
	{model = 'models/zerochain/props_halloween/oldcoffin.mdl', pos = Vector(-4446.279296875,-2704.1535644531,6299.8779296875) , ang = Angle(-0.00057206465862691,89.233085632324,0.036788940429688)},
	{model = 'models/props_candy/mikeandikemegamix.mdl', pos = Vector(-946.61047363281,6330.8032226562,23.451759338379) , ang = Angle(-0.067874759435654,59.737083435059,0.085678100585938)},
	{model = 'models/zerochain/props_halloween/witchcauldron.mdl', pos = Vector(-4007.4587402344,-2647.5334472656,6298.4653320312) , ang = Angle(0.099244721233845,179.97782897949,0.01251220703125)},
	{model = 'models/zerochain/props_halloween/cardboard_zombie02.mdl', pos = Vector(-4686.6015625,-3392.953125,6298.5249023438) , ang = Angle(6.6658525466919,45.89917755127,0.01324462890625)},
	{model = 'models/halloween2015/pumbkin_n_f01.mdl', pos = Vector(-2084.7036132812,5989.7026367188,143.81864929199) , ang = Angle(-0.22949722409248,31.707246780396,-0.16119384765625)},
	{model = 'models/zerochain/props_fairground/gamesign_01.mdl', pos = Vector(-4696.05859375,-3203.931640625,6299.1748046875) , ang = Angle(-0.3639318048954,-177.56468200684,-0.000335693359375)},
	{model = 'models/halloween2015/pumbkin_s_f02.mdl', pos = Vector(-4189.068359375,-3214.4228515625,6308.0327148438) , ang = Angle(-0.14166644215584,151.00582885742,-0.10000610351562)},
	{model = 'models/halloween2015/pumbkin_n_f01.mdl', pos = Vector(-4697.3901367188,-3127.5085449219,6313.8134765625) , ang = Angle(-0.43287715315819,20.695539474487,0.40243530273438)},
	{model = 'models/halloween2015/pumbkin_l_f01.mdl', pos = Vector(-1963.7169189453,6531.4375,146.85833740234) , ang = Angle(-0.70298451185226,-32.424633026123,-0.65093994140625)},
	{model = 'models/halloween2015/pumbkin_n_f01.mdl', pos = Vector(-4642.2685546875,-3406.9111328125,6313.921875) , ang = Angle(-0.77674460411072,58.941600799561,0.48757934570312)},
	{model = 'models/halloween2015/pumbkin_n_f01.mdl', pos = Vector(-6614.7465820312,-7322.0795898438,6627.8579101562) , ang = Angle(-0.01220163423568,50.907661437988,-0.0333251953125)},
	{model = 'models/halloween2015/pumbkin_l_f02.mdl', pos = Vector(-6621.4228515625,-6905.03125,6630.7641601562) , ang = Angle(-0.20028084516525,-31.081064224243,0.14851379394531)},
	{model = 'models/halloween2015/hay_block_tower.mdl', pos = Vector(-5999.3095703125,-6914.2739257812,6612.4858398438) , ang = Angle(-0.072977349162102,-178.67553710938,-0.15960693359375)},
	{model = 'models/halloween2015/pumbkin_s_f02.mdl', pos = Vector(-1327.3937988281,6146.4985351562,137.96667480469) , ang = Angle(0.25497350096703,-155.56405639648,0.42457580566406)},
	{model = 'models/zerochain/props_halloween/cardboard_zombie01_breakable.mdl', pos = Vector(-6067.1684570312,-6923.0791015625,6612.4907226562) , ang = Angle(-0.33712255954742,-123.6791305542,-6.103515625e-05)},
	{model = 'models/zerochain/props_halloween/oldcoffin.mdl', pos = Vector(-3007.4509277344,5005.8217773438,54.688526153564) , ang = Angle(81.887939453125,-46.116195678711,-4.4044189453125)},
	{model = 'models/halloween2015/pumbkin_s_f02.mdl', pos = Vector(-6004.5229492188,-6972.1240234375,6622.609375) , ang = Angle(-2.9572741985321,-121.27420806885,2.0858764648438)},
	{model = 'models/props_candy/twizzlersbites.mdl', pos = Vector(-3350.7473144531,3577.3891601562,38.060493469238) , ang = Angle(-0.37725284695625,161.0233001709,-0.00677490234375)},
	{model = 'models/props_candy/mikeandike.mdl', pos = Vector(-3894.3681640625,3417.6000976562,37.393772125244) , ang = Angle(0.26999643445015,46.127117156982,-0.63595581054688)},
	{model = 'models/props_candy/sweettarts.mdl', pos = Vector(-3900.8161621094,3423.3366699219,39.046829223633) , ang = Angle(8.9363651275635,108.85233306885,-4.5741271972656)},
	{model = 'models/halloween2015/pumbkin_ultimate_01.mdl', pos = Vector(-6547.1982421875,-5969.6557617188,6858.1440429688) , ang = Angle(-0.17529501020908,-54.61642074585,0.0079345703125)},
	{model = 'models/halloween2015/pumbkin_n_f01.mdl', pos = Vector(-2436.8012695312,2265.1032714844,16.190196990967) , ang = Angle(-2.1263601779938,39.664821624756,-0.602783203125)},
	{model = 'models/halloween2015/pumbkin_l_f01.mdl', pos = Vector(-2890.6735839844,2155.2507324219,274.74942016602) , ang = Angle(0.18739508092403,34.9948387146,-0.00311279296875)},
	{model = 'models/halloween2015/pumbkin_s_f02.mdl', pos = Vector(-2594.2321777344,2157.3137207031,265.9651184082) , ang = Angle(0.32605913281441,158.81423950195,0.68827819824219)},
	{model = 'models/props_candy/mmspeanutbutter.mdl', pos = Vector(-2557.8518066406,2161.9194335938,294.28988647461) , ang = Angle(0.36482262611389,66.552833557129,0.13453674316406)},
	{model = 'models/halloween2015/pumbkin_ultimate_02.mdl', pos = Vector(-3138.8537597656,-6954.0024414062,6703.7397460938) , ang = Angle(-0.35248762369156,115.3350982666,-1.2102661132812)},
	{model = 'models/props_candy/reesespieces.mdl', pos = Vector(-2552.5505371094,2156.7277832031,295.69528198242) , ang = Angle(-10.306592941284,145.42561340332,2.6775054931641)},
	{model = 'models/zerochain/props_halloween/witchcauldron.mdl', pos = Vector(-2653.7924804688,1806.2736816406,256.45336914062) , ang = Angle(-0.070483639836311,170.75514221191,0.026168823242188)},
	{model = 'models/halloween2015/pumbkin_ultimate_02.mdl', pos = Vector(-7064.2856445312,-12891.8359375,6945.5170898438) , ang = Angle(1.5909729003906,36.478950500488,-0.13385009765625)},
	{model = 'models/halloween2015/pumbkin_n_f02.mdl', pos = Vector(-2493.1955566406,3982.068359375,15.987242698669) , ang = Angle(-0.27160054445267,28.511384963989,0.94184875488281)},
	{model = 'models/halloween2015/pumbkin_l_f01.mdl', pos = Vector(-2323.3854980469,4204.62109375,18.720064163208) , ang = Angle(0.43264836072922,-135.23162841797,0.25100708007812)},
	{model = 'models/halloween2015/pumbkin_n_f01.mdl', pos = Vector(37.789482116699,3100.7058105469,-112.16770935059) , ang = Angle(-0.092432677745819,81.434364318848,-0.19247436523438)},
	{model = 'models/halloween2015/pumbkin_ultimate_03.mdl', pos = Vector(-7138.4541015625,-9767.84375,6982.1411132812) , ang = Angle(-0.84558439254761,-54.339260101318,-0.75689697265625)},
	{model = 'models/zerochain/props_halloween/witchcauldron.mdl', pos = Vector(235.18780517578,3107.1970214844,-127.50048065186) , ang = Angle(-0.16675809025764,98.151298522949,0.032089233398438)},
	{model = 'models/halloween2015/pumbkin_ultimate_01.mdl', pos = Vector(-4310.3657226562,-9764.345703125,7387.6020507812) , ang = Angle(1.1695612668991,-141.13284301758,-0.38665771484375)},
	{model = 'models/halloween2015/pumbkin_n_f02.mdl', pos = Vector(116.17213439941,3735.3198242188,15.807683944702) , ang = Angle(0.15151736140251,-44.447982788086,0.22006225585938)},
	{model = 'models/halloween2015/pumbkin_n_f01.mdl', pos = Vector(-9531.8603515625,-11518.801757812,6224.9379882812) , ang = Angle(-0.53527718782425,47.197696685791,-0.59506225585938)},
	{model = 'models/zerochain/props_halloween/oldcoffin.mdl', pos = Vector(1086.2229003906,839.240234375,53.732517242432) , ang = Angle(77.204284667969,73.912963867188,0.51669311523438)},
	{model = 'models/halloween2015/pumbkin_n_f02.mdl', pos = Vector(1050.2276611328,845.107421875,15.781069755554) , ang = Angle(0.001962840789929,76.041786193848,-0.010009765625)},
	{model = 'models/zerochain/props_fairground/gamesign_01.mdl', pos = Vector(-9486.3935546875,-11356.686523438,6202.2275390625) , ang = Angle(0.10874956846237,-141.0339050293,0)},
	{model = 'models/halloween2015/pumbkin_l_f01.mdl', pos = Vector(1118.6365966797,1888.5441894531,18.732297897339) , ang = Angle(0.24503144621849,-141.94201660156,-0.5040283203125)},
	{model = 'models/zerochain/props_fairground/gamesign_01.mdl', pos = Vector(-9492.4267578125,-10490.078125,6202.7197265625) , ang = Angle(-2.3218467235565,137.22462463379,0.0042877197265625)},
	{model = 'models/halloween2015/pumbkin_s_f01.mdl', pos = Vector(-613.34466552734,1887.3822021484,10.035683631897) , ang = Angle(-0.00017673351976555,-44.391338348389,-0.000244140625)},
	{model = 'models/halloween2015/pumbkin_s_f02.mdl', pos = Vector(-9431.2265625,-10460.295898438,6212.9067382812) , ang = Angle(-4.343189239502,-55.029563903809,-9.6024780273438)},
	{model = 'models/halloween2015/pumbkin_s_f02.mdl', pos = Vector(-9531.013671875,-10554.08984375,6210.953125) , ang = Angle(0.0079535460099578,-27.637729644775,-0.61770629882812)},
	{model = 'models/zerochain/props_fairground/gamesign_01.mdl', pos = Vector(-3761.2897949219,3117.1215820312,1.1853685379028) , ang = Angle(-0.2745081782341,134.60154724121,-0.0023193359375)},
	{model = 'models/zerochain/props_halloween/oldcoffin.mdl', pos = Vector(-9139.2958984375,-10927.478515625,6210.7163085938) , ang = Angle(0.0015739335212857,71.565437316895,0.04681396484375)},
	{model = 'models/zerochain/props_halloween/oldcoffin.mdl', pos = Vector(-9180.0283203125,-10905.607421875,6210.9008789062) , ang = Angle(0.00092063524061814,80.881546020508,6.103515625e-05)},
	{model = 'models/zerochain/props_halloween/oldcoffin.mdl', pos = Vector(-9176.49609375,-10907.053710938,6233.0043945312) , ang = Angle(-0.056966435164213,-13.627846717834,-0.00927734375)},
	{model = 'models/halloween2015/pumbkin_s_f02.mdl', pos = Vector(-8710.0654296875,-11514.786132812,6218.9794921875) , ang = Angle(-0.05458764731884,131.60177612305,0.11363220214844)},
	{model = 'models/halloween2015/pumbkin_s_f02.mdl', pos = Vector(-7543.5288085938,-11118.469726562,6219.1044921875) , ang = Angle(-0.16100522875786,150.5650177002,-1.417724609375)},
	{model = 'models/halloween2015/pumbkin_l_f02.mdl', pos = Vector(-7539.15625,-10854.302734375,6227.7573242188) , ang = Angle(0.43354597687721,-119.18758392334,0.042098999023438)},
	{model = 'models/halloween2015/pumbkin_s_f01.mdl', pos = Vector(-6280.5756835938,-9708.5751953125,6746.9135742188) , ang = Angle(-0.1557270437479,22.265539169312,0.099807739257812)},
	{model = 'models/halloween2015/pumbkin_s_f01.mdl', pos = Vector(-6283.3032226562,-10024.912109375,6747.0078125) , ang = Angle(-0.33516407012939,28.835748672485,0.1387939453125)},
	{model = 'models/zerochain/props_halloween/cardboard_zombie02_breakable.mdl', pos = Vector(-7382.1513671875,-9889.0244140625,6737.3374023438) , ang = Angle(0.28483510017395,-4.410933971405,0.0004730224609375)},
	{model = 'models/zerochain/props_halloween/cardboard_zombie01.mdl', pos = Vector(-7390.6333007812,-10040.272460938,6737.380859375) , ang = Angle(0.18460696935654,27.26902961731,0.0003509521484375)},
	{model = 'models/zerochain/props_halloween/gravestone02.mdl', pos = Vector(-7125.4638671875,-9706.9794921875,6737.5249023438) , ang = Angle(-0.22980560362339,-81.138580322266,-0.077880859375)},
	{model = 'models/zerochain/props_halloween/witchcauldron.mdl', pos = Vector(-6605.3051757812,-9733.8193359375,6737.4584960938) , ang = Angle(-0.18987160921097,-139.44033813477,-0.11257934570312)},
	{model = 'models/halloween2015/pumbkin_s_f02.mdl', pos = Vector(-6580.2036132812,-10018.795898438,6747.0356445312) , ang = Angle(-0.00040416902629659,109.58197021484,0.00042724609375)},
	{model = 'models/halloween2015/pumbkin_l_f01.mdl', pos = Vector(-7431.6635742188,-9599.830078125,6630.7416992188) , ang = Angle(0.57070529460907,33.438232421875,-0.11138916015625)},
	{model = 'models/halloween2015/hay_block.mdl', pos = Vector(882.32360839844,4454.3208007812,1.4423303604126) , ang = Angle(0.64130747318268,-148.80426025391,1.2555847167969)},
	{model = 'models/halloween2015/pumbkin_s_f01.mdl', pos = Vector(-6810.904296875,-6907.6625976562,6621.98046875) , ang = Angle(-0.011100872419775,-134.66795349121,0.19731140136719)},
	{model = 'models/halloween2015/pumbkin_l_f02.mdl', pos = Vector(882.60064697266,4453.771484375,44.097324371338) , ang = Angle(0.52958399057388,-139.60772705078,1.4163970947266)},
	{model = 'models/halloween2015/pumbkin_l_f02.mdl', pos = Vector(-7152.9716796875,-6906.294921875,6630.8237304688) , ang = Angle(-0.34937885403633,-55.723838806152,0.32298278808594)},
	{model = 'models/halloween2015/pumbkin_n_f02.mdl', pos = Vector(-6804.1875,-7378.7421875,6627.8901367188) , ang = Angle(0.16746450960636,134.99476623535,0.07073974609375)},
	{model = 'models/halloween2015/pumbkin_n_f01.mdl', pos = Vector(-6857.5258789062,-7416.3212890625,6658.8520507812) , ang = Angle(0.39128863811493,131.18208312988,0.13697814941406)},
	{model = 'models/halloween2015/pumbkin_l_f01.mdl', pos = Vector(-7003.0795898438,-7473.4809570312,6630.8110351562) , ang = Angle(-0.18665525317192,-125.89663696289,0.14161682128906)},
	{model = 'models/halloween2015/pumbkin_l_f02.mdl', pos = Vector(-0.3185721039772,2203.2951660156,83.191955566406) , ang = Angle(0.083593256771564,36.925533294678,0.17124938964844)},
	{model = 'models/halloween2015/pumbkin_l_f01.mdl', pos = Vector(-971.53607177734,2271.5895996094,18.761465072632) , ang = Angle(0.2084497064352,153.58656311035,0.27435302734375)},
	{model = 'models/zerochain/props_halloween/oldcoffin.mdl', pos = Vector(-1158.5244140625,3009.1630859375,1.8089017868042) , ang = Angle(0.013895184732974,95.22762298584,0.059219360351562)},
	{model = 'models/halloween2015/pumbkin_s_f02.mdl', pos = Vector(-1159.9478759766,3031.9499511719,32.107666015625) , ang = Angle(-0.69612896442413,-171.45742797852,0.48222351074219)},
	{model = 'models/zerochain/props_fairground/gamesign_01.mdl', pos = Vector(-4679.0908203125,4504.291015625,-1998.8477783203) , ang = Angle(-0.10591109842062,90.033271789551,-0.0015869140625)},
	{model = 'models/halloween2015/pumbkin_l_f02.mdl', pos = Vector(-7735.7583007812,-7593.7299804688,6630.9453125) , ang = Angle(-0.56414175033569,-119.97050476074,0.72491455078125)},
	{model = 'models/zerochain/props_halloween/oldcoffin.mdl', pos = Vector(-4574.787109375,4475.9594726562,-1998.2191162109) , ang = Angle(-0.021759355440736,-45.046508789062,0.16493225097656)},
	{model = 'models/halloween2015/pumbkin_s_f01.mdl', pos = Vector(-8328.7490234375,-9402.7509765625,6621.9462890625) , ang = Angle(0.35490843653679,59.587051391602,0.29800415039062)},
	{model = 'models/zerochain/props_halloween/oldcoffin.mdl', pos = Vector(-4594.3842773438,4442.080078125,-1998.1096191406) , ang = Angle(3.7236654861772e-06,134.95045471191,0.0003662109375)},
	{model = 'models/halloween2015/pumbkin_l_f01.mdl', pos = Vector(-6455.7680664062,-9148.1748046875,6630.8071289062) , ang = Angle(-0.0021524198818952,133.16958618164,0.14189147949219)},
	{model = 'models/halloween2015/pumbkin_s_f01.mdl', pos = Vector(-4583.33984375,4451.6123046875,-1967.9744873047) , ang = Angle(-0.097133025527,-97.405410766602,-0.11285400390625)},
	{model = 'models/halloween2015/pumbkin_ultimate_02.mdl', pos = Vector(-3720.4873046875,-8518.6943359375,6268.48046875) , ang = Angle(1.6058483123779,-121.30392456055,-0.10986328125)},
	{model = 'models/halloween2015/pumbkin_l_f01.mdl', pos = Vector(-223.40754699707,-3817.1640625,-1230.1754150391) , ang = Angle(-8.5703476315757e-07,161.07095336914,0)},
	{model = 'models/halloween2015/pumbkin_l_f01.mdl', pos = Vector(-6636.5322265625,-12828.155273438,6371.7299804688) , ang = Angle(-0.33321058750153,21.804182052612,0.25270080566406)},
	{model = 'models/halloween2015/pumbkin_n_f01.mdl', pos = Vector(388.40557861328,-4304.0717773438,-1233.0759277344) , ang = Angle(3.4338277998813e-08,162.23420715332,0)},
	{model = 'models/halloween2015/pumbkin_n_f02.mdl', pos = Vector(-6626.2407226562,-13326.85546875,6368.8666992188) , ang = Angle(0.22853942215443,58.958469390869,-0.0794677734375)},
	{model = 'models/halloween2015/pumbkin_s_f02.mdl', pos = Vector(-6416.720703125,-13326.3203125,6363.0229492188) , ang = Angle(-0.053582426160574,118.83753967285,-0.80068969726562)},
	{model = 'models/zerochain/props_halloween/oldcoffin.mdl', pos = Vector(-6284.6938476562,-13110.213867188,6354.8696289062) , ang = Angle(0.027844404801726,0.91340458393097,0.0004425048828125)},
	{model = 'models/halloween2015/pumbkin_n_f01.mdl', pos = Vector(-6283.83203125,-13115.74609375,6391.3579101562) , ang = Angle(1.9735459089279,-68.493453979492,1.3091583251953)},
	{model = 'models/halloween2015/pumbkin_l_f01.mdl', pos = Vector(-6242.9711914062,-13110.833984375,6393.7993164062) , ang = Angle(-0.075936414301395,-88.078819274902,-0.03936767578125)},
	{model = 'models/halloween2015/pumbkin_s_f01.mdl', pos = Vector(-375.72268676758,-5072.3798828125,-1174.5789794922) , ang = Angle(0.40697485208511,-118.1192779541,0.39144897460938)},
	{model = 'models/halloween2015/pumbkin_l_f01.mdl', pos = Vector(-6470.7919921875,-13044.3359375,6755.8247070312) , ang = Angle(-0.0011473932536319,28.893301010132,6.103515625e-05)},
	{model = 'models/halloween2015/pumbkin_l_f01.mdl', pos = Vector(-4410.2475585938,-12778.788085938,6797.7045898438) , ang = Angle(0.32191634178162,-159.05728149414,0.20956420898438)},
	{model = 'models/halloween2015/pumbkin_n_f01.mdl', pos = Vector(444.88442993164,-5249.5141601562,-1186.947265625) , ang = Angle(-0.15616422891617,134.53817749023,0.30197143554688)},
	{model = 'models/halloween2015/pumbkin_l_f02.mdl', pos = Vector(-4423.6435546875,-13043.8125,6755.791015625) , ang = Angle(-0.40590503811836,126.71166992188,0.17466735839844)},
	{model = 'models/halloween2015/pumbkin_l_f01.mdl', pos = Vector(-5405.7846679688,-12332.368164062,6804.953125) , ang = Angle(-0.18136021494865,-50.466808319092,0.18550109863281)},
	{model = 'models/halloween2015/hay_block.mdl', pos = Vector(1629.4210205078,-4411.0102539062,-1248.3389892578) , ang = Angle(-0.15512932837009,-150.80772399902,-0.22695922851562)},
	{model = 'models/halloween2015/pumbkin_n_f02.mdl', pos = Vector(1630.7897949219,-4400.453125,-1208.5634765625) , ang = Angle(-0.45504248142242,-151.06777954102,0.0071868896484375)},
	{model = 'models/halloween2015/pumbkin_l_f01.mdl', pos = Vector(-7072.908203125,-12404.69921875,6792.8217773438) , ang = Angle(3.3429794311523,24.988676071167,-2.1725463867188)},
	{model = 'models/halloween2015/pumbkin_l_f01.mdl', pos = Vector(-7195.2114257812,-11495.888671875,6792.33984375) , ang = Angle(-1.4179635047913,46.88697052002,0.33494567871094)},
	{model = 'models/halloween2015/pumbkin_n_f01.mdl', pos = Vector(-5780.7690429688,-10036.815429688,6752.8359375) , ang = Angle(-0.39314451813698,125.40118408203,-0.18145751953125)},
	{model = 'models/zerochain/props_fairground/gamesign_01.mdl', pos = Vector(-11870.743164062,4508.1787109375,9877.8955078125) , ang = Angle(0.12800912559032,-0.79892176389694,0.074295043945312)},
	{model = 'models/cultist/items/wmonster/whitemonster.mdl', pos = Vector(-12783.428710938,4681.564453125,10005.704101562) , ang = Angle(-68.747550964355,72.793342590332,73.252944946289)},
	{model = 'models/halloween2015/pumbkin_s_f01.mdl', pos = Vector(-11895.560546875,4511.4282226562,9886.6416015625) , ang = Angle(-0.12243974208832,-174.98838806152,0.37406921386719)},
	{model = 'models/halloween2015/pumbkin_n_f01.mdl', pos = Vector(-4779.8125,-10540.643554688,6368.9013671875) , ang = Angle(0.14502596855164,-56.428401947021,-0.01409912109375)},
}

function SpawnHprops()
	for i = 1, #tikvi do
		local data = tikvi[i]
		local prop = ents.Create("prop_dynamic")
		prop:SetModel(data.model)
		prop:SetMoveType( MOVETYPE_NONE )
		prop:SetSolid( SOLID_VPHYSICS )
		prop:SetPos(data.pos)
		prop:SetAngles(data.ang)
		prop:Spawn()
	end
end


local ny_event = {
	{model = 'models/unconid/xmas/snowman_u_big.mdl',    pos = Vector(      4171.9995117188     ,   -1425.7995605469    ,   1947.3200683594     ) , ang = Angle(    -0.52515780925751   ,   -179.99453735352    ,   -0.026336669921875  )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl',    pos = Vector(      4246.6401367188     ,   -49.097267150879    ,   1948.2489013672     ) , ang = Angle(    0.28014773130417    ,   -178.77755737305    ,   0.10098266601562    )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl',    pos = Vector(      5882.8276367188     ,   -79.689338684082    ,   1419.1090087891     ) , ang = Angle(    -0.1929292678833    ,   0.16501404345036    ,   -0.1903076171875    )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl',    pos = Vector(      2401.1806640625     ,   -184.93341064453    ,   1563.0213623047     ) , ang = Angle(    0.28604966402054    ,   89.995315551758     ,   0.0055694580078125  )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl',    pos = Vector(      482.30035400391     ,   -4666.1831054688    ,   1947.0506591797     ) , ang = Angle(    0.21045719087124    ,   91.990051269531     ,   0.005584716796875   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl',    pos = Vector(      -2654.9514160156    ,   -4923.0546875       ,   1947.0146484375     ) , ang = Angle(    0.090752400457859   ,   90.024765014648     ,   -0.04840087890625   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl',    pos = Vector(      -2877.35546875      ,   -3072.3566894531    ,   1948.8585205078     ) , ang = Angle(    4.6084895133972     ,   -89.696495056152    ,   -0.26617431640625   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl',    pos = Vector(      -2858.6633300781    ,   -3074.7021484375    ,   1948.8585205078     ) , ang = Angle(    4.6084895133972     ,   -90.752517700195    ,   -0.26617431640625   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl',    pos = Vector(      -2834.4230957031    ,   -3074.3688964844    ,   1948.8585205078     ) , ang = Angle(    4.6084895133972     ,   -90.752517700195    ,   -0.26617431640625   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl',    pos = Vector(      -2810.1828613281    ,   -3074.0366210938    ,   1948.8585205078     ) , ang = Angle(    4.6084895133972     ,   -90.752517700195    ,   -0.26617431640625   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl',    pos = Vector(      -2785.9426269531    ,   -3073.7045898438    ,   1948.8585205078     ) , ang = Angle(    4.6084895133972     ,   -90.752517700195    ,   -0.26617431640625   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl',    pos = Vector(      -2767.7624511719    ,   -3073.4555664062    ,   1948.8585205078     ) , ang = Angle(    4.6084895133972     ,   -90.752517700195    ,   -0.26617431640625   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl',    pos = Vector(      -2731.4018554688    ,   -3072.9575195312    ,   1948.8585205078     ) , ang = Angle(    4.6084895133972     ,   -90.752517700195    ,   -0.26617431640625   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl',    pos = Vector(      -2710.1918945312    ,   -3072.6669921875    ,   1948.8585205078     ) , ang = Angle(    4.6084895133972     ,   -90.752517700195    ,   -0.26617431640625   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl',    pos = Vector(      -2688.9816894531    ,   -3072.3764648438    ,   1948.8585205078     ) , ang = Angle(    4.6084895133972     ,   -90.752517700195    ,   -0.26617431640625   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl',    pos = Vector(      -2670.8015136719    ,   -3072.1274414062    ,   1948.8585205078     ) , ang = Angle(    4.6084895133972     ,   -90.752517700195    ,   -0.26617431640625   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl',    pos = Vector(      -2649.5913085938    ,   -3071.8369140625    ,   1948.8585205078     ) , ang = Angle(    4.6084895133972     ,   -90.752517700195    ,   -0.26617431640625   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl',    pos = Vector(      -2628.3811035156    ,   -3071.5463867188    ,   1948.8585205078     ) , ang = Angle(    4.6084895133972     ,   -90.752517700195    ,   -0.26617431640625   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl',    pos = Vector(      -2609.5571289062    ,   -3073.5375976562    ,   1948.8585205078     ) , ang = Angle(    4.6084895133972     ,   -91.016525268555    ,   -0.26617431640625   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl',    pos = Vector(      -2584.6931152344    ,   -3075.4680175781    ,   1948.8585205078     ) , ang = Angle(    4.6084895133972     ,   -91.280532836914    ,   -0.26617431640625   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl',    pos = Vector(      -2568.9387207031    ,   -3076.6052246094    ,   1948.8585205078     ) , ang = Angle(    4.6084895133972     ,   -91.544540405273    ,   -0.26617431640625   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl',    pos = Vector(      -2547.7268066406    ,   -3076.8837890625    ,   1948.8585205078     ) , ang = Angle(    4.6084895133972     ,   -91.544540405273    ,   -0.26617431640625   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl',    pos = Vector(      -2750.9887695312    ,   -3071.919921875     ,   1948.8585205078     ) , ang = Angle(    4.6084890365601     ,   -92.138557434082    ,   -0.26617431640625   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl',    pos = Vector(      -2876.1047363281    ,   -3071.9497070312    ,   2020.7899169922     ) , ang = Angle(    4.6084895133972     ,   -92.864570617676    ,   -0.26617431640625   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl',    pos = Vector(      -2845.6340332031    ,   -3070.7529296875    ,   2019.2673339844     ) , ang = Angle(    4.6084895133972     ,   -92.930572509766    ,   -0.26617431640625   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl',    pos = Vector(      -2810.845703125     ,   -3073.5913085938    ,   2020.8323974609     ) , ang = Angle(    4.6084895133972     ,   -92.930572509766    ,   -0.26617431640625   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl',    pos = Vector(      -2785.083984375     ,   -3073.6955566406    ,   2020.4216308594     ) , ang = Angle(    4.6084895133972     ,   -92.930572509766    ,   -0.26617431640625   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl',    pos = Vector(      -2753.2341308594    ,   -3072.7421875       ,   2019.0632324219     ) , ang = Angle(    4.6084895133972     ,   -92.930572509766    ,   -0.26617431640625   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl',    pos = Vector(      -2725.9538574219    ,   -3072.7250976562    ,   2018.5279541016     ) , ang = Angle(    4.6084895133972     ,   -92.930572509766    ,   -0.26617431640625   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl',    pos = Vector(      -2697.119140625     ,   -3071.1171875       ,   2016.7130126953     ) , ang = Angle(    4.6084895133972     ,   -92.930572509766    ,   -0.26617431640625   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl',    pos = Vector(      -2669.9060058594    ,   -3073.8481445312    ,   2018.5131835938     ) , ang = Angle(    4.6084895133972     ,   -92.930572509766    ,   -0.26617431640625   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl',    pos = Vector(      -2641.0363769531    ,   -3070.7946777344    ,   2015.568359375      ) , ang = Angle(    4.6084895133972     ,   -92.930572509766    ,   -0.26617431640625   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl',    pos = Vector(      -2610.8317871094    ,   -3075.1599121094    ,   2018.4141845703     ) , ang = Angle(    4.6084895133972     ,   -92.930572509766    ,   -0.26617431640625   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl',    pos = Vector(      -2580.5375976562    ,   -3075.8522949219    ,   2018.37890625       ) , ang = Angle(    4.6084895133972     ,   -92.930572509766    ,   -0.26617431640625   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl',    pos = Vector(      -2550.2661132812    ,   -3077.4702148438    ,   2019.0695800781     ) , ang = Angle(    4.6084895133972     ,   -92.930572509766    ,   -0.26617431640625   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl',    pos = Vector(      2206.8200683594     ,   -95.372444152832    ,   1949.8273925781     ) , ang = Angle(    4.6084895133972     ,   -1.3227616548538    ,   -0.26617431640625   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl',    pos = Vector(      2214.9743652344     ,   -124.94430541992    ,   1949.8273925781     ) , ang = Angle(    4.6084895133972     ,   8.181131362915      ,   -0.26617431640625   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl',    pos = Vector(      2219.8195800781     ,   -66.378570556641    ,   1949.8273925781     ) , ang = Angle(    4.6084895133972     ,   -10.892882347107    ,   -0.26617431640625   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl',    pos = Vector(      1831.0893554688     ,   720.77307128906     ,   1950.9730224609     ) , ang = Angle(    4.6084895133972     ,   2.2410674095154     ,   -0.26617431640625   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl',    pos = Vector(      1842.4600830078     ,   692.69671630859     ,   1949.8273925781     ) , ang = Angle(    4.6084895133972     ,   14.385018348694     ,   -0.26617431640625   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl',    pos = Vector(      1842.5954589844     ,   747.65301513672     ,   1952.0651855469     ) , ang = Angle(    4.6084895133972     ,   -9.1109962463379    ,   -0.26617431640625   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl',    pos = Vector(      2034.0573730469     ,   431.03408813477     ,   1948.8585205078     ) , ang = Angle(    4.6084895133972     ,   -3.8310422897339    ,   -0.26617431640625   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl',    pos = Vector(      2033.2219238281     ,   308.40887451172     ,   1948.8585205078     ) , ang = Angle(    4.6084895133972     ,   -1.3230211734772    ,   -0.26617431640625   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl',    pos = Vector(      2033.7570800781     ,   187.19792175293     ,   1948.8585205078     ) , ang = Angle(    4.6084895133972     ,   -1.3230211734772    ,   -0.26617431640625   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl',    pos = Vector(      1809.6135253906     ,   734.89782714844     ,   2492.8583984375     ) , ang = Angle(    4.6084895133972     ,   -23.960824966431    ,   -0.26617431640625   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl',    pos = Vector(      1810.5185546875     ,   586.91064453125     ,   2492.8583984375     ) , ang = Angle(    4.6084895133972     ,   -7.46071434021      ,   -0.26617431640625   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl',    pos = Vector(      1818.1772460938     ,   644.33270263672     ,   2492.8583984375     ) , ang = Angle(    4.6084895133972     ,   -4.3587288856506    ,   -0.26617431640625   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl',    pos = Vector(      4312.80078125       ,   -30.398761749268    ,   1948.8585205078     ) , ang = Angle(    4.6084890365601     ,   176.87731933594     ,   -0.26617431640625   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl',    pos = Vector(      4321.3603515625     ,   -78.149208068848    ,   1948.8585205078     ) , ang = Angle(    4.6084895133972     ,   167.83532714844     ,   -0.26617431640625   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl',    pos = Vector(      4289.109375 ,   -22.478815078735    ,   2492.8583984375     ) , ang = Angle(    4.6084895133972     ,   176.28332519531     ,   -0.26617431640625   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl',    pos = Vector(      4291.134765625      ,   -111.86511230469    ,   2492.8583984375     ) , ang = Angle(    4.6084890365601     ,   178.13131713867     ,   -0.26617431640625   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl',    pos = Vector(      5522.7407226562     ,   97.953407287598     ,   1420.8586425781     ) , ang = Angle(    4.6084895133972     ,   99.951110839844     ,   -0.26617431640625   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl',    pos = Vector(      5424.6044921875     ,   76.736595153809     ,   1420.8586425781     ) , ang = Angle(    4.6084895133972     ,   87.674980163574     ,   -0.26617431640625   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl',    pos = Vector(      5361.71484375       ,   78.859230041504     ,   1420.8586425781     ) , ang = Angle(    4.6084895133972     ,   84.704933166504     ,   -0.26617431640625   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl',    pos = Vector(      5277.6264648438     ,   96.062103271484     ,   1420.8586425781     ) , ang = Angle(    4.6084895133972     ,   71.108924865723     ,   -0.26617431640625   )},
	{model = 'models/unconid/xmas/xmas_tree.mdl',        pos = Vector(      3432.0766601562     ,   383.72717285156     ,   1554.3452148438     ) , ang = Angle(    -0.0026348617393523 ,   20.014154434204     ,   -0.006500244140625  )},
	{model = 'models/unconid/xmas/xmas_tree.mdl',        pos = Vector(      2359.4641113281     ,   247.55801391602     ,   1554.3452148438     ) , ang = Angle(    -0.0026348617393523 ,   -127.75988006592    ,   -0.006500244140625  )},
	{model = 'models/unconid/xmas/xmas_tree.mdl',        pos = Vector(      2201.8754882812     ,   442.02380371094     ,   1554.3452148438     ) , ang = Angle(    -0.0026348617393523 ,   -168.74594116211    ,   -0.006500244140625  )},
	{model = 'models/unconid/xmas/xmas_tree.mdl',        pos = Vector(      1555.7370605469     ,   -4.632266998291     ,   1554.3452148438     ) , ang = Angle(    -0.002634861972183  ,   -102.5478515625     ,   -0.006500244140625  )},
	{model = 'models/unconid/xmas/xmas_tree.mdl',        pos = Vector(      1439.2104492188     ,   -554.41326904297    ,   1554.3452148438     ) , ang = Angle(    -0.0026348617393523 ,   -89.677795410156    ,   -0.006500244140625  )},
	{model = 'models/unconid/xmas/xmas_tree.mdl',        pos = Vector(      1646.7349853516     ,   -1120.9946289062    ,   1554.3452148438     ) , ang = Angle(    -0.002634861972183  ,   -59.977794647217    ,   -0.006500244140625  )},
	{model = 'models/unconid/xmas/xmas_tree.mdl',        pos = Vector(      1147.0469970703     ,   -1295.9979248047    ,   1562.3453369141     ) , ang = Angle(    -0.002634861972183  ,   -145.84384155273    ,   -0.006500244140625  )},
	{model = 'models/unconid/xmas/xmas_tree.mdl',        pos = Vector(      1593.2974853516     ,   -2070.1237792969    ,   1554.3452148438     ) , ang = Angle(    -0.0026348617393523 ,   -48.625728607178    ,   -0.006500244140625  )},
	{model = 'models/unconid/xmas/xmas_tree.mdl',        pos = Vector(      1582.5308837891     ,   -3868.0126953125    ,   1682.3453369141     ) , ang = Angle(    -0.002634861972183  ,   -68.227851867676    ,   -0.006500244140625  )},
	{model = 'models/unconid/xmas/xmas_tree.mdl',        pos = Vector(      1104.8500976562     ,   -4241.728515625     ,   1682.3453369141     ) , ang = Angle(    -0.002634861972183  ,   -110.99591064453    ,   -0.006500244140625  )},
	{model = 'models/unconid/xmas/xmas_tree.mdl',        pos = Vector(      145.36859130859     ,   -4278.3276367188    ,   1682.3453369141     ) , ang = Angle(    -0.0026348617393523 ,   -159.37399291992    ,   -0.006500244140625  )},
	{model = 'models/unconid/xmas/xmas_tree.mdl',        pos = Vector(      -1442.0614013672    ,   -4129.6157226562    ,   1938.3453369141     ) , ang = Angle(    -0.0026348624378443 ,   -161.41983032227    ,   -0.006500244140625  )},
	{model = 'models/unconid/xmas/xmas_tree.mdl',        pos = Vector(      -2311.4514160156    ,   -4326.9926757812    ,   1938.3453369141     ) , ang = Angle(    -0.0026348622050136 ,   -148.02177429199    ,   -0.006500244140625  )},
	{model = 'models/unconid/xmas/xmas_tree.mdl',        pos = Vector(      -2673.634765625     ,   -3782.85546875      ,   1938.3453369141     ) , ang = Angle(    -0.002634861972183  ,   137.92614746094     ,   -0.006500244140625  )},
	{model = 'models/unconid/xmas/xmas_tree.mdl',        pos = Vector(      -2895.9775390625    ,   -4567.2807617188    ,   1946.3453369141     ) , ang = Angle(    -0.002634861972183  ,   -105.97970581055    ,   -0.006500244140625  )},
	{model = 'models/unconid/xmas/xmas_tree.mdl',        pos = Vector(      -2605.19921875      ,   -4646.810546875     ,   1946.3453369141     ) , ang = Angle(    -0.002634861972183  ,   -87.367713928223    ,   -0.006500244140625  )},
	{model = 'models/unconid/xmas/xmas_tree.mdl',        pos = Vector(      380.12655639648     ,   -4047.3344726562    ,   1682.3453369141     ) , ang = Angle(    -0.0026348617393523 ,   29.452310562134     ,   -0.006500244140625  )},
	{model = 'models/unconid/xmas/xmas_tree.mdl',        pos = Vector(      1314.6282958984     ,   -2261.0959472656    ,   1554.3452148438     ) , ang = Angle(    -0.002634861972183  ,   116.77045440674     ,   -0.006500244140625  )},
	{model = 'models/unconid/xmas/xmas_tree.mdl',        pos = Vector(      2781.4147949219     ,   -1080.5441894531    ,   1754.3453369141     ) , ang = Angle(    -0.0026348617393523 ,   19.552394866943     ,   -0.006500244140625  )},
	{model = 'models/unconid/xmas/xmas_tree.mdl',        pos = Vector(      3043.396484375      ,   -357.40637207031    ,   1754.3453369141     ) , ang = Angle(    -0.002634861972183  ,   63.442371368408     ,   -0.006500244140625  )},
	{model = 'models/unconid/xmas/xmas_tree.mdl',        pos = Vector(      2891.9165039062     ,   -772.01544189453    ,   1754.3453369141     ) , ang = Angle(    -0.002634861972183  ,   -71.065734863281    ,   -0.006500244140625  )},
	{model = 'models/unconid/xmas/xmas_tree.mdl',        pos = Vector(      3724.5424804688     ,   492.35317993164     ,   1947.3140869141     ) , ang = Angle(    -0.002634861972183  ,   55.984222412109     ,   -0.006500244140625  )},
	{model = 'models/unconid/xmas/xmas_tree.mdl',        pos = Vector(      3724.1462402344     ,   171.99124145508     ,   1947.3140869141     ) , ang = Angle(    -0.0026348617393523 ,   7.1442227363586     ,   -0.006500244140625  )},
	{model = 'models/unconid/xmas/xmas_tree.mdl',        pos = Vector(      3830.6062011719     ,   -89.745590209961    ,   1947.3140869141     ) , ang = Angle(    -0.0026348617393523 ,   -5.4617710113525    ,   -0.006500244140625  )},
	{model = 'models/unconid/xmas/xmas_tree.mdl',        pos = Vector(      4028.7661132812     ,   -92.344039916992    ,   1947.3140869141     ) , ang = Angle(    -0.0026348617393523 ,   1.7982243299484     ,   -0.006500244140625  )},
	{model = 'models/unconid/xmas/xmas_tree.mdl',        pos = Vector(      4150.1552734375     ,   649.2216796875      ,   1947.3140869141     ) , ang = Angle(    -0.002634861972183  ,   33.940223693848     ,   -0.006500244140625  )},
	{model = 'models/unconid/xmas/xmas_tree.mdl',        pos = Vector(      3923.537109375      ,   658.86346435547     ,   1947.3140869141     ) , ang = Angle(    -0.002634861972183  ,   48.32820892334      ,   -0.006500244140625  )},
	{model = 'models/unconid/xmas/xmas_tree.mdl',        pos = Vector(      3258.9970703125     ,   693.37408447266     ,   1947.3140869141     ) , ang = Angle(    -0.002634861972183  ,   133.40223693848     ,   -0.006500244140625  )},
	{model = 'models/unconid/xmas/xmas_tree.mdl',        pos = Vector(      2761.7541503906     ,   642.21997070312     ,   1947.3140869141     ) , ang = Angle(    -0.0026348617393523 ,   137.7582244873      ,   -0.006500244140625  )},
	{model = 'models/unconid/xmas/xmas_tree.mdl',        pos = Vector(      2355.7858886719     ,   597.56329345703     ,   1947.3140869141     ) , ang = Angle(    -0.002634861972183  ,   156.89833068848     ,   -0.006500244140625  )},
	{model = 'models/unconid/xmas/xmas_tree.mdl',        pos = Vector(      2073.1706542969     ,   682.15307617188     ,   1947.3140869141     ) , ang = Angle(    -0.002634861972183  ,   174.71835327148     ,   -0.006500244140625  )},
	{model = 'models/unconid/xmas/xmas_tree.mdl',        pos = Vector(      2419.6323242188     ,   -87.229118347168    ,   1947.3140869141     ) , ang = Angle(    -0.002634861972183  ,   -90.835548400879    ,   -0.006500244140625  )},
	{model = 'models/unconid/xmas/xmas_tree.mdl',        pos = Vector(      2690.0778808594     ,   -123.75720214844    ,   1947.3140869141     ) , ang = Angle(    -0.002634861972183  ,   -80.077461242676    ,   -0.006500244140625  )},
	{model = 'models/unconid/xmas/xmas_tree.mdl',        pos = Vector(      3520.6345214844     ,   -93.162033081055    ,   1947.3140869141     ) , ang = Angle(    -0.0026348617393523 ,   -62.389381408691    ,   -0.006500244140625  )},
	{model = 'models/unconid/xmas/xmas_tree.mdl',        pos = Vector(      3727.2788085938     ,   -421.50045776367    ,   1947.3140869141     ) , ang = Angle(    -0.0026348624378443 ,   -85.753532409668    ,   -0.006500244140625  )},
	{model = 'models/unconid/xmas/xmas_tree.mdl',        pos = Vector(      3756.0751953125     ,   -1279.5825195312    ,   1946.3453369141     ) , ang = Angle(    -0.0026348622050136 ,   -72.487434387207    ,   -0.006500244140625  )},
	{model = 'models/unconid/xmas/xmas_tree.mdl',        pos = Vector(      3694.6396484375     ,   -1091.1419677734    ,   1946.3453369141     ) , ang = Angle(    -0.002634861972183  ,   -93.871475219727    ,   -0.006500244140625  )},
	{model = 'models/unconid/xmas/xmas_tree.mdl',        pos = Vector(      3695.9013671875     ,   -855.53063964844    ,   1946.3453369141     ) , ang = Angle(    -0.0026348622050136 ,   -149.77355957031    ,   -0.006500244140625  )},
	{model = 'models/unconid/xmas/xmas_tree.mdl',        pos = Vector(      4010.283203125      ,   -820.25189208984    ,   1946.3453369141     ) , ang = Angle(    -0.0026348617393523 ,   16.150482177734     ,   -0.006500244140625  )},
	{model = 'models/unconid/xmas/xmas_tree.mdl',        pos = Vector(      4073.3229980469     ,   -1425.5841064453    ,   1946.3453369141     ) , ang = Angle(    -0.0026348622050136 ,   -7.609522819519     ,   -0.006500244140625  )},
	{model = 'models/unconid/xmas/xmas_tree.mdl',        pos = Vector(      3242.3364257812     ,   367.84262084961     ,   1554.3452148438     ) , ang = Angle(    -0.002634861972183  ,   6.77845287323       ,   -0.006500244140625  )},
	{model = 'models/unconid/xmas/xmas_tree.mdl',        pos = Vector(      3862.06640625       ,   329.78567504883     ,   1554.3452148438     ) , ang = Angle(    -0.0026348622050136 ,   15.358449935913     ,   -0.006500244140625  )},
	{model = 'models/unconid/xmas/xmas_tree.mdl',        pos = Vector(      4242.0478515625     ,   371.50704956055     ,   1554.3452148438     ) , ang = Angle(    -0.002634861972183  ,   22.156450271606     ,   -0.006500244140625  )},
	{model = 'models/unconid/xmas/xmas_tree.mdl',        pos = Vector(      5403.9399414062     ,   397.79043579102     ,   1410.3454589844     ) , ang = Angle(    -0.0026348617393523 ,   20.04444694519      ,   -0.006500244140625  )},
	{model = 'models/unconid/xmas/xmas_tree.mdl',        pos = Vector(      6265.5473632812     ,   197.68663024902     ,   1410.3454589844     ) , ang = Angle(    -0.002634861972183  ,   4.4684524536133     ,   -0.006500244140625  )},

}

function SpawnNYEprops()
	for i = 1, #ny_event do
		local data = ny_event[i]
		local prop = ents.Create("prop_dynamic")
		prop:SetModel(data.model)
		prop:SetMoveType( MOVETYPE_NONE )
		prop:SetSolid( SOLID_VPHYSICS )
		prop:SetPos(data.pos)
		prop:SetAngles(data.ang)
		prop:Spawn()
	end
end

--for k,v in pairs(ents.GetAll()) do
--	if v:GetClass() == "prop_dynamic" and v:GetModel():find("snowfall") then
--		
--		--timer.Simple(k * 1, function()
--			print("{model = '"..v:GetModel().."',"," pos = Vector(", v:GetPos().x, ",", v:GetPos().y, ",", v:GetPos().z,") , ang = Angle(", v:GetAngles().x, ",", v:GetAngles().y, ",", v:GetAngles().z,")},")
--			--file.Write("breach/hl2props.txt", tostring(file.Read( "breach/hl2prop.txt", "DATA" )) .. "\n" .. "{model = '"..v:GetModel().."'".." pos = Vector(".. v:GetPos().x.. ",".. v:GetPos().y.. ",".. v:GetPos().z..") , ang = Angle(".. v:GetAngles().x.. ",".. v:GetAngles().y.. ",".. v:GetAngles().z..")},")
--		--end)
--	end
--end

local snowfall = {
	{model = 'models/maps/nmo_blizzard/blizzard_snowfall1024.mdl',       pos = Vector(      -2673       ,   -4418       ,   1961        ) , ang = Angle(    0   ,   0   ,   0   )},
	{model = 'models/maps/nmo_blizzard/blizzard_snowfall1024.mdl',       pos = Vector(      -2669       ,   -3585       ,   1966.6899414062     ) , ang = Angle(    0   ,   0   ,   0   )},
	{model = 'models/maps/nmo_blizzard/blizzard_snowfall1024.mdl',       pos = Vector(      -8993       ,   -3277       ,   3040.6899414062     ) , ang = Angle(    0   ,   0   ,   0   )},
	{model = 'models/maps/nmo_blizzard/blizzard_snowfall1024.mdl',       pos = Vector(      -8935       ,   -2548       ,   3076.6899414062     ) , ang = Angle(    0   ,   0   ,   0   )},
	{model = 'models/maps/nmo_blizzard/blizzard_snowfall1024.mdl',       pos = Vector(      -10042      ,   -2548       ,   3076.6899414062     ) , ang = Angle(    0   ,   0   ,   0   )},
	{model = 'models/maps/nmo_blizzard/blizzard_snowfall1024.mdl',       pos = Vector(      -10042      ,   -3655       ,   3076.6899414062     ) , ang = Angle(    0   ,   0   ,   0   )},
	{model = 'models/maps/nmo_blizzard/blizzard_snowfall1024.mdl',       pos = Vector(      -11149      ,   -3655       ,   3076.6899414062     ) , ang = Angle(    0   ,   0   ,   0   )},
	{model = 'models/maps/nmo_blizzard/blizzard_snowfall1024.mdl',       pos = Vector(      -11149      ,   -2548       ,   3076.6899414062     ) , ang = Angle(    0   ,   0   ,   0   )},
	{model = 'models/maps/nmo_blizzard/blizzard_snowfall256.mdl',        pos = Vector(      -2594       ,   -7636       ,   1583        ) , ang = Angle(    0   ,   0   ,   0   )},
	{model = 'models/maps/nmo_blizzard/blizzard_snowfall256.mdl',        pos = Vector(      -2393       ,   -7631       ,   1624        ) , ang = Angle(    0   ,   0   ,   0   )},
	{model = 'models/maps/nmo_blizzard/blizzard_snowfall256.mdl',        pos = Vector(      -2157       ,   -7495       ,   1644.1899414062     ) , ang = Angle(    0   ,   0   ,   0   )},
	{model = 'models/maps/nmo_blizzard/blizzard_snowfall256.mdl',        pos = Vector(      -2152       ,   -7234       ,   1654.6899414062     ) , ang = Angle(    0   ,   0   ,   0   )},
	{model = 'models/maps/nmo_blizzard/blizzard_snowfall1024.mdl',       pos = Vector(      -2100       ,   -6580       ,   1612        ) , ang = Angle(    0   ,   0   ,   0   )},
	{model = 'models/maps/nmo_blizzard/blizzard_snowfall1024.mdl',       pos = Vector(      -2617       ,   -6108       ,   1632        ) , ang = Angle(    0   ,   0   ,   0   )},
	{model = 'models/maps/nmo_blizzard/blizzard_snowfall128.mdl',        pos = Vector(      4318        ,   725 ,   1974.6899414062     ) , ang = Angle(    0   ,   0   ,   0   )},
	{model = 'models/maps/nmo_blizzard/blizzard_snowfall256.mdl',        pos = Vector(      3231        ,   679 ,   1965.1899414062     ) , ang = Angle(    0   ,   0   ,   0   )},
	{model = 'models/maps/nmo_blizzard/blizzard_snowfall256.mdl',        pos = Vector(      1714        ,   -343        ,   1964.1899414062     ) , ang = Angle(    0   ,   0   ,   0   )},
	{model = 'models/maps/nmo_blizzard/blizzard_snowfall256.mdl',        pos = Vector(      3746        ,   -1099       ,   1964.1899414062     ) , ang = Angle(    0   ,   90  ,   0   )},
	{model = 'models/maps/nmo_blizzard/blizzard_snowfall128.mdl',        pos = Vector(      3699.9699707031     ,   -384        ,   1964.1899414062     ) , ang = Angle(    0   ,   90  ,   0   )},
	{model = 'models/maps/nmo_blizzard/blizzard_snowfall128.mdl',        pos = Vector(      3832        ,   -609.72998046875    ,   1964.1899414062     ) , ang = Angle(    0   ,   90  ,   0   )},
	{model = 'models/maps/nmo_blizzard/blizzard_snowfall256.mdl',        pos = Vector(      3635        ,   -1102       ,   1950        ) , ang = Angle(    0   ,   90  ,   0   )},
	{model = 'models/maps/nmo_blizzard/blizzard_snowfall256.mdl',        pos = Vector(      3751        ,   -972        ,   1964.1899414062     ) , ang = Angle(    0   ,   90  ,   0   )},
	{model = 'models/maps/nmo_blizzard/blizzard_snowfall128.mdl',        pos = Vector(      3578        ,   -607        ,   1964.1899414062     ) , ang = Angle(    0   ,   90  ,   0   )},
	{model = 'models/maps/nmo_blizzard/blizzard_snowfall128.mdl',        pos = Vector(      3297        ,   39  ,   1616        ) , ang = Angle(    0   ,   0   ,   0   )},
	{model = 'models/maps/nmo_blizzard/blizzard_snowfall128.mdl',        pos = Vector(      3182        ,   36  ,   1731        ) , ang = Angle(    0   ,   0   ,   0   )},
	{model = 'models/maps/nmo_blizzard/blizzard_snowfall128.mdl',        pos = Vector(      2795        ,   36  ,   1731        ) , ang = Angle(    0   ,   0   ,   0   )},
	{model = 'models/maps/nmo_blizzard/blizzard_snowfall128.mdl',        pos = Vector(      2924        ,   36  ,   1731        ) , ang = Angle(    0   ,   0   ,   0   )},
	{model = 'models/maps/nmo_blizzard/blizzard_snowfall128.mdl',        pos = Vector(      3053        ,   36  ,   1731        ) , ang = Angle(    0   ,   0   ,   0   )},
	{model = 'models/maps/nmo_blizzard/blizzard_snowfall256.mdl',        pos = Vector(      3101        ,   -43 ,   1963        ) , ang = Angle(    0   ,   0   ,   0   )},
	{model = 'models/maps/nmo_blizzard/blizzard_snowfall512.mdl',        pos = Vector(      2805        ,   315 ,   1573.5400390625     ) , ang = Angle(    0   ,   0   ,   0   )},
	{model = 'models/maps/nmo_blizzard/blizzard_snowfall512.mdl',        pos = Vector(      3311        ,   316 ,   1573.5400390625     ) , ang = Angle(    0   ,   0   ,   0   )},
	{model = 'models/maps/nmo_blizzard/blizzard_snowfall512.mdl',        pos = Vector(      4117        ,   320 ,   1573.5400390625     ) , ang = Angle(    0   ,   0   ,   0   )},
	{model = 'models/maps/nmo_blizzard/blizzard_snowfall512.mdl',        pos = Vector(      2298        ,   317.6780090332      ,   1573.5400390625     ) , ang = Angle(    0   ,   0   ,   0   )},
	{model = 'models/maps/nmo_blizzard/blizzard_snowfall1024.mdl',       pos = Vector(      -1626       ,   -4254       ,   1966.6899414062     ) , ang = Angle(    0   ,   0   ,   0   )},
	{model = 'models/maps/nmo_blizzard/blizzard_snowfall1024.mdl',       pos = Vector(      1061        ,   -1952       ,   1974.6899414062     ) , ang = Angle(    0   ,   0   ,   0   )},
	{model = 'models/maps/nmo_blizzard/blizzard_snowfall1024.mdl',       pos = Vector(      1061        ,   -845        ,   1974.6899414062     ) , ang = Angle(    0   ,   0   ,   0   )},
	{model = 'models/maps/nmo_blizzard/blizzard_snowfall256.mdl',        pos = Vector(      3744        ,   -1229       ,   1964.1899414062     ) , ang = Angle(    0   ,   90  ,   0   )},
	{model = 'models/maps/nmo_blizzard/blizzard_snowfall256.mdl',        pos = Vector(      3859        ,   -1109       ,   1950        ) , ang = Angle(    0   ,   90  ,   0   )},
	{model = 'models/maps/nmo_blizzard/blizzard_snowfall1024.mdl',       pos = Vector(      4597        ,   634 ,   2270.6899414062     ) , ang = Angle(    0   ,   0   ,   0   )},
	{model = 'models/maps/nmo_blizzard/blizzard_snowfall128.mdl',        pos = Vector(      3840        ,   -382.73001098633    ,   1964.1899414062     ) , ang = Angle(    0   ,   90  ,   0   )},
	{model = 'models/maps/nmo_blizzard/blizzard_snowfall1024.mdl',       pos = Vector(      3763        ,   291 ,   1965.5400390625     ) , ang = Angle(    0   ,   0   ,   0   )},
	{model = 'models/maps/nmo_blizzard/blizzard_snowfall128.mdl',        pos = Vector(      3691.9699707031     ,   -611        ,   1964.1899414062     ) , ang = Angle(    0   ,   90  ,   0   )},
	{model = 'models/maps/nmo_blizzard/blizzard_snowfall128.mdl',        pos = Vector(      3586        ,   -380        ,   1964.1899414062     ) , ang = Angle(    0   ,   90  ,   0   )},
	{model = 'models/maps/nmo_blizzard/blizzard_snowfall256.mdl',        pos = Vector(      2979        ,   679 ,   1965.1899414062     ) , ang = Angle(    0   ,   0   ,   0   )},
	{model = 'models/maps/nmo_blizzard/blizzard_snowfall256.mdl',        pos = Vector(      2597        ,   -43 ,   1963        ) , ang = Angle(    0   ,   0   ,   0   )},
	{model = 'models/maps/nmo_blizzard/blizzard_snowfall256.mdl',        pos = Vector(      2849        ,   -43 ,   1963        ) , ang = Angle(    0   ,   0   ,   0   )},
	{model = 'models/maps/nmo_blizzard/blizzard_snowfall256.mdl',        pos = Vector(      2727        ,   679 ,   1965.1899414062     ) , ang = Angle(    0   ,   0   ,   0   )},
	{model = 'models/maps/nmo_blizzard/blizzard_snowfall256.mdl',        pos = Vector(      2345        ,   -43 ,   1963        ) , ang = Angle(    0   ,   0   ,   0   )},
	{model = 'models/maps/nmo_blizzard/blizzard_snowfall256.mdl',        pos = Vector(      2475        ,   679 ,   1965.1899414062     ) , ang = Angle(    0   ,   0   ,   0   )},
	{model = 'models/maps/nmo_blizzard/blizzard_snowfall256.mdl',        pos = Vector(      2223        ,   679 ,   1965.1899414062     ) , ang = Angle(    0   ,   0   ,   0   )},
	{model = 'models/maps/nmo_blizzard/blizzard_snowfall256.mdl',        pos = Vector(      1706        ,   -570        ,   1962        ) , ang = Angle(    0   ,   0   ,   0   )},
	{model = 'models/maps/nmo_blizzard/blizzard_snowfall256.mdl',        pos = Vector(      1767        ,   -449        ,   1964.1899414062     ) , ang = Angle(    0   ,   0   ,   0   )},
	{model = 'models/maps/nmo_blizzard/blizzard_snowfall256.mdl',        pos = Vector(      1971        ,   679 ,   1965.1899414062     ) , ang = Angle(    0   ,   0   ,   0   )},
	{model = 'models/maps/nmo_blizzard/blizzard_snowfall1024.mdl',       pos = Vector(      1061        ,   262 ,   1974.6899414062     ) , ang = Angle(    0   ,   0   ,   0   )},

}

function SpawnNYESnow()
	for k,v in pairs(ents.GetAll()) do
		if v:GetClass() == "prop_dynamic" and v:GetModel():find("snowfall") then
			v:Remove()
		end
	end
	for i = 1, #snowfall do
		local data = snowfall[i]
		local prop = ents.Create("imper_snow")
		prop:Spawn()
		prop:SetModel(data.model)
		prop:SetMoveType( MOVETYPE_NONE )
		prop:SetSolid( SOLID_VPHYSICS )
		prop:SetPos(data.pos)
		prop:SetAngles(data.ang)
	end
end

--for k,v in pairs(ents.GetAll()) do
--	if v:GetClass() == "prop_physics" and v:GetModel() != "models/props_rooftop/roof_dish001.mdl" then
--		
--		--timer.Simple(k * 1, function()
--			print("{model = '"..v:GetModel().."',"," pos = Vector(", v:GetPos().x, ",", v:GetPos().y, ",", v:GetPos().z,") , ang = Angle(", v:GetAngles().x, ",", v:GetAngles().y, ",", v:GetAngles().z,")},")
--			--file.Write("breach/hl2props.txt", tostring(file.Read( "breach/hl2prop.txt", "DATA" )) .. "\n" .. "{model = '"..v:GetModel().."'".." pos = Vector(".. v:GetPos().x.. ",".. v:GetPos().y.. ",".. v:GetPos().z..") , ang = Angle(".. v:GetAngles().x.. ",".. v:GetAngles().y.. ",".. v:GetAngles().z..")},")
--		--end)
--	end
--end

--for k,v in pairs(ents.GetAll()) do
--	if v:GetClass() == "new_trea_gift_xmas" and v:GetModel() != "models/props_rooftop/roof_dish001.mdl" then
--		
--		--timer.Simple(k * 1, function()
--			print("{pos = Vector(", v:GetPos().x, ",", v:GetPos().y, ",", v:GetPos().z,") , ang = Angle(", v:GetAngles().x, ",", v:GetAngles().y, ",", v:GetAngles().z,")},")
--			--file.Write("breach/hl2props.txt", tostring(file.Read( "breach/hl2prop.txt", "DATA" )) .. "\n" .. "{model = '"..v:GetModel().."'".." pos = Vector(".. v:GetPos().x.. ",".. v:GetPos().y.. ",".. v:GetPos().z..") , ang = Angle(".. v:GetAngles().x.. ",".. v:GetAngles().y.. ",".. v:GetAngles().z..")},")
--		--end)
--	end
--end

local gifts = {
	{pos = Vector(      1069.3612060547     ,   -67.162231445312    ,   1946.4371337891     ) , ang = Angle(    0.053588036447763   ,   -31.101758956909    ,   -0.018157958984375  )},
{pos = Vector(      1051.6147460938     ,   -99.839996337891    ,   1946.3857421875     ) , ang = Angle(    -0.03476681932807   ,   -25.088565826416    ,   -0.00762939453125   )},
{pos = Vector(      1053.1177978516     ,   -41.208602905273    ,   1946.3840332031     ) , ang = Angle(    -0.035296246409416  ,   -3.0436358451843    ,   -0.00775146484375   )},
{pos = Vector(      1026.5616455078     ,   -21.765441894531    ,   1946.3804931641     ) , ang = Angle(    -0.036379441618919  ,   17.680213928223     ,   -0.00799560546875   )},
{pos = Vector(      1025.5207519531     ,   -115.24083709717    ,   1946.37109375       ) , ang = Angle(    -0.039235074073076  ,   -62.443328857422    ,   -0.00860595703125   )},
{pos = Vector(      984.29595947266     ,   -105.42966461182    ,   1946.4686279297     ) , ang = Angle(    -0.0094791017472744 ,   -141.11639404297    ,   -0.0020751953125    )},
{pos = Vector(      967.95928955078     ,   -73.619239807129    ,   1946.3524169922     ) , ang = Angle(    -0.044951152056456  ,   -174.24723815918    ,   -0.0098876953125    )},
{pos = Vector(      979.28991699219     ,   -44.630668640137    ,   1946.3381347656     ) , ang = Angle(    -0.010859883390367  ,   141.45899963379     ,   -0.00372314453125   )},
{pos = Vector(      999.47015380859     ,   -27.61014175415     ,   1946.3956298828     ) , ang = Angle(    -0.03175288811326   ,   118.62977600098     ,   -0.0069580078125    )},
{pos = Vector(      -2808.0100097656    ,   -4666.4213867188    ,   1946.3804931641     ) , ang = Angle(    -0.036379247903824  ,   24.411901473999     ,   -0.00799560546875   )},
{pos = Vector(      -2810.8618164062    ,   -4706.1372070312    ,   1946.3359375        ) , ang = Angle(    -0.049967616796494  ,   -35.38249206543     ,   -0.010986328125     )},
{pos = Vector(      -2825.376953125     ,   -4732.4331054688    ,   1946.3500976562     ) , ang = Angle(    -0.045635804533958  ,   -45.349281311035    ,   -0.010009765625     )},
{pos = Vector(      -2854.779296875     ,   -4738.90625 ,   1946.3940429688     ) , ang = Angle(    -0.032236605882645  ,   -62.246242523193    ,   -0.007080078125     )},
{pos = Vector(      -2833.974609375     ,   -4652.4135742188    ,   1946.3988037109     ) , ang = Angle(    -0.030807830393314  ,   50.878162384033     ,   -0.00677490234375   )},
{pos = Vector(      -2863.1420898438    ,   -4646.1396484375    ,   1946.3546142578     ) , ang = Angle(    -0.044277012348175  ,   78.070739746094     ,   -0.00970458984375   )},
{pos = Vector(      -2892.6936035156    ,   -4666.7412109375    ,   1946.435546875      ) , ang = Angle(    -0.019577614963055  ,   102.02799987793     ,   -0.004302978515625  )},
{pos = Vector(      -2899.3291015625    ,   -4702.384765625     ,   1946.3671875        ) , ang = Angle(    -0.040439091622829  ,   113.51208496094     ,   -0.008880615234375  )},
{pos = Vector(      3720.4548339844     ,   -1144.9332275391    ,   1946.3952636719     ) , ang = Angle(    0.0043100244365633  ,   -119.23973846436    ,   0.012298583984375   )},
{pos = Vector(      3749.0866699219     ,   -1146.0975341797    ,   1946.4521484375     ) , ang = Angle(    0.069708243012428   ,   -86.770774841309    ,   0.24345397949219    )},
{pos = Vector(      3777.24609375       ,   -1135.3178710938    ,   1946.4029541016     ) , ang = Angle(    -0.040631920099258  ,   -55.945442199707    ,   -0.009063720703125  )},
{pos = Vector(      3793.478515625      ,   -1097.5601806641    ,   1946.4677734375     ) , ang = Angle(    0.080839946866035   ,   -5.2406277656555    ,   0.0401611328125     )},
{pos = Vector(      3773.3664550781     ,   -1067.7113037109    ,   1946.443359375      ) , ang = Angle(    -0.0060740238986909 ,   44.389759063721     ,   -0.025299072265625  )},
{pos = Vector(      3738.6591796875     ,   -1060.6146240234    ,   1946.4305419922     ) , ang = Angle(    -0.042877092957497  ,   106.20179748535     ,   -0.20541381835938   )},
{pos = Vector(      3710.9680175781     ,   -1079.7159423828    ,   1946.3836669922     ) , ang = Angle(    -0.069151170551777  ,   139.7059173584      ,   -0.039398193359375  )},
{pos = Vector(      3703.9338378906     ,   -1111.0754394531    ,   1946.3511962891     ) , ang = Angle(    -0.17945621907711   ,   -177.53932189941    ,   0.086257934570312   )},
{pos = Vector(      7061.0205078125     ,   -65.55443572998     ,   1418.3941650391     ) , ang = Angle(    -0.03228859975934   ,   163.63771057129     ,   -0.007080078125     )},
{pos = Vector(      7080.8530273438     ,   -46.515186309814    ,   1418.3385009766     ) , ang = Angle(    -0.049298617988825  ,   106.02035522461     ,   -0.01080322265625   )},
{pos = Vector(      7108.8784179688     ,   -57.984378814697    ,   1418.4356689453     ) , ang = Angle(    -0.019609140232205  ,   29.195219039917     ,   -0.004302978515625  )},
{pos = Vector(      7107.1469726562     ,   -88.275009155273    ,   1418.4105224609     ) , ang = Angle(    -0.00038198329275474        ,   -39.169242858887    ,   0.04205322265625    )},
{pos = Vector(      7088.1376953125     ,   -99.138931274414    ,   1418.4666748047     ) , ang = Angle(    0.030399963259697   ,   -101.92919921875    ,   -0.0863037109375    )},
{pos = Vector(      7063.12109375       ,   -89.669471740723    ,   1418.3974609375     ) , ang = Angle(    -0.10690459609032   ,   -144.81297302246    ,   -0.10992431640625   )},
{pos = Vector(      -2129.6682128906    ,   -7617.662109375     ,   1666.8359375        ) , ang = Angle(    16.181135177612     ,   178.6244354248      ,   -15.674835205078    )},
{pos = Vector(      -2107.451171875     ,   -7579.6088867188    ,   1681.6120605469     ) , ang = Angle(    5.7311034202576     ,   175.42108154297     ,   -14.692199707031    )},
{pos = Vector(      -2187.3469238281    ,   -7599.6181640625    ,   1646.4647216797     ) , ang = Angle(    10.896766662598     ,   135.80033874512     ,   -13.057495117188    )},
{pos = Vector(      -2100.9670410156    ,   -7559.3383789062    ,   1686.2116699219     ) , ang = Angle(    3.2598061561584     ,   160.15251159668     ,   -13.11474609375     )},
{pos = Vector(      6727.6118164062     ,   -5518.314453125     ,   129.65466308594     ) , ang = Angle(    -0.044495649635792  ,   177.66680908203     ,   -0.00946044921875   )},
{pos = Vector(      6723.1450195312     ,   -5553.541015625     ,   129.77976989746     ) , ang = Angle(    -0.13081425428391   ,   -152.86663818359    ,   0.0135498046875     )},
{pos = Vector(      6749.0244140625     ,   -5566.3779296875    ,   129.75782775879     ) , ang = Angle(    -0.30121529102325   ,   -90.165672302246    ,   0.0002593994140625  )},
{pos = Vector(      6771.7915039062     ,   -5529.3037109375    ,   129.68585205078     ) , ang = Angle(    -0.034938178956509  ,   -98.052253723145    ,   -0.0074462890625    )},
{pos = Vector(      8159.2333984375     ,   -3511.2429199219    ,   1.7030863761902     ) , ang = Angle(    -0.029588198289275  ,   -98.616355895996    ,   -0.00628662109375   )},
{pos = Vector(      8138.451171875      ,   -3490.1979980469    ,   1.6522415876389     ) , ang = Angle(    -0.045175634324551  ,   -162.17367553711    ,   -0.0096435546875    )},
{pos = Vector(      8143.80859375       ,   -3456.6572265625    ,   1.7101110219955     ) , ang = Angle(    -0.027429906651378  ,   119.54809570312     ,   -0.005859375        )},
{pos = Vector(      8176.515625 ,   -3454.880859375     ,   1.6709814071655     ) , ang = Angle(    -0.039433024823666  ,   57.860046386719     ,   -0.00836181640625   )},
{pos = Vector(      8186.9692382812     ,   -3477.6650390625    ,   1.6405246257782     ) , ang = Angle(    -0.044623896479607  ,   -11.326766967773    ,   -0.0091552734375    )},
{pos = Vector(      8181.7114257812     ,   -3497.9587402344    ,   1.7101110219955     ) , ang = Angle(    -0.027435269206762  ,   -35.749271392822    ,   -0.005859375        )},
{pos = Vector(      532.6982421875      ,   4797.9184570312     ,   0.37501060962677    ) , ang = Angle(    -0.03825206682086   ,   35.993171691895     ,   -0.008148193359375  )},
{pos = Vector(      536.68725585938     ,   4771.5966796875     ,   0.42839688062668    ) , ang = Angle(    -0.021924156695604  ,   -39.798431396484    ,   -0.0045166015625    )},
{pos = Vector(      513.66143798828     ,   4757.9428710938     ,   0.32542127370834    ) , ang = Angle(    -0.023400858044624  ,   -94.185218811035    ,   -0.00677490234375   )},
{pos = Vector(      490.88217163086     ,   4769.3779296875     ,   0.43365487456322    ) , ang = Angle(    -0.020276730880141  ,   -152.11906433105    ,   -0.00433349609375   )},
{pos = Vector(      483.017578125       ,   4794.908203125      ,   0.47850808501244    ) , ang = Angle(    -0.0065265228040516 ,   141.08000183105     ,   -0.00140380859375   )},
{pos = Vector(      509.53176879883     ,   4807.607421875      ,   0.39657664299011    ) , ang = Angle(    -0.11385660618544   ,   97.224990844727     ,   -0.13336181640625   )},
}

function SpawnNYEGifts()
	for i = 1, #gifts do
		local data = gifts[i]
		local prop = ents.Create("new_trea_gift_xmas")
		--prop:SetModel(data.model)
		prop:SetMoveType( MOVETYPE_NONE )
		prop:SetSolid( SOLID_VPHYSICS )
		prop:SetPos(data.pos)
		prop:SetAngles(data.ang)
		prop:Spawn()
	end
end

local ny = {
	{model = 'models/unconid/xmas/snowman_u_big.mdl',     pos = Vector(      6102.978515625      ,   -5666.5737304688    ,   130.34298706055     ) , ang = Angle(    0.013849762268364   ,   10.722105026245     ,   0.0097198486328125  )},
	{model = 'models/blackjack/reno.mdl' ,        pos = Vector(      6273.6650390625     ,   -5572.455078125     ,   158.12448120117     ) , ang = Angle(    -0.011056297458708  ,   -135.19271850586    ,   -0.885498046875     )},
	{model = 'models/blackjack/birds_01.mdl'     ,pos = Vector(      6257.791015625      ,   -5744.4663085938    ,   154.32412719727     ) , ang = Angle(    -0.15456447005272   ,   135.69938659668     ,   -0.068603515625     )},
	{model = 'models/blackjack/nutcracker2.mdl'  ,pos = Vector(      6253.1728515625     ,   -6511.138671875     ,   187.73616027832     ) , ang = Angle(    -0.11631897091866   ,   122.75093841553     ,   0.066741943359375   )},
	{model = 'models/blackjack/muneco.mdl'       ,pos = Vector(      6050.6342773438     ,   -6438.5966796875    ,   155.45796203613     ) , ang = Angle(    -2.0268709659576    ,   -0.70319151878357   ,   9.7030487060547     )},
	{model = 'models/blackjack/sign.mdl'         ,pos = Vector(      6177.9790039062     ,   -4974.1015625       ,   168.29280090332     ) , ang = Angle(    0.13280785083771    ,   -89.617073059082    ,   0.057754516601562   )},
	{model = 'models/zerochain/props_christmas/zpn_tree_small.mdl' ,      pos = Vector(      6745.3481445312     ,   -5540.8774414062    ,   129.68893432617     ) , ang = Angle(    0.25561535358429    ,   -149.16262817383    ,   -0.045654296875     )},
	{model = 'models/unconid/xmas/snowman_u.mdl',         pos = Vector(      6747.4970703125     ,   -5822.4594726562    ,   130.14241027832     ) , ang = Angle(    -9.5747518571443e-06        ,   119.68891143799     ,   -0.01318359375      )},
	{model = 'models/blackjack/belen2.mdl'      , pos = Vector(      6320.8754882812     ,   -5735.3852539062    ,   151.85375976562     ) , ang = Angle(    0.11046722531319    ,   -0.10026955604553   ,   0   )},
	{model = 'models/blackjack/snowman.mdl'     , pos = Vector(      6538.6186523438     ,   -5502.4604492188    ,   181.92172241211     ) , ang = Angle(    -0.11382560431957   ,   -127.47933959961    ,   0.11849975585938    )},
	{model = 'models/blackjack/train.mdl'       , pos = Vector(      7017.1518554688     ,   -5489.4208984375    ,   146.94532775879     ) , ang = Angle(    0.046590957790613   ,   -106.45162963867    ,   -0.0096435546875    )},
	{model = 'models/blackjack/monigote.mdl'    , pos = Vector(      7192.2817382812     ,   -5165.6240234375    ,   156.06384277344     ) , ang = Angle(    20.769088745117     ,   89.939788818359     ,   9.6370239257812     )},
	{model = 'models/blackjack/snowman_globe.mdl',        pos = Vector(      7050.1235351562     ,   -5135.37109375      ,   186.69450378418     ) , ang = Angle(    -0.0020189085043967 ,   -51.2864112854      ,   -0.08544921875      )},
	{model = 'models/blackjack/snowman.mdl'      ,pos = Vector(      7039.4130859375     ,   -5315.919921875     ,   185.76689147949     ) , ang = Angle(    -0.085843540728092  ,   -45.941608428955    ,   0.088790893554688   )},
	{model = 'models/blackjack/reyes.mdl'        ,pos = Vector(      7366.3901367188     ,   -4975.0478515625    ,   196.75096130371     ) , ang = Angle(    -0.24529241025448   ,   -101.52132415771    ,   0.82354736328125    )},
	{model = 'models/blackjack/merry.mdl'        ,pos = Vector(      7712.8784179688     ,   -5894.013671875     ,   297.1037902832      ) , ang = Angle(    0.098396256566048   ,   0.037665143609047   ,   10.147171020508     )},
	{model = 'models/blackjack/new_pattern.mdl'  ,pos = Vector(      7713.5654296875     ,   -5698.2622070312    ,   279.55715942383     ) , ang = Angle(    -0.020484380424023  ,   0.2090330272913     ,   5.5963287353516     )},
	{model = 'models/blackjack/mail_box.mdl'     ,pos = Vector(      7701.3627929688     ,   -6210.4638671875    ,   250.22499084473     ) , ang = Angle(    -0.024529524147511  ,   45.274200439453     ,   -0.00311279296875   )},
	{model = 'models/blackjack/dog.mdl'  ,pos = Vector(      7778.5502929688     ,   -6532.3012695312    ,   250.85722351074     ) , ang = Angle(    0.11178170144558    ,   87.956199645996     ,   -0.029449462890625  )},
	{model = 'models/blackjack/street_lamp.mdl'  ,pos = Vector(      6879.755859375      ,   -6541.609375        ,   194.11059570312     ) , ang = Angle(    -0.018882744014263  ,   89.719779968262     ,   0.055923461914062   )},
	{model = 'models/blackjack/mail_box.mdl'     ,pos = Vector(      6986.6420898438     ,   -6327.8510742188    ,   154.22836303711     ) , ang = Angle(    6.9888228608761e-05 ,   -124.56907653809    ,   -6.103515625e-05    )},
	{model = 'models/blackjack/horse.mdl'        ,pos = Vector(      6817.7543945312     ,   -6086.5869140625    ,   153.26502990723     ) , ang = Angle(    0.11183077096939    ,   32.445411682129     ,   -0.2928466796875    )},
	{model = 'models/blackjack/santa_lantern.mdl'        ,pos = Vector(      6626.0927734375     ,   -6365.42578125      ,   163.29951477051     ) , ang = Angle(    -0.004872864112258  ,   -107.35433959961    ,   0.002105712890625   )},
	{model = 'models/blackjack/deer.mdl'        , pos = Vector(      6875.0043945312     ,   -4968.5361328125    ,   279.54336547852     ) , ang = Angle(    0.0088817030191422  ,   -90.001770019531    ,   2.7717895507812     )},
	{model = 'models/blackjack/deers.mdl'       , pos = Vector(      6816.7104492188     ,   -5121.8618164062    ,   197.77937316895     ) , ang = Angle(    0.074691444635391   ,   0.040642078965902   ,   1.7987976074219     )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'    , pos = Vector(      6677.4135742188     ,   -4201.46875 ,   130.37927246094     ) , ang = Angle(    -0.071171186864376  ,   -7.5313496589661    ,   -0.073883056640625  )},
	{model = 'models/blackjack/lucespng.mdl'    , pos = Vector(      6865.8920898438     ,   -4067.5910644531    ,   188.11264038086     ) , ang = Angle(    0.12229759991169    ,   -90.05793762207     ,   -5.9597778320312    )},
	{model = 'models/blackjack/horse.mdl'       , pos = Vector(      6941.7822265625     ,   -4078.6364746094    ,   153.40028381348     ) , ang = Angle(    -1.9335097074509    ,   -50.98441696167     ,   4.3928985595703     )},
	{model = 'models/blackjack/merry.mdl'       , pos = Vector(      6640.7563476562     ,   -4062.6281738281    ,   198.1759185791      ) , ang = Angle(    -0.01730689406395   ,   0.037056617438793   ,   0.18013000488281    )},
	{model = 'models/blackjack/buche.mdl'       , pos = Vector(      7386.0356445312     ,   -3948.9484863281    ,   41.681976318359     ) , ang = Angle(    0.16861325502396    ,   35.53201675415      ,   -0.05499267578125   )},
	{model = 'models/blackjack/santa.mdl'       , pos = Vector(      7413.6352539062     ,   -4180.8090820312    ,   30.15799331665      ) , ang = Angle(    1.5461523532867     ,   141.84521484375     ,   -3.4910888671875    )},
	{model = 'models/blackjack/porte.mdl'       , pos = Vector(      7417.3989257812     ,   -4064.9123535156    ,   66.064727783203     ) , ang = Angle(    0.41486141085625    ,   179.83308410645     ,   -0.002197265625     )},
	{model = 'models/blackjack/porte.mdl'       , pos = Vector(      7481.1606445312     ,   -4063.2004394531    ,   64.467399597168     ) , ang = Angle(    -0.056499607861042  ,   -0.93877732753754   ,   -0.0059814453125    )},
	{model = 'models/blackjack/santa_lantern.mdl'        ,pos = Vector(      7917.9995117188     ,   -3946.8552246094    ,   35.415161132812     ) , ang = Angle(    0.79365968704224    ,   -45.017631530762    ,   -0.059661865234375  )},
	{model = 'models/blackjack/deers.mdl'       , pos = Vector(      7919.1005859375     ,   -4143.1572265625    ,   63.433387756348     ) , ang = Angle(    0.078831747174263   ,   90.102462768555     ,   -2.94482421875      )},
	{model = 'models/blackjack/dog.mdl' , pos = Vector(      8048.603515625      ,   -4014.5588378906    ,   26.871101379395     ) , ang = Angle(    -0.24197152256966   ,   135.20399475098     ,   -0.04547119140625   )},
	{model = 'models/blackjack/merry.mdl'       , pos = Vector(      8236.69921875       ,   -4559.1875  ,   73.605918884277     ) , ang = Angle(    -0.16065087914467   ,   89.958129882812     ,   -0.001373291015625  )},
	{model = 'models/blackjack/sign.mdl'        , pos = Vector(      8354.7587890625     ,   -4552.1997070312    ,   40.135467529297     ) , ang = Angle(    0.18777702748775    ,   90.177139282227     ,   0.0091094970703125  )},
	{model = 'models/blackjack/reno.mdl'        , pos = Vector(      8096.21875  ,   -4558.0693359375    ,   30.102973937988     ) , ang = Angle(    -0.034412413835526  ,   90.231346130371     ,   -0.96966552734375   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'   ,  pos = Vector(      8355.4453125        ,   -4313.4125976562    ,   2.2957520484924     ) , ang = Angle(    0.00082163774641231 ,   -6.6888213157654    ,   0.04351806640625    )},
	{model = 'models/blackjack/snowman.mdl'  ,    pos = Vector(      8097.283203125      ,   -4333.59375 ,   50.033054351807     ) , ang = Angle(    -0.16389660537243   ,   179.72593688965     ,   -0.5728759765625    )},
	{model = 'models/zerochain/props_christmas/zpn_tree_small.mdl'   ,    pos = Vector(      8575.6689453125     ,   -4543.2041015625    ,   1.6918482780457     ) , ang = Angle(    -0.020914677530527  ,   137.54081726074     ,   -0.01171875 )},
	{model = 'models/blackjack/train.mdl'       , pos = Vector(      8537.966796875      ,   -4338.7387695312    ,   19.079044342041     ) , ang = Angle(    -0.032661497592926  ,   175.01770019531     ,   0.0058441162109375  )},
	{model = 'models/blackjack/nutcracker.mdl'  , pos = Vector(      8536.2275390625     ,   -3829.8059082031    ,   54.498027801514     ) , ang = Angle(    0.38029754161835    ,   179.45344543457     ,   -0.32418823242188   )},
	{model = 'models/zerochain/props_christmas/zpn_tree.mdl'   ,  pos = Vector(      8162.1215820312     ,   -3479.6032714844    ,   1.7519575357437     ) , ang = Angle(    0.0045627849176526  ,   -1.3227516412735    ,   0.0027008056640625  )},
	{model = 'models/blackjack/buche.mdl'       , pos = Vector(      8505.140625 ,   -3068.736328125     ,   77.924873352051     ) , ang = Angle(    -0.11322861164808   ,   82.474739074707     ,   0.01275634765625    )},
	{model = 'models/blackjack/train.mdl'       , pos = Vector(      8909.2783203125     ,   -3378.7185058594    ,   19.07154083252      ) , ang = Angle(    -0.11982048302889   ,   -137.6095123291     ,   0.010330200195312   )},
	{model = 'models/blackjack/elves.mdl'       , pos = Vector(      8689.5869140625     ,   -3380.87109375      ,   29.270973205566     ) , ang = Angle(    -0.13780158758163   ,   -51.663509368896    ,   -0.083740234375     )},
	{model = 'models/blackjack/elfa.mdl'        , pos = Vector(      8925.056640625      ,   -3630.5356445312    ,   25.377813339233     ) , ang = Angle(    1.2639008760452     ,   142.25390625        ,   0.37751770019531    )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'   ,  pos = Vector(      8069.185546875      ,   -3339.5666503906    ,   2.3615472316742     ) , ang = Angle(    0.22741134464741    ,   -44.697040557861    ,   -0.11602783203125   )},
	{model = 'models/blackjack/lucespng.mdl'    , pos = Vector(      8239.34765625       ,   -3703.1242675781    ,   66.49666595459      ) , ang = Angle(    -0.090776734054089  ,   -179.65356445312    ,   -5.8341064453125    )},
	{model = 'models/blackjack/mail_box.mdl'    , pos = Vector(      8303.2890625        ,   -3380.1557617188    ,   26.035894393921     ) , ang = Angle(    -0.025604654103518  ,   -137.05595397949    ,   0.0382080078125     )},
	{model = 'models/blackjack/jingle_bell.mdl' , pos = Vector(      9302.2275390625     ,   -4035.1267089844    ,   -25.310523986816    ) , ang = Angle(    -4.1664619445801    ,   -124.17539978027    ,   -13.0634765625      )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'  ,   pos = Vector(      9176.4111328125     ,   -3950.8247070312    ,   -125.73040008545    ) , ang = Angle(    0.036247909069061   ,   -113.78652954102    ,   0.028594970703125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'  ,   pos = Vector(      9242.189453125      ,   -4412.77734375      ,   -125.60460662842    ) , ang = Angle(    -0.13284832239151   ,   103.6895904541      ,   -0.17108154296875   )},
	{model = 'models/blackjack/muneco.mdl'      , pos = Vector(      8901.1025390625     ,   -4409.55078125      ,   -100.48725128174    ) , ang = Angle(    -0.51223236322403   ,   43.122383117676     ,   10.432571411133     )},
	{model = 'models/blackjack/merry.mdl'       , pos = Vector(      8736.857421875      ,   -4167.4819335938    ,   -61.682582855225    ) , ang = Angle(    -0.069005057215691  ,   -0.066093683242798  ,   0.71139526367188    )},
	{model = 'models/blackjack/new_pattern.mdl' , pos = Vector(      8796.6865234375     ,   -3873.4682617188    ,   -55.742881774902    ) , ang = Angle(    0.00043188844574615 ,   -90.037452697754    ,   1.2549285888672     )},
	{model = 'models/blackjack/nutcracker2.mdl' , pos = Vector(      9079.220703125      ,   -3833.2641601562    ,   -68.305610656738    ) , ang = Angle(    -0.11193607002497   ,   -95.87606048584     ,   0.06329345703125    )},
	{model = 'models/unconid/xmas/snowman_u.mdl'      ,   pos = Vector(      8674.66796875       ,   -4880.0927734375    ,   2.07386469841       ) , ang = Angle(    0.0025543353985995  ,   49.513648986816     ,   -0.07928466796875   )},
	{model = 'models/blackjack/reyes.mdl'       ,pos = Vector(      8924.134765625      ,   -4912.7353515625    ,   32.219673156738     ) , ang = Angle(    0.075171545147896   ,   134.89122009277     ,   0.39410400390625    )},
	{model = 'models/blackjack/etoile.mdl'      ,pos = Vector(      8920.7705078125     ,   -4618.322265625     ,   66.122001647949     ) , ang = Angle(    1.0301197767258     ,   -135.1368560791     ,   -2.6812744140625    )},
	{model = 'models/blackjack/dog.mdl'  ,pos = Vector(      8684.2666015625     ,   -4646.2543945312    ,   26.838714599609     ) , ang = Angle(    0.13701443374157    ,   -62.476127624512    ,   -0.027587890625     )},
	{model = 'models/blackjack/deer2.mdl'        ,pos = Vector(      9503.4013671875     ,   -4771.671875        ,   111.80876922607     ) , ang = Angle(    89.621383666992     ,   179.80110168457     ,   -90.325805664062    )},
	{model = 'models/blackjack/bougeoire.mdl'    ,pos = Vector(      9498.0859375        ,   -4768.2568359375    ,   6.0301599502563     ) , ang = Angle(    -0.040923856198788  ,   179.25119018555     ,   0.0057525634765625  )},
	{model = 'models/blackjack/nutcracker.mdl'   ,pos = Vector(      9492.2109375        ,   -4511.3090820312    ,   54.459098815918     ) , ang = Angle(    0.06957820802927    ,   -123.75735473633    ,   -0.044189453125     )},
	{model = 'models/blackjack/nutcracker2.mdl'  ,pos = Vector(      9492.416015625      ,   -5052.9008789062    ,   59.699039459229     ) , ang = Angle(    -0.066000059247017  ,   110.10836029053     ,   0.026596069335938   )},
	{model = 'models/blackjack/guirlande.mdl'    ,pos = Vector(      9413.4384765625     ,   -4795.7861328125    ,   164.25805664062     ) , ang = Angle(    -4.400337008019e-15 ,   -1.5251635313034    ,   1.52587890625e-05   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      8542.8408203125     ,   -5382.5009765625    ,   2.345477104187      ) , ang = Angle(    0.20487600564957    ,   -29.336826324463    ,   0.024093627929688   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      8288.3701171875     ,   -2736.1799316406    ,   2.368185043335      ) , ang = Angle(    0.22741132974625    ,   -129.50730895996    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      7992.0185546875     ,   -2121.7705078125    ,   2.368185043335      ) , ang = Angle(    0.22741132974625    ,   -59.547306060791    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      8056.3256835938     ,   -2052.0983886719    ,   2.368185043335      ) , ang = Angle(    0.22741134464741    ,   -31.431407928467    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      7451.4877929688     ,   -2093.1447753906    ,   2.3681926727295     ) , ang = Angle(    0.22741132974625    ,   -32.35538482666     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      7663.0620117188     ,   -1256.1790771484    ,   2.3681926727295     ) , ang = Angle(    0.22741132974625    ,   -120.06952667236    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      7543.681640625      ,   -2496.6384277344    ,   9.8346462249756     ) , ang = Angle(    0.22741134464741    ,   -1.5995482206345    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      7721.1904296875     ,   -2973.11328125      ,   2.3681926727295     ) , ang = Angle(    0.22741134464741    ,   -128.55340576172    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      7376.5102539062     ,   -3147.2687988281    ,   2.3681926727295     ) , ang = Angle(    0.22741132974625    ,   38.822883605957     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      6554.5512695312     ,   -3228.3193359375    ,   2.3681926727295     ) , ang = Angle(    0.22741134464741    ,   -4.0773129463196    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      5923.2978515625     ,   -2125.9689941406    ,   2.3681926727295     ) , ang = Angle(    0.22741134464741    ,   -4.7370128631592    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      5294.1953125        ,   -1670.927734375     ,   3.068395614624      ) , ang = Angle(    0.22741132974625    ,   -9.6208992004395    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      5335.408203125      ,   -2507.0031738281    ,   3.068395614624      ) , ang = Angle(    0.22741132974625    ,   60.405265808105     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      5685.8471679688     ,   -3325.578125        ,   3.068395614624      ) , ang = Angle(    0.22741132974625    ,   90.369445800781     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      5068.0258789062     ,   -2930.5427246094    ,   3.068395614624      ) , ang = Angle(    0.22741132974625    ,   -12.788519859314    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      4650.4375   ,   -2680.0739746094    ,   3.068395614624      ) , ang = Angle(    0.22741134464741    ,   -57.140411376953    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      4905.7895507812     ,   -1993.0053710938    ,   1.068395614624      ) , ang = Angle(    0.22741132974625    ,   -103.60473632812    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      7132.169921875      ,   -1718.6645507812    ,   2.3681926727295     ) , ang = Angle(    0.22741132974625    ,   155.61317443848     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      7243.197265625      ,   -1651.6486816406    ,   2.3681926727295     ) , ang = Angle(    0.22741132974625    ,   176.27119445801     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      7269.5122070312     ,   -1305.3706054688    ,   2.3681926727295     ) , ang = Angle(    0.22741134464741    ,   -174.75280761719    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      8882.11328125       ,   -2125.9013671875    ,   2.368185043335      ) , ang = Angle(    0.22741132974625    ,   -93.740882873535    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      9567.0625   ,   -2325.2145996094    ,   2.3681926727295     ) , ang = Angle(    0.22741132974625    ,   132.27896118164     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      9403.12890625       ,   -774.97467041016    ,   2.3681926727295     ) , ang = Angle(    0.22741132974625    ,   37.929004669189     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      10155.828125        ,   -658.64300537109    ,   2.068395614624      ) , ang = Angle(    0.22741134464741    ,   -150.40498352051    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      10514.170898438     ,   -697.78283691406    ,   2.068395614624      ) , ang = Angle(    0.22741132974625    ,   -155.94897460938    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      10387.33984375      ,   -1180.1765136719    ,   2.368185043335      ) , ang = Angle(    0.22741134464741    ,   -139.08871459961    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      10567.056640625     ,   -1239.6505126953    ,   2.368200302124      ) , ang = Angle(    0.22741132974625    ,   -142.12480163574    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      9870.9814453125     ,   -1176.0582275391    ,   2.368200302124      ) , ang = Angle(    0.22741132974625    ,   -32.168712615967    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      9872.84765625       ,   -2480.4758300781    ,   38.708305358887     ) , ang = Angle(    0.22741132974625    ,   80.361320495605     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      10367.029296875     ,   -2469.0263671875    ,   2.3681926727295     ) , ang = Angle(    0.22741132974625    ,   140.22325134277     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      10193.4375  ,   -2185.6813964844    ,   3.3681929111481     ) , ang = Angle(    0.22741132974625    ,   79.269348144531     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      10136.669921875     ,   -2154.1130371094    ,   3.3681929111481     ) , ang = Angle(    0.22741134464741    ,   42.837203979492     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      10114.760742188     ,   -2102.3056640625    ,   3.3682005405426     ) , ang = Angle(    0.22741134464741    ,   19.86909866333      ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      10270.7578125       ,   -1921.7963867188    ,   3.3681929111481     ) , ang = Angle(    0.22741134464741    ,   -93.782844543457    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      10328.920898438     ,   -1928.0085449219    ,   3.3682005405426     ) , ang = Angle(    0.22741134464741    ,   -121.63488769531    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      10369.73828125      ,   -1968.7943115234    ,   3.3681929111481     ) , ang = Angle(    0.22741134464741    ,   -149.22294616699    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      10371.306640625     ,   -2021.8519287109    ,   3.3681929111481     ) , ang = Angle(    0.22741134464741    ,   175.79698181152     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      10222.807617188     ,   -1915.3770751953    ,   3.3681929111481     ) , ang = Angle(    0.22741132974625    ,   -93.782897949219    ,   -0.11602783203125   )},
	{model = 'models/blackjack/elves.mdl'        ,pos = Vector(      10237.088867188     ,   -2059.2600097656    ,   30.246538162231     ) , ang = Angle(    0.004905445035547   ,   55.490081787109     ,   0.007598876953125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      9211.056640625      ,   -1167.0942382812    ,   -29.631807327271    ) , ang = Angle(    0.22741132974625    ,   -44.378787994385    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      9376.5263671875     ,   -1606.0190429688    ,   2.368185043335      ) , ang = Angle(    0.22741134464741    ,   60.825168609619     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      8904.732421875      ,   -1380.0087890625    ,   -29.631807327271    ) , ang = Angle(    0.22741134464741    ,   -4.2510862350464    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      8588.0185546875     ,   -1506.9388427734    ,   2.3681926727295     ) , ang = Angle(    0.22741134464741    ,   -3.3929646015167    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      8588.3447265625     ,   -1340.0213623047    ,   2.3681926727295     ) , ang = Angle(    0.22741132974625    ,   -3.524968624115     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      8588.4619140625     ,   -1264.2639160156    ,   2.3681926727295     ) , ang = Angle(    0.22741132974625    ,   -3.524968624115     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      8586.2802734375     ,   -1426.3790283203    ,   2.3681926727295     ) , ang = Angle(    0.22741134464741    ,   -12.632821083069    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      8443.3701171875     ,   -1975.5090332031    ,   2.3681926727295     ) , ang = Angle(    0.22741132974625    ,   -5.1089305877686    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      8835.1513671875     ,   -1848.1005859375    ,   2.3681926727295     ) , ang = Angle(    0.22741132974625    ,   -124.40702819824    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      9008.83984375       ,   -2833.5266113281    ,   2.3681926727295     ) , ang = Angle(    0.22741134464741    ,   176.4871673584      ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      9006.9228515625     ,   -2790.9580078125    ,   147.06838989258     ) , ang = Angle(    0.22741134464741    ,   173.25312805176     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      9150.7060546875     ,   -2450.4853515625    ,   147.06838989258     ) , ang = Angle(    0.22741134464741    ,   177.87313842773     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      5949.7905273438     ,   -3518.6267089844    ,   258.36837768555     ) , ang = Angle(    0.22741132974625    ,   -53.156627655029    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      5949.6030273438     ,   -3900.1745605469    ,   258.36837768555     ) , ang = Angle(    0.22741132974625    ,   37.395462036133     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      6585.6713867188     ,   -4056.9375  ,   258.36837768555     ) , ang = Angle(    0.22741132974625    ,   160.15550231934     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      6406.7705078125     ,   -4168.365234375     ,   258.36837768555     ) , ang = Angle(    0.22741132974625    ,   -158.72650146484    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      6338.1225585938     ,   -4626.4428710938    ,   258.36837768555     ) , ang = Angle(    0.22741132974625    ,   35.019195556641     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      6473.0122070312     ,   -4346.8544921875    ,   2.368200302124      ) , ang = Angle(    0.22741132974625    ,   -46.328765869141    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      7115.7172851562     ,   -4619.65625 ,   2.3681926727295     ) , ang = Angle(    0.22741132974625    ,   175.76129150391     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      7619.6059570312     ,   -4186.033203125     ,   2.3681926727295     ) , ang = Angle(    0.22741132974625    ,   -154.27464294434    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      7616.3959960938     ,   -4629.1391601562    ,   2.3681926727295     ) , ang = Angle(    0.22741132974625    ,   111.80736541748     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      8443.1083984375     ,   -4706.7084960938    ,   2.3681926727295     ) , ang = Angle(    0.22741132974625    ,   -138.50050354004    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      7804.314453125      ,   -4711.4643554688    ,   2.3681926727295     ) , ang = Angle(    0.22741132974625    ,   -139.75444030762    ,   -0.11602783203125   )},
	{model = 'models/blackjack/elves.mdl'        ,pos = Vector(      8467.7666015625     ,   -3927.974609375     ,   29.297595977783     ) , ang = Angle(    -0.13780158758163   ,   -152.94329833984    ,   -0.083770751953125  )},
	{model = 'models/blackjack/elves.mdl'        ,pos = Vector(      7887.1743164062     ,   -4062.3903808594    ,   29.297595977783     ) , ang = Angle(    -0.13780158758163   ,   45.026473999023     ,   -0.083770751953125  )},
	{model = 'models/blackjack/elves.mdl'        ,pos = Vector(      8164.7231445312     ,   -2202.197265625     ,   29.297603607178     ) , ang = Angle(    -0.13780158758163   ,   -70.473495483398    ,   -0.083770751953125  )},
	{model = 'models/blackjack/elves.mdl'        ,pos = Vector(      9455.6484375        ,   -2221.7927246094    ,   29.297603607178     ) , ang = Angle(    -0.13780158758163   ,   -167.95553588867    ,   -0.083770751953125  )},
	{model = 'models/blackjack/elves.mdl'        ,pos = Vector(      9629.8369140625     ,   -1405.6121826172    ,   29.297588348389     ) , ang = Angle(    -0.13780158758163   ,   -63.741451263428    ,   -0.083770751953125  )},
	{model = 'models/blackjack/nutcracker.mdl'   ,pos = Vector(      7014.8422851562     ,   -2720.5341796875    ,   54.545318603516     ) , ang = Angle(    0.3802974820137     ,   37.385402679443     ,   -0.32418823242188   )},
	{model = 'models/blackjack/nutcracker.mdl'   ,pos = Vector(      7009.3466796875     ,   -2127.7104492188    ,   54.545310974121     ) , ang = Angle(    0.3802974820137     ,   -52.57262802124     ,   -0.32418823242188   )},
	{model = 'models/blackjack/nutcracker.mdl'   ,pos = Vector(      6595.330078125      ,   -2285.4384765625    ,   54.545310974121     ) , ang = Angle(    0.3802974820137     ,   36.659637451172     ,   -0.32418823242188   )},
	{model = 'models/blackjack/nutcracker.mdl'   ,pos = Vector(      7161.7475585938     ,   -2946.0927734375    ,   54.545310974121     ) , ang = Angle(    0.38029742240906    ,   135.32983398438     ,   -0.32418823242188   )},
	{model = 'models/blackjack/nutcracker.mdl'   ,pos = Vector(      6817.6064453125     ,   -2881.1296386719    ,   54.545318603516     ) , ang = Angle(    0.38029745221138    ,   6.0358781814575     ,   -0.32418823242188   )},
	{model = 'models/blackjack/nutcracker.mdl'   ,pos = Vector(      8858.69140625       ,   -3784.78515625      ,   54.545310974121     ) , ang = Angle(    0.38029745221138    ,   117.83984375        ,   -0.32418823242188   )},
	{model = 'models/blackjack/nutcracker.mdl'   ,pos = Vector(      9907.43359375       ,   -3555.5893554688    ,   54.545318603516     ) , ang = Angle(    0.38029742240906    ,   134.93377685547     ,   -0.32418823242188   )},
	{model = 'models/blackjack/nutcracker.mdl'   ,pos = Vector(      9196.591796875      ,   -3782.5458984375    ,   54.545310974121     ) , ang = Angle(    0.3802974820137     ,   55.205940246582     ,   -0.32418823242188   )},
	{model = 'models/blackjack/nutcracker.mdl'   ,pos = Vector(      10190.18359375      ,   -3568.5888671875    ,   54.545310974121     ) , ang = Angle(    0.3802974820137     ,   122.52587127686     ,   -0.32418823242188   )},
	{model = 'models/blackjack/nutcracker.mdl'   ,pos = Vector(      10229.592773438     ,   -3825.9990234375    ,   -73.454483032227    ) , ang = Angle(    0.3802974820137     ,   -150.28802490234    ,   -0.32418823242188   )},
	{model = 'models/blackjack/nutcracker.mdl'   ,pos = Vector(      10019.203125        ,   -4418.0385742188    ,   -73.454483032227    ) , ang = Angle(    0.3802974820137     ,   99.096176147461     ,   -0.32418823242188   )},
	{model = 'models/blackjack/nutcracker.mdl'   ,pos = Vector(      9897.365234375      ,   -2579.0871582031    ,   54.545318603516     ) , ang = Angle(    0.3802974820137     ,   -122.83186340332    ,   -0.32418823242188   )},
	{model = 'models/blackjack/nutcracker.mdl'   ,pos = Vector(      9854.3671875        ,   -2578.4475097656    ,   54.545310974121     ) , ang = Angle(    0.3802974820137     ,   -95.969818115234    ,   -0.32418823242188   )},
	{model = 'models/blackjack/nutcracker.mdl'   ,pos = Vector(      9741.2841796875     ,   -2580.5808105469    ,   54.545310974121     ) , ang = Angle(    0.3802974820137     ,   -91.54768371582     ,   -0.32418823242188   )},
	{model = 'models/blackjack/nutcracker.mdl'   ,pos = Vector(      9774.951171875      ,   -2578.8986816406    ,   54.545310974121     ) , ang = Angle(    0.38029742240906    ,   -111.41371154785    ,   -0.32418823242188   )},
	{model = 'models/blackjack/nutcracker.mdl'   ,pos = Vector(      9328.3916015625     ,   -3265.4963378906    ,   54.545310974121     ) , ang = Angle(    0.3802974820137     ,   0.32425621151924    ,   -0.32418823242188   )},
	{model = 'models/blackjack/birds_01.mdl'     ,pos = Vector(      7217.091796875      ,   -3270.8032226562    ,   26.364858627319     ) , ang = Angle(    -0.15456448495388   ,   -20.492481231689    ,   -0.068634033203125  )},
	{model = 'models/blackjack/birds_01.mdl'     ,pos = Vector(      7279.2421875        ,   -2788.0073242188    ,   26.364866256714     ) , ang = Angle(    -0.15456448495388   ,   -87.878646850586    ,   -0.068634033203125  )},
	{model = 'models/blackjack/birds_01.mdl'     ,pos = Vector(      6941.4995117188     ,   -1935.4356689453    ,   26.364858627319     ) , ang = Angle(    -0.15456448495388   ,   -158.43252563477    ,   -0.068634033203125  )},
	{model = 'models/blackjack/birds_01.mdl'     ,pos = Vector(      7158.8891601562     ,   -2291.1821289062    ,   26.364862442017     ) , ang = Angle(    -0.15456448495388   ,   148.23951721191     ,   -0.068634033203125  )},
	{model = 'models/blackjack/birds_01.mdl'     ,pos = Vector(      7576.3857421875     ,   -2081.7297363281    ,   26.364858627319     ) , ang = Angle(    -0.15456448495388   ,   -134.21043395996    ,   -0.068634033203125  )},
	{model = 'models/blackjack/birds_01.mdl'     ,pos = Vector(      8292.4951171875     ,   -2319.8298339844    ,   26.364858627319     ) , ang = Angle(    -0.15456448495388   ,   137.41548156738     ,   -0.068634033203125  )},
	{model = 'models/blackjack/birds_01.mdl'     ,pos = Vector(      8385.19921875       ,   -2911.162109375     ,   26.364862442017     ) , ang = Angle(    -0.15456448495388   ,   91.149345397949     ,   -0.068634033203125  )},
	{model = 'models/blackjack/birds_01.mdl'     ,pos = Vector(      8030.51171875       ,   -2957.0461425781    ,   26.364866256714     ) , ang = Angle(    -0.15456448495388   ,   49.899269104004     ,   -0.068634033203125  )},
	{model = 'models/blackjack/birds_01.mdl'     ,pos = Vector(      8881.552734375      ,   -3649.1179199219    ,   26.364858627319     ) , ang = Angle(    -0.15456448495388   ,   141.90338134766     ,   -0.068634033203125  )},
	{model = 'models/blackjack/birds_01.mdl'     ,pos = Vector(      8944.177734375      ,   -3583.4343261719    ,   26.364858627319     ) , ang = Angle(    -0.15456448495388   ,   136.22738647461     ,   -0.068634033203125  )},
	{model = 'models/blackjack/birds_01.mdl'     ,pos = Vector(      8098.4252929688     ,   -3683.5261230469    ,   26.364858627319     ) , ang = Angle(    -0.15456447005272   ,   14.259209632874     ,   -0.068634033203125  )},
	{model = 'models/blackjack/birds_01.mdl'     ,pos = Vector(      8543.8916015625     ,   -4072.6828613281    ,   26.364858627319     ) , ang = Angle(    -0.15456448495388   ,   -177.44068908691    ,   -0.068634033203125  )},
	{model = 'models/blackjack/birds_01.mdl'     ,pos = Vector(      9256.05078125       ,   -4346.6547851562    ,   -101.63491821289    ) , ang = Angle(    -0.15456447005272   ,   164.80534362793     ,   -0.068634033203125  )},
	{model = 'models/blackjack/birds_01.mdl'     ,pos = Vector(      10167.947265625     ,   -4410.6206054688    ,   -65.13493347168     ) , ang = Angle(    -0.15456448495388   ,   95.505516052246     ,   -0.068634033203125  )},
	{model = 'models/blackjack/birds_01.mdl'     ,pos = Vector(      10183.571289062     ,   -3361.7189941406    ,   26.364858627319     ) , ang = Angle(    -0.15456448495388   ,   -154.8684387207     ,   -0.068634033203125  )},
	{model = 'models/blackjack/birds_01.mdl'     ,pos = Vector(      10325.51171875      ,   -2825.0573730469    ,   27.364858627319     ) , ang = Angle(    -0.15456448495388   ,   -144.1463470459     ,   -0.068634033203125  )},
	{model = 'models/blackjack/birds_01.mdl'     ,pos = Vector(      9320.3935546875     ,   -2084.4978027344    ,   26.364858627319     ) , ang = Angle(    -0.15456448495388   ,   -42.770175933838    ,   -0.068634033203125  )},
	{model = 'models/blackjack/birds_01.mdl'     ,pos = Vector(      8618.958984375      ,   -2268.9284667969    ,   26.364858627319     ) , ang = Angle(    -0.15456448495388   ,   92.463905334473     ,   -0.068634033203125  )},
	{model = 'models/blackjack/birds_01.mdl'     ,pos = Vector(      7287.7934570312     ,   -2149.0646972656    ,   26.364858627319     ) , ang = Angle(    -0.15456448495388   ,   -88.178314208984    ,   -0.068634033203125  )},
	{model = 'models/blackjack/birds_01.mdl'     ,pos = Vector(      6278.2661132812     ,   -1765.8154296875    ,   26.364858627319     ) , ang = Angle(    -0.15456448495388   ,   -39.074478149414    ,   -0.068634033203125  )},
	{model = 'models/blackjack/snowman_globe.mdl'        ,pos = Vector(      8571.2685546875     ,   -3256.7663574219    ,   54.604553222656     ) , ang = Angle(    -0.0020189075730741 ,   -133.58836364746    ,   -0.08544921875      )},
	{model = 'models/blackjack/snowman_globe.mdl'        ,pos = Vector(      7663.0073242188     ,   -4341.1401367188    ,   55.285049438477     ) , ang = Angle(    -0.002018908271566  ,   81.73388671875      ,   -0.08544921875      )},
	{model = 'models/blackjack/snowman_globe.mdl'        ,pos = Vector(      7823.33984375       ,   -3844.7214355469    ,   55.288967132568     ) , ang = Angle(    -0.002018908271566  ,   -149.00219726562    ,   -0.08544921875      )},
	{model = 'models/blackjack/snowman_globe.mdl'        ,pos = Vector(      5747.8544921875     ,   -2769.9887695312    ,   56.104553222656     ) , ang = Angle(    -0.0020189087372273 ,   25.369674682617     ,   -0.08544921875      )},
	{model = 'models/blackjack/snowman_globe.mdl'        ,pos = Vector(      6123.8935546875     ,   -2595.6020507812    ,   55.174606323242     ) , ang = Angle(    -0.0020189094357193 ,   85.795745849609     ,   -0.08544921875      )},
	{model = 'models/blackjack/snowman_globe.mdl'        ,pos = Vector(      6044.6318359375     ,   -2458.5622558594    ,   54.759021759033     ) , ang = Angle(    -0.002018908271566  ,   -2.710440158844     ,   -0.08544921875      )},
	{model = 'models/blackjack/snowman_globe.mdl'        ,pos = Vector(      6472.080078125      ,   -1957.3962402344    ,   54.689308166504     ) , ang = Angle(    -0.002018908271566  ,   -167.71044921875    ,   -0.08544921875      )},
	{model = 'models/blackjack/snowman_globe.mdl'        ,pos = Vector(      5677.0825195312     ,   -1640.3695068359    ,   54.340984344482     ) , ang = Angle(    -0.0020189073402435 ,   -141.21461486816    ,   -0.08544921875      )},
	{model = 'models/blackjack/dog.mdl' ,pos = Vector(      8491.62890625       ,   -6358.1875  ,   250.71678161621     ) , ang = Angle(    0.11178168654442    ,   -153.1117401123     ,   -0.029449462890625  )},
	{model = 'models/blackjack/dog.mdl' ,pos = Vector(      8942.25     ,   -4665.7963867188    ,   26.716547012329     ) , ang = Angle(    0.111781693995      ,   -154.95965576172    ,   -0.029449462890625  )},
	{model = 'models/blackjack/dog.mdl' ,pos = Vector(      9457.056640625      ,   -3779.9973144531    ,   26.716547012329     ) , ang = Angle(    0.11178168654442    ,   75.350296020508     ,   -0.029449462890625  )},
	{model = 'models/blackjack/dog.mdl' ,pos = Vector(      9424.5400390625     ,   -3357.5341796875    ,   61.813167572021     ) , ang = Angle(    0.11178168654442    ,   40.070243835449     ,   -0.029449462890625  )},
	{model = 'models/blackjack/dog.mdl' ,pos = Vector(      10038.42578125      ,   -2384.0734863281    ,   26.716541290283     ) , ang = Angle(    0.111781693995      ,   -78.171714782715    ,   -0.029449462890625  )},
	{model = 'models/blackjack/dog.mdl' ,pos = Vector(      9500.6416015625     ,   -1633.3531494141    ,   26.716541290283     ) , ang = Angle(    0.111781693995      ,   -55.269172668457    ,   -0.029449462890625  )},
	{model = 'models/blackjack/dog.mdl' ,pos = Vector(      9050.9931640625     ,   -1374.1010742188    ,   18.674186706543     ) , ang = Angle(    0.111781693995      ,   169.76075744629     ,   -0.029449462890625  )},
	{model = 'models/blackjack/dog.mdl' ,pos = Vector(      7177.5302734375     ,   -1299.2344970703    ,   62.716541290283     ) , ang = Angle(    0.111781693995      ,   -141.6272277832     ,   -0.029449462890625  )},
	{model = 'models/blackjack/dog.mdl' ,pos = Vector(      7860.1845703125     ,   -1667.2150878906    ,   62.716541290283     ) , ang = Angle(    0.11178168654442    ,   -53.64905166626     ,   -0.029449462890625  )},
	{model = 'models/blackjack/dog.mdl' ,pos = Vector(      7487.44140625       ,   -2558.423828125     ,   44.040271759033     ) , ang = Angle(    0.11178168654442    ,   174.05709838867     ,   -0.029449462890625  )},
	{model = 'models/blackjack/dog.mdl' ,pos = Vector(      7980.4340820312     ,   -2773.5695800781    ,   26.716541290283     ) , ang = Angle(    0.111781693995      ,   -63.644821166992    ,   -0.029449462890625  )},
	{model = 'models/blackjack/dog.mdl' ,pos = Vector(      6263.8354492188     ,   -2051.7375488281    ,   26.716541290283     ) , ang = Angle(    0.111781693995      ,   25.917381286621     ,   -0.029449462890625  )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      6127.09765625       ,   -6754.4125976562    ,   166.24322509766     ) , ang = Angle(    0.22741132974625    ,   -28.623733520508    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      8236.578125 ,   -723.78631591797    ,   1.0683975219727     ) , ang = Angle(    0.22741134464741    ,   -138.54962158203    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      7195.953125 ,   -725.32989501953    ,   1.0683975219727     ) , ang = Angle(    0.22741132974625    ,   -19.419469833374    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      6817.7421875        ,   -1095.3676757812    ,   1.0683975219727     ) , ang = Angle(    0.22741132974625    ,   53.24662399292      ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      6670.4697265625     ,   -1310.3714599609    ,   2.3681945800781     ) , ang = Angle(    0.22741134464741    ,   4.802770614624      ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      6934.314453125      ,   -117.89385986328    ,   1.0683975219727     ) , ang = Angle(    0.22741132974625    ,   -112.14928436279    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      6549.861328125      ,   -263.88772583008    ,   1.0683975219727     ) , ang = Angle(    0.22741134464741    ,   104.33097076416     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      5991.0610351562     ,   -267.31436157227    ,   1.0683937072754     ) , ang = Angle(    0.22741132974625    ,   38.726997375488     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      5757.990234375      ,   -111.61800384521    ,   1.0683975219727     ) , ang = Angle(    0.22741132974625    ,   -40.14302444458     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      5366.0615234375     ,   -476.8932800293     ,   1.0683975219727     ) , ang = Angle(    0.22741132974625    ,   58.526985168457     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      5347.3046875        ,   -957.36047363281    ,   1.0683975219727     ) , ang = Angle(    0.22741132974625    ,   5.1997127532959     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      5177.5336914062     ,   549.93670654297     ,   1.0683975219727     ) , ang = Angle(    0.22741132974625    ,   -58.886459350586    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      5425.1069335938     ,   1204.8923339844     ,   -454.93154907227    ) , ang = Angle(    0.22741132974625    ,   -75.944358825684    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      5460.197265625      ,   1205.7786865234     ,   -458.60202026367    ) , ang = Angle(    0.22741134464741    ,   -94.028450012207    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      4511.9614257812     ,   -122.49771881104    ,   1.0683975219727     ) , ang = Angle(    0.22741132974625    ,   -56.840484619141    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      4079.6169433594     ,   -457.75970458984    ,   1.0683975219727     ) , ang = Angle(    0.22741132974625    ,   42.357776641846     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      4263.3540039062     ,   577.06561279297     ,   1.0683975219727     ) , ang = Angle(    0.22741134464741    ,   -133.13650512695    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      4478.69140625       ,   509.95965576172     ,   1.0683975219727     ) , ang = Angle(    0.22741132974625    ,   -123.23645782471    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      3865.5307617188     ,   1166.9060058594     ,   1.0683975219727     ) , ang = Angle(    0.22741134464741    ,   -26.414211273193    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      3403.1857910156     ,   1279.4633789062     ,   1.0683975219727     ) , ang = Angle(    0.22741134464741    ,   -33.872219085693    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      2797.3208007812     ,   1029.2122802734     ,   1.0683898925781     ) , ang = Angle(    0.22741132974625    ,   46.977855682373     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      2413.2006835938     ,   1287.8684082031     ,   1.0683975219727     ) , ang = Angle(    0.22741132974625    ,   -34.136352539062    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      2958.9833984375     ,   1158.8187255859     ,   1.0683898925781     ) , ang = Angle(    0.22741132974625    ,   -125.34838867188    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      2799.9584960938     ,   1810.6171875        ,   1.0683975219727     ) , ang = Angle(    0.22741132974625    ,   -38.756214141846    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      2772.3977050781     ,   2454.9311523438     ,   1.0683975219727     ) , ang = Angle(    0.22741132974625    ,   -41.066177368164    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      3375.4184570312     ,   2205.8781738281     ,   1.0683937072754     ) , ang = Angle(    0.22741134464741    ,   37.509811401367     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      4263.9609375        ,   2291.9501953125     ,   1.0683975219727     ) , ang = Angle(    0.22741132974625    ,   146.60784912109     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      4439.0078125        ,   2459.0158691406     ,   1.0683975219727     ) , ang = Angle(    0.22741134464741    ,   -146.60011291504    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      4449.86328125       ,   2414.6628417969     ,   1.0683975219727     ) , ang = Angle(    0.22741134464741    ,   -169.30409240723    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      4443.6669921875     ,   2370.6960449219     ,   1.0683975219727     ) , ang = Angle(    0.22741132974625    ,   168.12385559082     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      4446.7470703125     ,   2320.9204101562     ,   1.0683937072754     ) , ang = Angle(    0.22741132974625    ,   -175.24412536621    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      4439.6923828125     ,   2277.6499023438     ,   1.0683975219727     ) , ang = Angle(    0.22741132974625    ,   160.13789367676     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      4366.3168945312     ,   2460.765625 ,   1.0683975219727     ) , ang = Angle(    0.22741132974625    ,   -91.357986450195    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      4376.53515625       ,   2274.7819824219     ,   1.0683975219727     ) , ang = Angle(    0.22741134464741    ,   103.64196777344     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      4236.5869140625     ,   2654.8344726562     ,   1.0683975219727     ) , ang = Angle(    0.22741132974625    ,   -132.27780151367    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      3267.7573242188     ,   3151.6325683594     ,   -90.22745513916     ) , ang = Angle(    0.22741132974625    ,   -17.371465682983    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      3819.3715820312     ,   3236.4821777344     ,   1.0683975219727     ) , ang = Angle(    0.22741132974625    ,   -81.919189453125    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      4083.9338378906     ,   3467.1320800781     ,   1.0683975219727     ) , ang = Angle(    0.22741134464741    ,   -16.513252258301    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      4578.6196289062     ,   3714.0424804688     ,   1.0683975219727     ) , ang = Angle(    0.22741132974625    ,   -103.03910064697    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      4649.3813476562     ,   3799.1823730469     ,   1.0683975219727     ) , ang = Angle(    0.22741132974625    ,   -42.781070709229    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      5178.8466796875     ,   3781.24609375       ,   1.0683975219727     ) , ang = Angle(    0.22741132974625    ,   -107.79109954834    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      5561.42578125       ,   3677.2536621094     ,   1.0683975219727     ) , ang = Angle(    0.22741132974625    ,   -93.073036193848    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      6334.3408203125     ,   3608.4157714844     ,   1.0683975219727     ) , ang = Angle(    0.22741132974625    ,   -128.25112915039    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      6340.2348632812     ,   3274.5224609375     ,   1.0683975219727     ) , ang = Angle(    0.22741132974625    ,   152.15281677246     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      6352.6791992188     ,   2690.8237304688     ,   1.0683975219727     ) , ang = Angle(    0.22741134464741    ,   113.74077606201     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      6176.3447265625     ,   2948.6320800781     ,   1.0683975219727     ) , ang = Angle(    0.22741132974625    ,   4.3126363754272     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      6788.0405273438     ,   2917.0695800781     ,   1.0683975219727     ) , ang = Angle(    0.22741132974625    ,   145.28869628906     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      7210.6142578125     ,   3250.2199707031     ,   1.0683975219727     ) , ang = Angle(    0.22741132974625    ,   -117.03120422363    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      7130.7353515625     ,   4350.009765625      ,   -218.93161010742    ) , ang = Angle(    0.22741132974625    ,   -84.295249938965    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      7008.6782226562     ,   4340.6850585938     ,   -218.93161010742    ) , ang = Angle(    0.22741132974625    ,   -66.4091796875      ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      6893.8505859375     ,   4207.1665039062     ,   -254.93159484863    ) , ang = Angle(    0.22741134464741    ,   6.9827651977539     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      6716.8608398438     ,   4447.3579101562     ,   -254.93159484863    ) , ang = Angle(    0.22741132974625    ,   -11.893117904663    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      6759.0415039062     ,   4505.6708984375     ,   -254.93159484863    ) , ang = Angle(    0.22741132974625    ,   -51.559112548828    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      6983.8193359375     ,   3487.3149414062     ,   -446.93157958984    ) , ang = Angle(    0.22741134464741    ,   64.666847229004     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      6722.1752929688     ,   2204.3869628906     ,   1.0683975219727     ) , ang = Angle(    0.22741132974625    ,   11.009188652039     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      6722.66015625       ,   2270.3276367188     ,   1.0683898925781     ) , ang = Angle(    0.22741132974625    ,   -7.140839099884     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      6581.6323242188     ,   2476.7783203125     ,   50.463310241699     ) , ang = Angle(    0.22741134464741    ,   -10.374836921692    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      6638.26953125       ,   2595.97265625       ,   1.0683975219727     ) , ang = Angle(    0.22741134464741    ,   -62.910907745361    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      6028.3276367188     ,   1580.5104980469     ,   1.0684013366699     ) , ang = Angle(    0.22741134464741    ,   123.34111785889     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      5502.3330078125     ,   1765.9525146484     ,   1.0683975219727     ) , ang = Angle(    0.22741132974625    ,   -36.379062652588    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      5599.1728515625     ,   1967.4215087891     ,   1.0683975219727     ) , ang = Angle(    0.22741132974625    ,   -31.495094299316    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      6024.2900390625     ,   1960.2247314453     ,   1.0683975219727     ) , ang = Angle(    0.22741132974625    ,   -125.54509735107    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      6362.1870117188     ,   2486.0095214844     ,   1.0683975219727     ) , ang = Angle(    0.22741132974625    ,   -144.8171081543     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      5989.5893554688     ,   2439.0349121094     ,   1.0683975219727     ) , ang = Angle(    0.22741134464741    ,   -25.159109115601    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      5401.97265625       ,   2237.4069824219     ,   1.0683975219727     ) , ang = Angle(    0.22741132974625    ,   75.689331054688     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      5514.3696289062     ,   2193.3283691406     ,   1.0683975219727     ) , ang = Angle(    0.22741134464741    ,   49.025249481201     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      5923.162109375      ,   2585.0725097656     ,   43.111190795898     ) , ang = Angle(    0.22741134464741    ,   -123.23471832275    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      5415.330078125      ,   1608.9481201172     ,   1.0683975219727     ) , ang = Angle(    0.22741132974625    ,   148.68534851074     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      4723.0551757812     ,   1448.6640625        ,   1.0683975219727     ) , ang = Angle(    0.22741134464741    ,   63.281589508057     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      4339.1884765625     ,   1625.7836914062     ,   1.0683898925781     ) , ang = Angle(    0.22741134464741    ,   91.991806030273     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      4098.5112304688     ,   1435.11328125       ,   1.0683975219727     ) , ang = Angle(    0.22741132974625    ,   48.629974365234     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      4613.6689453125     ,   -271.94741821289    ,   1.0683898925781     ) , ang = Angle(    0.22741132974625    ,   107.70001983643     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      5092.68359375       ,   -122.12934875488    ,   1.0683975219727     ) , ang = Angle(    0.22741132974625    ,   -127.4278717041     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      5518.1918945312     ,   -75.04280090332     ,   1.0684051513672     ) , ang = Angle(    0.22741132974625    ,   -134.42387390137    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      8264.0322265625     ,   3192.2280273438     ,   1.0683898925781     ) , ang = Angle(    0.22741132974625    ,   -141.48594665527    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      7599.3198242188     ,   3234.9641113281     ,   1.0684051513672     ) , ang = Angle(    0.22741134464741    ,   -68.819984436035    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      7983.5668945312     ,   2449.2692871094     ,   1.0683975219727     ) , ang = Angle(    0.22741132974625    ,   7.5779485702515     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      8585.7275390625     ,   2482.7290039062     ,   1.0683975219727     ) , ang = Angle(    0.22741132974625    ,   -83.369895935059    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      -650.40679931641    ,   -6454.5473632812    ,   -2399.931640625     ) , ang = Angle(    0.22741132974625    ,   98.658447265625     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      -361.23541259766    ,   -6457.6635742188    ,   -2399.931640625     ) , ang = Angle(    0.22741132974625    ,   97.074348449707     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      -328.70220947266    ,   -6318.0654296875    ,   -2591.931640625     ) , ang = Angle(    0.22741134464741    ,   143.99990844727     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      -320.59722900391    ,   -6073.6586914062    ,   -2591.931640625     ) , ang = Angle(    0.22741132974625    ,   -128.74794006348    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      -506.89959716797    ,   -6187.8212890625    ,   -2431.931640625     ) , ang = Angle(    0.22741132974625    ,   -174.74998474121    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      -368.62506103516    ,   -6184.6352539062    ,   -2431.931640625     ) , ang = Angle(    0.22741132974625    ,   8.0397901535034     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      -706.75036621094    ,   -5960.6352539062    ,   -2399.931640625     ) , ang = Angle(    0.22741132974625    ,   -21.528165817261    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      1635.6652832031     ,   -4802.2641601562    ,   -1247.931640625     ) , ang = Angle(    0.22741134464741    ,   -175.34417724609    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      142.51443481445     ,   -4117.380859375     ,   -1247.931640625     ) , ang = Angle(    0.22741134464741    ,   81.990211486816     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      364.71697998047     ,   -4318.8002929688    ,   -1247.931640625     ) , ang = Angle(    0.22741132974625    ,   131.02821350098     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      535.01715087891     ,   -5569.994140625     ,   -1247.931640625     ) , ang = Angle(    0.22741132974625    ,   139.80613708496     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      -48.525756835938    ,   -5577.6733398438    ,   -1247.931640625     ) , ang = Angle(    0.22741132974625    ,   49.056018829346     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      407.23687744141     ,   -5351.8823242188    ,   -1247.931640625     ) , ang = Angle(    0.22741132974625    ,   145.68019104004     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      -753.37829589844    ,   -5412.6181640625    ,   -1247.931640625     ) , ang = Angle(    0.22741132974625    ,   7.0444421768188     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      -705.80908203125    ,   -5728.4384765625    ,   -1247.931640625     ) , ang = Angle(    0.22741134464741    ,   59.844665527344     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      -701.16455078125    ,   -4564.125   ,   -1247.931640625     ) , ang = Angle(    0.22741134464741    ,   -37.439434051514    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      542.55755615234     ,   -4031.3442382812    ,   -1247.931640625     ) , ang = Angle(    0.22741132974625    ,   -149.44148254395    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      1640.9842529297     ,   -3731.7014160156    ,   -1247.931640625     ) , ang = Angle(    0.22741134464741    ,   -147.19749450684    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      1625.6076660156     ,   -4408.3203125       ,   -1247.931640625     ) , ang = Angle(    0.22741132974625    ,   -173.39947509766    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      4092.9223632812     ,   -2327.7351074219    ,   1.0683898925781     ) , ang = Angle(    0.22741134464741    ,   53.08251953125      ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      4481.4213867188     ,   -2455.1789550781    ,   1.0683898925781     ) , ang = Angle(    0.22741134464741    ,   84.366516113281     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      4098.4638671875     ,   -1340.8920898438    ,   1.0683975219727     ) , ang = Angle(    0.22741132974625    ,   -36.911365509033    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      4218.6665039062     ,   -522.109375 ,   1.0683975219727     ) , ang = Angle(    0.22741132974625    ,   -104.69348144531    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      4059.1142578125     ,   -91.945678710938    ,   1.0683898925781     ) , ang = Angle(    0.22741132974625    ,   -48.989398956299    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      3668.6315917969     ,   413.96310424805     ,   1.0683975219727     ) , ang = Angle(    0.22741132974625    ,   -176.73545837402    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      3665.6252441406     ,   475.03457641602     ,   1.0683975219727     ) , ang = Angle(    0.22741132974625    ,   -168.8814239502     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      2284.7026367188     ,   1256.6678466797     ,   1.0684051513672     ) , ang = Angle(    0.22741132974625    ,   6.0846333503723     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      1375.1005859375     ,   2070.9150390625     ,   1.0684051513672     ) , ang = Angle(    0.22741134464741    ,   96.966705322266     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      1523.3870849609     ,   2144.0534667969     ,   1.0683975219727     ) , ang = Angle(    0.22741134464741    ,   45.685028076172     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      1311.1296386719     ,   2426.5393066406     ,   1.0683898925781     ) , ang = Angle(    0.22741132974625    ,   -45.065238952637    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      1176.7775878906     ,   1947.2912597656     ,   1.0683975219727     ) , ang = Angle(    0.22741132974625    ,   42.120704650879     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      2161.6306152344     ,   1553.3336181641     ,   1.0684051513672     ) , ang = Angle(    0.22741134464741    ,   96.04271697998      ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      2039.7564697266     ,   1552.2797851562     ,   1.0683898925781     ) , ang = Angle(    0.22741134464741    ,   95.316688537598     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      1952.8188476562     ,   2023.4530029297     ,   1.0683975219727     ) , ang = Angle(    0.22741134464741    ,   -50.645286560059    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      4571.013671875      ,   2105.3996582031     ,   1.0683975219727     ) , ang = Angle(    0.22741132974625    ,   -120.8692855835     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      5772.94921875       ,   960.64569091797     ,   1.0683975219727     ) , ang = Angle(    0.22741134464741    ,   5.8209056854248     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      5773.7680664062     ,   1057.3176269531     ,   1.0684051513672     ) , ang = Angle(    0.22741132974625    ,   11.892932891846     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      6158.52734375       ,   922.84307861328     ,   1.0683975219727     ) , ang = Angle(    0.22741132974625    ,   129.17498779297     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      4520.525390625      ,   2911.4729003906     ,   -16.450565338135    ) , ang = Angle(    0.22741134464741    ,   7.1409387588501     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      4524.65234375       ,   3076.349609375      ,   -14.931606292725    ) , ang = Angle(    0.22741132974625    ,   7.8670010566711     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      4520.8852539062     ,   3232.6684570312     ,   -17.127941131592    ) , ang = Angle(    0.22741132974625    ,   11.695008277893     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      6342.6435546875     ,   2018.6080322266     ,   1.0684051513672     ) , ang = Angle(    0.22741132974625    ,   -124.23496246338    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      6345.5561523438     ,   153.32192993164     ,   1.0683975219727     ) , ang = Angle(    0.22741132974625    ,   141.34921264648     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      8066.6118164062     ,   -259.62957763672    ,   1.0683975219727     ) , ang = Angle(    0.22741132974625    ,   -46.024608612061    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      7600.3696289062     ,   -465.54470825195    ,   1.0683975219727     ) , ang = Angle(    0.22741134464741    ,   -170.86651611328    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      7602.5908203125     ,   -573.10095214844    ,   1.0683975219727     ) , ang = Angle(    0.22741134464741    ,   -175.2225189209     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      7480.3876953125     ,   -121.0630569458     ,   34.990898132324     ) , ang = Angle(    0.22741134464741    ,   -85.462333679199    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      9341.6767578125     ,   -429.03799438477    ,   3.0683975219727     ) , ang = Angle(    0.22741134464741    ,   164.91152954102     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      9462.4208984375     ,   -255.05331420898    ,   2.3681945800781     ) , ang = Angle(    0.22741132974625    ,   -54.244441986084    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      9808.3974609375     ,   -251.75094604492    ,   2.3681869506836     ) , ang = Angle(    0.22741134464741    ,   -105.13042449951    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      6670.2036132812     ,   874.732421875       ,   1.0683975219727     ) , ang = Angle(    0.22741132974625    ,   -32.728404998779    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      7034.7392578125     ,   992.2314453125      ,   1.0683975219727     ) , ang = Angle(    0.22741132974625    ,   -100.31237030029    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      7726.9350585938     ,   1016.8826293945     ,   1.0683937072754     ) , ang = Angle(    0.22741134464741    ,   -132.32238769531    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      7431.9692382812     ,   849.34515380859     ,   1.0683975219727     ) , ang = Angle(    0.22741132974625    ,   -43.552410125732    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      4235.4970703125     ,   691.42987060547     ,   1948.037109375      ) , ang = Angle(    0.22741132974625    ,   -130.0484161377     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      456.15380859375     ,   1451.80859375       ,   1.0683975219727     ) , ang = Angle(    0.22741132974625    ,   62.239440917969     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      253.51013183594     ,   1483.4445800781     ,   1.0683975219727     ) , ang = Angle(    0.22741132974625    ,   143.02346801758     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      289.43606567383     ,   2014.1774902344     ,   1.0683975219727     ) , ang = Angle(    0.22741134464741    ,   -49.732471466064    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      -70.650604248047    ,   2665.7263183594     ,   1.0683975219727     ) , ang = Angle(    0.22741132974625    ,   -44.056457519531    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      87.364852905273     ,   2823.8803710938     ,   1.0683975219727     ) , ang = Angle(    0.22741134464741    ,   42.27180480957      ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      -73.604293823242    ,   3256.6379394531     ,   -86.623588562012    ) , ang = Angle(    0.22741132974625    ,   26.101747512817     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      472.93902587891     ,   3140.0451660156     ,   -126.93159484863    ) , ang = Angle(    0.22741132974625    ,   152.49174499512     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      293.37783813477     ,   4964.0288085938     ,   1.0683975219727     ) , ang = Angle(    0.22741134464741    ,   8.7077302932739     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      -871.74145507812    ,   4484.314453125      ,   -62.931602478027    ) , ang = Angle(    0.22741132974625    ,   -16.570226669312    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      -999.72058105469    ,   4567.689453125      ,   1.0683975219727     ) , ang = Angle(    0.22741132974625    ,   -22.576299667358    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      -538.03857421875    ,   3561.6103515625     ,   1.0683975219727     ) , ang = Angle(    0.22741132974625    ,   52.66353225708      ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      -1346.4241943359    ,   3949.7644042969     ,   -62.931594848633    ) , ang = Angle(    0.22741132974625    ,   -44.950496673584    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      -1823.0589599609    ,   4173.638671875      ,   1.0683975219727     ) , ang = Angle(    0.22741132974625    ,   -37.426502227783    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      -1890.6845703125    ,   4466.8413085938     ,   1.0683975219727     ) , ang = Angle(    0.22741132974625    ,   61.441661834717     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      -1364.0007324219    ,   5214.9799804688     ,   1.0683975219727     ) , ang = Angle(    0.22741132974625    ,   147.67353820801     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      -1330.6389160156    ,   5875.2690429688     ,   129.06838989258     ) , ang = Angle(    0.22741132974625    ,   152.35960388184     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      -1035.7221679688    ,   5516.552734375      ,   1.0684051513672     ) , ang = Angle(    0.22741132974625    ,   155.85760498047     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      -919.97888183594    ,   6611.1997070312     ,   1.0683975219727     ) , ang = Angle(    0.22741132974625    ,   -128.37448120117    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      -977.24816894531    ,   6618.2563476562     ,   1.0684051513672     ) , ang = Angle(    0.22741132974625    ,   -83.560478210449    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      -915.17065429688    ,   6548.638671875      ,   1.0684051513672     ) , ang = Angle(    0.22741134464741    ,   -171.27449035645    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      -1227.0550537109    ,   7161.8627929688     ,   1.0683975219727     ) , ang = Angle(    0.22741132974625    ,   -39.340473175049    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      -913.39538574219    ,   7158.7084960938     ,   1.0683975219727     ) , ang = Angle(    0.22741132974625    ,   -121.97245788574    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      -1484.04296875      ,   7155.5224609375     ,   1.0683975219727     ) , ang = Angle(    0.22741132974625    ,   -39.040603637695    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      -1774.7069091797    ,   6348.0727539062     ,   129.06838989258     ) , ang = Angle(    0.22741132974625    ,   170.90545654297     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      -1787.2972412109    ,   6518.5415039062     ,   129.06838989258     ) , ang = Angle(    0.22741132974625    ,   -147.11853027344    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      -2080.9279785156    ,   5989.603515625      ,   129.06838989258     ) , ang = Angle(    0.22741132974625    ,   40.981582641602     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      -2476.8237304688    ,   5837.1953125        ,   1.0683975219727     ) , ang = Angle(    0.22741134464741    ,   -45.544410705566    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      -2515.7478027344    ,   4766.3706054688     ,   1.0683937072754     ) , ang = Angle(    0.22741134464741    ,   152.1257019043      ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      -2658.2670898438    ,   4772.1752929688     ,   1.0683975219727     ) , ang = Angle(    0.22741132974625    ,   24.745681762695     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      -2860.375   ,   4476.595703125      ,   1.0683975219727     ) , ang = Angle(    0.22741132974625    ,   134.43769836426     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      -3053.9143066406    ,   3975.9243164062     ,   -1997.931640625     ) , ang = Angle(    0.22741132974625    ,   49.759510040283     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      -4983.1059570312    ,   4480.7456054688     ,   -1998.9315185547    ) , ang = Angle(    0.22741132974625    ,   -40.264450073242    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      -4620.1977539062    ,   4490.4213867188     ,   -1998.9315185547    ) , ang = Angle(    0.22741134464741    ,   -86.728477478027    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      -5321.8393554688    ,   4474.298828125      ,   -1998.9315185547    ) , ang = Angle(    0.22741132974625    ,   -84.418518066406    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      -3293.9748535156    ,   3882.0874023438     ,   90.706527709961     ) , ang = Angle(    0.22741134464741    ,   -124.97872924805    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      -3194.1882324219    ,   4113.2221679688     ,   1.0683975219727     ) , ang = Angle(    0.22741132974625    ,   -162.7307434082     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      -3198.7492675781    ,   3940.0573730469     ,   1.0683975219727     ) , ang = Angle(    0.22741134464741    ,   165.39120483398     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      -2813.7319335938    ,   3690.8332519531     ,   1.0683975219727     ) , ang = Angle(    0.22741132974625    ,   -94.948684692383    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      -3571.7875976562    ,   3353.7573242188     ,   1.0683898925781     ) , ang = Angle(    0.22741132974625    ,   96.913459777832     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      -3077.1203613281    ,   3356.7395019531     ,   1.0683975219727     ) , ang = Angle(    0.22741134464741    ,   97.30931854248      ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      -1476.9875488281    ,   3528.0573730469     ,   1.0683975219727     ) , ang = Angle(    0.22741132974625    ,   -120.06466674805    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      -2011.3780517578    ,   3735.111328125      ,   1.0683975219727     ) , ang = Angle(    0.22741132974625    ,   -39.874652862549    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      -2112.9619140625    ,   4440.0297851562     ,   1.0683975219727     ) , ang = Angle(    0.22741132974625    ,   125.19123840332     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      -1324.7218017578    ,   2478.7834472656     ,   1.0683975219727     ) , ang = Angle(    0.22741132974625    ,   70.7412109375       ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      -826.11737060547    ,   2486.2875976562     ,   1.0684013366699     ) , ang = Angle(    0.22741132974625    ,   162.15124511719     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      -1884.4586181641    ,   3180.5207519531     ,   1.0683975219727     ) , ang = Angle(    0.22741132974625    ,   -21.364582061768    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      -2438.9150390625    ,   2264.1215820312     ,   1.0683975219727     ) , ang = Angle(    0.22741132974625    ,   43.117485046387     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      -2671.6572265625    ,   1528.7947998047     ,   1.0683975219727     ) , ang = Angle(    0.22741132974625    ,   62.653293609619     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      -1458.2224121094    ,   1433.6827392578     ,   -62.931602478027    ) , ang = Angle(    0.22741134464741    ,   165.28329467773     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      -1388.5264892578    ,   1466.4881591797     ,   1.0684051513672     ) , ang = Angle(    0.22741134464741    ,   59.353130340576     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      -171.08532714844    ,   1478.9868164062     ,   1.0683975219727     ) , ang = Angle(    0.22741132974625    ,   141.32516479492     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      995.72589111328     ,   3089.7150878906     ,   1.0683975219727     ) , ang = Angle(    0.22741132974625    ,   -125.41683197021    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      1504.6789550781     ,   2919.0861816406     ,   65.068397521973     ) , ang = Angle(    0.22741134464741    ,   172.67515563965     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      743.29449462891     ,   3739.4279785156     ,   1.0683975219727     ) , ang = Angle(    0.22741132974625    ,   -28.990821838379    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      888.13201904297     ,   4466.1240234375     ,   1.0683975219727     ) , ang = Angle(    0.22741134464741    ,   -130.43301391602    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      1708.4283447266     ,   4007.4477539062     ,   1.0683975219727     ) , ang = Angle(    0.22741132974625    ,   -83.176933288574    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      1389.3981933594     ,   4000.0668945312     ,   1.0683975219727     ) , ang = Angle(    0.22741134464741    ,   -84.365135192871    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      1800.1677246094     ,   3507.7224121094     ,   1.0683975219727     ) , ang = Angle(    0.22741134464741    ,   116.70707702637     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      2257.1870117188     ,   3908.0139160156     ,   1.0683937072754     ) , ang = Angle(    0.22741132974625    ,   -71.692832946777    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      -731.83203125       ,   4944.6123046875     ,   113.04840087891     ) , ang = Angle(    0.22741132974625    ,   -48.262836456299    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      -380.60510253906    ,   4710.4545898438     ,   113.04840087891     ) , ang = Angle(    0.22741132974625    ,   145.81311035156     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      -652.048828125      ,   5744.4907226562     ,   113.04842376709     ) , ang = Angle(    0.22741134464741    ,   -11.632699012756    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      -378.48934936523    ,   6179.8842773438     ,   113.04840087891     ) , ang = Angle(    0.22741132974625    ,   -110.76485443115    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      -68.394104003906    ,   6199.3735351562     ,   1.0444107055664     ) , ang = Angle(    0.22741134464741    ,   -59.086780548096    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      703.93237304688     ,   5464.8579101562     ,   1.0444107055664     ) , ang = Angle(    0.22741132974625    ,   -172.73878479004    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      1212.0654296875     ,   5089.2119140625     ,   1.0444107055664     ) , ang = Angle(    0.22741132974625    ,   169.90321350098     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      1683.646484375      ,   4715.3100585938     ,   113.04840087891     ) , ang = Angle(    0.22741132974625    ,   141.85327148438     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      1361.6127929688     ,   4714.7338867188     ,   113.04840087891     ) , ang = Angle(    0.22741132974625    ,   55.723194122314     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      1296.2231445312     ,   5965.1967773438     ,   113.04840087891     ) , ang = Angle(    0.22741132974625    ,   -17.008892059326    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      1308.2930908203     ,   6267.6845703125     ,   113.04839324951     ) , ang = Angle(    0.22741134464741    ,   47.341144561768     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      1301.7701416016     ,   6384.8842773438     ,   113.04840087891     ) , ang = Angle(    0.22741132974625    ,   -43.210956573486    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      844.73413085938     ,   5560.6987304688     ,   1.0444107055664     ) , ang = Angle(    0.22741132974625    ,   35.527084350586     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      -210.36242675781    ,   4758.4916992188     ,   214.48773193359     ) , ang = Angle(    0.22741134464741    ,   62.058815002441     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      -143.10452270508    ,   4731.2880859375     ,   214.47903442383     ) , ang = Angle(    0.22741132974625    ,   70.902862548828     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      -53.797691345215    ,   4720.376953125      ,   214.46858215332     ) , ang = Angle(    0.22741132974625    ,   102.45086669922     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      680.54663085938     ,   5003.4467773438     ,   1.0683975219727     ) , ang = Angle(    0.22741134464741    ,   -136.24096679688    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      -2888.552734375     ,   2155.3110351562     ,   257.06842041016     ) , ang = Angle(    0.22741132974625    ,   62.058902740479     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      -2501.9128417969    ,   2230.3393554688     ,   257.06842041016     ) , ang = Angle(    0.22741132974625    ,   -141.61715698242    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      -2620.8308105469    ,   1679.1713867188     ,   257.06842041016     ) , ang = Angle(    0.22741132974625    ,   139.71087646484     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      -2425.0571289062    ,   3291.4614257812     ,   1.0683898925781     ) , ang = Angle(    0.22741134464741    ,   -34.397232055664    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      -3401.8681640625    ,   2403.4406738281     ,   129.06838989258     ) , ang = Angle(    0.22741132974625    ,   -172.43916320801    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      -3580.4108886719    ,   2081.486328125      ,   1.0683975219727     ) , ang = Angle(    0.22741132974625    ,   134.62873840332     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      -3944.0107421875    ,   2091.3950195312     ,   1.0683975219727     ) , ang = Angle(    0.22741134464741    ,   -37.367206573486    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      -3752.3210449219    ,   3112.6948242188     ,   1.0683975219727     ) , ang = Angle(    0.22741132974625    ,   -37.301177978516    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      2227.048828125      ,   6364.6079101562     ,   1.0684051513672     ) , ang = Angle(    0.22741132974625    ,   -129.50317382812    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      2258.263671875      ,   6191.369140625      ,   1.0683975219727     ) , ang = Angle(    0.22741132974625    ,   139.74676513672     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      1802.1263427734     ,   6356.6284179688     ,   1.0683975219727     ) , ang = Angle(    0.22741132974625    ,   -38.91527557373     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      2382.7658691406     ,   6314.8227539062     ,   1.0683975219727     ) , ang = Angle(    0.22741134464741    ,   -79.175178527832    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      3802.0576171875     ,   5988.806640625      ,   1.0683975219727     ) , ang = Angle(    0.22741132974625    ,   -118.34907531738    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      3288.6657714844     ,   5296.8061523438     ,   1.0683975219727     ) , ang = Angle(    0.22741132974625    ,   -19.049259185791    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      3819.8823242188     ,   4469.0366210938     ,   1.0683975219727     ) , ang = Angle(    0.22741132974625    ,   -165.7371673584     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      4040.4223632812     ,   3673.6389160156     ,   1.0684051513672     ) , ang = Angle(    0.22741134464741    ,   -157.02516174316    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      4199.6879882812     ,   3945.798828125      ,   1.0683975219727     ) , ang = Angle(    0.22741132974625    ,   -120.39512634277    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'     ,pos = Vector(      4238.6513671875     ,   3569.6889648438     ,   1.0683975219727     ) , ang = Angle(    0.22741132974625    ,   143.37687683105     ,   -0.11602783203125   )},
	{model = 'models/blackjack/elves.mdl'        ,pos = Vector(      8173.2490234375     ,   -338.4548034668     ,   27.997791290283     ) , ang = Angle(    -0.13780157268047   ,   -59.385601043701    ,   -0.083770751953125  )},
	{model = 'models/blackjack/elves.mdl'        ,pos = Vector(      7888.8139648438     ,   3009.0856933594     ,   27.997798919678     ) , ang = Angle(    -0.13780157268047   ,   34.598545074463     ,   -0.083770751953125  )},
	{model = 'models/blackjack/elves.mdl'        ,pos = Vector(      5040.59765625       ,   3720.0791015625     ,   27.997798919678     ) , ang = Angle(    -0.13780157268047   ,   -3.6155893802643    ,   -0.083770751953125  )},
	{model = 'models/blackjack/elves.mdl'        ,pos = Vector(      2891.5812988281     ,   2369.5942382812     ,   27.997798919678     ) , ang = Angle(    -0.13780157268047   ,   51.392658233643     ,   -0.083770751953125  )},
	{model = 'models/blackjack/elves.mdl'        ,pos = Vector(      2536.5905761719     ,   1164.044921875      ,   27.997798919678     ) , ang = Angle(    -0.13780157268047   ,   107.22859954834     ,   -0.083770751953125  )},
	{model = 'models/blackjack/elves.mdl'        ,pos = Vector(      4165.1850585938     ,   -211.50190734863    ,   27.997806549072     ) , ang = Angle(    -0.13780157268047   ,   -173.50532531738    ,   -0.083770751953125  )},
	{model = 'models/blackjack/buche.mdl'        ,pos = Vector(      -2010.7381591797    ,   1397.8919677734     ,   -23.651786804199    ) , ang = Angle(    0.1686132401228     ,   -123.10162353516    ,   -0.05499267578125   )},
	{model = 'models/blackjack/buche.mdl'        ,pos = Vector(      -2625.3427734375    ,   1520.5802001953     ,   40.348213195801     ) , ang = Angle(    0.1686132401228     ,   -88.979850769043    ,   -0.05499267578125   )},
	{model = 'models/blackjack/buche.mdl'        ,pos = Vector(      -2284.8635253906    ,   1926.3831787109     ,   40.348213195801     ) , ang = Angle(    0.1686132401228     ,   48.168128967285     ,   -0.05499267578125   )},
	{model = 'models/blackjack/buche.mdl'        ,pos = Vector(      -2450.7709960938    ,   2466.0278320312     ,   40.348213195801     ) , ang = Angle(    0.1686132401228     ,   154.09812927246     ,   -0.05499267578125   )},
	{model = 'models/blackjack/buche.mdl'        ,pos = Vector(      -1001.4033813477    ,   4518.8530273438     ,   40.348213195801     ) , ang = Angle(    0.1686132401228     ,   172.05014038086     ,   -0.05499267578125   )},
	{model = 'models/blackjack/buche.mdl'        ,pos = Vector(      4230.4814453125     ,   3835.724609375      ,   40.348213195801     ) , ang = Angle(    0.1686132401228     ,   11.202264785767     ,   -0.05499267578125   )},
	{model = 'models/blackjack/buche.mdl'        ,pos = Vector(      6513.5263671875     ,   2285.7761230469     ,   40.348205566406     ) , ang = Angle(    0.1686132401228     ,   -49.518009185791    ,   -0.05499267578125   )},
	{model = 'models/blackjack/buche.mdl'        ,pos = Vector(      6923.6528320312     ,   2602.9448242188     ,   76.705764770508     ) , ang = Angle(    0.1686132401228     ,   86.50798034668      ,   -0.05499267578125   )},
	{model = 'models/blackjack/buche.mdl'        ,pos = Vector(      7724.3959960938     ,   559.06530761719     ,   40.348220825195     ) , ang = Angle(    0.16861322522163    ,   -45.990104675293    ,   -0.05499267578125   )},
	{model = 'models/blackjack/buche.mdl'        ,pos = Vector(      8109.7573242188     ,   1952.7065429688     ,   108.59828948975     ) , ang = Angle(    0.1686132401228     ,   178.21203613281     ,   -0.05499267578125   )},
	{model = 'models/blackjack/buche.mdl'        ,pos = Vector(      1839.6724853516     ,   3577.6376953125     ,   -215.6517791748     ) , ang = Angle(    0.16861322522163    ,   143.72406005859     ,   -0.05499267578125   )},
	{model = 'models/blackjack/buche.mdl'        ,pos = Vector(      428.08291625977     ,   3538.0341796875     ,   -87.65177154541     ) , ang = Angle(    0.16861322522163    ,   55.776260375977     ,   -0.05499267578125   )},
	{model = 'models/zerochain/props_christmas/zpn_tree.mdl'    , pos = Vector(      513.56707763672     ,   4782.9619140625     ,   0.40574851632118    ) , ang = Angle(    0.0090446099638939  ,   -142.7014465332     ,   0.0052642822265625  )},
	{model = 'models/zerochain/props_christmas/zpn_tree_large.mdl'      , pos = Vector(      1014.3101806641     ,   -69.348411560059    ,   1946.4010009766     ) , ang = Angle(    2.6569414330879e-06 ,   -1.06525349617      ,   0.0050811767578125  )},
	{model = 'models/zerochain/props_christmas/zpn_tree.mdl'   ,  pos = Vector(      7086.9794921875     ,   -71.8720703125      ,   1418.3298339844     ) , ang = Angle(    0.015152879059315   ,   176.97241210938     ,   0.008758544921875   )},
	{model = 'models/zerochain/props_christmas/zpn_tree_large.mdl'     ,  pos = Vector(      -2853.3940429688    ,   -4693.623046875     ,   1946.3297119141     ) , ang = Angle(    0.0075657214038074  ,   23.588363647461     ,   0.0043792724609375  )},
	{model = 'models/zerochain/props_christmas/zpn_tree_small.mdl'     ,  pos = Vector(      -2130.7983398438    ,   -7576.5883789062    ,   1626.3494873047     ) , ang = Angle(    -0.028918756172061  ,   135.26029968262     ,   -0.0167236328125    )},
	{model = 'models/zerochain/props_christmas/zpn_tree_large.mdl'     ,  pos = Vector(      3749.3852539062     ,   -1102.0506591797    ,   1946.4713134766     ) , ang = Angle(    -0.080833829939365  ,   172.43975830078     ,   -0.13995361328125   )},
	{model = 'models/zerochain/props_christmas/zpn_tree_large.mdl'     ,  pos = Vector(      -9757.3857421875    ,   -3382.7919921875    ,   3012.400390625      ) , ang = Angle(    -0.011980934999883  ,   48.205974578857     ,   0.007080078125      )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'    , pos = Vector(      1860.9940185547     ,   622.86883544922     ,   1950.8264160156     ) , ang = Angle(    0.22741134464741    ,   61.945579528809     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'    , pos = Vector(      360.5927734375      ,   -479.59622192383    ,   1948.037109375      ) , ang = Angle(    0.22741132974625    ,   57.655612945557     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'    , pos = Vector(      1475.603515625      ,   -1816.9704589844    ,   2389.0681152344     ) , ang = Angle(    0.22741132974625    ,   145.83160400391     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'    , pos = Vector(      1400.6995849609     ,   -692.21765136719    ,   2243.068359375      ) , ang = Angle(    0.22741134464741    ,   -114.64035797119    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'    , pos = Vector(      2041.9189453125     ,   518.93981933594     ,   1947.068359375      ) , ang = Angle(    0.22741132974625    ,   -118.66645812988    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'    , pos = Vector(      1608.6064453125     ,   797.23748779297     ,   2491.068359375      ) , ang = Angle(    0.22741132974625    ,   -34.780414581299    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'    , pos = Vector(      4460.6591796875     ,   -190.30520629883    ,   2491.068359375      ) , ang = Angle(    0.22741132974625    ,   144.31352233887     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'    , pos = Vector(      3315.7866210938     ,   -1521.0130615234    ,   1947.068359375      ) , ang = Angle(    0.22741132974625    ,   55.873405456543     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'    , pos = Vector(      4511.08984375       ,   -9681.5185546875    ,   1953.068359375      ) , ang = Angle(    0.22741134464741    ,   -118.07266998291    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'    , pos = Vector(      1788.2680664062     ,   -4973.2045898438    ,   1691.068359375      ) , ang = Angle(    0.22741132974625    ,   144.47541809082     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'    , pos = Vector(      -1150.7136230469    ,   -4655.8310546875    ,   1947.068359375      ) , ang = Angle(    0.22741134464741    ,   136.48948669434     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'    , pos = Vector(      -1140.2629394531    ,   -3881.2321777344    ,   1948.037109375      ) , ang = Angle(    0.22741132974625    ,   -127.74454498291    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'    , pos = Vector(      -2424.8393554688    ,   -3112.8627929688    ,   1947.068359375      ) , ang = Angle(    0.22741134464741    ,   -122.26641845703    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'    , pos = Vector(      -2360.9174804688    ,   -7175.7456054688    ,   1627.068359375      ) , ang = Angle(    0.22741134464741    ,   83.029411315918     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'    , pos = Vector(      -2370.0510253906    ,   -7161.1245117188    ,   1795.0682373047     ) , ang = Angle(    0.22741132974625    ,   102.69755554199     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'    , pos = Vector(      -2496.2124023438    ,   -7164.5083007812    ,   1795.0682373047     ) , ang = Angle(    0.22741132974625    ,   97.945541381836     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'    , pos = Vector(      -2318.5668945312    ,   -7166.6518554688    ,   1795.0682373047     ) , ang = Angle(    0.22741132974625    ,   116.82152557373     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'    , pos = Vector(      -2420.9921875       ,   -7167.6762695312    ,   1795.0682373047     ) , ang = Angle(    0.22741134464741    ,   64.681503295898     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'    , pos = Vector(      -2451.8732910156    ,   -7178.1079101562    ,   1795.0682373047     ) , ang = Angle(    0.22741132974625    ,   116.35941314697     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'    , pos = Vector(      -2547.2551269531    ,   -7163.6020507812    ,   1795.0682373047     ) , ang = Angle(    0.22741134464741    ,   56.299308776855     ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'    , pos = Vector(      -2533.4797363281    ,   -7164.630859375     ,   1627.068359375      ) , ang = Angle(    0.22741134464741    ,   -37.618560791016    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'    , pos = Vector(      1799.5004882812     ,   -1515.8822021484    ,   1563.068359375      ) , ang = Angle(    0.22741134464741    ,   -101.11071777344    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'    , pos = Vector(      685.39666748047     ,   -1202.3277587891    ,   1563.068359375      ) , ang = Angle(    0.22741134464741    ,   -18.016630172729    ,   -0.11602783203125   )},
	{model = 'models/unconid/xmas/snowman_u_big.mdl'    , pos = Vector(      2873.8227539062     ,   -230.0397644043     ,   1755.068359375      ) , ang = Angle(    0.22741132974625    ,   -32.602275848389    ,   -0.11602783203125   )},

}

function SpawnNYprops()
	for i = 1, #ny do
		local data = ny[i]
		local prop = ents.Create("prop_dynamic")
		prop:SetModel(data.model)
		prop:SetMoveType( MOVETYPE_NONE )
		prop:SetSolid( SOLID_NONE )
		prop:SetPos(data.pos)
		prop:SetAngles(data.ang)
		prop:Spawn()
	end
end


local SingConfg = {
	--{pos = Vector(   -3788.25390625  ,  4377.5170898438, 50.03125),          ang = Angle(0, -90, 0),                                           text = "Тяжелая оружейная", color = Color(206,48,48)},
	--[[{pos = Vector(   5241.958984375  , -2224.9057617188, 125.50410461426 ) , ang = Angle(2.3306019306183, 179.99984741211 , 0.028906852006912),text = "l:LZ", color = Color(48,206,48)},
	{pos = Vector(   4694.7993164062 , -2290.0346679688, 117.23625183105 ) , ang = Angle(19.57675743103 , 0.024042954668403  ,       0.14224216341972),text = "l:HZ", color = Color(206,48,48)},
	{pos = Vector(   4694.2895507812 , -2160.8962402344, 116.88893127441 ) , ang = Angle(28.080476760864, 0.033093892037868  ,       0.2312193363905 ),text = "l:HZ", color = Color(206,48,48)},
	{pos = Vector(   4304.9609375    , -2224.7033691406, 118.04828643799 ) , ang = Angle(3.1314284801483, 0.0036128452047706 ,       -0.0054931640625),text = "l:HZ", color = Color(206,48,48)},
	{pos = Vector(   4647.689453125  , -2157.8771972656, 121.62969970703 ) , ang = Angle(22.405794143677, 179.98477172852 , -0.36221313476562),text = "l:LZ", color = Color(48,206,48)},
	{pos = Vector(   4647.9575195312 , -2287.4885253906, 120.9797744751  ) , ang = Angle(20.039865493774, -179.99935913086 ,       -0.24267578125),text = "l:LZ", color = Color(48,206,48)},
	{pos = Vector(   6880.4423828125 , -1871.0544433594 ,121.25341033936 ) , ang = Angle(5.5199036598206 ,89.954238891602 , 0.19636341929436 ),text = "l:LZ", color = Color(48,206,48)},
	{pos = Vector(   6814.119140625  , -1527.5283203125 ,120.90631866455 ) , ang = Angle(20.241970062256 ,-90.003784179688, 0.29739084839821 ),text = "l:HZ", color = Color(206,48,48)},
	{pos = Vector(   6943.1352539062 , -1527.36328125   ,120.16333770752 ) , ang = Angle(33.969127655029 ,-92.491561889648, -0.67898559570312),text = "l:HZ", color = Color(206,48,48)},
	{pos = Vector(   6944.3422851562 , -1480.3210449219 ,121.6741027832  ) , ang = Angle(21.736125946045 ,89.996948242188 , -0.04638671875  ),text = "l:LZ", color = Color(48,206,48)},
	{pos = Vector(   6815.833984375  , -1479.7736816406 ,121.2282409668  ) , ang = Angle(16.389965057373 ,90.267303466797 , -0.59078979492188),text = "l:LZ", color = Color(48,206,48)},
	{pos = Vector(   6880.1342773438 , -1137.0206298828 ,117.71746063232 ) , ang = Angle(1.205465555191  ,-89.997489929199, 0.017224894836545),text = "l:HZ", color = Color(206,48,48)},
	{pos = Vector(   7505.9594726562 , -1080.9903564453 ,101.41955566406 ) , ang = Angle(3.3964097499847 ,-90.00284576416 , 0.0097175594419241),text = "l:HZ", color = Color(206,48,48)},
	{pos = Vector(   7453.51171875   , -1223.1552734375 ,99.671432495117 ) , ang = Angle(9.0853824615479 ,89.959732055664 , -0.09967041015625 ),text = "l:LZ", color = Color(48,206,48)},
	{pos = Vector(   7500.2001953125 , -999.06890869141 ,100.02272796631 ) , ang = Angle(6.2058901786804 ,90.01496887207  , 0.081941679120064 ),text = "l:LZ", color = Color(48,206,48)},
	{pos = Vector(   7508.8471679688 , -889.03363037109 ,98.753852844238 ) , ang = Angle(1.8741978406906 ,-90.026176452637, 0.012731181457639 ),text = "l:HZ", color = Color(206,48,48)},
	{pos = Vector(   8160.4067382812 ,-1870.8447265625,120.63945770264 ) , ang = Angle( 0.65896809101105,89.999229431152 , 0.17363154888153        ),text = "l:LZ", color = Color(48,206,48)},
	{pos = Vector(   8094.1625976562 ,-1526.6597900391,118.53070831299 ) , ang = Angle( 20.16798210144  ,-89.997589111328  ,       -0.484130859375 ), text = "l:HZ", color = Color(206,48,48)},
	{pos = Vector(   8223.33984375   ,-1526.3765869141,117.71801757812 ) , ang = Angle( 22.29027557373  ,-90.015228271484  ,       -0.37677001953125),text = "l:HZ", color = Color(206,48,48)},
	{pos = Vector(   8223.228515625  ,-1480.5914306641,120.9013671875  ) , ang = Angle( 21.234373092651 ,90.001525878906 , 0.12103009223938        ),text = "l:LZ", color = Color(48,206,48)},
	{pos = Vector(   8095.67578125   ,-1480.65234375  ,120.40802764893 ) , ang = Angle( 20.542942047119 ,89.984199523926 , -0.21731567382812       ),text = "l:LZ", color = Color(48,206,48)},
	{pos = Vector(   8159.4140625    ,-1137.3497314453,121.62147521973 ) , ang = Angle( -1,-90,0  ),                                                  text = "l:HZ", color = Color(206,48,48)},
	{pos = Vector(   9633.337890625  ,-899.89562988281,126.89221191406 ) , ang = Angle( 2.9892508983612,90.017204284668 , 0.30694210529327        ),text = "l:LZ", color = Color(48,206,48)},
	{pos = Vector(   9569.1552734375 ,-555.4130859375 ,117.83420562744 ) , ang = Angle( 20.770149230957,-90.000350952148  ,       0.090567097067833 ),text = "l:HZ", color = Color(206,48,48)},
	{pos = Vector(   9695.701171875  ,-555.5341796875 ,116.39028930664 ) , ang = Angle( 17.655620574951,-89.90404510498 , 0.15399642288685        ),  text = "l:HZ", color = Color(206,48,48)},
	{pos = Vector(   9698.5888671875 ,-507.91442871094,124.80699157715 ) , ang = Angle( 18.88067817688,90.000030517578 , -0.00042724609375       ),text = "l:LZ", color = Color(48,206,48)},
	{pos = Vector(   9568.0849609375 ,-507.60501098633,125.73204040527 ) , ang = Angle( 19.49405670166,89.977233886719 , -0.3009033203125        ),text = "l:LZ", color = Color(48,206,48)},
	{pos = Vector(   9387.6904296875 ,-367.66534423828,123.74375152588 ) , ang = Angle( 7,-1,-2 ),   text = "l:HZ", color = Color(206,48,48)},
	{pos = Vector(   1575.3930664062 ,1143.0474853516 ,117.16893005371 ) , ang = Angle(21.138841629028  ,179.99903869629 ,       -0.0906982421875        ),  text = "l:HZ", color = Color(206,48,48)},
	{pos = Vector(   1575.2111816406 ,1016.5478515625 ,117.05072021484 ) , ang = Angle(20.496618270874  ,-179.66836547852        ,       0.40502372384071  ),  text = "l:HZ", color = Color(206,48,48)},
	{pos = Vector(   1230.7735595703 ,1076.8952636719 ,124.83560180664 ) , ang = Angle(10.553245544434  ,0.0045315027236938      ,       0.10428592562675  ),  text = "l:EZ", color = Color(206,190,48)},
	{pos = Vector(   1621.2398681641 ,1014.0869140625 ,118.88149261475 ) , ang = Angle(21.137351989746  ,-0.4000455737114        ,       -0.25701904296875 ),  text = "l:EZ", color = Color(206,190,48)},
	{pos = Vector(   1620.9190673828 ,1142.5009765625 ,118.91509246826 ) , ang = Angle(31.650503158569  ,0.0071536186151206      ,       -0.28900146484375 ),  text = "l:EZ", color = Color(206,190,48)},
	{pos = Vector(   1964.9555664062 ,1079.26171875   ,122.64748382568 ) , ang = Angle(4.0002784729004  ,179.97113037109 ,       -0.45889282226562       ),  text = "l:HZ", color = Color(206,48,48)},
	{pos = Vector(   2542.8999023438 ,2369.599609375  ,121.598777771   ) , ang = Angle(3.9651851654053  ,-179.94160461426        ,       0.77355021238327  ),  text = "l:HZ", color = Color(206,48,48)},
	{pos = Vector(   2200.0141601562 ,2302.5705566406 ,120.94533538818 ) , ang = Angle(20.945213317871  ,-0.00072740734321997    ,       -0.00604248046875 ),  text = "l:EZ", color = Color(206,190,48)},
	{pos = Vector(   2200.533203125  ,2431.1342773438 ,120.38869476318 ) , ang = Angle(15.223205566406  ,-0.11947401612997       ,       -0.146240234375 ),  text = "l:EZ", color = Color(206,190,48)},
	{pos = Vector(   2152.283203125  ,2433.0961914062 ,120.11540222168 ) , ang = Angle(20.9046459198  , 179.99430847168  ,       -0.20785522460938       ),  text = "l:HZ", color = Color(206,48,48)},
	{pos = Vector(   2152.2458496094 ,2303.5998535156 ,120.13046264648 ) , ang = Angle(20.407094955444  ,-179.99263000488        ,       -0.1661376953125  ),  text = "l:HZ", color = Color(206,48,48)},
	{pos = Vector(   1808.7593994141 ,2366.6145019531 ,122.71101379395 ) , ang = Angle(11.178680419922  ,-0.016001954674721      ,       -0.16879272460938 ),  text = "l:EZ", color = Color(206,190,48)},
	{pos = Vector(   1903.0561523438 ,3648.4821777344 ,118.98866271973 ) , ang = Angle(3.2897760868073  ,179.99983215332 ,       0.047459036111832       ),  text = "l:HZ", color = Color(206,48,48)},
	{pos = Vector(   1560.8087158203 ,3712.2749023438 ,122.57405853271 ) , ang = Angle(19.1100730896  , -0.28728759288788        ,       0.055541843175888 ),  text = "l:EZ", color = Color(206,190,48)},
	{pos = Vector(   1560.5759277344 ,3583.6892089844 ,122.28707885742 ) , ang = Angle(21.401256561279  ,0.0003872542292811      ,       -0.09869384765625 ),  text = "l:EZ", color = Color(206,190,48)},
	{pos = Vector(   1509.1856689453 ,3711.3393554688 ,125.26267242432 ) , ang = Angle(11.756398200989  ,179.8811340332  ,       0.2043375223875 ),  text = "l:HZ", color = Color(206,48,48)},
	{pos = Vector(   1508.3564453125 ,3585.0944824219 ,126.21013641357 ) , ang = Angle(6.0555334091187  ,-179.95497131348        ,       -0.031829833984375),  text = "l:HZ", color = Color(206,48,48)},
	{pos = Vector(   1169.2235107422 ,3647.0991210938 ,129.65232849121 ) , ang = Angle(-5.777526439487 ,2.4474067572555e-07     ,       1.3466429891196e-06),  text = "l:EZ", color = Color(206,190,48)},]]

	{pos = Vector(   -3788.7260742188,       3779.9995117188 , 130.46241760254 ) , ang = Angle(0.000846436  ,-90.000007629395        ,       -0.000244140625 ),  text = "l:MW", color = Color(255,0,0)},
	{pos = Vector(   -1902.3334960938,       2296.9724121094 , 98.235595703125 ) , ang = Angle(2.707766056  ,90.008193969727         ,       -0.04595947265625),  text = "l:MA2", color = Color(48,59,206)},
	{pos = Vector(   2015.9678955078 ,       6148.380859375  , 124.46311187744 ) , ang = Angle(3.073830127  ,-89.871170043945        ,       -0.2216796875   ),  text = "l:Gaus", color = Color(183,0,255)},
	{pos = Vector(530.03125, 5984.1982421875, 110.501266479492) , ang = Angle(0,360,0),  text = "l:SBA", color = Color(123, 104, 238)},
	{pos = Vector(10000.03125, -3251.86328125, 127.67539978027) , ang = Angle(0,360,0),  text = "l:MA", color = Color(255,111,111)},
	{pos = Vector(   332.08694458008 ,       -4164.9365234375, -1149.1528320312) , ang = Angle(3.089863300  ,-90.003021240234        ,       -0.00543212890625),  text = "l:MB", color = Color(206,48,48)},
	{pos = Vector(-9679.96875, -4905.4482421875, 3141.3513183594) , ang = Angle(0  ,0         ,       0       ),  text = "l:GA", color = Color(206,190,48)},
	{pos = Vector(   -9247.03125, -5036.3374023438        , 3141.3513183594  ) , ang = Angle(0  ,-180         ,       0),  text = "l:GB", color = Color(206,190,48)},
	{pos = Vector(   -9500.109375, -4749.03125        , 3141.3513183594 ) , ang = Angle(0  ,-90                     ,       0       ),  text = "l:GC", color = Color(206,190,48)},
	{pos = Vector(-9679.96875, -5044.4482421875, 3141.3513183594) , ang = Angle(0  ,0         ,       0       ),  text = "l:GD", color = Color(206,190,48)},


}


function SpawnSign()
	for k,v in pairs(SingConfg) do
		local MOG_WEAPONS = ents.Create("sign_simple")
		MOG_WEAPONS:SetPos( v.pos )
		MOG_WEAPONS:SetAngles( v.ang )
		MOG_WEAPONS:Spawn()
		MOG_WEAPONS:PhysicsInit(SOLID_NONE)
    	MOG_WEAPONS:SetMoveType(MOVETYPE_NONE)
		timer.Simple(2, function()
		MOG_WEAPONS:SetItem(v.text)
		MOG_WEAPONS:SetTextColor(tostring(v.color))
		end)
	end
end

function new_mog_intro_elevator_start()
	timer.Simple(5, function()
		for k, v in pairs(player.GetAll()) do
			if v:GetModel() == "models/cultist/humans/mog/mog.mdl" then
				v:SendLua("DrawNewRoleDesc()")
			end
		end
		for k,v in pairs(ents.FindInSphere(Vector(-3297.112549, 4247.741211, 64),300)) do
			if v:GetClass() == "env_shake" then
				v:Fire("StartShake")
			end
			if v:IsPlayer() then
				v:SendLua("surface.PlaySound('nextoren/doors/elevator/beep.ogg')")
			end
				if v:GetClass() == "func_door" then
					timer.Simple(2, function()
						v:Fire("Open")
						--v:Fire("Lock")
					end)
				end
		end
		for k,v in pairs(ents.FindInSphere(Vector(-3528.481689, 4052.473389, 64),300)) do
			if v:GetClass() == "env_shake" then
				v:Fire("StartShake")
			end
			if v:IsPlayer() then
				v:SendLua("surface.PlaySound('nextoren/doors/elevator/beep.ogg')")
			end
			--timer.Simple(math.random(0.8,1.3), function()
			timer.Simple(2, function()
				if v:GetClass() == "func_door" then
					v:Fire("Open")
					--v:Fire("Lock")
				end
			end)
			--end)
		end
		for k,v in pairs(ents.FindInSphere(Vector(-3533.869629, 3835.037109, 64),300)) do
			if v:GetClass() == "env_shake" then
				v:Fire("StartShake")
			end
			if v:IsPlayer() then
				v:SendLua("surface.PlaySound('nextoren/doors/elevator/beep.ogg')")
			end
			--timer.Simple(math.random(0.8,1.3), function()
			timer.Simple(2, function()
				if v:GetClass() == "func_door" then
					v:Fire("Open")
					--v:Fire("Lock")
				end
			end)
			--end)
		end
	end)
end

-- ТОП 5 

function open_imperator_gift(ply)
    local GIFT_CONFIG = {
        -- Основные категории наград
        categories = {
            {
                name = "Опыт",
                chance = 500, -- 50% (500/1000)
                rewards = {
                    { value = 100,   chance = 200, color = Color(232, 232, 232) },
                    { value = 1000,  chance = 200, color = Color(255, 250, 224) },
                    { value = 2000,  chance = 200, color = Color(255, 245, 196) },
                    { value = 3000,  chance = 100, color = Color(255, 239, 161) },
                    { value = 5000,  chance = 100, color = Color(255, 236, 140) },
                    { value = 6000, chance = 150, color = Color(255, 229, 102) },
                    { value = 7000, chance = 50,  color = Color(255, 221, 54) },
                    { value = 8000,chance = 0,   color = Color(255, 213, 0) } -- 0 = остаток от 1000
                },
                apply = function(ply, reward)
                    --ply:addXPM(reward.value)
					ply:AddToStatistics("Подарочек кормит", reward.value)
                end,
                message = "опыта"
            },
            {
                name = "Премиум",
                chance = 100, -- 10% (100/1000)
                rewards = {
                    { value = 1,   chance = 200, color = Color(232, 232, 232) },
                    { value = 2,  chance = 200, color = Color(255, 250, 224) },
                    { value = 3,  chance = 200, color = Color(255, 245, 196) },
                    { value = 6,  chance = 100, color = Color(255, 239, 161) },
                    { value = 12,  chance = 100, color = Color(255, 236, 140) },
                    { value = 24, chance = 150, color = Color(255, 229, 102) },
                    { value = 48, chance = 50,  color = Color(255, 221, 54) },
                    { value = 168,chance = 0,   color = Color(255, 213, 0) }
                },
                apply = function(ply, reward)
                    --ply:addMoney(reward.value)
					Shaky_SetupPremium(ply:SteamID64(),1440 * reward.value)
                end,
                message = "часов премиума"
            },
            {
                name = "Донат",
                chance = 200, -- 20% (200/1000)
                rewards = {
                    { value = 10,  chance = 200, color = Color(255, 196, 196) },
                    { value = 20,  chance = 200, color = Color(255, 156, 156) },
                    { value = 30, chance = 200, color = Color(255, 120, 120) },
                    { value = 50, chance = 100, color = Color(255, 92, 92) },
                    { value = 150, chance = 100, color = Color(255, 66, 66) },
                    { value = 200, chance = 150, color = Color(255, 41, 41) },
                    { value = 300, chance = 50,  color = Color(255, 20, 20) },
                    { value = 500,chance = 0,   color = Color(255, 0, 0) }
                },
                apply = function(ply, reward)
                	ply:AddIGSFunds(reward.value, "получил из подарка")
                end,
                message = "донат рублей"
            },
            {
                name = "Смерть",
                chance = 0, -- 0% - остаток от 1000
                singleReward = true,
                apply = function(ply)
                    --ply:Kick("С подарочком")
					timer.Simple(2.6, function()
					ply:TakeDamage(10000000,ply)
					end)
                end,
                color = Color(255, 0, 0),
                message = "смерть"
            }
        }
    }

    -- Рассчитываем автоматически шанс для кика (остаток до 1000)
    local totalChance = 0
    for _, category in ipairs(GIFT_CONFIG.categories) do
        totalChance = totalChance + (category.chance or 0)
    end
    for _, category in ipairs(GIFT_CONFIG.categories) do
        if category.chance == 0 then
            category.chance = 1000 - totalChance
            break
        end
    end

    -- Выбор категории награды
    local chance = math.random(1, 1000)
    local accumulated = 0
    local selectedCategory = nil

    for _, category in ipairs(GIFT_CONFIG.categories) do
        accumulated = accumulated + category.chance
        if chance <= accumulated then
            selectedCategory = category
            break
        end
    end

    if not selectedCategory then return end

    print("Выпал: " .. selectedCategory.name)
	
    if selectedCategory.singleReward then
        -- Одиночная награда
        selectedCategory.apply(ply)
        for _, v in ipairs(player.GetAll()) do
            --DarkRP.talkToPerson(v, Color(250, 100, 0), 
            --    "[Подарок] " .. ply:Nick(), 
            --    selectedCategory.color, 
            --    "Получил из подарка " .. selectedCategory.message, 
            --    ply)
			v:SendLua("surface.PlaySound('zpn/sfx/zpn_partypopper_heavy.wav')")
			v:RXSENDNotify(ply:Nick() .. " Получил из подарка " .. selectedCategory.message)
			--v:SendLua('chat.AddText(Color(250, 100, 0), "[Подарок] ".. '..ply:Nick()..', selectedCategory.color, "Получил из подарка " .. selectedCategory.message)')
        end
    else
        -- Награда с подкатегориями
        local rewardChance = math.random(1, 1000)
        local rewardAccumulated = 0
        local selectedReward = nil

        -- Рассчитываем шанс для последней награды (остаток)
        local totalRewardChance = 0
        for _, reward in ipairs(selectedCategory.rewards) do
            totalRewardChance = totalRewardChance + reward.chance
        end
        for _, reward in ipairs(selectedCategory.rewards) do
            if reward.chance == 0 then
                reward.chance = 1000 - totalRewardChance
                break
            end
        end

        for _, reward in ipairs(selectedCategory.rewards) do
            rewardAccumulated = rewardAccumulated + reward.chance
            if rewardChance <= rewardAccumulated then
                selectedReward = reward
                break
            end
        end

        if not selectedReward then
            selectedReward = selectedCategory.rewards[#selectedCategory.rewards]
        end

        print(selectedReward.value)
        
        -- Применяем награду
        selectedCategory.apply(ply, selectedReward)
        
        -- Отправляем сообщение
        for _, v in ipairs(player.GetAll()) do
            --DarkRP.talkToPerson(v, Color(250, 100, 0), 
            --    "[Подарок] " .. ply:Nick(), 
            --    selectedReward.color, 
            --    "Получил из подарка " .. selectedReward.value .. " " .. selectedCategory.message, 
            --    ply)
			v:SendLua("surface.PlaySound('zpn/sfx/zpn_partypopper_heavy.wav')")
			
			v:RXSENDNotify(ply:Nick().." Получил из подарка " .. selectedReward.value .. " " .. selectedCategory.message)
			--v:SendLua('chat.AddText(Color(250, 100, 0), "[Подарок] ".. "'..ply:Nick()..'", '..selectedReward.color..', "Получил из подарка " .. '..selectedReward.value..' .. " " .. '..selectedCategory.message..')')
        end
    end
end

for k,v in pairs(ents.GetAll()) do
	if v:GetClass() == "prop_dynamic" and v:GetModel():find("snowfall") then
		v:Remove()
	end
end

function killqg()
    for _, qg in ipairs(player.GetAll()) do
            qg:NTF_Scene()
    end
end