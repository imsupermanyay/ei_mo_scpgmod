local CATEGORY_NAME = "娱乐"

------------------------------ Strip ------------------------------
function ulx.stripweapons( calling_ply, target_plys )
	for i=1, #target_plys do
		target_plys[ i ]:StripWeapons()
	end

	ulx.fancyLogAdmin( calling_ply, "#A stripped weapons from #T", target_plys )
end
local strip = ulx.command( CATEGORY_NAME, "ulx strip", ulx.stripweapons, "!strip" )
strip:addParam{ type=ULib.cmds.PlayersArg }
strip:defaultAccess( ULib.ACCESS_ADMIN )
strip:help( "Strip weapons from target(s)." )



------------------------------ God ------------------------------
function ulx.god( calling_ply, target_plys, should_revoke )
	if not target_plys[ 1 ]:IsValid() then
		if not should_revoke then
			Msg( "You are the console, you are already god.\n" )
		else
			Msg( "Your position of god is irrevocable; if you don't like it, leave the matrix.\n" )
		end
		return
	end

	local affected_plys = {}
	for i=1, #target_plys do
		local v = target_plys[ i ]

		if ulx.getExclusive( v, calling_ply ) then
			ULib.tsayError( calling_ply, ulx.getExclusive( v, calling_ply ), true )
		else
			if not should_revoke then
				v:GodEnable()
				v.ULXHasGod = true
			else
				v:GodDisable()
				v.ULXHasGod = nil
			end
			table.insert( affected_plys, v )
		end
	end

	if not should_revoke then
		ulx.fancyLogAdmin( calling_ply, "#A granted god mode upon #T", affected_plys )
	else
		ulx.fancyLogAdmin( calling_ply, "#A revoked god mode from #T", affected_plys )
	end
end
local god = ulx.command( CATEGORY_NAME, "ulx god", ulx.god, "!god" )
god:addParam{ type=ULib.cmds.PlayersArg, ULib.cmds.optional }
god:addParam{ type=ULib.cmds.BoolArg, invisible=true }
god:defaultAccess( ULib.ACCESS_ADMIN )
god:help( "Grants god mode to target(s)." )
god:setOpposite( "ulx ungod", {_, _, true}, "!ungod" )

------------------------------ Hp ------------------------------
function ulx.hp( calling_ply, target_plys, amount )
	for i=1, #target_plys do
		target_plys[ i ]:SetHealth( amount )
	end
	ulx.fancyLogAdmin( calling_ply, "#A set the hp for #T to #i", target_plys, amount )
end
local hp = ulx.command( CATEGORY_NAME, "ulx hp", ulx.hp, "!hp" )
hp:addParam{ type=ULib.cmds.PlayersArg }
hp:addParam{ type=ULib.cmds.NumArg, min=1, max=2^32/2-1, hint="hp", ULib.cmds.round }
hp:defaultAccess( ULib.ACCESS_ADMIN )
hp:help( "Sets the hp for target(s)." )

------------------------------ Noclip ------------------------------
local function RecursiveSetPreventTransmit(ent, ply, stopTransmitting)
    if ent ~= ply and IsValid(ent) and IsValid(ply) then
        ent:SetPreventTransmit(ply, stopTransmitting)
        local tab = ent:GetChildren()
        for i = 1, #tab do
            RecursiveSetPreventTransmit(tab[ i ], ply, stopTransmitting)
        end
    end
end

function ulx.noclip( calling_ply, target_plys )
	if not target_plys[ 1 ]:IsValid() then
		Msg( "You are god, you are not constrained by walls built by mere mortals.\n" )
		return
	end

	local affected_plys = {}
	for i=1, #target_plys do
		local v = target_plys[ i ]

		if v.NoNoclip then
			ULib.tsayError( calling_ply, v:Nick() .. " can't be noclipped right now.", true )
		else
			if v:GetMoveType() == MOVETYPE_WALK then
				v:SetMoveType( MOVETYPE_NOCLIP )
				table.insert( affected_plys, v )
				v.Was_GodEnabled = v:HasGodMode()
				v:GodEnable()
				v:SetNoDraw(true)
				v:SetNoTarget(true)
				v:SetNoCollideWithTeammates(true)

				local steamid64 = v:SteamID64()

				for _, gay in ipairs(player.GetAll()) do
					RecursiveSetPreventTransmit(v, gay, true)
				end

				timer.Create("AdminObserver_"..steamid64, 1, 0, function()
					if !IsValid(v) then
						timer.Remove("AdminObserver_"..steamid64)
						return
					end

					if v:GetMoveType() != MOVETYPE_NOCLIP then
						for _, gay in ipairs(player.GetAll()) do
							RecursiveSetPreventTransmit(v, gay, false)
						end
						timer.Remove("AdminObserver_"..steamid64)
						return
					end

					for _, gay in ipairs(player.GetAll()) do
						RecursiveSetPreventTransmit(v, gay, true)
					end
				end)
			elseif v:GetMoveType() == MOVETYPE_NOCLIP then
				v:SetMoveType( MOVETYPE_WALK )
				table.insert( affected_plys, v )
				if !v.Was_GodEnabled then
					v:GodDisable()
				end
				v.Was_GodEnabled = nil
				if v:GetRoleName() != "SCP173" then
					v:SetNoDraw(false)
				end
				v:SetNoCollideWithTeammates(false)
				v:SetNoTarget(false)
				for _, gay in ipairs(player.GetAll()) do
					RecursiveSetPreventTransmit(v, gay, false)
				end
				local steamid64 = v:SteamID64()
				timer.Remove("AdminObserver_"..steamid64)
			else -- Ignore if they're an observer
				ULib.tsayError( calling_ply, v:Nick() .. " can't be noclipped right now.", true )
			end
		end
	end
end
local noclip = ulx.command( CATEGORY_NAME, "ulx noclip", ulx.noclip, "!noclip" )
noclip:addParam{ type=ULib.cmds.PlayersArg, ULib.cmds.optional }
noclip:defaultAccess( ULib.ACCESS_ADMIN )
noclip:help( "Toggles noclip on target(s)." )