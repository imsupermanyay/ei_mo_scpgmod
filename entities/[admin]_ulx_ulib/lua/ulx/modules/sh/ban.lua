local CATEGORY_NAME = "封禁菜单"

------------------------------ Ban ------------------------------
function ulx.ban( calling_ply, target_ply, amount, reason )
	local minutes = amount
	if target_ply:IsListenServerHost() or target_ply:IsBot() then
		ULib.tsayError( calling_ply, "This player is immune to banning", true )
		return
	end

	if IsValid(calling_ply) then
		local muhaha = hook.Call("shbr_AdminBan", GAMEMODE, calling_ply)

		if muhaha == false then return end -- cancel !!!
	end

	local time = "for #s"
	if minutes == 0 then time = "permanently" end
	local str = "#A banned #T " .. time
	if reason and reason ~= "" then str = str .. " (#s)" end
	ulx.fancyLogAdmin( calling_ply, str, target_ply, minutes ~= 0 and ULib.secondsToStringTime( minutes * 60 ) or reason, reason )

	-- Delay by 1 frame to ensure any chat hook finishes with player intact. Prevents a crash.

	local timeban = os.time() + minutes*60

	if minutes == 0 then timeban = 0 end

	BREACH.Punishment:Ban(target_ply, calling_ply, timeban, reason)

	minutes = minutes * 60

	local timestring = string.NiceTime(minutes)

	local logtext = "Banned "..target_ply:Name().." Permanently"
	if time != 0 then
		logtext = "Banned "..target_ply:Name().." for "..timestring
	end
	local logreason = ""
	if reason != nil and reason != "" then
		logreason = reason
	end
	AdminActionLog(calling_ply, target_ply, logtext, logreason)

end
local ban = ulx.command( CATEGORY_NAME, "ulx ban", ulx.ban, "!ban", false, false, true )
ban:addParam{ type=ULib.cmds.PlayerArg }
ban:addParam{ type = ULib.cmds.NumArg, min=1000 }
ban:addParam{ type=ULib.cmds.StringArg, hint="reason", ULib.cmds.optional, ULib.cmds.takeRestOfLine, completes=ulx.common_kick_reasons }
ban:defaultAccess( ULib.ACCESS_ADMIN )
ban:help( "Bans target." )

------------------------------ BanID ------------------------------
function ulx.banid( calling_ply, steamid, amount, reason )
	local minutes = amount
	steamid = steamid:upper()
	if not ULib.isValidSteamID( steamid ) then
		ULib.tsayError( calling_ply, "Invalid steamid." )
		return
	end

	if IsValid(calling_ply) then
		local muhaha = hook.Call("shbr_AdminBan", GAMEMODE, calling_ply)

		if muhaha == false then return end -- cancel !!!
	end

	local name, target_ply
	local plys = player.GetAll()
	for i=1, #plys do
		if plys[ i ]:SteamID() == steamid then
			target_ply = plys[ i ]
			name = target_ply:Nick()
			break
		end
	end

	if target_ply and (target_ply:IsListenServerHost() or target_ply:IsBot()) then
		ULib.tsayError( calling_ply, "This player is immune to banning", true )
		return
	end

	local time = "for #s"
	if minutes == 0 then time = "permanently" end
	local str = "#A banned steamid #s "
	displayid = steamid
	if name then
		displayid = displayid .. "(" .. name .. ") "
	end
	str = str .. time
	if reason and reason ~= "" then str = str .. " (#4s)" end
	ulx.fancyLogAdmin( calling_ply, str, displayid, minutes ~= 0 and minutes .. " hours" or reason, reason )
	-- Delay by 1 frame to ensure any chat hook finishes with player intact. Prevents a crash.
	--ULib.queueFunctionCall( ULib.addBan, steamid, minutes, reason, name, calling_ply )

	minutes = minutes * 60

	local timeban = os.time() + minutes*60

	if minutes == 0 then timeban = 0 end

	BREACH.Punishment:Ban(steamid, calling_ply, timeban, reason)

	steamid = util.SteamIDTo64(steamid)

	local timestring = string.NiceTime(minutes)

	local logtext = "Banned "..steamid.." Permanently"
	if time != 0 then
		logtext = "Banned "..steamid.." for "..timestring
	end
	local logreason = ""
	if reason != nil and reason != "" then
		logreason = reason
	end
	AdminActionLog(calling_ply, steamid, logtext, logreason)
end
local banid = ulx.command( CATEGORY_NAME, "ulx banid", ulx.banid, "!banid", false, false, true )
banid:addParam{ type=ULib.cmds.StringArg, hint="steamid" }
banid:addParam{ type = ULib.cmds.NumArg, min=1 }
banid:addParam{ type=ULib.cmds.StringArg, hint="reason", ULib.cmds.optional, ULib.cmds.takeRestOfLine, completes=ulx.common_kick_reasons }
banid:defaultAccess( ULib.ACCESS_SUPERADMIN )
banid:help( "Bans steamid." )

function ulx.unban( calling_ply, steamid )
	steamid = steamid:upper()
	if not ULib.isValidSteamID( steamid ) then
		ULib.tsayError( calling_ply, "Invalid steamid." )
		return
	end

	name = ULib.bans[ steamid ] and ULib.bans[ steamid ].name

	ULib.unban( steamid, calling_ply )
	if name then
		ulx.fancyLogAdmin( calling_ply, "#A unbanned steamid #s", steamid .. " (" .. name .. ")" )
	else
		ulx.fancyLogAdmin( calling_ply, "#A unbanned steamid #s", steamid )
	end

	AdminActionLog(calling_ply, util.SteamIDTo64(steamid), "Unbanned "..util.SteamIDTo64(steamid), reason || "")
end
local unban = ulx.command( CATEGORY_NAME, "ulx unban", ulx.unban, nil, false, false, true )
unban:addParam{ type=ULib.cmds.StringArg, hint="steamid" }
unban:defaultAccess( ULib.ACCESS_ADMIN )
unban:help( "Unbans steamid." )

function ulx.kick( calling_ply, target_ply, reason )
	if target_ply:IsListenServerHost() then
		ULib.tsayError( calling_ply, "This player is immune to kicking", true )
		return
	end

	if reason and reason ~= "" then
		ulx.fancyLogAdmin( calling_ply, "#A kicked #T (#s)", target_ply, reason )
	else
		reason = nil
		ulx.fancyLogAdmin( calling_ply, "#A kicked #T", target_ply )
	end
	-- Delay by 1 frame to ensure the chat hook finishes with player intact. Prevents a crash.
	ULib.queueFunctionCall( ULib.kick, target_ply, reason, calling_ply )

	AdminActionLog(calling_ply, target_ply, "Kicked "..target_ply:Name(), reason || "")
end
local kick = ulx.command( CATEGORY_NAME, "ulx kick", ulx.kick, "!kick" )
kick:addParam{ type=ULib.cmds.PlayerArg }
kick:addParam{ type=ULib.cmds.StringArg, hint="reason", ULib.cmds.optional, ULib.cmds.takeRestOfLine, completes=ulx.common_kick_reasons }
kick:defaultAccess( ULib.ACCESS_ADMIN )
kick:help( "Kicks target." )
