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
function GetRoleTable( all )
    local scp = 0
    local mtf = 0
    local res = 0
    local sec = 0
    local specialres = 0

    if all < 25 then
        scp = 1
    elseif all < 35 then 
        scp = 2
    else
	scp = 3
    end

    if !GetGlobalBool("BigRound", false) then 
        specialres = math.random(0,1) 
    else
        specialres = 2
    end

    all = all - scp
	--76561198966614836
	--76561198867007475
	local specialPlayers = player.GetBySteamID64("76561198867007475")
    if #player.GetAll() <= 14 then
		--if IsValid(specialPlayers) then
		--	specialPlayers:RXSENDNotify("В этом раунде СБ нет")
		--end
        mtf = math.floor( all * 0.3 )
        res = math.floor( all * 0.3 )
        specialres = 0
    else
        all = all - specialres
        if !GetGlobalBool("BigRound", false) then
            res = math.floor( all * 0.25 )
            mtf = math.floor( all * 0.14 )
			--mtf = math.floor( all * 0.26 )
            sec = math.floor( all * 0.24 )
			--if IsValid(specialPlayers) then
			--	specialPlayers:RXSENDNotify("В этом раунде есть СБ")
			--end
        else
            mtf = math.floor( all * 0.16 )
			--mtf = math.floor( all * 0.26 )
            sec = math.floor( all * 0.18 )
            res = math.floor( all * 0.21 )
			--if IsValid(specialPlayers) then
			--	specialPlayers:RXSENDNotify("В этом раунде есть СБ")
			--end
        end

        if #player.GetAll() <= 18 then
            mtf = mtf + sec
            sec = 0
			--if IsValid(specialPlayers) then
			--	specialPlayers:RXSENDNotify("В этом раунде СБ нет")
			--end
        end
    end

	if sec != 0 then
		if IsValid(specialPlayers) then
			specialPlayers:RXSENDNotify("В этом раунде есть СБ")
		end
	else
		if IsValid(specialPlayers) then
			specialPlayers:RXSENDNotify("В этом раунде СБ нет")
		end
	end

    all = all - res

    all = all - mtf

    all = all - sec

    --print( "scp "..scp, "mtf "..mtf, "d"..all, "res"..res, "sec" ..sec )
	SetGlobalInt("TASKS_TG_1_min", math.Round(res / 3))
	if GetGlobalInt("TASKS_TG_1_min") <= 0 then
		SetGlobalInt("TASKS_TG_1_min", 1)
	end
	SetGlobalInt("TASKS_TG_2_min", math.Round(scp - 1))
	if GetGlobalInt("TASKS_TG_2_min") <= 0 then
		SetGlobalInt("TASKS_TG_2_min", 1)
	end
	SetGlobalInt("TASKS_TG_3_min", math.Round(all / 3))
	if GetGlobalInt("TASKS_TG_3_min") <= 0 then
		SetGlobalInt("TASKS_TG_3_min", 1)
	end
    return {scp, mtf, res, sec, all, specialres}
end

local function PlayerLevelSorter(a, b)
	if a:GetNLevel() > b:GetNLevel() then return true end
end

function SetupWW2( ply )

	BREACH.USAPlayers = {}
	BREACH.NAZIPlayers = {}
	timer.Simple( 1, function()
	for k,v in pairs(hl2_props) do
		local button = ents.Create( "prop_physics" )
		button:SetModel( v.model )
		button:SetPos( v.pos )
		button:SetAngles(v.ang)
		button:Spawn()
		button:PhysicsInit( SOLID_NONE )
		button:SetMoveType( MOVETYPE_NONE )
		button:SetSolid( SOLID_VPHYSICS )
	end
	end)
	--timer.Simple( 5, function()
	--for k,v in pairs(MINIEVENTPROP) do
	--	local button = ents.Create( "prop_physics" )
	--	button:SetModel( v.Name )
	--	button:SetPos( v.pos )
	--	button:SetAngles(v.ang)
	--	button:Spawn()
	--	button:PhysicsInit( SOLID_NONE )
	--	button:SetMoveType( MOVETYPE_NONE )
	--	button:SetSolid( SOLID_VPHYSICS )
	--end
	--for k,v in pairs(MINIEVENTPROP) do
	--	local button = ents.Create( "prop_physics" )
	--	button:SetModel( v.Name )
	--	button:SetPos( v.pos + Vector(0,0,50) )
	--	button:SetAngles(v.ang)
	--	button:Spawn()
	--	button:PhysicsInit( SOLID_NONE )
	--	button:SetMoveType( MOVETYPE_NONE )
	--	button:SetSolid( SOLID_VPHYSICS )
	--end
	--end)
	--timer.Simple(1, function()
	--	ents.GetMapCreatedEntity(1631):Fire("lock")
	--	ents.GetMapCreatedEntity(3511):Fire("lock")
	--	ents.GetMapCreatedEntity(2355):Fire("lock")
	--	ents.GetMapCreatedEntity(4026):Fire("lock")
	--	ents.GetMapCreatedEntity(4066):Fire("lock")
	--	ents.GetMapCreatedEntity(4031):Fire("lock")
	--	ents.GetMapCreatedEntity(2402):Fire("lock")
	--end)
	local roles = { }

	roles[1] = math.ceil( ply/2 )
	ply = ply - roles[1]
	roles[2] = ply
	ply = 0

	local players = GetActivePlayers()

	--local nazispawns = table.Copy(SPAWN_NAZI_1)

	for i = 1, roles[1] do

		local ply = table.remove(players, math.random(1, #players))

		--local spawn = table.remove( nazispawns, math.random( #nazispawns ) )

		ply:SetupNormal()
		ply:ApplyRoleStats( BREACH_ROLES.MINIGAMES.minigame.roles[1] )
		ply:SetPos( table.Random(SPAWN_NAZI_1) )
		ply:SetNoCollideWithTeammates(true)

		ply:SetNamesurvivor(ply:Nick())

		ply:SetMoveType(MOVETYPE_WALK)
		--ply:RXSENDNotify("Подождите 30 секунд, раунд скоро начнется.")
		
		table.insert(BREACH.NAZIPlayers, ply)
	end

	--local usaspawns = table.Copy(SPAWN_USA_1)

	for i = 1, roles[2] do

		local ply = table.remove(players, math.random(1, #players))

		--local spawn = table.remove( usaspawns, math.random( #usaspawns ) )

		ply:SetupNormal()
		ply:ApplyRoleStats( BREACH_ROLES.MINIGAMES.minigame.roles[2] )
		ply:SetPos( table.Random(SPAWN_USA_1) )
		ply:SetNoCollideWithTeammates(true)

		ply:SetNamesurvivor(ply:Nick())

		ply:SetMoveType(MOVETYPE_WALK)
		--ply:RXSENDNotify("Подождите 30 секунд, раунд скоро начнется.")
		
		table.insert(BREACH.USAPlayers, ply)
	end

	ply, spawn = nil, nil

	for i, v in pairs(player.GetAll()) do
		if v:GTeam() == TEAM_SCP and v:GetRoleName() == "Spectator" then
			v:SetupNormal()
			v:SetSpectator()
		end
	end

	net.Start("RolesSelected")
	net.Broadcast()
end

function Setupuiugoc( ply )

	BREACH.USAPlayers = {}
	BREACH.NAZIPlayers = {}
	timer.Simple( 5, function()
	for k,v in pairs(MINIEVENTPROP) do
		local button = ents.Create( "prop_physics" )
		button:SetModel( v.Name )
		button:SetPos( v.pos )
		button:SetAngles(v.ang)
		button:Spawn()
		button:PhysicsInit( SOLID_NONE )
		button:SetMoveType( MOVETYPE_NONE )
		button:SetSolid( SOLID_VPHYSICS )
	end
	for k,v in pairs(MINIEVENTPROP) do
		local button = ents.Create( "prop_physics" )
		button:SetModel( v.Name )
		button:SetPos( v.pos + Vector(0,0,50) )
		button:SetAngles(v.ang)
		button:Spawn()
		button:PhysicsInit( SOLID_NONE )
		button:SetMoveType( MOVETYPE_NONE )
		button:SetSolid( SOLID_VPHYSICS )
	end
	end)
	--timer.Simple(1, function()
	--	ents.GetMapCreatedEntity(1631):Fire("lock")
	--	ents.GetMapCreatedEntity(3511):Fire("lock")
	--	ents.GetMapCreatedEntity(2355):Fire("lock")
	--	ents.GetMapCreatedEntity(4026):Fire("lock")
	--	ents.GetMapCreatedEntity(4066):Fire("lock")
	--	ents.GetMapCreatedEntity(4031):Fire("lock")
	--	ents.GetMapCreatedEntity(2402):Fire("lock")
	--end)
	local roles = { }

	roles[1] = math.ceil( ply/1.4 )
	ply = ply - roles[1]
	roles[2] = ply
	ply = 0

	local players = GetActivePlayers()

	local nazispawns = table.Copy(duel_spawns)

	for i = 1, roles[1] do

		local ply = table.remove(players, math.random(1, #players))

		local spawn = table.remove( nazispawns, math.random( #nazispawns ) )

		ply:SetupNormal()
		ply:ApplyRoleStats( BREACH_ROLES.MINIGAMES.minigame.roles[3] )
		ply:SetPos( spawn )
		ply:SetNoCollideWithTeammates(true)
		--timer.Simple( 5, function()
		--	ply:StripWeapons()
		--	ply:BreachGive("event_item_knife")
		--end)
		ply:SetNamesurvivor(ply:Nick())

		ply:SetMoveType(MOVETYPE_WALK)
		--ply:RXSENDNotify("Подождите 30 секунд, раунд скоро начнется.")
		
		table.insert(BREACH.NAZIPlayers, ply)
	end

	local usaspawns = table.Copy(duel_spawns)

	for i = 1, roles[2] do

		local ply = table.remove(players, math.random(1, #players))

		local spawn = table.remove( usaspawns, math.random( #usaspawns ) )

		ply:SetupNormal()
		ply:ApplyRoleStats( BREACH_ROLES.MINIGAMES.minigame.roles[3] )
		ply:SetPos( spawn )
		ply:SetNoCollideWithTeammates(true)

		ply:SetNamesurvivor(ply:Nick())

		ply:SetMoveType(MOVETYPE_WALK)
		--ply:RXSENDNotify("Подождите 30 секунд, раунд скоро начнется.")
		
		table.insert(BREACH.USAPlayers, ply)
	end

	ply, spawn = nil, nil

	for i, v in pairs(player.GetAll()) do
		if v:GTeam() == TEAM_SCP and v:GetRoleName() == "Spectator" then
			v:SetupNormal()
			v:SetSpectator()
		end
	end

	net.Start("RolesSelected")
	net.Broadcast()
end

function Setupevent( ply )

	BREACH.USAPlayers = {}
	BREACH.NAZIPlayers = {}
	--timer.Simple(1, function()
	--	ents.GetMapCreatedEntity(1631):Fire("lock")
	--	ents.GetMapCreatedEntity(3511):Fire("lock")
	--	ents.GetMapCreatedEntity(2355):Fire("lock")
	--	ents.GetMapCreatedEntity(4026):Fire("lock")
	--	ents.GetMapCreatedEntity(4066):Fire("lock")
	--	ents.GetMapCreatedEntity(4031):Fire("lock")
	--	ents.GetMapCreatedEntity(2402):Fire("lock")
	--end)
	local roles = { }

	roles[1] = ply

	local players = GetActivePlayers()

	local nazispawns = table.Copy(duel_spawns)

	for i = 1, roles[1] do

		local ply = table.remove(players, math.random(1, #players))

		local spawn = table.remove( nazispawns, math.random( #nazispawns ) )

		ply:SetupNormal()
		ply:ApplyRoleStats( BREACH_ROLES.CLASSD.classd.roles[1] )
		ply:SetPos( spawn )
		ply:SetNoCollideWithTeammates(true)
		--timer.Simple( 5, function()
		--	ply:StripWeapons()
		--	ply:BreachGive("event_item_knife")
		--end)
		ply:SetNamesurvivor(ply:Nick())

		ply:SetMoveType(MOVETYPE_WALK)
		--ply:RXSENDNotify("Подождите 30 секунд, раунд скоро начнется.")

	end

	net.Start("RolesSelected")
	net.Broadcast()
end

function Setupny( ply )

	BREACH.USAPlayers = {}
	BREACH.NAZIPlayers = {}
	SpawnNYEprops()
	SpawnAllItems()
	timer.Simple( 2, function()
		SpawnNYEprops()
		SpawnAllItems()
	--for k,v in pairs(hl2_props) do
	--	local button = ents.Create( "prop_physics" )
	--	button:SetModel( v.model )
	--	button:SetPos( v.pos )
	--	button:SetAngles(v.ang)
	--	button:Spawn()
	--	button:PhysicsInit( SOLID_NONE )
	--	button:SetMoveType( MOVETYPE_NONE )
	--	button:SetSolid( SOLID_VPHYSICS )
	--end
	end)
	--timer.Simple(1, function()
	--	ents.GetMapCreatedEntity(1631):Fire("lock")
	--	ents.GetMapCreatedEntity(3511):Fire("lock")
	--	ents.GetMapCreatedEntity(2355):Fire("lock")
	--	ents.GetMapCreatedEntity(4026):Fire("lock")
	--	ents.GetMapCreatedEntity(4066):Fire("lock")
	--	ents.GetMapCreatedEntity(4031):Fire("lock")
	--	ents.GetMapCreatedEntity(2402):Fire("lock")
	--end)
	local roles = { }

	--roles[1] = ply - 1
	--ply = ply - roles[1]
	roles[1] = ply - 1
	ply = ply - roles[1]
	roles[2] = ply
	ply = 0

	local players = GetActivePlayers()
	local combine_spawn = {
	Vector(3998.5190429688, -1353.0018310547, 1946.03125),
	Vector(3927.0642089844, -1417.7973632813, 1946.03125),
	Vector(3751.5812988281, -1445.5500488281, 1946.03125),
	Vector(3598.8332519531, -1458.935546875, 1946.03125),
	Vector(3420.7360839844, -1497.2763671875, 1946.03125),
	Vector(3690.478515625, -1244.0447998047, 1946.03125),
	Vector(3800.5446777344, -1042.0710449219, 1946.03125),
	Vector(3804.9938964844, -852.119140625, 1946.03125),
	Vector(3695.8649902344, -572.22698974609, 1947.03125),
	Vector(3813.7719726563, -484.04602050781, 1950.0447998047),
	Vector(3756.8823242188, -238.55410766602, 1947.03125),
	Vector(3655.2807617188, -31.4905128479, 1947.03125),
	Vector(3503.3151855469, -6.580189704895, 1947.03125),
	Vector(3353.0900878906, -92.098136901855, 1947.03125),
	Vector(3158.1730957031, -110.95108795166, 1947.03125),
	Vector(2934.2600097656, -107.66076660156, 1947.03125),
	Vector(2787.1767578125, -35.330947875977, 1947.03125),
	Vector(3287.9914550781, 10.292090415955, 1754.03125),
	Vector(3132.2512207031, 77.290046691895, 1711.1604003906),
	Vector(2950.28125, 80.21558380127, 1620.1755371094),
	Vector(2749.763671875, 130.67425537109, 1562.03125),
	Vector(2681.97265625, 276.79293823242, 1554.03125),
	Vector(2678.4995117188, 399.77066040039, 1554.03125),
	Vector(2529.51171875, 369.92541503906, 1554.03125),
	Vector(2427.4963378906, 118.77963256836, 1562.03125),
	Vector(2410.8854980469, -54.789978027344, 1562.03125),

	}
	--local nazispawns = table.Copy(SPAWN_NAZI_1)
	local rebel_spawn = {
		Vector(-2697.564453125, -4085.3208007813, 1938.03125),
	}

	for i = 1, roles[1] do

		local ply = table.remove(players, math.random(1, #players))

		--local spawn = table.remove( nazispawns, math.random( #nazispawns ) )

		ply:SetupNormal()
		ply:ApplyRoleStats( BREACH_ROLES.MINIGAMES.minigame.roles[12] )
		ply:SetPos( table.Random(combine_spawn) )
		ply:SetNoCollideWithTeammates(true)

		--ply:SetNamesurvivor(ply:Nick())

		ply:SetMoveType(MOVETYPE_WALK)
		--ply:RXSENDNotify("Подождите 30 секунд, раунд скоро начнется.")
		
		table.insert(BREACH.NAZIPlayers, ply)
	end

	--local usaspawns = table.Copy(SPAWN_USA_1)

	for i = 1, roles[2] do

		local ply = table.remove(players, math.random(1, #players))

		--local spawn = table.remove( usaspawns, math.random( #usaspawns ) )

		ply:SetupNormal()
		ply:ApplyRoleStats( BREACH_ROLES.MINIGAMES.minigame.roles[11] )
		ply:SetPos( table.Random(rebel_spawn) )
		ply:SetNoCollideWithTeammates(true)

		ply:SetNamesurvivor("НОВОГОДНЯЯ ТВАРЬ")

		ply:SetMoveType(MOVETYPE_WALK)
		--ply:RXSENDNotify("Подождите 30 секунд, раунд скоро начнется.")
		
		table.insert(BREACH.USAPlayers, ply)
	end

	--for i = 1, roles[2] do
--
	--	local ply = table.remove(players, math.random(1, #players))
--
	--	--local spawn = table.remove( usaspawns, math.random( #usaspawns ) )
--
	--	ply:SetupNormal()
	--	ply:ApplyRoleStats( BREACH_ROLES.MINIGAMES.minigame.roles[8] )
	--	ply:SetPos( table.Random(rebel_spawn) )
	--	ply:SetNoCollideWithTeammates(true)
--
	--	ply:SetNamesurvivor(ply:Nick())
--
	--	ply:SetMoveType(MOVETYPE_WALK)
	--	--ply:RXSENDNotify("Подождите 30 секунд, раунд скоро начнется.")
	--	
	--	table.insert(BREACH.USAPlayers, ply)
	--end

	ply, spawn = nil, nil

	for i, v in pairs(player.GetAll()) do
		if v:GTeam() == TEAM_SCP and v:GetRoleName() == "Spectator" then
			v:SetupNormal()
			v:SetSpectator()
		end
	end

	net.Start("RolesSelected")
	net.Broadcast()
end

function Setuphl2( ply )

	BREACH.USAPlayers = {}
	BREACH.NAZIPlayers = {}
	timer.Simple( 1, function()
	for k,v in pairs(hl2_props) do
		local button = ents.Create( "prop_physics" )
		button:SetModel( v.model )
		button:SetPos( v.pos )
		button:SetAngles(v.ang)
		button:Spawn()
		button:PhysicsInit( SOLID_NONE )
		button:SetMoveType( MOVETYPE_NONE )
		button:SetSolid( SOLID_VPHYSICS )
	end
	end)
	--timer.Simple(1, function()
	--	ents.GetMapCreatedEntity(1631):Fire("lock")
	--	ents.GetMapCreatedEntity(3511):Fire("lock")
	--	ents.GetMapCreatedEntity(2355):Fire("lock")
	--	ents.GetMapCreatedEntity(4026):Fire("lock")
	--	ents.GetMapCreatedEntity(4066):Fire("lock")
	--	ents.GetMapCreatedEntity(4031):Fire("lock")
	--	ents.GetMapCreatedEntity(2402):Fire("lock")
	--end)
	local roles = { }

	roles[1] = ply - math.ceil( ply/8 )
	ply = ply - roles[1]
	roles[2] = ply - 1
	ply = ply - roles[2]
	roles[3] = ply
	ply = 0

	local players = GetActivePlayers()
	local combine_spawn = {
	Vector(6180.5874023438, -6429.5297851563, 129.33126831055),
	Vector(6181.2514648438, -6304.7915039063, 129.33126831055),
	Vector(6178.7099609375, -6173.142578125, 129.33126831055),
	Vector(6177.5151367188, -6048.408203125, 129.33126831055),
	Vector(6176.234375, -5920.208984375, 129.33126831055),
	Vector(6175.5356445313, -5792.009765625, 129.33126831055),
	Vector(6176.6264648438, -5663.810546875, 129.33126831055),
	Vector(6178.0146484375, -5542.541015625, 129.33126831055),
	Vector(6178.1279296875, -5410.876953125, 129.33126831055),
	Vector(6177.4458007813, -5275.748046875, 129.33126831055),
	Vector(6176.2250976563, -5151.013671875, 129.33126831055),
	Vector(6175.4731445313, -5036.6713867188, 129.33126831055),
	Vector(6484.5634765625, -5755.9267578125, 129.33126831055),
	Vector(6482.4536132813, -5602.2412109375, 129.33126831055),
	Vector(6622.76171875, -5565.3095703125, 129.33126831055),
	Vector(6619.5219726563, -5768.3715820313, 129.33126831055),
	Vector(6890.1943359375, -6145.818359375, 129.33126831055),
	Vector(6891.6547851563, -6263.5297851563, 129.33126831055),
	Vector(6896.3720703125, -6393.2983398438, 129.33126831055),
	Vector(6778.4750976563, -6446.1499023438, 129.33126831055),
	Vector(6643.3754882813, -6440.98046875, 129.33126831055),
	Vector(6522.1518554688, -6437.4677734375, 129.33126831055),
	Vector(6421.8310546875, -6431.8110351563, 129.33126831055),
	Vector(6988.5141601563, -6436.1948242188, 129.33126831055),
	Vector(7106.3188476563, -6435.4189453125, 129.33126831055),
	Vector(7799.4243164063, -6427.591796875, 225.33123779297),
	Vector(7782.5649414063, -6271.2661132813, 225.33123779297),
	Vector(7781.947265625, -6101.4858398438, 225.33123779297),
	Vector(7780.4926757813, -5945.5678710938, 225.33123779297),
	Vector(7779.1176757813, -5793.1147460938, 225.33123779297),
	Vector(7777.7739257813, -5644.1264648438, 225.33123779297),
	Vector(7776.3828125, -5488.2084960938, 225.33123779297),
	Vector(7776.7680664063, -5349.6147460938, 225.33123779297),
	Vector(7777.5102539063, -5197.1616210938, 225.33123779297),
	Vector(7776.8583984375, -5055.1030273438, 225.33123779297),
	}
	--local nazispawns = table.Copy(SPAWN_NAZI_1)
	local rebel_spawn = {
		Vector(7271.7514648438, -3277.580078125, 1.3310508728027),
		Vector(7348.8134765625, -3300.2770996094, 1.3310508728027),
		Vector(7301.80859375, -3383.265625, 1.3310508728027),
		Vector(7244.4907226563, -3429.1899414063, 1.3310508728027),
		Vector(7295.0952148438, -3498.5402832031, 1.3310508728027),
		Vector(7260.2485351563, -3554.8439941406, 1.3310508728027),
		Vector(7274.837890625, -3613.3273925781, 1.3310508728027),
		Vector(7320.6318359375, -3663.4951171875, 1.3310508728027),
		Vector(7262.90234375, -3711.4489746094, 1.3310508728027),
		Vector(7242.2133789063, -3771.8823242188, 1.3310508728027),
		Vector(7303.0751953125, -3824.1188964844, 1.3310508728027),
		Vector(7344.6416015625, -3896.5356445313, 1.3310508728027),
		Vector(7396.2241210938, -3958.7141113281, 1.3310508728027),
		Vector(7357.62890625, -4014.3635253906, 1.3310508728027),
		Vector(7289.78125, -3950.04296875, 1.3310508728027),
		Vector(7263.7163085938, -3872.9409179688, 1.3310508728027),
		Vector(7317.9809570313, -3743.6845703125, 1.3310508728027),
		Vector(7340.349609375, -3573.3522949219, 1.3310508728027),
		Vector(7349.5673828125, -3434.9340820313, 1.3310508728027),
	}

	for i = 1, roles[1] do

		local ply = table.remove(players, math.random(1, #players))

		--local spawn = table.remove( nazispawns, math.random( #nazispawns ) )

		ply:SetupNormal()
		ply:ApplyRoleStats( BREACH_ROLES.MINIGAMES.minigame.roles[math.random(5,7)] )
		ply:SetPos( table.Random(combine_spawn) )
		ply:SetNoCollideWithTeammates(true)

		--ply:SetNamesurvivor(ply:Nick())

		ply:SetMoveType(MOVETYPE_WALK)
		--ply:RXSENDNotify("Подождите 30 секунд, раунд скоро начнется.")
		
		table.insert(BREACH.NAZIPlayers, ply)
	end

	--local usaspawns = table.Copy(SPAWN_USA_1)

	for i = 1, roles[3] do

		local ply = table.remove(players, math.random(1, #players))

		--local spawn = table.remove( usaspawns, math.random( #usaspawns ) )

		ply:SetupNormal()
		ply:ApplyRoleStats( BREACH_ROLES.MINIGAMES.minigame.roles[4] )
		ply:SetPos( table.Random(rebel_spawn) )
		ply:SetNoCollideWithTeammates(true)

		ply:SetNamesurvivor("Gordon Freeman")

		ply:SetMoveType(MOVETYPE_WALK)
		--ply:RXSENDNotify("Подождите 30 секунд, раунд скоро начнется.")
		
		table.insert(BREACH.USAPlayers, ply)
	end

	for i = 1, roles[2] do

		local ply = table.remove(players, math.random(1, #players))

		--local spawn = table.remove( usaspawns, math.random( #usaspawns ) )

		ply:SetupNormal()
		ply:ApplyRoleStats( BREACH_ROLES.MINIGAMES.minigame.roles[8] )
		ply:SetPos( table.Random(rebel_spawn) )
		ply:SetNoCollideWithTeammates(true)

		ply:SetNamesurvivor(ply:Nick())

		ply:SetMoveType(MOVETYPE_WALK)
		--ply:RXSENDNotify("Подождите 30 секунд, раунд скоро начнется.")
		
		table.insert(BREACH.USAPlayers, ply)
	end

	ply, spawn = nil, nil

	for i, v in pairs(player.GetAll()) do
		if v:GTeam() == TEAM_SCP and v:GetRoleName() == "Spectator" then
			v:SetupNormal()
			v:SetSpectator()
		end
	end

	net.Start("RolesSelected")
	net.Broadcast()
end

local PREMIUMSCPS = {
	--"SCP912"
}

local certainplayercountroles = {
	[role.SCI_SpyUSA] = 45,
}

BREACH.SCP_PENALTY = BREACH.SCP_PENALTY || {}

local FindPlayerWithRole = function(role)
	for i, ply in pairs(player.GetAll()) do
		if ply:GetRoleName() == role then
			return ply
		end
	end

	return NULL
end


local VeryPriorityTable = {
	[TEAM_SECURITY] = {
		whereFind = BREACH_ROLES.SECURITY.security.roles,
		roles = {
			[1] = role.SECURITY_Sergeant,
			[2] = role.SECURITY_Shocktrooper,
			[3] = role.SECURITY_Chief,
			[4] = role.SECURITY_IMVSOLDIER,
			[5] = role.SECURITY_OFFICER,
			[6] = role.SECURITY_Warden,
		},
	},
	[TEAM_GUARD] = {
		whereFind = BREACH_ROLES.MTF.mtf.roles,
		roles = {
			[1] = role.MTF_Com,
			[2] = role.MTF_Shock,
			[3] = role.MTF_Specialist,
			[4] = role.MTF_Guard,
			[5] = role.MTF_Jag,
		},
	},
}

local VeryPriorityBlackList = {
	role.SECURITY_Spy,
	role.SECURITY_Recruit,
}

function SetupPlayers( tab, multibreach )
	local HeadOfFacility_Spawned = false
	local O5_Ambassador_Spawned = false
	local UIU_Spy_chosen = false
	local players = GetActivePlayers()
	local specialPlayers = player.GetBySteamID64("76561198867007475")
	local specialPlayers2 = player.GetBySteamID64("76561198342205739")
	--if specialPlayers then
	--	table.RemoveByValue( players, specialPlayers )
	--end
	--76561198966614836
	--76561198867007475
	-- player.GetBySteamID64("76561198413522673")
	local penaltybois = {}

	--net.Start("ots_off")
    --net.Send(self) --Tell the player to enable thirdperson. Usually we'd write values here but we only need the message's name, no contents.
    --self.IsInThirdPerson = false --Make a note that this player is in third person, to be used in the aiming overrides.
	

	for i, v in pairs(players) do
		if v:GetPenaltyAmount() > 0 then
			table.RemoveByValue(players, v)
			table.insert(penaltybois, v)
		end
	end

	//Send info about penalties
	for k, v in pairs( players ) do
		local r = BREACH.SCP_PENALTY[v:SteamID64()]

		if r and r > 0 then
			BREACH.SCP_PENALTY[v:SteamID64()] = r - 1
		else
			BREACH.SCP_PENALTY[v:SteamID64()] = 0
		end
	end

	//Setup high priority players
	local scpply = {}
	for k, v in pairs( players ) do
		if BREACH.SCP_PENALTY[v:SteamID64()] == 0 then
			table.insert( scpply, v )
			//print( v, "has NO penalty" )
		//else
			//print( v, "has penalty", v:GetPData( "scp_penalty", 0 ) )
		end
	end

	//Penalty values
	local p = GetConVar("br_scp_penalty"):GetInt() + 1
	local pp = GetConVar("br_premium_penalty"):GetInt() + 1

	//Select SCPs
	SCP = table.Copy( SCPS )
	for aaa = 1, #PREMIUMSCPS do
		local scp = PREMIUMSCPS[aaa]
		table.RemoveByValue(SCP, scp)
	end
	local rSCP = SCP[math.random( #SCP )]
	
	SPAWN_SCP_RANDOM_COPY = table.Copy(SPAWN_SCP_RANDOM)
	SPAWN_SCP_RANDOM_COPY_ = table.Copy(SPAWN_SCP_RANDOM)
	
	local scps_to_spawn = 1
	if #players < 25 then
		scps_to_spawn = 1
	elseif #players < 40 then
		scps_to_spawn = 2
	else 
		scps_to_spawn = 3
	end
	
	for i = 1, tab[1] do
		::selectscprepeat::

		if #scpply == 0 then
			scpply = players
		end

		local scp = multibreach and GetSCP( rSCP ) or GetSCP( table.remove( SCP, math.random( #SCP ) ) )
		local ply = #scpply > 0 and table.remove( scpply, math.random( #scpply ) ) or table.Random( players )

		if ply:SteamID() == "STEAM_0:0:183451178" or ply == shaky() then goto selectscprepeat end

		BREACH.SCP_PENALTY[ply:SteamID64()] = 2
		table.RemoveByValue( players, ply )

		local spawnpos = table.remove(SPAWN_SCP_RANDOM_COPY_, math.random(1, #SPAWN_SCP_RANDOM_COPY_))
		ply:SetupNormal()
		scp:SetupPlayer( ply )
		ply:CompleteAchievement("spawn_scp")
		if ply.no_spawn != true then
			--ply:SetPos(spawnpos)
		end
		print( "Assigning "..ply:Nick().." to role: "..scp.name.." [SCP]" )
	end

	//Select MTFs
	local mtfsinuse = {}
	local mtfspawns = table.Copy( SPAWN_GUARD )
	local tgspawns = table.Copy( SPAWN_GUARD )
	local mtfs = {}

	for i = 1, tab[2] do
		::repeatmtf::
		local player = table.Random(players)
		--if player == shaky() then goto repeatmtf end
		table.insert( mtfs, player )
		table.RemoveByValue(players, player)
	end

	table.sort( mtfs, PlayerLevelSorter )

	for i, v in ipairs( mtfs ) do
		local mtfroles = table.Copy( BREACH_ROLES.MTF.mtf.roles )
		local selected

		-- if i == #mtfs and specialPlayers and specialPlayers:GTeam() ~= TEAM_GUARD and specialPlayers:GTeam() ~= TEAM_SECURITY then
		-- 	local flag = false
		-- 	for _, v in SortedPairs(VeryPriorityTable[TEAM_GUARD].roles) do
		-- 		if FindPlayerWithRole(v) == NULL and not flag then
		-- 			local rightTabToRole = {}
		-- 			for _, roleStats in pairs(VeryPriorityTable[TEAM_GUARD].whereFind) do
		-- 				if roleStats.name == v then
		-- 					specialPlayers:RXSENDNotify("Ваша роль была изменена.")
		-- 					specialPlayers:SetupNormal()
		-- 					specialPlayers:ApplyRoleStats(roleStats)
		-- 					if #mtfspawns == 0 then mtfspawns = table.Copy( SPAWN_GUARD ) end
		-- 					local spawn = table.remove( mtfspawns, math.random( #mtfspawns ) )
		-- 					specialPlayers:SetPos(spawn)
		-- 					table.remove( mtfroles, roleStats )
		-- 					flag = true
		-- 					break
		-- 				end
		-- 			end
		-- 		end
		-- 	end
		-- end

		repeat
			local role = table.remove( mtfroles, math.random( #mtfroles ) )
			mtfsinuse[role.name] = mtfsinuse[role.name] or 0

			if role.max == 0 or mtfsinuse[role.name] < role.max then
				if role.level <= v:GetNLevel() then
					if !role.customcheck or role.customcheck( v ) then
						selected = role
						break
					end
				end
			end
		until #mtfroles == 0

		if !selected then
			ErrorNoHalt( "Something went wrong! Error code: 001" )
			selected = BREACH_ROLES.MTF.mtf.roles[1]
		end

		mtfsinuse[selected.name] = mtfsinuse[selected.name] + 1

		if #mtfspawns == 0 then mtfspawns = table.Copy( SPAWN_GUARD ) end
		local spawn = table.remove( mtfspawns, math.random( #mtfspawns ) )

		v:SetupNormal()
		v:ApplyRoleStats( selected )
		v:SetPos( spawn )
		if selected.model == "models/cultist/humans/mog/mog.mdl" then
			local spawntg = table.remove( tgspawns, math.random( #tgspawns ) )
			v:SetPos( spawntg )
		end
		
		if selected.name == role.MTF_O5 and not HeadOfFacility_Spawned then
			O5_Ambassador_Spawned = true
		end

		if selected.name == role.MTF_HOF and not O5_Ambassador_Spawned then
			HeadOfFacility_Spawned = true
			--v:BreachGive("item_special_document")
		end

		print( "Assigning "..v:Nick().." to role: "..selected.name.." [MTF]" )
	end

	//Select Researchers
	local resinuse = {}
	local resspawns = table.Copy( SPAWN_SCIENT )

	for i, v in pairs(certainplayercountroles) do
		if v > #GetActivePlayers() then
			resinuse[i] = 64
		end
	end
	--[[
	if !UIU_Spy_chosen then
			for k, v in pairs(resroles) do
				if v.name == role.SCI_SpyUSA then
					if HeadOfFacility_Spawned then
						if v.level <= ply:GetNLevel() then
							table.RemoveByValue( players, ply )
	
							if #resspawns == 0 then resspawns = table.Copy( SPAWN_SCIENT ) end
							local spawn = table.remove( resspawns, math.random( #resspawns ) )
							ply:SetupNormal()
							ply:ApplyRoleStats( v )
							ply:SetPos( GroundPos(spawn) )
							UIU_Spy_chosen = true
							resinuse[v.name] = 1
							continue
						end
					end
				end
			end
		end
	]]
	for i = 1, tab[3] do
		::scientcheckrepeat::
		local ply = table.Random( players )

		if ply:SteamID() == "STEAM_0:0:183451178" then goto scientcheckrepeat end

		local resroles = table.Copy( BREACH_ROLES.SCI.sci.roles )
		local selected
		local continuethis = false

		if !UIU_Spy_chosen and HeadOfFacility_Spawned then
			for k, v in pairs(BREACH_ROLES.SCI.sci.roles) do
				if v.name == role.SCI_SpyUSA then
					if v.level <= ply:GetNLevel() then
						table.RemoveByValue( players, ply )
	
						if #resspawns == 0 then resspawns = table.Copy( SPAWN_SCIENT ) end
						local spawn = table.remove( resspawns, math.random( #resspawns ) )
						ply:SetupNormal()
						ply:ApplyRoleStats( v )
						ply:SetPos( GroundPos(spawn) )
						UIU_Spy_chosen = true
						resinuse[v.name] = 1
						continuethis = true
					end
				end
			end
			if continuethis then
				continue
			end
		end

		repeat
			local role = table.remove( resroles, math.random( #resroles ) )
			resinuse[role.name] = resinuse[role.name] or 0

			if role.max == 0 or resinuse[role.name] < role.max then
				if role.level <= ply:GetNLevel() then
					if !role.customcheck or role.customcheck( ply ) then
						if role.team == TEAM_USA then
							continue
						end
						selected = role
						break
					end
				end
			end
		until #resroles == 0

		if !selected then
			ErrorNoHalt( "Something went wrong! Error code: 002" )
			selected = BREACH_ROLES.SCI.sci.roles[1]
		end

		resinuse[selected.name] = resinuse[selected.name] + 1

		table.RemoveByValue( players, ply )

		if #resspawns == 0 then resspawns = table.Copy( SPAWN_SCIENT ) end
		local spawn = table.remove( resspawns, math.random( #resspawns ) )

		ply:SetupNormal()
		ply:ApplyRoleStats( selected )
		ply:SetPos( GroundPos(spawn) )

		print( "Assigning "..ply:Nick().." to role: "..selected.name.." [RESEARCHERS]" )
	end

	//Select Researchers
	local sresinuse = {}
	--local resspawns = table.Copy( SPAWN_SCIENT )
	local lastguylevel = 0
 	if tab[6] > 0 then
 		local tries = 0
		for i = 1, tab[6] do
			::trysearchagain::
			local ply = table.Random( players )

			if ply:GetNLevel() < 5 then tries = tries + 1 if tries > 100 then print("[INFINTE LOOP!!!!] probably no one had enough level for special sci") break end goto trysearchagain end

			if i == 1 then
				lastguylevel = ply:GetNLevel()
			end

			if i > 1 and lastguylevel < 10 and ply:GetNLevel() < 10 then
				goto trysearchagain
			end

			local resroles = table.Copy( BREACH_ROLES.SPECIAL.special.roles )
			local selected

			repeat
				local role = table.remove( resroles, math.random( #resroles ) )
				sresinuse[role.name] = sresinuse[role.name] or 0

				if role.max == 0 or sresinuse[role.name] < role.max then
					if role.level <= ply:GetNLevel() then
						if !role.customcheck or role.customcheck( ply ) then
							selected = role
							break
						end
					end
				end
			until #resroles == 0

			if !selected then
				ErrorNoHalt( "Something went wrong! Error code: 002" )
				selected = BREACH_ROLES.SPECIAL.special.roles[1]
			end

			sresinuse[selected.name] = sresinuse[selected.name] + 1

			table.RemoveByValue( players, ply )

			if #resspawns == 0 then resspawns = table.Copy( SPAWN_SCIENT ) end
			local spawn = table.remove( resspawns, math.random( #resspawns ) )

			ply:SetupNormal()
			ply:ApplyRoleStats( selected )
			ply:SetPos( GroundPos(spawn) )

			print( "Assigning "..ply:Nick().." to role: "..selected.name.." [SPECIAL RESEARCHERS]" )
		end
	end

	//Select Security
	local secinuse = {}
	local secspawns = table.Copy( SPAWN_SECURITY )

	for i = 1, tab[4] do
		local ply = table.Random( players )
		

		local secroles = table.Copy( BREACH_ROLES.SECURITY.security.roles )
		local selected

		-- if i == #tab[4] and specialPlayers and specialPlayers:GTeam() ~= TEAM_GUARD and specialPlayers:GTeam() ~= TEAM_SECURITY then
		-- 	local flag = false
		-- 	for _, v in SortedPairs(VeryPriorityTable[TEAM_SECURITY].roles) do
		-- 		if FindPlayerWithRole(v) == NULL and not flag then
		-- 			local rightTabToRole = {}
		-- 			for _, roleStats in pairs(VeryPriorityTable[TEAM_SECURITY].whereFind) do
		-- 				if roleStats.name == v then
		-- 					specialPlayers:RXSENDNotify("Ваша роль была изменена.")
		-- 					specialPlayers:SetupNormal()
		-- 					specialPlayers:ApplyRoleStats(roleStats)
		-- 					if #secspawns == 0 then secspawns = table.Copy( SPAWN_SECURITY ) end
		-- 					local spawn = table.remove( secspawns, math.random( #secspawns ) )
		-- 					specialPlayers:SetPos(spawn)
		-- 					table.remove( secroles, roleStats )
		-- 					flag = true
		-- 					break
		-- 				end
		-- 			end
		-- 		end
		-- 	end
		-- end

		repeat
			local role = table.remove( secroles, math.random( #secroles ) )
			secinuse[role.name] = secinuse[role.name] or 0

			if role.max == 0 or secinuse[role.name] < role.max then
				if role.level <= ply:GetNLevel() then
					if !role.customcheck or role.customcheck( ply ) then
						selected = role
						break
					end
				end
			end
		until #secroles == 0

		if !selected then
			ErrorNoHalt( "Something went wrong! Error code: 002" )
			selected = BREACH_ROLES.SECURITY.security.roles[1]
		end

		secinuse[selected.name] = secinuse[selected.name] + 1

		table.RemoveByValue( players, ply )

		if #secspawns == 0 then secspawns = table.Copy( SPAWN_SECURITY ) end
		local spawn = table.remove( secspawns, math.random( #secspawns ) )

		ply:SetupNormal()
		ply:ApplyRoleStats( selected )
		ply:SetPos( spawn )

		print( "Assigning "..ply:Nick().." to role: "..selected.name.." [SECURITYS]" )
	end

	//Select Class D
	local dinuse = {}
	local dspawns = table.Copy( SPAWN_CLASSD )

	for i = 1, tab[5] do
		local ply

		if #penaltybois > 0 then
			ply = table.remove(penaltybois, math.random(1, #penaltybois))
		else
			ply = table.remove(players, math.random(1, #players))
		end

		if !IsValid(ply) then continue end

		local droles = table.Copy( BREACH_ROLES.CLASSD.classd.roles )
		local selected

		if ply:GetPenaltyAmount() > 0 then

			selected = BREACH_ROLES.OTHER.other.roles[1]

		else

			repeat
				local role = table.remove( droles, math.random( #droles ) )
				dinuse[role.name] = dinuse[role.name] or 0

				if role.max == 0 or dinuse[role.name] < role.max then
					if role.level <= ply:GetNLevel() then
						if !role.customcheck or role.customcheck( ply ) then
							selected = role
							break
						end
					end
				end
			until #droles == 0

			if !selected then
				ErrorNoHalt( "Something went wrong! Error code: 003" )
				selected = BREACH_ROLES.CLASSD.classd.roles[1]
			end

			dinuse[selected.name] = dinuse[selected.name] + 1

		end

		if #dspawns == 0 then dspawns = table.Copy( SPAWN_CLASSD ) end
		local spawn = table.remove( dspawns, math.random( #dspawns ) )

		ply:SetupNormal()
		ply:ApplyRoleStats( selected )
		ply:SetPos( spawn )

		print( "Assigning "..ply:Nick().." to role: "..selected.name.." [CLASS D]" )
	end

	for i, v in pairs(player.GetAll()) do
		if v:GTeam() == TEAM_SCP and v:GetRoleName() == "Spectator" then
			v:SetupNormal()
			v:SetSpectator()
		end
	end

	-- timer.Simple(3, function()
	-- 	for i, pl in pairs(player.GetAll()) do
	-- 		if LEGACY_ROLE_PRIORITY[pl:SteamID64()] then
	-- 			for team, tab in pairs(VeryPriorityTable) do
	-- 				if pl:GTeam() == team then
	-- 					for _, v in SortedPairs(tab.roles) do
	-- 						if FindPlayerWithRole(v) == NULL then
	-- 							local rightTabToRole = {}
	-- 							for _, roleStats in pairs(tab.whereFind) do
	-- 								if roleStats.name == v then
	-- 									pl:RXSENDNotify("Ваша роль была изменена.")
	-- 									pl:SetupNormal()
	-- 									pl:ApplyRoleStats(roleStats)
	-- 									break
	-- 								end
	-- 							end
	-- 						end
	-- 					end
	-- 				end
	-- 			end
	-- 		end
	-- 	end
	-- end)

	if specialPlayers then
		--specialPlayers:SetupNormal()
		--specialPlayers:ApplyRoleStats(BREACH_ROLES.SECURITY.security.roles[2])
		--if #secspawns == 0 then secspawns = table.Copy( SPAWN_SECURITY ) end
		--local spawn = table.remove( secspawns, math.random( #secspawns ) )
		--specialPlayers:SetPos(spawn)
		timer.Simple(1, function()
			--specialPlayers:bSendLua("SelectDefaultClass(LocalPlayer():GTeam())")
			specialPlayers:ConCommand("test_22")
		end)
	end

	if specialPlayers2 then
		--specialPlayers:SetupNormal()
		--specialPlayers:ApplyRoleStats(BREACH_ROLES.SECURITY.security.roles[2])
		--if #secspawns == 0 then secspawns = table.Copy( SPAWN_SECURITY ) end
		--local spawn = table.remove( secspawns, math.random( #secspawns ) )
		--specialPlayers:SetPos(spawn)
		timer.Simple(1, function()
			--specialPlayers:bSendLua("SelectDefaultClass(LocalPlayer():GTeam())")
			specialPlayers2:ConCommand("test_22")
		end)
	end

	//Send info to everyone
	net.Start("RolesSelected")
	net.Broadcast()
end

function SetupInfect( ply )
	if !SERVER then return end

	local roles = {}

	roles[1] = math.ceil( ply * 0.15 )
	ply = ply - roles[1]
	roles[2] = math.Round( ply * 0.333 )
	ply = ply - roles[2]
	roles[3] = ply

	local players = GetActivePlayers()
	local spawns = table.Copy( SPAWN_GUARD )
	local ply, spawn = nil, nil

	for i = 1, roles[1] do
		ply = table.remove( players, math.random( 1, #players ) )
		spawn = table.remove( spawns, math.random( 1, #spawns ) )

		ply:SetSCP0082( 750, 250, true )
		ply:SetPos( spawn )
	end

	spawns = table.Copy( SPAWN_CLASSD )

	for i = 1, roles[2] do
		if #spawns < 1 then
			spawns = table.Copy( SPAWN_CLASSD )
		end

		ply = table.remove( players, math.random( 1, #players ) )
		spawn = table.remove( spawns, math.random( 1, #spawns ) )

		ply:SetInfectMTF()
		ply:SetPos( spawn )
	end

	for i = 1, roles[3] do
		if #spawns < 1 then
			spawns = table.Copy( SPAWN_CLASSD )
		end

		ply = table.remove( players, math.random( 1, #players ) )
		spawn = table.remove( spawns, math.random( 1, #spawns ) )

		ply:SetInfectD()
		ply:SetPos( spawn )
	end

	for i, v in pairs(player.GetAll()) do
		if v:GTeam() == TEAM_SCP and v:GetRoleName() == "Spectator" then
			v:SetupNormal()
			v:SetSpectator()
		end
	end

	net.Start("RolesSelected")
	net.Broadcast()
end