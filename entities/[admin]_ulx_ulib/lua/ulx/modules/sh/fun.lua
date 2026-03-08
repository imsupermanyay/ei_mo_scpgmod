local CATEGORY_NAME = "处死菜单"

------------------------------ Slay ------------------------------
function ulx.slay( calling_ply, v )
	local affected_plys = {}

	--for i=1, #target_plys do
		--local v = target_plys[ i ]

		v:Kill()
		table.insert( affected_plys, v )
		
		if v != calling_ply then AdminActionLog( calling_ply, v, "Slayed "..v:Name(), "" ) end

	--end

	ulx.fancyLogAdmin( calling_ply, "#A slayed #T", affected_plys )
end
local slay = ulx.command( CATEGORY_NAME, "ulx slay", ulx.slay, "!slay" )
slay:addParam{ type=ULib.cmds.PlayerArg }
slay:defaultAccess( ULib.ACCESS_ADMIN )
slay:help( "Slays target(s)." )

------------------------------ Sslay ------------------------------
function ulx.sslay( calling_ply, v )
	local affected_plys = {}

	--for i=1, #target_plys do
		--local v = target_plys[ i ]
			if v:InVehicle() then
				v:ExitVehicle()
			end

			v:LevelBar()

			v:SetupNormal()
			v:SetSpectator()

			v:RXSENDNotify("Вы были переведены в команду наблюдателей")
			table.insert( affected_plys, v )

			if v != calling_ply then AdminActionLog( calling_ply, v, "Silently Slayed "..v:Name(), "" ) end
	--end
end
local sslay = ulx.command( CATEGORY_NAME, "ulx sslay", ulx.sslay, "!sslay" )
sslay:addParam{ type=ULib.cmds.PlayerArg }
sslay:defaultAccess( ULib.ACCESS_ADMIN )
sslay:help( "Silently slays target(s)." )

------------------------------ Maul ------------------------------
local zombieDeath -- We need these registered up here because functions reference each other.
local checkMaulDeath

local function newZombie( pos, ang, ply, b )
		local ent = ents.Create( "npc_fastzombie" )
		ent:SetPos( pos )
		ent:SetAngles( ang )
		ent:Spawn()
		ent:Activate()
		ent:AddRelationship("player D_NU 98") -- Don't attack other players
		ent:AddEntityRelationship( ply, D_HT, 99 ) -- Hate target

		ent:DisallowDeleting( true, _, true )
		ent:DisallowMoving( true )

		if not b then
			ent:CallOnRemove( "NoDie", zombieDeath, ply )
		end

		return ent
end