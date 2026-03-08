local surface = surface
local Material = Material
local draw = draw
local DrawBloom = DrawBloom
local DrawSharpen = DrawSharpen
local DrawToyTown = DrawToyTown
local Derma_StringRequest = Derma_StringRequest;
local RunConsoleCommand = RunConsoleCommand;
local tonumber = tonumber;
local tostring = tostring;
local CurTime = CurTime;
local Entity = Entity;
local unpack = unpack;
local table = table;
local pairs = pairs;
local ScrW = ScrW;
local ScrH = ScrH;
local concommand = concommand;
local timer = timer;
local ents = ents;
local hook = hook;
local math = math;
local draw = draw;
local pcall = pcall;
local ErrorNoHalt = ErrorNoHalt;
local DeriveGamemode = DeriveGamemode;
local vgui = vgui;
local util = util
local net = net
local player = player
local TCV = "V0.1"

/*
local hide = {
	CHudHealth = true,
	CHudBattery = true,
	CHudAmmo = true,
	CHudSecondaryAmmo = true,
	CHudDeathNotice = true,
	CHudPoisonDamageIndicator = true,
	CHudSquadStatus = true,
	CHudWeaponSelection = true,
	CHudCrosshair = true,
	CHudDamageIndicator = true,
	CHUDQuickInfo = true,
	CHudVoiceStatus = true,
	CHUDAutoAim = true,
	CHudVoiceSelfStatus = true,
	CHudChat = true
} */
 --Impact

surface.CreateFont("Waitingmini", {font = "Hitmarker Normal",
                                  size = 40,
								  extended = true,
                                  weight = 500,	outline = true})

surface.CreateFont("Waiting", {font = "Hitmarker Normal",
                                  size = 70,
								  extended = true,
                                  weight = 500,	outline = true})

surface.CreateFont("ImpactBig4", {font = "Hitmarker Normal",
                                  size = 150,
								  extended = true,
								  scanlines = 3,
                                  weight = 200})
surface.CreateFont("ImpactBig3", {font = "Hitmarker Normal",
                                  size = 100,
								  extended = true,
								  scanlines = 3,
                                  weight = 200})
surface.CreateFont("ImpactBig3m", {font = "Hitmarker Normal",
                                  size = 90,
								  extended = true,
								  scanlines = 3,
                                  weight = 200})
surface.CreateFont("ImpactBig2", {font = "Hitmarker Normal",
                                  size = 70,
								  extended = true,
								  scanlines = 3,
                                  weight = 200})

surface.CreateFont("ImpactBig", {font = "Hitmarker Normal",
                                  size = 45,
								  	extended = true,
								  scanlines = 3,
                                  weight = 700})
surface.CreateFont("ImpactSmall42", {font = "Hitmarker Normal",
                                  size = 35,
								  	extended = true,
								  scanlines = 3,
                                  weight = 700})
surface.CreateFont("ImpactSmall", {font = "Hitmarker Normal",
                                  size = 30,
								  	extended = true,
								  scanlines = 3,
                                  weight = 700})
surface.CreateFont("ImpactSmallest", {font = "Hitmarker Normal",
                                  size = 20,
								  	extended = true,
								  scanlines = 3,
                                  weight = 700})
surface.CreateFont("ImpactSmall2", {font = "Hitmarker Normal",
                                  size = 15,
								  	extended = true,
								  scanlines = 3,
                                  weight = 700})

surface.CreateFont("ImpactSmall2n", {font = "Hitmarker Normal",
                                  size = 15,
								  	extended = true,
								  scanlines = 0,
                                  weight = 500})

surface.CreateFont("ImpactSmall22", {font = "Hitmarker Normal",
                                  size = 5,
								  	extended = true,
								  scanlines = 3,
                                  weight = 300})

surface.CreateFont( "RadioFont", {
	font = "Hitmarker Normal",
	extended = true,
	size = 26,
	weight = 7000,
	blursize = 0,
	scanlines = 2,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

surface.CreateFont("new_spec_2", {font = "Hitmarker Normal",
                                  size = 30,
								  	extended = true,
								  scanlines = 0,
                                  weight = 700})

local custom_vector = Vector( 1, 1, 1 )

hook.Remove("HUDPaint", "BreachTEST")

local ANGLE = FindMetaTable( "Angle" )

local client = LocalPlayer()

net.Receive("create_Headshot", function(len)

	local en = net.ReadEntity()
	local origin = net.ReadVector()
	local Normal = net.ReadVector()

	local efdata = EffectData()
	efdata:SetEntity(en)
	efdata:SetOrigin(origin)
	efdata:SetNormal(Normal)
	util.Effect( "headshot", efdata )

end)

local clr_green = Color( 0, 255, 0 )

function NewProgressLevelBar( stats, my_xp )

	local client = LocalPlayer()
	local total_exp = 0

	for _, v in ipairs( stats ) do

		v.value = math.floor( v.value )

		total_exp = total_exp + v.value

	end

	--[[
	if ( client:GetUserGroup() == "premium" ) then

		stats[ #stats + 1 ] = { reason = "Premium bonus", value = math.abs( total_exp ) }

	end]]

	table.SortByMember( stats, "value", true )

	if ( !BREACH.Level ) then

		BREACH.Level = {}

	end

	local screenwidth, screenheight = ScrW(), ScrH()

	BREACH.Level.main_panel = vgui.Create( "DPanel" )
	BREACH.Level.main_panel:SetSize( screenwidth * .6, 32 )
	BREACH.Level.main_panel:SetPos( screenwidth * .2, screenheight * .85 )
	BREACH.Level.main_panel.StartValue =  my_xp || 0
	BREACH.Level.main_panel.Value = my_xp || 0
  BREACH.Level.main_panel.DebugTime = CurTime() + 15
	BREACH.Level.main_panel.Maximum = client:RequiredEXP()
	BREACH.Level.main_panel.Removing = false

	BREACH.Level.main_panel.Paint = function( self, w, h )

		if ( self.Removing || self.DebugTime < CurTime() ) then

			self:SetAlpha( math.Approach( self:GetAlpha(), 0, RealFrameTime() * 512 ) )

			if ( self:GetAlpha() == 0 ) then

				self:Remove()
                BREACH.Level.main_panel = nil
                BREACH.Level.EXP_Panel_Child = nil
                BREACH.Level.EXP_Panel_Table = nil

			end

		end

		draw.RoundedBox( 0, 0, 0, w, h, color_black )

		draw.RoundedBox( 0, 2, 2, w * ( self.Value / self.Maximum ) - 4, h - 4, color_white )

		draw.SimpleText( self.Value .. " / " .. self.Maximum, "HUDFontTitle", w / 2, h / 2, clr_green, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

	end

	BREACH.Level.EXP_Panel_Table = stats

	BREACH.Level.EXP_Panel = vgui.Create( "DPanel" )
	BREACH.Level.EXP_Panel:SetSize( screenwidth * .6, 128 )
	BREACH.Level.EXP_Panel:SetPos( screenwidth * .2, screenheight * .85 - 128 )
	BREACH.Level.EXP_Panel.Paint = function( self, w, h ) end

	BREACH.Level.EXP_Panel_Child = {}

	local exp_panel_width, exp_panel_height = BREACH.Level.EXP_Panel:GetSize()
	for i = 1, #BREACH.Level.EXP_Panel_Table do

		BREACH.Level.EXP_Panel_Child[ i ] = vgui.Create( "DPanel", BREACH.Level.EXP_Panel )
		BREACH.Level.EXP_Panel_Child[ i ].Value = BREACH.Level.EXP_Panel_Table[ i ].value
		BREACH.Level.EXP_Panel_Child[ i ].Reason = BREACH.Level.EXP_Panel_Table[ i ].reason
		BREACH.Level.EXP_Panel_Child[ i ].ID = i

		if ( BREACH.Level.EXP_Panel_Child[ i ].Value < 0 ) then

			BREACH.Level.EXP_Panel_Child[ i ].clr = Color( 255, 0, 0 )

		else

			BREACH.Level.EXP_Panel_Child[ i ].clr = Color( 0, 255, 0 )

		end

		surface.SetFont( "HUDFont" )

		local text_to_print

		if ( BREACH.Level.EXP_Panel_Child[ i ].Value > 0 ) then

			text_to_print = BREACH.Level.EXP_Panel_Child[ i ].Reason .. " +" .. BREACH.Level.EXP_Panel_Child[ i ].Value

		else

			text_to_print = BREACH.Level.EXP_Panel_Child[ i ].Reason .. " -" .. BREACH.Level.EXP_Panel_Child[ i ].Value

		end

		local reason_width, reason_height = surface.GetTextSize( text_to_print )

		BREACH.Level.EXP_Panel_Child[ i ]:SetPos( exp_panel_width / 2, exp_panel_height / 2 - reason_height / 2 )
		BREACH.Level.EXP_Panel_Child[ i ]:SetSize( reason_width+1000, reason_height )
		BREACH.Level.EXP_Panel_Child[ i ].CreationTime = RealTime() + 3

		if ( i == 1 ) then

			BREACH.Level.EXP_Panel_Child[ i ].Play = true

		end

		BREACH.Level.EXP_Panel_Child[ i ].Paint = function( self, w, h )

			if ( self.ShouldMove ) then

				self.ShouldMove = false
				self:MoveTo( exp_panel_width / 2, exp_panel_height / 2 - reason_height / 2, .1, 0, -1, function()

					self.Play = true

				end )

			end

            if ( !IsValid( BREACH.Level.EXP_Panel ) ) then

                self:Remove()

            end

			if ( !self.Play ) then

				if ( !self.PosSet ) then

					self.PosSet = true
					self:SetPos( exp_panel_width / 2, exp_panel_height / 2 - reason_height / 2 - ( reason_height * ( i - 1 ) ) )

				end

				self.font = "LevelBarLittle"
				self:SetAlpha( 100 )

			else

				self:SetAlpha( 255 )
				self.font = "LevelBar"

			end

			if ( self.Play && self.CreationTime < RealTime() ) then

				if ( !self.ToReach ) then

					self.ToReach = BREACH.Level.main_panel.Value + self.Value

				end

                if ( !BREACH.Level.main_panel ) then self:Remove() return end

				BREACH.Level.main_panel.Value = math.Round( math.Approach( BREACH.Level.main_panel.Value, self.ToReach, RealFrameTime() * 1024 ) )

				if ( BREACH.Level.main_panel.Value >= BREACH.Level.main_panel.Maximum ) then

					self.ToReach = self.ToReach - BREACH.Level.main_panel.Value

					BREACH.Level.main_panel.Value = 0
					BREACH.Level.main_panel.Maximum = client:RequiredEXP() + (client:RequiredEXP() / client:GetNLevel())
					BREACH.Level.main_panel.StartValue = 0

				end

				if ( BREACH.Level.main_panel.Value == self.ToReach && !self.StartMoving ) then

					self.StartMoving = true

					self:MoveTo( exp_panel_width / 2, exp_panel_height, .5, 0, -1, function()

						table.remove( BREACH.Level.EXP_Panel_Child, self.ID )

						for k, v in ipairs( BREACH.Level.EXP_Panel_Child ) do

                            v.ID = k

							if ( k != 1 ) then

								BREACH.Level.EXP_Panel_Child[ k ]:MoveTo( exp_panel_width / 2, exp_panel_height / 2 - reason_height / 2 - ( reason_height * ( k - 1 ) ), .1, 0, -1, function() end )

							end

						end

						if ( BREACH.Level.EXP_Panel_Child[ 1 ] ) then

							BREACH.Level.EXP_Panel_Child[ 1 ].ShouldMove = true

						end

						if ( #BREACH.Level.EXP_Panel_Child == 0 ) then

							BREACH.Level.main_panel.Removing = true

							BREACH.Level.EXP_Panel:Remove()

                            if ( BREACH.Level && BREACH.Level.EXP_Panel ) then

							  BREACH.Level.EXP_Panel = nil

                            end

						end

						self:Remove()

					end )

				end

			end

			surface.SetFont( self.font )
			surface.SetTextColor( self.clr )
			surface.SetTextPos( 0, 0 )

			if ( self.clr == color_white ) then

				if ( self.ToReach ) then

					surface.DrawText( BREACH.TranslateString(self.Reason) .. " " .. self.ToReach - BREACH.Level.main_panel.Value )

				else

					surface.DrawText( BREACH.TranslateString(self.Reason) .. " " .. self.Value )

				end

			else

				if ( !self.ToReach ) then

					surface.DrawText( BREACH.TranslateString(self.Reason) .. " " .. self.Value )

				else

					surface.DrawText( BREACH.TranslateString(self.Reason) .. " " .. self.ToReach - BREACH.Level.main_panel.Value )

				end

			end

		end

	end

end

local banned_Teams = {

  [ TEAM_SPEC ] = true,
  [ TEAM_SCP ] = true

}

local LCSpacing = -30
local wepclr = Color( 198, 198, 198, 210 )
local txtclr = Color( 127, 127, 127, 180 )

local scp_049_text_col1 = Color( 0, 180, 127, 180 )
local scp_049_text_col2 = Color( 200, 127, 127, 180 )
local chaoscolor = Color(29, 81, 56)

hook.Add("PreDrawOutlines", "CHAOS_SPY", function()

	local client = LocalPlayer()
  local client_team = client:GTeam()
  --local cl_pos = client:GetPos()
  	if client_team == TEAM_CHAOS or client_team == TEAM_CLASSD then
	  for i = 1, #player.GetAll() do

	  	local ply = player.GetAll()[i]

	  	if ply == client then continue end
	  	if ply:GetRoleName() != role.SECURITY_Spy then continue end
	  	if ply:Health() < 0 then continue end

	  	--if ply:GetPos():DistToSqr(cl_pos) > 25000 then continue end

			local entstab = ply:LookupBonemerges()
			entstab[#entstab + 1] = ply

			outline.Add(entstab, chaoscolor, OUTLINE_MODE_VISIBLE)

	  end
	end
	if client_team == TEAM_CBG then
	  for i = 1, #player.GetAll() do

	  	local ply = player.GetAll()[i]

	  	if ply == client then continue end
	  	if ply:GetRoleName() != role.CBG_Spec then continue end
	  	if ply:Health() < 0 then continue end

	  	--if ply:GetPos():DistToSqr(cl_pos) > 25000 then continue end

			local entstab = ply:LookupBonemerges()
			entstab[#entstab + 1] = ply

			outline.Add(entstab, Color(200, 127, 127), OUTLINE_MODE_VISIBLE)

	  end
	end
end)

local green = Color(0, 255, 0)
local black = Color(0, 0, 0)
local red = Color(255, 0, 0)
local backgroundmat = Material( "nextoren_hud/inventory/menublack.png" )
hook.Add("HUDPaint", "DrawBoxInfoOnRagdoll", function()

  local client = LocalPlayer()
  local client_team = client:GTeam()

  if ( banned_Teams[ client_team ] && client:GetRoleName() != "SCP049" || client:Health() <= 0 ) then return end

	local tr = client:GetEyeTrace()

	local ent = tr.Entity

	if ( !( ent && ent:IsValid() ) ) then return end

  local is_wep = ent:IsWeapon()

  if ( ent:GetClass() != "prop_ragdoll" && !is_wep ) then return end

	local Distance = ent:GetPos():DistToSqr( client:GetPos() )

  if ( Distance <= 6400 && is_wep ) then

    local tab = { ent }
    outline.Add( tab, wepclr, OUTLINE_MODE_VISIBLE )

  elseif ( Distance <= 2500 && client:HasWeapon( "weapon_scp_049_redux" ) ) then

    local tab = { ent }
    outline.Add( tab, wepclr, OUTLINE_MODE_VISIBLE )

    local screenheight = ScrH()

    local x_text = ScrW() / 2

	if ent:GetNWBool("Death_SCP049_IsVictim", false) then
		if ent:GetNWBool("Death_SCP049_CanRessurect", false) then
    		draw.SimpleText( L("l:scp049_targetisalive"), "LC.MenuFont", x_text, screenheight / 2.6, scp_049_text_col1, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    		draw.SimpleText( L("l:scp049_press_e"), "LC.MenuFont", x_text, screenheight / 2.3, txtclr, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    		draw.SimpleText( L("l:scp049_press_r"), "LC.MenuFont", x_text, screenheight / 2, scp_049_text_col2, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		else
			draw.SimpleText( L("l:scp049_targetisdead"), "LC.MenuFont", x_text, screenheight / 2, red, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
	end

	elseif ( Distance <= 2500 && !IsValid( LC_LootMenu ) && client_team != TEAM_SCP ) then

    local tab = { ent }
    local bnmrgtab = ents.FindByClassAndParent("ent_bonemerged", ent)
	if istable(bnmrgtab) then
		tab = bnmrgtab
		tab[#tab + 1] = ent
	end
		outline.Add( tab, wepclr, OUTLINE_MODE_VISIBLE )

    local screenwidth, screenheight = ScrW(), ScrH()

    local middle_w = screenwidth / 2
    local middle_h = screenheight / 2

    draw.Blur(middle_w-175, middle_h-28, 350, 75)
		surface.SetDrawColor( 0, 0, 0, 100)
		surface.DrawRect( middle_w-176, middle_h-29, 352, 77)
		surface.SetMaterial(backgroundmat)
		surface.DrawTexturedRect( middle_w-175, middle_h-28, 350, 75)

		local body_time = ent:GetNWInt("DiedWhen", false)
		local minutes = BREACH.TranslateString("l:body_cant_determine_death_time")
		if body_time then
			local timesincedeath = os.time() - body_time
			minutes = timesincedeath / 60

			if minutes < 1 then
				minutes = BREACH.TranslateString("l:body_died_right_now")
			else
				minutes = math.Round(minutes)
				local lastdigit = math.floor(minutes%10)
				local realstring= ""
				if minutes >= 10 and minutes <= 20 or lastdigit > 4 then
					realstring = "  l:body_minutes_ago"
				elseif lastdigit == 1 then
					realstring = "  l:body_1minute_ago"
				elseif lastdigit > 1 and lastdigit < 5 then
					realstring = "  l:body_2to4minutes_ago"
				end

				minutes = BREACH.TranslateString("l:body_death_happened  "..math.Round(minutes)..realstring)
			end
		end

		draw.SimpleTextOutlined( ent:GetNWString("SurvivorName", ""), "HUDFont", middle_w, screenheight / 2.5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 0.5, black)
    	draw.SimpleTextOutlined(BREACH.TranslateString(ent:GetNWString("DeathReason1", "l:body_death_unknown")), "HUDFont", middle_w, screenheight / 1.95 + 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 0.5, black)
		draw.SimpleTextOutlined( BREACH.TranslateString(ent:GetNWString("DeathReason2", "")), "HUDFont", middle_w, screenheight / 1.95 + 18, red, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 0.5, black)
		draw.SimpleText( input.LookupBinding("+use") and string.upper(input.LookupBinding("+use")) or "+use", "HUDFont", middle_w + LCSpacing-5, middle_h - 15, green, 0, 1)
		draw.SimpleTextOutlined( BREACH.TranslateString(" - l:body_search"), "HUDFont", middle_w + LCSpacing, middle_h - 15, color_white, 0, 1, 0.5, black)
		draw.SimpleTextOutlined( minutes, "HUDFont", middle_w, middle_h, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 0.5, black)

	end

end)

local scarletmat = Material("nextoren/gui/roles_icon/crb.png")
	hook.Add( "PostDrawTranslucentRenderables", "crb_draw_mark", function( bDepth, bSkybox )
    	local client = LocalPlayer()
		local capos = CBG_COG_VECTOR
		if CBG_COG_VECTOR then
		if capos == Vector(0, 0, 0) then return end
		local ang = client:EyeAngles()
		ang:RotateAroundAxis( ang:Forward(), 90 )
		ang:RotateAroundAxis( ang:Right(), 90 )
		capos = capos + Vector(0,0, 50)
		local dist = client:GetPos():Distance(capos)
		local size = 140 * (math.Clamp(dist * .005, 1, 30))
		if client:GTeam() == TEAM_CBG then
			cam.Start3D2D( capos, ang, 0.1 )
			cam.IgnoreZ(true)
				surface.SetDrawColor(ColorAlpha(color_white, 255 - Pulsate(5) * 40))
				surface.SetMaterial(scarletmat)
				surface.DrawTexturedRect(-(size/2), -(size/2), size, size);
			cam.End3D2D()
			cam.IgnoreZ(false)
		end
		end
	end)

net.Receive("LevelBar", function()
	local client = LocalPlayer()
	local stats = net.ReadTable()
	local exp = net.ReadUInt(32)
	NewProgressLevelBar(stats, exp)
end)

local Dead_Body = false
local Death_Scene = false
local Death_Blur_Intensity = 0
local Death_Desaturation_Intensity = 1

--local alpha_color = 0
--local final_color = 255
local clr_blood = Color(102, 0, 0)
local clr_red = Color(255, 0, 0)
local clr_gray = Color(198, 198, 198)

function CorpsedMessage(msg)
	local col = gteams.GetColor(LocalPlayer():GTeam())
	
	if !msg then
		msg = BREACH.TranslateString("l:cutscene_kia")
	end
	
	local name
	
	if LocalPlayer():GTeam() == TEAM_SCP then
		name = BREACH.TranslateString("l:cutscene_subject ")..GetLangRole(LocalPlayer():GetRoleName())
	else
		name = BREACH.TranslateString("l:cutscene_subject_name ")..LocalPlayer():GetNamesurvivor().. " - "..GetLangRole(LocalPlayer():GetRoleName())
	end
	
	local CutSceneWindow = vgui.Create("DPanel")
	CutSceneWindow:SetText("")
	CutSceneWindow:SetSize(ScrW(), ScrH())
	CutSceneWindow.StartAlpha = 255
	CutSceneWindow.StartTime = CurTime() + 8
	CutSceneWindow.Name = name
	CutSceneWindow.Status = BREACH.TranslateString("l:cutscene_status ")..msg
	CutSceneWindow.Time = BREACH.TranslateString("l:cutscene_last_report_time ") .. tostring(os.date("%X")) .. " " .. tostring(os.date("%d/%m/%Y")) .. BREACH.TranslateString("l:cutscene_time_after_disaster_for_last_report_time ") .. string.ToMinutesSeconds(cltime)
	
	-- Время появления каждой строки
	CutSceneWindow.LineAppearTimes = {
		1.5,  -- Первая строка через 0.5 секунды
		2.5,  -- Вторая строка через 1.5 секунды
		3.5   -- Третья строка через 2.5 секунды
	}
	
	-- Длительность дрожания для каждой строки (в секундах)
	CutSceneWindow.ShakeDurations = {
		1.2,  -- Первая строка дрожит 1.2 секунды
		1.2,  -- Вторая строка дрожит 1.2 секунды
		1.2   -- Третья строка дрожит 1.2 секунды
	}
	
	-- Интенсивность дрожания для каждой строки
	CutSceneWindow.ShakeIntensities = {
		6.0,  -- Интенсивность дрожания первой строки
		6.0,  -- Интенсивность дрожания второй строки
		6.0   -- Интенсивность дрожания третьей строки
	}
	
	-- Текущее смещение для каждой строки
	CutSceneWindow.LineOffsets = {
		Vector(0, 0),
		Vector(0, 0),
		Vector(0, 0)
	}
	
	-- Время последнего обновления дрожания для каждой строки
	CutSceneWindow.LastShakeTimes = {CurTime(), CurTime(), CurTime()}
	
	-- Статус для каждой строки: дрожит или нет
	CutSceneWindow.LineShaking = {
		false,
		false,
		false
	}
	
	-- Функция обновления дрожания для конкретной строки
	local function UpdateLineShake(lineIndex)
		local time = CurTime()
		local shakeInterval = 0.03 -- Интервал обновления дрожания
		
		if time - CutSceneWindow.LastShakeTimes[lineIndex] > shakeInterval then
			-- Генерируем новое случайное смещение
			CutSceneWindow.LineOffsets[lineIndex] = Vector(
				math.Rand(-CutSceneWindow.ShakeIntensities[lineIndex], CutSceneWindow.ShakeIntensities[lineIndex]),
				math.Rand(-CutSceneWindow.ShakeIntensities[lineIndex], CutSceneWindow.ShakeIntensities[lineIndex])
			)
			
			CutSceneWindow.LastShakeTimes[lineIndex] = time
		end
	end
	
	-- Функция остановки дрожания для строки
	local function StopLineShake(lineIndex)
		CutSceneWindow.LineShaking[lineIndex] = false
		CutSceneWindow.LineOffsets[lineIndex] = Vector(0, 0) -- Сбрасываем смещение
	end
	
	CutSceneWindow.Paint = function(self, w, h)
		local elapsed = CurTime() - (self.CreationTime or CurTime())
		
		-- Обновляем состояние каждой строки
		for i = 1, 3 do
			if elapsed >= self.LineAppearTimes[i] then
				local lineElapsed = elapsed - self.LineAppearTimes[i]
				
				-- Если строка только что появилась, начинаем дрожание
				if not self.LineShaking[i] and lineElapsed < 0.1 then
					self.LineShaking[i] = true
				end
				
				-- Если дрожание активно и время еще не вышло
				if self.LineShaking[i] and lineElapsed < self.ShakeDurations[i] then
					UpdateLineShake(i)
				-- Если время дрожания вышло
				elseif self.LineShaking[i] and lineElapsed >= self.ShakeDurations[i] then
					StopLineShake(i)
				end
			end
		end
		
		if self.StartTime <= CurTime() + 6 then
			if self.StartTime <= CurTime() then
				self.StartAlpha = math.Approach(self.StartAlpha, 0, RealFrameTime() * 80)
				
				if self.StartAlpha <= 0 then
					FadeMusic(10)
					self:Remove()
				end
			end
			
			-- Рисуем каждую строку
			for i = 1, 3 do
				if elapsed >= self.LineAppearTimes[i] then
					local lineElapsed = elapsed - self.LineAppearTimes[i]
					local lineAlpha = self.StartAlpha
					
					-- Эффект постепенного появления (плавное увеличение альфа-канала)
					if lineElapsed < 0.5 then
						lineAlpha = math.min(self.StartAlpha, (lineElapsed / 0.5) * 255)
					end
					
					local yOffset = 0
					if i == 2 then yOffset = 32
					elseif i == 3 then yOffset = 64 end
					
					local text = ""
					local textColor = ColorAlpha(clr_gray, lineAlpha)
					local outlineColor = ColorAlpha(clr_blood, lineAlpha)
					
					if i == 1 then 
						text = self.Name
						outlineColor = ColorAlpha(col, lineAlpha)
					elseif i == 2 then 
						text = self.Status
					elseif i == 3 then 
						text = self.Time
					end
					
					-- Применяем текущее смещение (будет Vector(0, 0) если дрожание закончилось)
					local xPos = w / 2 + self.LineOffsets[i].x
					local yPos = h / 2 + yOffset + self.LineOffsets[i].y
					
					-- Рисуем текст
					draw.SimpleTextOutlined(
						text, 
						"TimeMisterFreeman", 
						xPos, 
						yPos, 
						textColor, 
						TEXT_ALIGN_CENTER, 
						TEXT_ALIGN_CENTER, 
						1, 
						outlineColor
					)
					
					-- Если строка все еще дрожит, добавляем легкий эффект размытия
					if self.LineShaking[i] then
						local blurAlpha = lineAlpha * 0.15
						draw.SimpleTextOutlined(
							text, 
							"TimeMisterFreeman", 
							xPos + math.Rand(-1, 1), 
							yPos + math.Rand(-1, 1), 
							ColorAlpha(clr_gray, blurAlpha), 
							TEXT_ALIGN_CENTER, 
							TEXT_ALIGN_CENTER, 
							1, 
							ColorAlpha(clr_blood, blurAlpha)
						)
					end
				end
			end
		end
	end
	
	-- Запоминаем время создания
	CutSceneWindow.CreationTime = CurTime()
	
	return CutSceneWindow
end

local function FirstPerson_CutScene(ply, pos, angles, fov)
	if Dead_Body then
		local target = Dead_Body

		if !IsValid(target) then
			return
		end

		local head = target:GetAttachment( target:LookupAttachment( "eyes" ) )
		local view = {}
		if head then
			view.origin = head.Pos + head.Ang:Forward() * -5
			view.angles = head.Ang
		end
		local target = Dead_Body

		if !timer.Exists("DeathScene_RestoreHead_"..target:EntIndex()) then
			timer.Create("DeathScene_RestoreHead_"..target:EntIndex(), 8, 1, function()
				if !IsValid(target) then
					return
				end

				Dead_Body = false

				local matrix

				  for bone = 0, ( target:GetBoneCount() || 1 ) do
					if target:GetBoneName( bone ):lower():find( "head" ) then
						  matrix = target:GetBoneMatrix( bone )
						  target:ManipulateBoneScale(bone, Vector(1,1,1))
						  break
					end
				  end

				  if ( IsValid( matrix ) ) then
					matrix:SetScale(Vector(1,1,1))
				end
			end)
		end
		Death_Blur_Intensity = math.Approach(Death_Blur_Intensity, 10, 0.05)
		Death_Desaturation_Intensity = math.Approach(Death_Desaturation_Intensity, 0, 0.01)

		local matrix

		  for bone = 0, ( target:GetBoneCount() || 1 ) do
			if target:GetBoneName( bone ):lower():find( "head" ) then
				  matrix = target:GetBoneMatrix( bone )
				  target:ManipulateBoneScale(bone, vector_origin)
				  break
			end
		  end

		  if ( IsValid( matrix ) ) then
			matrix:SetScale( vector_origin )
		end
		view.fov = fov
		view.drawviewer = true
		return view
	end

	if ply && ply:GetNWEntity("NTF1Entity", NULL) != NULL then
		local target = ply:GetNWEntity("NTF1Entity", NULL)
		local view = {}
		local head = target:GetAttachment( target:LookupAttachment( "eyes" ) )
		if head then
			if target == ply then
				view.origin = head.Pos + head.Ang:Up() * 5 + head.Ang:Forward() * 5
				view.angles = head.Ang

			elseif target:GetClass() == "ntf_cutscene_2" then
				view.origin = head.Pos
				view.angles = head.Ang - Angle(0, -70, 0)
			else
				view.origin = head.Pos + head.Ang:Forward() * -5
				view.angles = head.Ang
			end
		end

		view.fov = fov
		view.drawviewer = true
		return view

	end

	--[[
	if ply and Dead_Body then
		local target = Dead_Body
		local view = {}
		local head = target:GetAttachment( target:LookupAttachment( "eyes" ) )
		Death_Blur_Intensity = math.Approach(Death_Blur_Intensity, 10, 0.05)
		Death_Desaturation_Intensity = math.Approach(Death_Desaturation_Intensity, 0, 0.01)
		if head then
				view.origin = head.Pos + head.Ang:Forward() * -5
				view.angles = head.Ang
		end

		local matrix

	  for bone = 0, ( Dead_Body:GetBoneCount() || 1 ) do

	    if Dead_Body:GetBoneName( bone ):lower():find( "head" ) then

	      matrix = Dead_Body:GetBoneMatrix( bone )
	      Dead_Body:ManipulateBoneScale(bone, vector_origin)

	      break

	    end

	  end

	  	if ( IsValid( matrix ) ) then

	    	matrix:SetScale( vector_origin )

    	end
		view.fov = fov
		view.drawviewer = false
		return view

	end
	--]]
end
hook.Add( "CalcView", "FirstPerson_CutScene", FirstPerson_CutScene )

hook.Add( "CalcView", "firstpersondeathkk", function( ply, origin, angles, fov )

  if ( ply:GetNWEntity( "NTF1Entity" ) == NULL ) then return end

	local ragdoll = ply:GetNWEntity( "NTF1Entity" )

	if ( !( ragdoll && ragdoll:IsValid() ) ) then return end
	local head = ragdoll:LookupAttachment( "eyes" )
	head = ragdoll:GetAttachment( head )

	local view = {}

  if ( !head || !head.Pos ) then return end

	if ( !ragdoll.BonesRattled ) then

	  ragdoll.BonesRattled = true
	  ragdoll:InvalidateBoneCache()
	  ragdoll:SetupBones()
	  local matrix

	  for bone = 0, ( ragdoll:GetBoneCount() || 1 ) do

	    if ragdoll:GetBoneName( bone ):lower():find( "head" ) then

	      matrix = ragdoll:GetBoneMatrix( bone )
	      ragdoll:ManipulateBoneScale(bone, vector_origin)

	      break

	    end

	  end

	  if ( IsValid( matrix ) ) then

	    matrix:SetScale( vector_origin )

    end

	end

	view.origin = head.Pos + head.Ang:Up() * 5 + head.Ang:Forward() * 5
	view.angles = head.Ang
  	view.drawviewer = true

	return view

end )

local Death_Anims = {
	"wos_bs_shared_death_neck_slice",
	"wos_bs_shared_death_belly_slice_side",
	"wos_bs_shared_death_belly_slice",
}

function Death_Scene( ply )
	if LocalPlayer():GTeam() == TEAM_ARENA then
		return
	end

	LocalPlayer():SetNWEntity("NTF1Entity", NULL)

	StopMusic()

	local camtorag = net.ReadBool()
	local sent_rag = net.ReadEntity()

	if LocalPlayer():GTeam() == TEAM_SCP then
		camtorag = true
	end

	hook.Run("CalcView", LocalPlayer(), EyePos(), EyeAngles(), LocalPlayer():GetFOV(), 0, 0)

	if !camtorag then

	Death_Scene = true
	Dead_Body = ents.CreateClientside( "base_gmodentity" )
	Death_Blur_Intensity = 0
	Death_Desaturation_Intensity = 1
		
	local dead_pos = LocalPlayer():GetPos()

	Dead_Body:SetPos( dead_pos )

	Dead_Body:SetAngles( Angle(0, LocalPlayer():GetAngles().y, 0) )
	
	Dead_Body:SetModel(  LocalPlayer():GetModel()  )
	Dead_Body:SetBodyGroups(LocalPlayer():GetBodyGroupsString())
	Dead_Body:Spawn()
	local sequence = table.Random( Death_Anims )
	Dead_Body:SetSequence(  sequence  )
	Dead_Body:SetCycle( 0 )
	Dead_Body:SetPlaybackRate( 0.5 )
	Dead_Body.AutomaticFrameAdvance = true
	
	Dead_Body.Think = function( self )
	
		self:NextThink( CurTime() )
	
		self:SetCycle( math.Approach( cycle, 1, FrameTime() * 0.4 ) )
	
		cycle = self:GetCycle()
	
		return true
	
	end

	end

	if camtorag then
		Dead_Body = sent_rag
	end

	LocalPlayer():SetNoDraw(true)
	LocalPlayer():SetDSP(35)

	timer.Simple(1.5, function()
		LocalPlayer():SetDSP(31)
	end)

	timer.Simple(2, function()
		if LocalPlayer():GTeam() == TEAM_SCP then
			CorpsedMessage()
		else
			CorpsedMessage()
		end
	end)
	
	local cycle = 0

	LocalPlayer():ScreenFade( SCREENFADE.OUT, color_black, 4, 4.1)
	timer.Simple( 8, function()
		LocalPlayer():SetDSP(0)
		Death_Blur_Intensity = 0
		Death_Desaturation_Intensity = 1
		Death_Scene = false
		Dead_Body = false
		LocalPlayer():SetNWEntity("RagdollEntityNO", NULL)
		LocalPlayer():SetNWEntity("NTF1Entity", NULL)

		if IsValid(Dead_Body) then
			LocalPlayer():SetNoDraw(false)
			if !camtorag then
		    	Dead_Body:Remove()
			end
		    Dead_Body = false
			show_spec_role = true
			if show_spec_role then
				DrawNewRoleDesc()
				show_spec_role = false
			end
		end
		if IsValid(LocalPlayer():GetNWEntity("RagdollEntityNO")) then
			for _, bnmrg in pairs(LocalPlayer():GetNWEntity("RagdollEntityNO"):LookupBonemerges()) do
				bnmrg:SetNoDraw(false)
			end
			LocalPlayer():GetNWEntity("RagdollEntityNO"):SetNoDraw(false)
		end
	end )
	if !camtorag then
		timer.Create("FINDRAGDOLLBODY", FrameTime(), 9999, function()
			if IsValid(LocalPlayer():GetNWEntity("RagdollEntityNO")) then
				for _, bnmrg in pairs(LocalPlayer():GetNWEntity("RagdollEntityNO"):LookupBonemerges()) do
					bnmrg:SetNoDraw(true)
				end
				LocalPlayer():GetNWEntity("RagdollEntityNO"):SetNoDraw(true)
				timer.Remove("FINDRAGDOLLBODY")
			end
		end)
		LocalPlayer():SetNWEntity("NTF1Entity", Dead_Body)
	else
		--local rag = LocalPlayer():GetNWEntity("RagdollEntityNO")
		local rag = LocalPlayer():GetNWEntity("NTF1Entity")
		local times = 0
		timer.Create("FINDRAGDOLLBODY", FrameTime(), 9999, function()
			if IsValid(LocalPlayer():GetNWEntity("RagdollEntityNO")) then
				LocalPlayer():SetNWEntity("NTF1Entity", LocalPlayer():GetNWEntity("RagdollEntityNO"))
				timer.Remove("FINDRAGDOLLBODY")
				if IsValid(rag) then
					rag:ManipulateBoneScale(rag:LookupBone("ValveBiped.Bip01_Head1"), Vector(0,0,0))
				end
			end
			timer.Simple(8, function()
				if IsValid(rag) then
					rag:ManipulateBoneScale(rag:LookupBone("ValveBiped.Bip01_Head1"), Vector(1,1,1))
					local head = rag:GetAttachment( rag:LookupAttachment( "eyes" ) )

					local matrix

	  				for bone = 0, ( rag:GetBoneCount() || 1 ) do
	    				if rag:GetBoneName( bone ):lower():find( "head" ) then
	      					matrix = rag:GetBoneMatrix( bone )
	      					rag:ManipulateBoneScale(bone, Vector(1,1,1))
	      					break
	    				end
	  				end

	  				if ( IsValid( matrix ) ) then
	    				matrix:SetScale( Vector(1,1,1) )
    				end
				end
			end)
		end)
		if !camtorag then
			Dead_Body:Remove()
		end
	end

	BREACH.Music:Play(BR_MUSIC_DEATH)
end
net.Receive("Death_Scene", Death_Scene)

function ANGLE:CalculateVectorDot( vec )



	local x = self:Forward():DotProduct( vec )

	local y = self:Right():DotProduct( vec )

	local z = self:Up():DotProduct( vec )



	return Vector( x, y, z )



end


function GM:DrawDeathNotice( x,  y )
end
/*
hook.Add( "HUDShouldDraw", "HideHUD", function( name )
	if ( hide[ name ] ) then return false end
end )
*/

function DrawInfo(pos, txt, clr)
	pos = pos:ToScreen()
	draw.TextShadow( {
		text = txt,
		pos = { pos.x, pos.y },
		font = "HealthAmmo",
		color = clr,
		xalign = TEXT_ALIGN_CENTER,
		yalign = TEXT_ALIGN_CENTER,
	}, 2, 255 )
end



SCPMarkers = {}

tab_scarlet = {
	["$pp_colour_addr"] = 0.07,
	["$pp_colour_addg"] = 0,
	["$pp_colour_addb"] = 0,
	["$pp_colour_brightness"] = 0,
	["$pp_colour_contrast"] = 1,
	["$pp_colour_colour"] = 1,
	["$pp_colour_mulr"] = 2,
	["$pp_colour_mulg"] = 0,
	["$pp_colour_mulb"] = 0
}

local client = LocalPlayer()

function Scarlet_King_Shake()

	util.ScreenShake( Vector(0, 0, 0), 2, 2, 10, 1000 )

	surface.PlaySound( "nextoren/others/helicopter/helicopter_distant_explosion.wav" )

end

hook.Add("Think", "Check_Scarlet_Skybox", function()
	if GetGlobalBool("Scarlet_King_Scarlet_Skybox", false) then
		if ( ( NextShake || 0 ) >= CurTime() ) then return end
	
		NextShake = CurTime() + 50

	    Scarlet_King_Shake()
	end
end)

local bloomtab = {
	pp_bloom_passes = "0",
	pp_bloom_darken = "0.20",
	pp_bloom_multiply = "0.15",
	pp_bloom_sizex = "6.42",
	pp_bloom_sizey = "4.65",
	pp_bloom_color = "20.00",
	pp_bloom_color_r = "255",
	pp_bloom_color_g = "0",
	pp_bloom_color_b = "0"
}

local outsidescarlettab = {
	["$pp_colour_addr"] = 0.07,
	["$pp_colour_addg"] = 0,
	["$pp_colour_addb"] = 0,
	["$pp_colour_brightness"] = 0,
	["$pp_colour_contrast"] = 1,
	["$pp_colour_colour"] = 1.2,
	["$pp_colour_mulr"] = 2,
	["$pp_colour_mulg"] = 0,
	["$pp_colour_mulb"] = 0
}

local outsidenoscarlettab = {
	["$pp_colour_addr"] = 0,
	["$pp_colour_addg"] = 0,
	["$pp_colour_addb"] = 0,
	["$pp_colour_brightness"] = 0,
	["$pp_colour_contrast"] = 1,
	["$pp_colour_colour"] = 1.2,
	["$pp_colour_mulr"] = 0,
	["$pp_colour_mulg"] = 0,
	["$pp_colour_mulb"] = 0
}

local notoutsidetab = {
	["$pp_colour_addr"] = 0,
	["$pp_colour_addg"] = 0,
	["$pp_colour_addb"] = 0,
	["$pp_colour_brightness"] = -0.04,
	["$pp_colour_contrast"] = 1.1,
	["$pp_colour_colour"] = 1.1,
	["$pp_colour_mulr"] = 0,
	["$pp_colour_mulg"] = 0,
	["$pp_colour_mulb"] = 0
}

local evactab = {
	["$pp_colour_addr"] = 0,
	["$pp_colour_addg"] = 0,
	["$pp_colour_addb"] = 0,
	["$pp_colour_brightness"] = 0.01,
	["$pp_colour_contrast"] = 0.9,
	["$pp_colour_colour"] = 2.2,
	["$pp_colour_mulr"] = 0,
	["$pp_colour_mulg"] = 0,
	["$pp_colour_mulb"] = 0
}

local forscptab = {
	["$pp_colour_addr"] = 0.05,
	["$pp_colour_addg"] = 0,
	["$pp_colour_addb"] = 0,
	["$pp_colour_brightness"] = 0.01,
	["$pp_colour_contrast"] = 1,
	["$pp_colour_colour"] = 1,
	["$pp_colour_mulr"] = 0,
	["$pp_colour_mulg"] = 0,
	["$pp_colour_mulb"] = 0
}

local forartab = {
	["$pp_colour_addr"] = 0,
	["$pp_colour_addg"] = 0,
	["$pp_colour_addb"] = 0.05,
	["$pp_colour_brightness"] = 0,
	["$pp_colour_contrast"] = 2,
	["$pp_colour_colour"] = 0,
	["$pp_colour_mulr"] = 0,
	["$pp_colour_mulg"] = 0,
	["$pp_colour_mulb"] = 0
}

local generatorsactivated = {
	["$pp_colour_addr"] = 0,
	["$pp_colour_addg"] = 0,
	["$pp_colour_addb"] = 0,
	["$pp_colour_brightness"] = 0.01,
	["$pp_colour_contrast"] = 1.2,
	["$pp_colour_colour"] = 1.2,
	["$pp_colour_mulr"] = 0,
	["$pp_colour_mulg"] = 0,
	["$pp_colour_mulb"] = 0
}

local _DrawColorModify = DrawColorModify

local scpvision = CreateConVar("breach_config_scp_red_screen", 1, FCVAR_ARCHIVE, "Enables the red screen for SCP", 0, 1)

hook.Add( "RenderScreenspaceEffects", "ToytownEffect", function()

    --DrawBloom( 0.55, 1, 9, 9, 5, 1, 1.1, 1.1, 1 )
    --DrawSharpen( 1.2, 0.2 )

	local client = LocalPlayer()
	local tab2
		if OUTSIDE_BUFF and OUTSIDE_BUFF( client:GetPos() ) then

			if GetGlobalBool("Scarlet_King_Scarlet_Skybox", false) then
				tab2 = outsidescarlettab
			else
				tab2 = outsidenoscarlettab
			end
		else
			tab2 = notoutsidetab
		end

	if BREACH["Round"] and BREACH["Round"]["GeneratorsActivated"] and !client:Outside() then
		tab2 = generatorsactivated
	end

	if GetGlobalBool("Evacuation_HUD", false) and !client:Outside() then
		tab2 = evactab
		tab2["$pp_colour_addr"] = Pulsate(1.4) * 0.04
		tab2["$pp_colour_colour"] = 1 + Pulsate(1.4) * 0.4
	end

	local oldcolor = tab2["$pp_colour_colour"]
	if Dead_Body then
		local tab2 = table.Copy(tab2)
    DrawToyTown(Death_Blur_Intensity, ScrH())
    tab2["$pp_colour_colour"] = Death_Desaturation_Intensity
  end

  if client:GTeam() == TEAM_SCP and GetConVar("breach_config_scp_red_screen"):GetBool() then
  	tab2 = forscptab
  end

  if client:GTeam() == TEAM_AR then
  	tab2 = forartab
  end

	_DrawColorModify( tab2 )

	tab2["$pp_colour_colour"] = oldcolor
	

end )

local clr = color_white
local clr1 = Color( 255, 69, 0 )

local hud_style = CreateConVar("breach_config_hud_style", 0, FCVAR_ARCHIVE, "Changes your HUD style", 0, 1)
local hide_title = CreateConVar("breach_config_hide_title", 0, FCVAR_ARCHIVE, "Disable bottom title", 0, 1)

local red = Color(255,0,0)

local function BreachVersionIndicator()

	local widthz = ScrW()
	local heightz = ScrH()

	if ( LocalPlayer():Health() <= 0 ) then return end
	if clang == nil then return end
	if GetGlobalBool("NewEventRound") then
		draw.SimpleText( "ИВЕНТОВЫЙ РАУНД (Опыт не начисляется)", "ScoreboardContent", widthz * 0.5, heightz * 0.972, clr1, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	--draw.SimpleText( "МИРНЫЙ РАУНД (За убийства выдают штрафников)", "dev_name", widthz * 0.5, heightz * 0.972, Color(47,143,60), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	if LocalPlayer():GetNWBool("priorityvoice") then
		draw.SimpleText( "Режим Интеркома (Вас все слышат)", "ScoreboardContent", widthz * 0.5, heightz * 0.952, clr1, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	--if hud_style:GetInt() != 0 then return end
	if LocalPlayer():GetTable().IN_106_DIMENSION then return end
	if hide_title:GetInt() == 1 then return end
	local clang = clang

	--draw.SimpleText( "ОЧЕНЬ ВЕРОЯТНЫ БАГИ", "ScoreboardContent", widthz * 0.5, heightz * 0.972, clr1, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	--draw.SimpleText( "Рестарт после этого раунда (Фикс рега пуль)", "ScoreboardContent", widthz * 0.5, heightz * 0.972, clr1, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

	draw.SimpleText( "如果遇到BUG请报告BUG!", "ScoreboardContent", widthz * 0.5, heightz * 0.955, red, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	draw.SimpleText( "测 试 服", "ScoreboardContent", widthz * 0.5, heightz * 0.975, clr1, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	draw.SimpleText( "[CN] Legacy Breach 10TH " .. TCV, "ScoreboardContent", widthz * 0.5, heightz * 0.99, clr, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

end
hook.Add( "HUDPaintBackground", "BreachVersionIndicator", BreachVersionIndicator )

local clrgray = Color( 198, 198, 198 )
local clrgray2 = Color( 180, 180, 180 )
local clrred = Color( 255, 0, 0 )
local clrred2 = Color( 198, 0, 0 )

local BREACH = BREACH || {}

local function ShowAbillityDesc( name, text, cooldown, x, y )

  if ( BREACH.Abilities && IsValid( BREACH.Abilities.TipWindow ) ) then

    BREACH.Abilities.TipWindow:Remove()

  end

	if ( !BREACH.Abilities ) then

		BREACH.Abilities = {}

	end

  surface.SetFont( "ChatFont_new" )
  local _, stringheight = surface.GetTextSize( text )
  BREACH.Abilities.TipWindow = vgui.Create( "DPanel" )
  BREACH.Abilities.TipWindow:SetAlpha( 0 )
  BREACH.Abilities.TipWindow:SetPos( x + 10, ScrH() - 80  )
  BREACH.Abilities.TipWindow:SetSize( 180, stringheight + 76 )
  BREACH.Abilities.TipWindow:SetText( "" )
  BREACH.Abilities.TipWindow:MakePopup()
  BREACH.Abilities.TipWindow.Paint = function( self, w, h )

    if ( !vgui.CursorVisible() ) then

      self:Remove()

    end

    self:SetPos( gui.MouseX() + 15, gui.MouseY() )
    if ( self && self:IsValid() && self:GetAlpha() <= 0 ) then

      self:SetAlpha( 255 )

    end
    DrawBlurPanel( self )
    draw.OutlinedBox( 0, 0, w, h, 2, clrgray2 )
    drawMultiLine( name, "ChatFont_new", w, 16, 5, 3, clrred, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT )

    local namewidth, nameheight = surface.GetTextSize( name )
    drawMultiLine( text, "ChatFont_new", w-10, 16, 5, nameheight * 1.2, clrgray, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT )

    surface.DrawLine( 0, nameheight * 1.15, w, nameheight * 1.15 )
    surface.DrawLine( 0, nameheight * 1.15 + 1, w, nameheight * 1.15 + 1 )

    draw.SimpleText( L"l:abilities_cd "..cooldown, "ChatFont_new", w - 8, 3, clrred2, TEXT_ALIGN_RIGHT, TEXT_ALIGN_RIGHT )

  end

end

local darkgray = Color(105, 105, 105)
local abilityAnim = {
    press = 0,
    cooldown = 0,
    hover = 0,
    readyPulse = 0,
    scale = 1,
    appear = 0
}

function DrawSpecialAbility(tbl)
    local client = LocalPlayer()

    client.AbilityKey = string.upper(input.GetKeyName(GetConVar("breach_config_useability"):GetInt()))
    client.AbilityKeyCode = GetConVar("breach_config_useability"):GetInt()

    local name, current_team = client:GetNamesurvivor(), client:GTeam()

    if (IsValid(BREACH.Abilities)) then
        BREACH.Abilities.HumanSpecial:Remove()
    end

    if BREACH.Abilities and IsValid(BREACH.Abilities.HumanSpecial) then BREACH.Abilities.HumanSpecial:Remove() end
    if BREACH.Abilities and IsValid(BREACH.Abilities.HumanSpecialButt) then BREACH.Abilities.HumanSpecialButt:Remove() end

    abilityAnim = {
        press = 0,
        cooldown = 0,
        hover = 0,
        readyPulse = 0,
        scale = 1,
        appear = 0
    }

    BREACH.Abilities = {}
    BREACH.Abilities.HumanSpecial = vgui.Create("DPanel")
    BREACH.Abilities.HumanSpecial:SetSize(64, 64)
    BREACH.Abilities.HumanSpecial:SetPos(ScrW() / 2 - 32, ScrH() / 1.2)
    BREACH.Abilities.HumanSpecial:SetText("")
    BREACH.Abilities.HumanSpecial:SetAlpha(0)
    BREACH.Abilities.HumanSpecial.CreationTime = CurTime()
    BREACH.Abilities.HumanSpecial.Alpha = 0
    
    BREACH.Abilities.HumanSpecial.OnRemove = function()
        gui.EnableScreenClicker(false)
        if (BREACH.Abilities && IsValid(BREACH.Abilities.TipWindow)) then
            BREACH.Abilities.TipWindow:Remove()
        end
    end

    local iconmat = Material(tbl.Icon)
    local is_countable = tbl.Countable

    BREACH.Abilities.HumanSpecial.Think = function(self)
        local currentTime = CurTime()
        
        if self.CreationTime < (currentTime - 4) then
            abilityAnim.appear = Lerp(FrameTime() * 6, abilityAnim.appear, 1)
            self.Alpha = abilityAnim.appear * 255
            self:SetAlpha(self.Alpha)
        end

        if (client.AbilityKeyCode && (input.IsMouseDown(client.AbilityKeyCode) or input.IsKeyDown(client.AbilityKeyCode))) then
            abilityAnim.press = Lerp(FrameTime() * 15, abilityAnim.press, 1)
            abilityAnim.scale = Lerp(FrameTime() * 20, abilityAnim.scale, 0.85)
        else
            abilityAnim.press = Lerp(FrameTime() * 8, abilityAnim.press, 0)
            abilityAnim.scale = Lerp(FrameTime() * 12, abilityAnim.scale, 1)
        end

        if self:IsHovered() then
            abilityAnim.hover = Lerp(FrameTime() * 8, abilityAnim.hover, 1)
        else
            abilityAnim.hover = Lerp(FrameTime() * 6, abilityAnim.hover, 0)
        end

        local cdTime = client:GetSpecialCD() - currentTime
        if cdTime > 0 then
            abilityAnim.cooldown = Lerp(FrameTime() * 6, abilityAnim.cooldown, 1)
        else
            abilityAnim.cooldown = Lerp(FrameTime() * 4, abilityAnim.cooldown, 0)
        end

        if cdTime <= 0 and not self.Blocked then
            abilityAnim.readyPulse = math.sin(currentTime * 2) * 0.3 + 0.7
        else
            abilityAnim.readyPulse = Lerp(FrameTime() * 5, abilityAnim.readyPulse, 1)
        end
    end

    BREACH.Abilities.HumanSpecial.Paint = function(self, w, h)
        if (client:Health() <= 0 || client:GTeam() == TEAM_SPEC || (name != client:GetNamesurvivor() and client:GetRoleName() != role.ClassD_Hitman) || current_team != client:GTeam()) then
            client.SpecialTable = nil
            BREACH.Abilities = nil
            self:Remove()
            return
        end

        if (IsValid(INTRO_PANEL) && INTRO_PANEL:IsVisible()) then return end

        local currentTime = CurTime()
        local currentAlpha = abilityAnim.appear

        local currentScale = abilityAnim.scale
        local scaledW = w * currentScale
        local scaledH = h * currentScale
        local offsetX = (w - scaledW) / 2
        local offsetY = (h - scaledH) / 2

        local appearScale = 0.5 + abilityAnim.appear * 0.5
        local finalScale = currentScale * appearScale
        
        local finalW = w * finalScale
        local finalH = h * finalScale
        local finalX = (w - finalW) / 2
        local finalY = (h - finalH) / 2

        local bgColor = Color(40, 40, 40, 200 * currentAlpha)
        draw.RoundedBox(8, finalX, finalY, finalW, finalH, bgColor)

        if abilityAnim.hover > 0 then
            local outlineColor = Color(255, 255, 255, 80 * abilityAnim.hover * currentAlpha)
            draw.RoundedBox(8, finalX - 2, finalY - 2, finalW + 4, finalH + 4, outlineColor)
        end

        if abilityAnim.readyPulse < 1 and not self.Blocked then
            local readyColor = Color(255, 255, 255, 30 * (1 - abilityAnim.readyPulse) * currentAlpha)
            draw.RoundedBox(8, finalX - 1, finalY - 1, finalW + 2, finalH + 2, readyColor)
        end

        surface.SetDrawColor(color_white)
        surface.SetMaterial(iconmat)
        
        if abilityAnim.press > 0 then
            surface.SetDrawColor(200, 200, 200, 255 * currentAlpha)
        end
        
        surface.DrawTexturedRect(finalX, finalY, finalW, finalH)

        if abilityAnim.press > 0 then
            local pressAlpha = 80 * abilityAnim.press * currentAlpha
            draw.RoundedBox(8, finalX, finalY, finalW, finalH, Color(0, 0, 0, pressAlpha))
        end

        local cdTime = client:GetSpecialCD() - currentTime
        if cdTime > 0 || self.Blocked then
            local cdAlpha = 190 * abilityAnim.cooldown * currentAlpha
            draw.RoundedBox(8, finalX, finalY, finalW, finalH, ColorAlpha(darkgray, cdAlpha))

            if cdTime > 0 then
                local progress = 1 - (cdTime / (tbl.Cooldown or 1))

                local cdText = math.Round(cdTime, 1)
                draw.SimpleTextOutlined(
                    cdText, 
                    "ImpactSmall2n", 
                    w / 2, 
                    h / 2, 
                    Color(255, 255, 255, 255 * currentAlpha), 
                    TEXT_ALIGN_CENTER, 
                    TEXT_ALIGN_CENTER, 
                    2, 
                    Color(0, 0, 0, 150 * currentAlpha)
                )
            end
        end

        draw.SimpleTextOutlined(
            client.AbilityKey, 
            "ImpactSmall2n", 
            w - 6, 
            8, 
            Color(255, 255, 255, 255 * currentAlpha), 
            TEXT_ALIGN_RIGHT, 
            TEXT_ALIGN_TOP, 
            1, 
            Color(0, 0, 0, 150 * currentAlpha)
        )

        if (is_countable) then
            local n_max = client:GetSpecialMax() or 0
            
            draw.SimpleTextOutlined(
                tostring(n_max), 
                "ImpactSmall2n", 
                6, 
                8, 
                Color(255, 255, 255, 255 * currentAlpha), 
                TEXT_ALIGN_LEFT, 
                TEXT_ALIGN_TOP, 
                1, 
                Color(0, 0, 0, 150 * currentAlpha)
            )

            if (!self.Blocked && n_max <= 0) then
                self.Blocked = true
            elseif (self.Blocked && n_max > 0) then
                self.Blocked = nil
            end
        end

        if (input.IsKeyDown(KEY_F3)) then
            if ((self.NextCall || 0) >= CurTime()) then return end
            self.NextCall = CurTime() + 1

            if (vgui.CursorVisible()) then
                gui.EnableScreenClicker(false)
            else
                gui.EnableScreenClicker(true)
            end
        end
    end

    BREACH.Abilities.HumanSpecialButt = vgui.Create("DButton", BREACH.Abilities.HumanSpecial)
    BREACH.Abilities.HumanSpecialButt:SetSize(64, 64)
    BREACH.Abilities.HumanSpecialButt:SetText("")
    BREACH.Abilities.HumanSpecialButt.Paint = function() end
    
    BREACH.Abilities.HumanSpecialButt.OnCursorEntered = function()
        ShowAbillityDesc(L(tbl.Name), L(tbl.Description), tostring(tbl.Cooldown), gui.MouseX(), gui.MouseY())
    end
    
    BREACH.Abilities.HumanSpecialButt.OnCursorExited = function()
        if (BREACH.Abilities && IsValid(BREACH.Abilities.TipWindow)) then
            BREACH.Abilities.TipWindow:Remove()
        end
    end
end

local info1 = Material( "breach/info_mtf.png")
hook.Add( "HUDPaint", "Breach_DrawHUD", function()
	for i, v in ipairs( SCPMarkers ) do
		local scr = v.data.pos:ToScreen()

		if scr.visible then
			surface.SetDrawColor( Color( 255, 100, 100, 200 ) )
			//surface.DrawRect( scr.x - 5, scr.y - 5, 10, 10 )
			surface.DrawPoly( {
				{ x = scr.x, y = scr.y - 10 },
				{ x = scr.x + 5, y = scr.y },
				{ x = scr.x, y = scr.y + 10 },
				{ x = scr.x - 5, y = scr.y },
			} )

			draw.Text( {
				text = v.data.name,
				font = "HUDFont",
				color = Color( 255, 100, 100, 200 ),
				pos = { scr.x, scr.y + 10 },
				xalign = TEXT_ALIGN_CENTER,
				yalign = TEXT_ALIGN_TOP,
			} )

			draw.Text( {
				text = math.Round( v.data.pos:Distance( LocalPlayer():GetPos() ) * 0.019 ) .. "m",
				font = "HUDFont",
				color = Color( 255, 100, 100, 200 ),
				pos = { scr.x, scr.y + 25 },
				xalign = TEXT_ALIGN_CENTER,
				yalign = TEXT_ALIGN_TOP,
			} )
		end

		if v.time < CurTime() then
			table.remove( SCPMarkers, i )
		end
	end

	if disablehud then return end


	if shoulddrawinfo == true then
		if LocalPlayer():GTeam() == TEAM_SPEC then
			timer.Simple(0.1, function()
				DrawNewRoleDesc()
			end)
		else
			local client = LocalPlayer()
			if (client:GTeam() != TEAM_QRT and client:GTeam() != TEAM_OSN and client:GTeam() != TEAM_ETT and client:GTeam() != TEAM_FAF and client:GTeam() != TEAM_AR and client:GTeam() != TEAM_ALPHA1 and client:GTeam() != TEAM_CBG and client:GTeam() != TEAM_GUARD and ( client:GTeam() != TEAM_DZ or client:GetRoleName() == role.SCI_SpyDZ ) and client:GTeam() != TEAM_NTF and ( client:GTeam() != TEAM_USA or client:GetRoleName() == role.SCI_SpyUSA ) and client:GTeam() != TEAM_GRU and ( client:GTeam() != TEAM_GOC or client:GetRoleName() == role.ClassD_GOCSpy ) and client:GTeam() != TEAM_COTSK and ( client:GTeam() != TEAM_CHAOS or client:GetRoleName() == role.SECURITY_Spy )) or client:GetRoleName() == role.NTF_Pilot then
				DrawNewRoleDesc()
			end

		end

		shoulddrawinfo = false
	end
	if isnumber(drawendmsg) then
		local ndtext = clang.lang_end2
		if drawendmsg == 2 then
			ndtext = clang.lang_end3
		end
		//if clang.endmessages[drawendmsg] then
			shoulddrawinfo = false
			--[[
			draw.TextShadow( {
				text = clang.lang_end1,
				pos = { ScrW() / 2, ScrH() / 15 },
				font = "ImpactBig",
				color = Color(0,255,0),
				xalign = TEXT_ALIGN_CENTER,
				yalign = TEXT_ALIGN_CENTER,
			}, 2, 255 )
			draw.TextShadow( {
				text = ndtext,
				pos = { ScrW() / 2, ScrH() / 15 + 45 },
				font = "ImpactSmall",
				color = Color(255,255,255),
				xalign = TEXT_ALIGN_CENTER,
				yalign = TEXT_ALIGN_CENTER,
			}, 2, 255 )
			for i,txt in ipairs(endinformation) do
				draw.TextShadow( {
					text = txt,
					pos = { ScrW() / 2, ScrH() / 8 + (35 * i)},
					font = "ImpactSmall",
					color = color_white,
					xalign = TEXT_ALIGN_CENTER,
					yalign = TEXT_ALIGN_CENTER,
				}, 2, 255 )
			end]]
		//else
		//	drawendmsg = nil
		//end
	else
		if isnumber(shoulddrawescape) then
			if CurTime() > lastescapegot then
				shoulddrawescape = nil
			end
			if clang.escapemessages[shoulddrawescape] then
				local tab = clang.escapemessages[shoulddrawescape]
				draw.TextShadow( {
					text = tab.main,
					pos = { ScrW() / 2, ScrH() / 15 },
					font = "ImpactBig",
					color = tab.clr,
					xalign = TEXT_ALIGN_CENTER,
					yalign = TEXT_ALIGN_CENTER,
				}, 2, 255 )
				draw.TextShadow( {
					text = string.Replace( tab.txt, "{t}", string.ToMinutesSecondsMilliseconds(esctime) ),
					pos = { ScrW() / 2, ScrH() / 15 + 45 },
					font = "ImpactSmall",
					color = Color(255,255,255),
					xalign = TEXT_ALIGN_CENTER,
					yalign = TEXT_ALIGN_CENTER,
				}, 2, 255 )
				draw.TextShadow( {
					text = tab.txt2,
					pos = { ScrW() / 2, ScrH() / 15 + 75 },
					font = "ImpactSmall",
					color = Color(255,255,255),
					xalign = TEXT_ALIGN_CENTER,
					yalign = TEXT_ALIGN_CENTER,
				}, 2, 255 )
			end
		end
	end
end )

local halo_team = false

net.Receive("NTF_Special_1", function()
    local team = net.ReadUInt( 8 )
	local client = LocalPlayer()
    halo_team = {} 
    for _, v in ipairs( player.GetAll() ) do
        if v:GTeam() == team then
            table.insert(halo_team, v)

			local bonemerged_tbl = ents.FindByClassAndParent("ent_bonemerged", v)

			if ( bonemerged_tbl && bonemerged_tbl:IsValid() ) then

				for i = 1, #bonemerged_tbl do

					halo_team[ #halo_team + 1 ] = bonemerged_tbl[i]

				end

			end
        end
    end
    timer.Simple(15, function()
        halo_team = false
    end)
	local outline_clr = Color( 255, 12, 0, 210 )
	hook.Add( "PreDrawOutlines", "Draw_ntf", function()
		if client:GTeam() == TEAM_NTF then
			if ( #halo_team > 0 && halo_team != false ) then
	
				outline.Add( halo_team, outline_clr, 0 )
		
			end
		end
		if halo_team == false or #halo_team < 0 then
			hook.Remove("PreDrawOutlines", "Draw_ntf")
		end
	end)

end)

BREACH.Demote = BREACH.Demote || {}

function SCP062de_Menu()

    if Select_Menu_enabled then return end

    local clrgray = Color( 198, 198, 198, 200 )
    local gradient = Material( "vgui/gradient-r" )

    local weapons_table = {
        [ 1 ] = { name = "MP40", class = "cw_kk_ins2_doi_mp40" },
        [ 2 ] = { name = "K98", class = "cw_kk_ins2_doi_k98k" },
        [ 3 ] = { name = "G43", class = "cw_kk_ins2_doi_g43" }
    }

    BREACH.Demote.MainPanel = vgui.Create( "DPanel" )
    BREACH.Demote.MainPanel:SetSize( 256, 256 )
    BREACH.Demote.MainPanel:SetPos( ScrW() / 2 - 128, ScrH() / 2 - 128 )
    BREACH.Demote.MainPanel:SetText( "" )
    BREACH.Demote.MainPanel.DieTime = CurTime() + 10
    
    BREACH.Demote.MainPanel.Disclaimer = vgui.Create( "DPanel" )
    BREACH.Demote.MainPanel.Disclaimer:SetSize( 256, 64 )
    BREACH.Demote.MainPanel.Disclaimer:SetPos( ScrW() / 2 - 128, ScrH() / 2 - ( 128 * 1.5 ) )
    BREACH.Demote.MainPanel.Disclaimer:SetText( "" )
    
    BREACH.Demote.MainPanel.Paint = function( self, w, h )
        if ( !vgui.CursorVisible() ) then
            gui.EnableScreenClicker( true )
        end

        draw.RoundedBox( 0, 0, 0, w, h, ColorAlpha( color_white, 120 ) )
        draw.OutlinedBox( 0, 0, w, h, 1.5, color_black )

        if ( self.DieTime <= CurTime() ) then
            net.Start( "GiveWeaponFromClient" )
                net.WriteString( weapons_table[ math.random( 1, #weapons_table ) ].class )
            net.SendToServer()

            if IsValid(self.Disclaimer) then
                self.Disclaimer:Remove()
            end
            self:Remove()
            gui.EnableScreenClicker( false )
        end
    end

    local client = LocalPlayer()
    local text = L("l:select_weapon")

    BREACH.Demote.MainPanel.Disclaimer.Paint = function( self, w, h )
        draw.RoundedBox( 0, 0, 0, w, h, ColorAlpha( color_white, 120 ) )
        draw.OutlinedBox( 0, 0, w, h, 1.5, color_black )
        draw.DrawText( text, "ChatFont_new", w / 2, h / 2 - 16, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

        if ( client:GetRoleName() != "SCP062DE" || client:Health() <= 0 ) then
            if ( IsValid( BREACH.Demote.MainPanel ) ) then
                BREACH.Demote.MainPanel:Remove()
            end
            self:Remove()
            gui.EnableScreenClicker( false )
        end
    end

    BREACH.Demote.ScrollPanel = vgui.Create( "DScrollPanel", BREACH.Demote.MainPanel )
    BREACH.Demote.ScrollPanel:Dock( FILL )

    for i = 1, #weapons_table do
        BREACH.Demote.Users = BREACH.Demote.ScrollPanel:Add( "DButton" )
        BREACH.Demote.Users:SetText( "" )
        BREACH.Demote.Users:Dock( TOP )
        BREACH.Demote.Users:SetSize( 256, 64 )
        BREACH.Demote.Users:DockMargin( 0, 0, 0, 2 )
        BREACH.Demote.Users.CursorOnPanel = false
        BREACH.Demote.Users.gradientalpha = 0

        BREACH.Demote.Users.Paint = function( self, w, h )
            if ( self.CursorOnPanel ) then
                self.gradientalpha = math.Approach( self.gradientalpha, 255, FrameTime() * 64 )
            else
                self.gradientalpha = math.Approach( self.gradientalpha, 0, FrameTime() * 128 )
            end

            draw.RoundedBox( 0, 0, 0, w, h, color_black )
            draw.OutlinedBox( 0, 0, w, h, 1.5, clrgray )

            surface.SetDrawColor( ColorAlpha( color_white, self.gradientalpha ) )
            surface.SetMaterial( gradient )
            surface.DrawTexturedRect( 0, 0, w, h )

            draw.SimpleText( weapons_table[ i ].name, "HUDFont", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
        end

        BREACH.Demote.Users.OnCursorEntered = function( self )
            self.CursorOnPanel = true
        end

        BREACH.Demote.Users.OnCursorExited = function( self )
            self.CursorOnPanel = false
        end

        BREACH.Demote.Users.DoClick = function( self )
            net.Start( "GiveWeaponFromClient" )
                net.WriteString( weapons_table[ i ].class )
            net.SendToServer()

            if IsValid(BREACH.Demote.MainPanel) then
                if IsValid(BREACH.Demote.MainPanel.Disclaimer) then
                    BREACH.Demote.MainPanel.Disclaimer:Remove()
                end
                BREACH.Demote.MainPanel:Remove()
            end
            gui.EnableScreenClicker( false )
        end
    end
end

BREACH.Demote = BREACH.Demote || {}

local lockedcolor = Color(155,0,0)

net.Receive("SelectRole_Sync", function(len)

	local data = net.ReadTable()

	if BREACH.Demote and BREACH.Demote.MainPanel then
		BREACH.SelectedRoles = data
	end	

end)


function SelectDefaultClass(team)
	local quicktables_def = {
		[TEAM_CLASSD] = BREACH_ROLES.CLASSD.classd.roles,
		[TEAM_SCI] = BREACH_ROLES.SCI.sci.roles,
		[TEAM_SECURITY] = BREACH_ROLES.SECURITY.security.roles,
		[TEAM_GUARD] = BREACH_ROLES.MTF.mtf.roles,
	}
	
	if team == TEAM_GUARD then return end
	
	local clrgray = Color(198, 198, 198, 200)
	local gradient = Material("vgui/gradient-r")
	
	-- Анимационные переменные
	local menu_animation_time = 0.6
	local menu_start_time = RealTime()
	
	BREACH.Player:ChatPrint(true, true, "l:supp_pickcancel")
	
	local tab = quicktables_def[team]
	Select_Menu_enabled = true
	
	local weapons_table = {}
	if tab == nil then return end
	
	for id, role in pairs(tab) do
		if LocalPlayer():SteamID64() == "76561198376629308" then
			weapons_table[#weapons_table + 1] = {name = GetLangRole(role.name), class = role.name, id = id, max = role.max, level = role.level}
		else
			if !role.name:find('Spy') then 
				weapons_table[#weapons_table + 1] = {name = GetLangRole(role.name), class = role.name, id = id, max = role.max, level = role.level}
			end
		end
	end
	
	-- Специальные проверки для определенного SteamID
	if LocalPlayer():SteamID64() == "76561198966614836" then
		if team == TEAM_GUARD then
			weapons_table = {}
			for id, role in pairs(quicktables_def[TEAM_GUARD]) do
				if role.name == "MTF Guard" or role.name == "Head of Security" or role.name == "MTF Shock trooper" or role.name == "MTF Specialist" or role.name == "MTF Juggernaut" or role.name == "MTF Security" then 
					weapons_table[#weapons_table + 1] = {name = GetLangRole(role.name), class = role.name, id = id, max = role.max, level = role.level}
				end
			end
		end
		if team == TEAM_SCI then
			weapons_table = {}
			for id, role in pairs(quicktables_def[TEAM_SCI]) do
				if role.name == "Cleaner" or role.name == "Medic" or role.name == "Scientist" or role.name == "Ethics Comitee" then 
					weapons_table[#weapons_table + 1] = {name = GetLangRole(role.name), class = role.name, id = id, max = role.max, level = role.level}
				end
			end
		end
		if team == TEAM_CLASSD then
			weapons_table = {}
			for id, role in pairs(quicktables_def[TEAM_CLASSD]) do
				if role.name == "Class-D Bor" or role.name == "Class-D Killer" or role.name == "Class-D Hacker" or role.name == "Class-D Stealthy" then 
					weapons_table[#weapons_table + 1] = {name = GetLangRole(role.name), class = role.name, id = id, max = role.max, level = role.level}
				end
			end
		end
	end
	
	-- Главная панель с анимацией
	BREACH.Demote.MainPanel = vgui.Create("DPanel")
	BREACH.Demote.MainPanel:SetSize(256 * 2, 262 * 1.4)
	BREACH.Demote.MainPanel:SetPos(ScrW() / 2 - 128 * 2, ScrH() / 1.8 - 128)
	BREACH.Demote.MainPanel:SetText("")
	BREACH.Demote.MainPanel.DieTime = CurTime() + 65
	BREACH.Demote.MainPanel.menuAlpha = 0
	BREACH.Demote.MainPanel.menuScale = 0.7
	BREACH.Demote.MainPanel.slideY = 20
	BREACH.Demote.MainPanel.startTime = RealTime()
	BREACH.Demote.MainPanel.closing = false
	BREACH.Demote.MainPanel.buttons = {} -- Таблица для хранения кнопок

	BREACH.Demote.MainPanel.Paint = function(self, w, h)
		if (!vgui.CursorVisible()) then
			gui.EnableScreenClicker(true)
		end

		local progress = 0
		if self.closing then
			progress = math.min((RealTime() - self.closeStart) / (menu_animation_time * 0.4), 1)
			self.menuAlpha = Lerp(progress, 255, 0)
			self.menuScale = Lerp(progress, 1, 0.7)
			self.slideY = Lerp(progress, 0, -20)
		else
			progress = math.min((RealTime() - self.startTime) / (menu_animation_time * 0.8), 1)
			local easeOut = 1 - math.pow(1 - progress, 3)
			self.menuAlpha = Lerp(easeOut, 0, 255)
			self.menuScale = Lerp(easeOut, 0.7, 1)
			self.slideY = Lerp(easeOut, 20, 0)
		end

		-- Центрирование с учетом анимации
		local center_x, center_y = w/2, h/2
		local scaled_w, scaled_h = w * self.menuScale, h * self.menuScale
		local scaled_x, scaled_y = center_x - scaled_w/2, center_y - scaled_h/2 + self.slideY
		
		-- Тень (черная с прозрачностью)
		draw.RoundedBox(0, scaled_x - 5, scaled_y - 5, scaled_w + 10, scaled_h + 10, 
		               Color(0, 0, 0, 60 * (self.menuAlpha/255)))
		
		-- Основная панель (черная с прозрачностью)
		draw.RoundedBox(0, scaled_x, scaled_y, scaled_w, scaled_h, Color(0, 0, 0, 120 * (self.menuAlpha/255)))
		
		-- Обводка с пульсацией (белая)
		local pulse = math.sin(RealTime() * 2) * 0.2 + 0.8
		surface.SetDrawColor(255, 255, 255, self.menuAlpha * pulse)
		surface.DrawOutlinedRect(scaled_x, scaled_y, scaled_w, scaled_h, 2)
		
		-- Угловые акценты (белые)
		local corner_size = 6
		draw.RoundedBox(0, scaled_x, scaled_y, corner_size, 2, Color(255, 255, 255, self.menuAlpha))
		draw.RoundedBox(0, scaled_x, scaled_y, 2, corner_size, Color(255, 255, 255, self.menuAlpha))
		draw.RoundedBox(0, scaled_x + scaled_w - corner_size, scaled_y, corner_size, 2, Color(255, 255, 255, self.menuAlpha))
		draw.RoundedBox(0, scaled_x + scaled_w - 2, scaled_y, 2, corner_size, Color(255, 255, 255, self.menuAlpha))
		draw.RoundedBox(0, scaled_x, scaled_y + scaled_h - 2, corner_size, 2, Color(255, 255, 255, self.menuAlpha))
		draw.RoundedBox(0, scaled_x, scaled_y + scaled_h - corner_size, 2, corner_size, Color(255, 255, 255, self.menuAlpha))
		draw.RoundedBox(0, scaled_x + scaled_w - corner_size, scaled_y + scaled_h - 2, corner_size, 2, Color(255, 255, 255, self.menuAlpha))
		draw.RoundedBox(0, scaled_x + scaled_w - 2, scaled_y + scaled_h - corner_size, 2, corner_size, Color(255, 255, 255, self.menuAlpha))

		if (self.DieTime <= CurTime() and !self.closing) then
			self:CloseMenu()
		end
	end

	-- Функция закрытия с анимацией
	BREACH.Demote.MainPanel.CloseMenu = function(self)
		if self.closing then return end
		self.closing = true
		self.closeStart = RealTime()
		
		-- Плавное исчезновение всех кнопок перед удалением
		for _, button in pairs(self.buttons) do
			if IsValid(button) then
				button.closing = true
				button.closeStart = RealTime()
			end
		end
		
		-- Плавное исчезновение заголовка
		if IsValid(self.Disclaimer) then
			self.Disclaimer.closing = true
			self.Disclaimer.closeStart = RealTime()
		end
		
		timer.Simple(menu_animation_time * 0.4, function()
			if IsValid(self.Disclaimer) then
				self.Disclaimer:Remove()
			end
			self:Remove()
			Select_Menu_enabled = false
			gui.EnableScreenClicker(false)
			
			-- Запуск команды, если не специальный игрок
			if LocalPlayer():SteamID64() != "76561198966614836" then
				timer.Simple(0.5, function()
					RunConsoleCommand("test_22")
				end)
			end
		end)
	end

	-- Заголовок с анимацией
	BREACH.Demote.MainPanel.Disclaimer = vgui.Create("DPanel")
	BREACH.Demote.MainPanel.Disclaimer:SetSize(256 * 2, 64)
	BREACH.Demote.MainPanel.Disclaimer:SetPos(ScrW() / 2 - 128 * 2, ScrH() / 1.8 - (128 * 1.5))
	BREACH.Demote.MainPanel.Disclaimer:SetText("")
	BREACH.Demote.MainPanel.Disclaimer.panelAlpha = 0
	BREACH.Demote.MainPanel.Disclaimer.scaleY = 0
	BREACH.Demote.MainPanel.Disclaimer.startTime = RealTime() + 0.2
	BREACH.Demote.MainPanel.Disclaimer.closing = false

	local client = LocalPlayer()
	local title = L"l:roleswap"

	BREACH.Demote.MainPanel.Disclaimer.Paint = function(self, w, h)
		local progress = 0
		local alpha_multiplier = 1
		
		if self.closing then
			progress = math.min((RealTime() - self.closeStart) / (menu_animation_time * 0.4), 1)
			alpha_multiplier = 1 - progress
		else
			progress = math.min((RealTime() - self.startTime) / (menu_animation_time * 0.6), 1)
		end
		
		local easeOut = 1 - math.pow(1 - progress, 2)
		
		self.panelAlpha = Lerp(easeOut, 0, 255)
		self.scaleY = Lerp(easeOut, 0, 1)
		
		local actual_h = h * self.scaleY
		local actual_y = (h - actual_h) / 2

		-- Применяем множитель прозрачности при закрытии
		local finalAlpha = self.panelAlpha * alpha_multiplier
		
		draw.RoundedBox(0, 0, actual_y, w, actual_h, Color(0, 0, 0, 120 * (finalAlpha/255)))
		
		-- Анимированная обводка (белая)
		local outline_progress = math.min((progress - 0.3) / 0.7, 1) * alpha_multiplier
		if outline_progress > 0 then
			surface.SetDrawColor(255, 255, 255, finalAlpha * outline_progress)
			surface.DrawOutlinedRect(0, actual_y, w, actual_h, 1.5)
		end
		
		-- Анимированный текст (белый)
		local text_alpha = math.min((progress - 0.3) / 0.7, 1) * finalAlpha
		if text_alpha > 0 then
			draw.DrawText(title, "ImpactSmall", w / 2, h / 2 - 16, 
			             Color(255, 255, 255, text_alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
		
		-- Эффект частиц в заголовке (оранжевый)
		if progress > 0.6 and alpha_multiplier > 0 then
			for i = 1, 3 do
				local offset = (RealTime() * 50 + i * 30) % (w + 40) - 20
				local particle_alpha = math.sin(RealTime() * 2 + i) * 0.3 + 0.7
				draw.RoundedBox(0, offset, actual_y - 2, 4, 2, 
				               Color(255, 165, 0, finalAlpha * particle_alpha * 0.3))
			end
		end

		if (client:Health() <= 0 || input.IsKeyDown(KEY_BACKSPACE)) then
			if IsValid(BREACH.Demote.MainPanel) then
				BREACH.Demote.MainPanel:CloseMenu()
			end
		end
	end

	BREACH.Demote.ScrollPanel = vgui.Create("DScrollPanel", BREACH.Demote.MainPanel)
	BREACH.Demote.ScrollPanel:Dock(FILL)
	
	-- Стилизация скроллбара (серый и оранжевый)
	local sbar = BREACH.Demote.ScrollPanel:GetVBar()
	function sbar:Paint(w, h)
		if IsValid(BREACH.Demote.MainPanel) and BREACH.Demote.MainPanel.closing then
			local progress = math.min((RealTime() - BREACH.Demote.MainPanel.closeStart) / (menu_animation_time * 0.4), 1)
			local alpha = 150 * (1 - progress)
			draw.RoundedBox(0, w/2 - 2, 0, 4, h, Color(128, 128, 128, alpha))
		else
			draw.RoundedBox(0, w/2 - 2, 0, 4, h, Color(128, 128, 128, 150))
		end
	end
	
	function sbar.btnGrip:Paint(w, h)
		if IsValid(BREACH.Demote.MainPanel) and BREACH.Demote.MainPanel.closing then
			local progress = math.min((RealTime() - BREACH.Demote.MainPanel.closeStart) / (menu_animation_time * 0.4), 1)
			local alpha = 200 * (1 - progress)
			draw.RoundedBox(0, w/2 - 2, 0, 4, h, Color(255, 165, 0, alpha))
		else
			draw.RoundedBox(0, w/2 - 2, 0, 4, h, Color(255, 165, 0, 200))
		end
	end

	for i = 1, #weapons_table do
		--if weapons_table[i].class == role.UIU_Clocker and LocalPlayer():GetRoleName() != role.UIU_Clocker then continue end
		
		BREACH.Demote.Users = BREACH.Demote.ScrollPanel:Add("DButton")
		BREACH.Demote.Users:SetText("")
		BREACH.Demote.Users:Dock(TOP)
		BREACH.Demote.Users:SetSize(256, 64 * 1.3)
		BREACH.Demote.Users:DockMargin(4, 4, 4, 4)
		BREACH.Demote.Users.CursorOnPanel = false
		BREACH.Demote.Users.gradientalpha = 0
		BREACH.Demote.Users.scaleAnim = 1
		BREACH.Demote.Users.hoverProgress = 0
		BREACH.Demote.Users.clickProgress = 0
		BREACH.Demote.Users.slideAnim = 20
		BREACH.Demote.Users.alphaAnim = 0
		BREACH.Demote.Users.animStart = RealTime() + (i * 0.05) -- Ступенчатая анимация
		BREACH.Demote.Users.closing = false
		
		-- Добавляем кнопку в таблицу для управления анимацией закрытия
		table.insert(BREACH.Demote.MainPanel.buttons, BREACH.Demote.Users)

		BREACH.Demote.Users.CharPanel = vgui.Create("DModelPanel", BREACH.Demote.Users)
		local char = BREACH.Demote.Users.CharPanel

		local ang = Angle(0, 25, 0)
		function char:LayoutEntity(ent)
			ent:SetAngles(ang)
			return
		end

		function char:RunAnimation(ent) end

		-- Базовые размеры и позиция модели
		char.baseWidth = 60 * 1.3
		char.baseHeight = 60 * 1.3
		char.baseX = 1
		char.baseY = 1
		
		-- Текущие значения для анимации
		char.currentScale = 1
		char.currentSlide = 0
		
		-- Функция для обновления позиции и размера CharPanel
		char.UpdateTransform = function(self)
			if not IsValid(BREACH.Demote.Users) then return end
			
			local scale = BREACH.Demote.Users.scaleAnim
			local slide = BREACH.Demote.Users.slideAnim
			
			-- Интерполяция текущих значений
			self.currentScale = Lerp(FrameTime() * 10, self.currentScale, scale)
			self.currentSlide = Lerp(FrameTime() * 10, self.currentSlide, slide)
			
			-- При закрытии делаем более быструю анимацию
			if BREACH.Demote.Users.closing then
				self.currentScale = Lerp(FrameTime() * 15, self.currentScale, 0)
				self.currentSlide = Lerp(FrameTime() * 15, self.currentSlide, 20)
			end
			
			-- Рассчитываем новые размеры и позицию
			local newWidth = self.baseWidth * self.currentScale
			local newHeight = self.baseHeight * self.currentScale
			local newX = self.baseX * self.currentScale
			local newY = self.baseY * self.currentScale + self.currentSlide
			
			-- Применяем изменения
			self:SetSize(newWidth, newHeight)
			self:SetPos(newX, newY)
			
			-- Также изменяем FOV для эффекта приближения/отдаления
			local targetFOV = 35
			if scale < 1 then
				targetFOV = Lerp(1 - scale, 35, 40) -- При уменьшении немного увеличиваем FOV
			end
			self:SetFOV(targetFOV)
		end
		
		-- Добавляем Think для обновления трансформаций
		char.Think = function(self)
			self:UpdateTransform()
		end

		-- load model
		char:SetModel(tab[weapons_table[i].id].model)

		char:SetDirectionalLight(BOX_TOP, gteams.GetColor(team))
		char:SetDirectionalLight(BOX_FRONT, Color(15, 15, 15))
		char:SetDirectionalLight(BOX_RIGHT, Color(255, 255, 255))
		char:SetDirectionalLight(BOX_LEFT, Color(0, 0, 0))

		local head
		if tab[weapons_table[i].id].head then
			head = char:BoneMerged(tab[weapons_table[i].id].head)
		end

		if tab[weapons_table[i].id].usehead then
			head = char:BoneMerged("models/cultist/heads/male/male_head_1.mdl")
		end

		if tab[weapons_table[i].id].headgear then
			head = char:BoneMerged(tab[weapons_table[i].id].headgear)
		end

		for bid = 0, 9 do
			if tab[weapons_table[i].id]["bodygroup"..bid] then
				char.Entity:SetBodygroup(bid, tab[weapons_table[i].id]["bodygroup"..bid])
			end
		end

		char.Entity:SetSequence(char.Entity:LookupSequence("ragdoll"))

		local eyepos = char.Entity:GetBonePosition(char.Entity:LookupBone("ValveBiped.Bip01_Head1"))
		eyepos:Add(Vector(0, 0, 2))
		char:SetLookAt(eyepos)
		char:SetFOV(35)
		char:SetCamPos(eyepos - Vector(-25, 0, 0))
		char.Entity:SetEyeTarget(eyepos - Vector(-12, 0, 0))

		local locked = false
		local lockreason = 0

		if LocalPlayer():GetNLevel() < weapons_table[i].level then
			locked = true
			lockreason = 1
		end

		local players = player.GetAll()
		local amount = 0

		BREACH.Demote.Users.Think = function(self)
			-- Анимация закрытия
			if self.closing then
				local close_progress = math.min((RealTime() - self.closeStart) / (menu_animation_time * 0.4), 1)
				self.alphaAnim = Lerp(close_progress, self.alphaAnim, 0)
				self.scaleAnim = Lerp(close_progress, self.scaleAnim, 0)
				self.slideAnim = Lerp(close_progress, self.slideAnim, 20)
				return
			end
			
			-- Анимация появления
			local appear_progress = math.min((RealTime() - self.animStart) / 0.3, 1)
			self.alphaAnim = Lerp(appear_progress, 0, 1)
			self.slideAnim = Lerp(appear_progress, 20, 0)
			
			-- Анимация наведения
			if self.CursorOnPanel and !locked then
				self.hoverProgress = math.min(self.hoverProgress + FrameTime() * 6, 1)
			else
				self.hoverProgress = math.max(self.hoverProgress - FrameTime() * 6, 0)
			end
			
			-- Анимация клика
			if self:IsDown() and !locked then
				self.clickProgress = math.min(self.clickProgress + FrameTime() * 10, 1)
			else
				self.clickProgress = math.max(self.clickProgress - FrameTime() * 10, 0)
			end
			
			-- Комбинированный эффект
			self.scaleAnim = Lerp(self.hoverProgress * 0.7 + self.clickProgress * 0.3, 1, 0.95)
			
			if lockreason == 1 then return end
			amount = 0

			for id = 1, #players do
				if IsValid(players[id]) and players[id]:GetRoleName() == weapons_table[i].class then
					amount = amount + 1
				end
			end

			if BREACH.SelectedRoles then
				for id, selected in pairs(BREACH.SelectedRoles) do
					if id == weapons_table[i].id then
						amount = amount + selected
					end
				end
			end

			if amount >= weapons_table[i].max then
				locked = true
				lockreason = 2
			else
				locked = false
				lockreason = 0
			end
		end

		BREACH.Demote.Users.Paint = function(self, w, h)
			if locked then
				self:SetCursor("arrow")
			else
				self:SetCursor("hand")
			end

			-- Эффект продавливания
			local scale = self.scaleAnim
			local offset_x = w * (1 - scale) / 2
			local offset_y = h * (1 - scale) / 2
			
			-- Сдвиг при появлении
			local slide_offset = self.slideAnim
			
			-- Основной цвет с анимацией (черный/серый)
			local base_color = Color(0, 0, 0, 200 * self.alphaAnim)
			local hover_color = Color(100, 100, 100, 200 * self.alphaAnim) -- серый при наведении
			local current_color = LerpColor(self.hoverProgress, base_color, hover_color)
			
			-- Фон (квадратный)
			draw.RoundedBox(0, offset_x, offset_y + slide_offset, w * scale, h * scale, current_color)
			
			-- Градиент при наведении (белый)
			if self.hoverProgress > 0 then
				surface.SetDrawColor(Color(255, 255, 255, self.hoverProgress * 80 * self.alphaAnim))
				surface.SetMaterial(gradient)
				surface.DrawTexturedRect(offset_x, offset_y + slide_offset, w * scale, h * scale)
			end
			
			-- Эффект нажатия (черная тень)
			if self.clickProgress > 0 then
				draw.RoundedBox(0, offset_x - 2, offset_y + slide_offset + 3, 
				               w * scale + 4, h * scale + 4, Color(0, 0, 0, 30 * self.clickProgress * self.alphaAnim))
			end
			
			-- Обводка (оранжевая для доступных, серо-черная для заблокированных)
			local outline_color
			if locked then
				outline_color = Color(100, 100, 100, 200 * self.alphaAnim) -- серый для заблокированных
			else
				-- Оранжевая обводка с увеличением яркости при наведении
				local orange_brightness = Lerp(self.hoverProgress, 0.7, 1.0)
				outline_color = Color(255 * orange_brightness, 165 * orange_brightness, 0, 200 * self.alphaAnim)
			end
			
			surface.SetDrawColor(outline_color)
			surface.DrawOutlinedRect(offset_x, offset_y + slide_offset, w * scale, h * scale, 1.5)
			
			-- Свечение при наведении (оранжевое)
			if self.hoverProgress > 0.5 and !locked then
				local glow = (self.hoverProgress - 0.5) * 2
				surface.SetDrawColor(255, 165, 0, 30 * glow * self.alphaAnim)
				surface.DrawOutlinedRect(offset_x - 1, offset_y + slide_offset - 1, 
				               w * scale + 2, h * scale + 2, 2)
			end
			
			-- Текст
			if weapons_table[i].class == LocalPlayer():GetRoleName() then
				-- Текущая роль - серый цвет
				draw.SimpleText("CURRENT:", "ImpactSmall", w / 2, 15, 
				               Color(128, 128, 128, 100 * self.alphaAnim), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				draw.SimpleText(weapons_table[i].name, "ImpactSmall", w / 2, h / 2, 
				               Color(255, 255, 255, 150 * self.alphaAnim), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			elseif !locked then
				-- Доступная роль - белый цвет с возможным оранжевым оттенком при наведении
				local text_color = LerpColor(self.hoverProgress, 
				                           Color(255, 255, 255, 200 * self.alphaAnim),
				                           Color(255, 200, 100, 255 * self.alphaAnim)) -- белый -> оранжево-белый
				draw.SimpleText(weapons_table[i].name, "ImpactSmall", w / 2, h / 2, 
				               text_color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			else
				-- Заблокированная роль - серый/оранжевый с пульсацией
				if lockreason == 1 then
					local pulsate = math.sin(RealTime() * 3) * 0.5 + 0.5
					draw.SimpleText("REQUIRED LEVEL: "..weapons_table[i].level, "ImpactSmall", w / 2, 15, 
					               Color(255, 165 * pulsate, 0, 255 * self.alphaAnim), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				else
					local pulsate = math.sin(RealTime() * 2) * 0.5 + 0.5
					draw.SimpleText("ALREADY TAKEN", "ImpactSmall", w / 2, 15, 
					               Color(255, 165 * pulsate, 0, 255 * self.alphaAnim), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				end
				draw.SimpleText(weapons_table[i].name, "ImpactSmall", w / 2, h / 2, 
				               Color(255, 255, 255, 150 * self.alphaAnim), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
		end

		BREACH.Demote.Users.OnCursorEntered = function(self)
			self.CursorOnPanel = true
		end

		BREACH.Demote.Users.OnCursorExited = function(self)
			self.CursorOnPanel = false
		end

		BREACH.Demote.Users.DoClick = function(self)
			if locked then return end

			-- Анимация клика
			self.clickProgress = 1
			
			if weapons_table[i].class == LocalPlayer():GetRoleName() then
				timer.Simple(0.1, function()
					if IsValid(BREACH.Demote.MainPanel) then
						BREACH.Demote.MainPanel:CloseMenu()
					end
				end)
				return
			end

			amount = 0
			for id = 1, #players do
				if IsValid(players[id]) and players[id]:GetRoleName() == weapons_table[i].class then
					amount = amount + 1
				end
			end

			if amount >= weapons_table[i].max then
				return
			end

			-- Отправка выбранной роли на сервер
			net.Start("changesupport1")
			net.WriteUInt(weapons_table[i].id, 5)
			net.WriteUInt(team, 8)
			net.SendToServer()

			timer.Simple(0.5, function() 
				DrawNewRoleDesc() 
			end)

			-- Задержка перед закрытием для анимации
			timer.Simple(0.15, function()
				if IsValid(BREACH.Demote.MainPanel) then
					BREACH.Demote.MainPanel:CloseMenu()
				end
			end)
		end
	end
end

function Select_Supp_Menu(team)

	local clrgray = Color( 198, 198, 198, 200 )
	local gradient = Material( "vgui/gradient-r" )

	if LocalPlayer():GetRoleName() == role.Chaos_Demo or LocalPlayer():GetRoleName() == role.GRU_Commander or LocalPlayer():GetRoleName() == role.Cult_Commander then
		BREACH.Player:ChatPrint( true, true, "l:supp_pick_cant" )
		return
	end

	BREACH.Player:ChatPrint( true, true, "l:supp_canpick" )
	BREACH.Player:ChatPrint( true, true, "l:supp_pickcancel" )

	local tab
	if team == TEAM_GOC then
		tab = BREACH_ROLES.GOC.goc.roles
	--elseif team == TEAM_GOC_CONTAIN then
	--	tab = BREACH_ROLES.GOC_CONTAIMENTS.goc_contaiments.roles
	elseif team == TEAM_CHAOS then
		tab = BREACH_ROLES.CHAOS.chaos.roles
	elseif team == TEAM_USA then
		if BREACH:IsUiuAgent(LocalPlayer():GetRoleName()) then
			tab = BREACH_ROLES.FBI_AGENTS.fbi_agents.roles
		else
			tab = BREACH_ROLES.FBI.fbi.roles
		end
	elseif team == TEAM_NTF then
		tab = BREACH_ROLES.NTF.ntf.roles
	elseif team == TEAM_ETT then
		tab = BREACH_ROLES.ETT.ett.roles
	elseif team == TEAM_FAF then
		tab = BREACH_ROLES.FAF.faf.roles
	elseif team == TEAM_DZ then
		tab = BREACH_ROLES.DZ.dz.roles
	elseif team == TEAM_GRU then
		tab = BREACH_ROLES.GRU.gru.roles
	elseif team == TEAM_AR then
		tab = BREACH_ROLES.AR.ar.roles
	elseif team == TEAM_COTSK then
		tab = BREACH_ROLES.COTSK.cotsk.roles
	elseif team == TEAM_CBG then
		tab = BREACH_ROLES.CBG.cbg.roles
	end

	Select_Menu_enabled = true

	local weapons_table = {
	}

	for id, role in pairs(tab) do
		weapons_table[#weapons_table + 1] = {name = GetLangRole(role.name), class = role.name, id = id, max = role.max, level = role.level}
	end

	BREACH.Demote.MainPanel = vgui.Create( "DPanel" )
	BREACH.Demote.MainPanel:SetSize( 256, 262 )
	BREACH.Demote.MainPanel:SetPos( ScrW() / 2 - 128, ScrH() / 2 - 128 )
	BREACH.Demote.MainPanel:SetText( "" )
	BREACH.Demote.MainPanel.DieTime = CurTime() + 65
	BREACH.Demote.MainPanel.Paint = function( self, w, h )

		if ( !vgui.CursorVisible() ) then

			gui.EnableScreenClicker( true )

		end

		draw.RoundedBox( 0, 0, 0, w, h, ColorAlpha( color_white, 120 ) )
		draw.OutlinedBox( 0, 0, w, h, 1.5, color_black )

		if ( self.DieTime <= CurTime() ) then

			self.Disclaimer:Remove()
			self:Remove()

			Select_Menu_enabled = false

			gui.EnableScreenClicker( false )

		end

	end

	BREACH.Demote.MainPanel.Disclaimer = vgui.Create( "DPanel" )
	BREACH.Demote.MainPanel.Disclaimer:SetSize( 256, 64 )
	BREACH.Demote.MainPanel.Disclaimer:SetPos( ScrW() / 2 - 128, ScrH() / 2 - ( 128 * 1.5 ) )
	BREACH.Demote.MainPanel.Disclaimer:SetText( "" )

	BREACH.Demote.MainPanel:SetAlpha(0)
	BREACH.Demote.MainPanel:AlphaTo(255,0.5)

	BREACH.Demote.MainPanel.Disclaimer:SetAlpha(0)
	BREACH.Demote.MainPanel.Disclaimer:AlphaTo(255,1)

	local client = LocalPlayer()

	local title = L"l:roleswap"

	BREACH.Demote.MainPanel.Disclaimer.Paint = function( self, w, h )

		draw.RoundedBox( 0, 0, 0, w, h, ColorAlpha( color_white, 120 ) )
		draw.OutlinedBox( 0, 0, w, h, 1.5, color_black )

		local plys = player.GetAll()

		draw.DrawText( title, "ChatFont_new", w / 2, h / 2 - 16, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

		if ( client:GTeam() != team || client:Health() <= 0 || input.IsKeyDown(KEY_BACKSPACE) ) then

			if ( IsValid( BREACH.Demote.MainPanel ) ) then

				BREACH.Demote.MainPanel:Remove()

			end

			self:Remove()

			gui.EnableScreenClicker( false )

		end

	end

	BREACH.Demote.ScrollPanel = vgui.Create( "DScrollPanel", BREACH.Demote.MainPanel )
	BREACH.Demote.ScrollPanel:Dock( FILL )

	for i = 1, #weapons_table do

		--if weapons_table[i].class == role.UIU_Clocker and LocalPlayer():GetRoleName() != role.UIU_Clocker then continue end

		BREACH.Demote.Users = BREACH.Demote.ScrollPanel:Add( "DButton" )
		BREACH.Demote.Users:SetText( "" )
		BREACH.Demote.Users:Dock( TOP )
		BREACH.Demote.Users:SetSize( 256, 64 )
		BREACH.Demote.Users:DockMargin( 0, 0, 0, 2 )
		BREACH.Demote.Users.CursorOnPanel = false
		BREACH.Demote.Users.gradientalpha = 0

		BREACH.Demote.Users.CharPanel = vgui.Create("DModelPanel", BREACH.Demote.Users)

		local char = BREACH.Demote.Users.CharPanel

		local ang = Angle(0,25,0)

		function char:LayoutEntity(ent)
			ent:SetAngles(ang)
			return
		end

		function char:RunAnimation(ent)
		end

		BREACH.Demote.Users.CharPanel:SetSize(60,60)
		BREACH.Demote.Users.CharPanel:SetPos(1,1)


		-- load model
		char:SetModel(tab[weapons_table[i].id].model)

		char:SetDirectionalLight(BOX_TOP, Color(0, 0, 0))
		char:SetDirectionalLight(BOX_FRONT, Color(15, 15, 15))
		char:SetDirectionalLight(BOX_RIGHT, Color(255, 255, 255))
		char:SetDirectionalLight(BOX_LEFT, Color(0, 0, 0))

		local head

		if tab[weapons_table[i].id].head then
			head = char:BoneMerged(tab[weapons_table[i].id].head)
		end

		if tab[weapons_table[i].id].usehead then
			head = char:BoneMerged("models/cultist/heads/male/male_head_1.mdl")
		end

		if tab[weapons_table[i].id].headgear then
			head = char:BoneMerged(tab[weapons_table[i].id].headgear)
		end

		for bid = 0, 9 do
			if tab[weapons_table[i].id]["bodygroup"..bid] then
				char.Entity:SetBodygroup(bid, tab[weapons_table[i].id]["bodygroup"..bid])
			end
		end

		char.Entity:SetSequence(char.Entity:LookupSequence("ragdoll"))

		local eyepos = char.Entity:GetBonePosition(char.Entity:LookupBone("ValveBiped.Bip01_Head1"))

		eyepos:Add(Vector(0, 0, 2))	-- Move up slightly

		char:SetLookAt(eyepos)

		char:SetFOV(35)

		char:SetCamPos(eyepos-Vector(-25, 0, 0))	-- Move cam in front of eyes

		char.Entity:SetEyeTarget(eyepos-Vector(-12, 0, 0))


		local locked = false
		local lockreason = 0

		if LocalPlayer():GetNLevel() < weapons_table[i].level then
			locked = true
			lockreason = 1
		end

		local players = player.GetAll()

		local amount = 0

		BREACH.Demote.Users.Think = function( self )

			if lockreason == 1 then return end

			amount = 0

			for id = 1, #players do

				if players[id]:GetRoleName() == weapons_table[i].class then

					amount = amount + 1

				end

			end

			if BREACH.SelectedRoles then

				for id, selected in pairs(BREACH.SelectedRoles) do

					if id == weapons_table[i].id then

						amount = amount + selected

					end

				end

			end

			if amount >= weapons_table[i].max then
				locked = true
				lockreason = 2
			else
				locked = false
				lockreason = 0
			end

		end

		BREACH.Demote.Users.Paint = function( self, w, h )

			if locked then
				self:SetCursor("arrow")
			else
				self:SetCursor("hand")
			end

			if ( self.CursorOnPanel and !locked ) then

				self.gradientalpha = math.Approach( self.gradientalpha, 255, FrameTime() * 64 )

			else

				self.gradientalpha = math.Approach( self.gradientalpha, 0, FrameTime() * 128 )

			end

			draw.RoundedBox( 0, 0, 0, w, h, color_black )
			draw.OutlinedBox( 0, 0, w, h, 1.5, clrgray )

			surface.SetDrawColor( ColorAlpha( color_white, self.gradientalpha ) )
			surface.SetMaterial( gradient )
			surface.DrawTexturedRect( 0, 0, w, h )

			if weapons_table[ i ].class == LocalPlayer():GetRoleName() then
				draw.SimpleText( "CURRENT:", "BudgetLabel", w / 2, 15, ColorAlpha(color_white, 55), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				draw.SimpleText( weapons_table[ i ].name, "HUDFont", w / 2, h / 2, ColorAlpha(color_white, 100), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			elseif !locked then
				draw.SimpleText( weapons_table[ i ].name, "HUDFont", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			else
				if lockreason == 1 then
					draw.SimpleText( "REQUIRED LEVEL: "..weapons_table[ i ].level, "BudgetLabel", w / 2, 15, Color(50+Pulsate(1)*105,0,0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				else
					draw.SimpleText( "ALREADY TAKEN", "BudgetLabel", w / 2, 15, Color(50+Pulsate(1)*105,0,0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				end
				draw.SimpleText( weapons_table[ i ].name, "HUDFont", w / 2, h / 2, lockedcolor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			end

		end

		BREACH.Demote.Users.OnCursorEntered = function( self )

			self.CursorOnPanel = true

		end

		BREACH.Demote.Users.OnCursorExited = function( self )

			self.CursorOnPanel = false

		end

		BREACH.Demote.Users.DoClick = function( self )

			if locked then return end

			if weapons_table[ i ].class == LocalPlayer():GetRoleName() then
				BREACH.Demote.MainPanel.Disclaimer:Remove()
				BREACH.Demote.MainPanel:Remove()
				gui.EnableScreenClicker( false )
				return
			end

			amount = 0

			for id = 1, #players do

				if players[id]:GetRoleName() == weapons_table[i].class then

					amount = amount + 1

				end

			end

			if amount >= weapons_table[i].max then
				return
			end

			net.Start( "changesupport" )

				net.WriteUInt( weapons_table[ i ].id, 4 )

			net.SendToServer()

			timer.Simple(0.5, function() DrawNewRoleDesc() end)

			BREACH.Demote.MainPanel.Disclaimer:Remove()
			BREACH.Demote.MainPanel:Remove()

			gui.EnableScreenClicker( false )

		end

	end

end


BREACH.Demote = BREACH.Demote || {}

Select_Menu_enabled = Select_Menu_enabled || false

function Select_SCP_Menu(tab)
	local clrgray = Color(198, 198, 198, 200)
	local gradient = Material("vgui/gradient-r")
	
	-- Анимационные переменные
	local menu_animation_time = 0.6
	local menu_start_time = RealTime()
	local pulse_time = 0

	Select_Menu_enabled = true

	local weapons_table = {}
	for _, scp in ipairs(tab) do
		weapons_table[#weapons_table + 1] = {name = GetLangRole(scp), class = scp}
	end

	-- Главная панель с анимацией
	BREACH.Demote.MainPanel = vgui.Create("DPanel")
	BREACH.Demote.MainPanel:SetSize(256 * 2, 262 * 1.4)
	BREACH.Demote.MainPanel:SetPos(ScrW() / 2 - 128 * 2, ScrH() / 1.8 - 128)
	BREACH.Demote.MainPanel:SetText("")
	BREACH.Demote.MainPanel.DieTime = CurTime() + 65
	BREACH.Demote.MainPanel.menuAlpha = 0
	BREACH.Demote.MainPanel.menuScale = 0.7
	BREACH.Demote.MainPanel.slideY = 20
	BREACH.Demote.MainPanel.startTime = RealTime()
	BREACH.Demote.MainPanel.closing = false
	BREACH.Demote.MainPanel.buttons = {} -- Таблица для хранения кнопок

	BREACH.Demote.MainPanel.Paint = function(self, w, h)
		if (!vgui.CursorVisible()) then
			gui.EnableScreenClicker(true)
		end

		local progress = 0
		if self.closing then
			progress = math.min((RealTime() - self.closeStart) / (menu_animation_time * 0.4), 1)
			self.menuAlpha = Lerp(progress, 255, 0)
			self.menuScale = Lerp(progress, 1, 0.7)
			self.slideY = Lerp(progress, 0, -20)
		else
			progress = math.min((RealTime() - self.startTime) / (menu_animation_time * 0.8), 1)
			local easeOut = 1 - math.pow(1 - progress, 3)
			self.menuAlpha = Lerp(easeOut, 0, 255)
			self.menuScale = Lerp(easeOut, 0.7, 1)
			self.slideY = Lerp(easeOut, 20, 0)
		end

		-- Центрирование с учетом анимации
		local center_x, center_y = w/2, h/2
		local scaled_w, scaled_h = w * self.menuScale, h * self.menuScale
		local scaled_x, scaled_y = center_x - scaled_w/2, center_y - scaled_h/2 + self.slideY
		
		-- Тень (черная с прозрачностью)
		draw.RoundedBox(0, scaled_x - 5, scaled_y - 5, scaled_w + 10, scaled_h + 10, 
		               Color(0, 0, 0, 60 * (self.menuAlpha/255)))
		
		-- Основная панель (черная с прозрачностью)
		draw.RoundedBox(0, scaled_x, scaled_y, scaled_w, scaled_h, Color(0, 0, 0, 120 * (self.menuAlpha/255)))
		
		-- Обводка с пульсацией (белая)
		local pulse = math.sin(RealTime() * 2) * 0.2 + 0.8
		surface.SetDrawColor(255, 255, 255, self.menuAlpha * pulse)
		surface.DrawOutlinedRect(scaled_x, scaled_y, scaled_w, scaled_h, 2)
		
		-- Угловые акценты (белые)
		local corner_size = 6
		draw.RoundedBox(0, scaled_x, scaled_y, corner_size, 2, Color(255, 255, 255, self.menuAlpha))
		draw.RoundedBox(0, scaled_x, scaled_y, 2, corner_size, Color(255, 255, 255, self.menuAlpha))
		draw.RoundedBox(0, scaled_x + scaled_w - corner_size, scaled_y, corner_size, 2, Color(255, 255, 255, self.menuAlpha))
		draw.RoundedBox(0, scaled_x + scaled_w - 2, scaled_y, 2, corner_size, Color(255, 255, 255, self.menuAlpha))
		draw.RoundedBox(0, scaled_x, scaled_y + scaled_h - 2, corner_size, 2, Color(255, 255, 255, self.menuAlpha))
		draw.RoundedBox(0, scaled_x, scaled_y + scaled_h - corner_size, 2, corner_size, Color(255, 255, 255, self.menuAlpha))
		draw.RoundedBox(0, scaled_x + scaled_w - corner_size, scaled_y + scaled_h - 2, corner_size, 2, Color(255, 255, 255, self.menuAlpha))
		draw.RoundedBox(0, scaled_x + scaled_w - 2, scaled_y + scaled_h - corner_size, 2, corner_size, Color(255, 255, 255, self.menuAlpha))

		if (self.DieTime <= CurTime() and !self.closing) then
			self:CloseMenu()
		end
	end

	-- Функция закрытия с анимацией
	BREACH.Demote.MainPanel.CloseMenu = function(self)
		if self.closing then return end
		self.closing = true
		self.closeStart = RealTime()
		
		-- Плавное исчезновение всех кнопок перед удалением
		for _, button in pairs(self.buttons) do
			if IsValid(button) then
				button.closing = true
				button.closeStart = RealTime()
			end
		end
		
		-- Плавное исчезновение заголовка
		if IsValid(self.Disclaimer) then
			self.Disclaimer.closing = true
			self.Disclaimer.closeStart = RealTime()
		end
		
		timer.Simple(menu_animation_time * 0.4, function()
			if IsValid(self.Disclaimer) then
				self.Disclaimer:Remove()
			end
			self:Remove()
			Select_Menu_enabled = false
			gui.EnableScreenClicker(false)
			
			-- Проверка для SCP062DE после закрытия
			if LocalPlayer():GetRoleName() == "SCP062DE" then
				SCP062de_Menu()
			end
		end)
	end

	-- Заголовок с анимацией
	BREACH.Demote.MainPanel.Disclaimer = vgui.Create("DPanel")
	BREACH.Demote.MainPanel.Disclaimer:SetSize(256 * 2, 64)
	BREACH.Demote.MainPanel.Disclaimer:SetPos(ScrW() / 2 - 128 * 2, ScrH() / 1.8 - (128 * 1.5))
	BREACH.Demote.MainPanel.Disclaimer:SetText("")
	BREACH.Demote.MainPanel.Disclaimer.panelAlpha = 0
	BREACH.Demote.MainPanel.Disclaimer.scaleY = 0
	BREACH.Demote.MainPanel.Disclaimer.startTime = RealTime() + 0.2
	BREACH.Demote.MainPanel.Disclaimer.closing = false

	local client = LocalPlayer()
	local title = "ВЫБЕРИТЕ SCP"

	BREACH.Demote.MainPanel.Disclaimer.Paint = function(self, w, h)
		local progress = 0
		local alpha_multiplier = 1
		
		if self.closing then
			progress = math.min((RealTime() - self.closeStart) / (menu_animation_time * 0.4), 1)
			alpha_multiplier = 1 - progress
		else
			progress = math.min((RealTime() - self.startTime) / (menu_animation_time * 0.6), 1)
		end
		
		local easeOut = 1 - math.pow(1 - progress, 2)
		
		self.panelAlpha = Lerp(easeOut, 0, 255)
		self.scaleY = Lerp(easeOut, 0, 1)
		
		local actual_h = h * self.scaleY
		local actual_y = (h - actual_h) / 2

		-- Применяем множитель прозрачности при закрытии
		local finalAlpha = self.panelAlpha * alpha_multiplier
		
		draw.RoundedBox(0, 0, actual_y, w, actual_h, Color(0, 0, 0, 120 * (finalAlpha/255)))
		
		-- Анимированная обводка (белая)
		local outline_progress = math.min((progress - 0.3) / 0.7, 1) * alpha_multiplier
		if outline_progress > 0 then
			surface.SetDrawColor(255, 255, 255, finalAlpha * outline_progress)
			surface.DrawOutlinedRect(0, actual_y, w, actual_h, 1.5)
		end
		
		-- Анимированный текст (белый)
		local text_alpha = math.min((progress - 0.3) / 0.7, 1) * finalAlpha
		if text_alpha > 0 then
			draw.DrawText(title, "ImpactSmall", w / 2, h / 2 - 16, 
			             Color(255, 255, 255, text_alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
		
		-- Эффект частиц в заголовке (оранжевый)
		if progress > 0.6 and alpha_multiplier > 0 then
			for i = 1, 3 do
				local offset = (RealTime() * 50 + i * 30) % (w + 40) - 20
				local particle_alpha = math.sin(RealTime() * 2 + i) * 0.3 + 0.7
				draw.RoundedBox(0, offset, actual_y - 2, 4, 2, 
				               Color(255, 165, 0, finalAlpha * particle_alpha * 0.3))
			end
		end

		if (client:GTeam() != TEAM_SCP || client:Health() <= 0 || input.IsKeyDown(KEY_BACKSPACE)) then
			if IsValid(BREACH.Demote.MainPanel) then
				BREACH.Demote.MainPanel:CloseMenu()
			end
		end
	end

	BREACH.Demote.ScrollPanel = vgui.Create("DScrollPanel", BREACH.Demote.MainPanel)
	BREACH.Demote.ScrollPanel:Dock(FILL)
	
	-- Стилизация скроллбара (серый и оранжевый)
	local sbar = BREACH.Demote.ScrollPanel:GetVBar()
	function sbar:Paint(w, h)
		if IsValid(BREACH.Demote.MainPanel) and BREACH.Demote.MainPanel.closing then
			local progress = math.min((RealTime() - BREACH.Demote.MainPanel.closeStart) / (menu_animation_time * 0.4), 1)
			local alpha = 150 * (1 - progress)
			draw.RoundedBox(0, w/2 - 2, 0, 4, h, Color(128, 128, 128, alpha))
		else
			draw.RoundedBox(0, w/2 - 2, 0, 4, h, Color(128, 128, 128, 150))
		end
	end
	
	function sbar.btnGrip:Paint(w, h)
		if IsValid(BREACH.Demote.MainPanel) and BREACH.Demote.MainPanel.closing then
			local progress = math.min((RealTime() - BREACH.Demote.MainPanel.closeStart) / (menu_animation_time * 0.4), 1)
			local alpha = 200 * (1 - progress)
			draw.RoundedBox(0, w/2 - 2, 0, 4, h, Color(255, 165, 0, alpha))
		else
			draw.RoundedBox(0, w/2 - 2, 0, 4, h, Color(255, 165, 0, 200))
		end
	end

	for i = 1, #weapons_table do
		BREACH.Demote.Users = BREACH.Demote.ScrollPanel:Add("DButton")
		BREACH.Demote.Users:SetText("")
		BREACH.Demote.Users:Dock(TOP)
		BREACH.Demote.Users:SetSize(256, 64 * 1.3)
		BREACH.Demote.Users:DockMargin(4, 4, 4, 4)
		BREACH.Demote.Users.CursorOnPanel = false
		BREACH.Demote.Users.gradientalpha = 0
		BREACH.Demote.Users.scaleAnim = 1
		BREACH.Demote.Users.hoverProgress = 0
		BREACH.Demote.Users.clickProgress = 0
		BREACH.Demote.Users.slideAnim = 20
		BREACH.Demote.Users.alphaAnim = 0
		BREACH.Demote.Users.animStart = RealTime() + (i * 0.05) -- Ступенчатая анимация
		BREACH.Demote.Users.closing = false
		
		-- Добавляем кнопку в таблицу для управления анимацией закрытия
		table.insert(BREACH.Demote.MainPanel.buttons, BREACH.Demote.Users)

		local locked = false
		local lockreason = 0

		local players = player.GetAll()
		local amount = 0

		BREACH.Demote.Users.Think = function(self)
			-- Анимация закрытия
			if self.closing then
				local close_progress = math.min((RealTime() - self.closeStart) / (menu_animation_time * 0.4), 1)
				self.alphaAnim = Lerp(close_progress, self.alphaAnim, 0)
				self.scaleAnim = Lerp(close_progress, self.scaleAnim, 0)
				self.slideAnim = Lerp(close_progress, self.slideAnim, 20)
				return
			end
			
			-- Анимация появления
			local appear_progress = math.min((RealTime() - self.animStart) / 0.3, 1)
			self.alphaAnim = Lerp(appear_progress, 0, 1)
			self.slideAnim = Lerp(appear_progress, 20, 0)
			
			-- Анимация наведения
			if self.CursorOnPanel and !locked then
				self.hoverProgress = math.min(self.hoverProgress + FrameTime() * 6, 1)
			else
				self.hoverProgress = math.max(self.hoverProgress - FrameTime() * 6, 0)
			end
			
			-- Анимация клика
			if self:IsDown() and !locked then
				self.clickProgress = math.min(self.clickProgress + FrameTime() * 10, 1)
			else
				self.clickProgress = math.max(self.clickProgress - FrameTime() * 10, 0)
			end
			
			-- Комбинированный эффект
			self.scaleAnim = Lerp(self.hoverProgress * 0.7 + self.clickProgress * 0.3, 1, 0.95)
			
			if lockreason == 1 then return end
			amount = 0

			for id = 1, #players do
				if players[id]:GetRoleName() == weapons_table[i].class then
					amount = amount + 1
				end
			end

			if BREACH.SelectedRoles then
				for id, selected in pairs(BREACH.SelectedRoles) do
					if id == weapons_table[i].id then
						amount = amount + selected
					end
				end
			end
		end

		BREACH.Demote.Users.Paint = function(self, w, h)
			if locked then
				self:SetCursor("arrow")
			else
				self:SetCursor("hand")
			end

			-- Эффект продавливания
			local scale = self.scaleAnim
			local offset_x = w * (1 - scale) / 2
			local offset_y = h * (1 - scale) / 2
			
			-- Сдвиг при появлении
			local slide_offset = self.slideAnim
			
			-- Основной цвет с анимацией (черный/серый)
			local base_color = Color(0, 0, 0, 200 * self.alphaAnim)
			local hover_color = Color(100, 100, 100, 200 * self.alphaAnim) -- серый при наведении
			local current_color = LerpColor(self.hoverProgress, base_color, hover_color)
			
			-- Фон (квадратный)
			draw.RoundedBox(0, offset_x, offset_y + slide_offset, w * scale, h * scale, current_color)
			
			-- Градиент при наведении (белый)
			--if self.hoverProgress > 0 then
			--	surface.SetDrawColor(Color(255, 255, 255, self.hoverProgress * 80 * self.alphaAnim))
			--	surface.SetMaterial(gradient)
			--	surface.DrawTexturedRect(offset_x, offset_y + slide_offset, w * scale, h * scale)
			--end
			
			-- Эффект нажатия (черная тень)
			if self.clickProgress > 0 then
				draw.RoundedBox(0, offset_x - 2, offset_y + slide_offset + 3, 
				               w * scale + 4, h * scale + 4, Color(0, 0, 0, 30 * self.clickProgress * self.alphaAnim))
			end
			
			-- Обводка (оранжевая для доступных, серо-черная для заблокированных)
			local outline_color
			if locked then
				outline_color = Color(100, 100, 100, 200 * self.alphaAnim) -- серый для заблокированных
			else
				-- Оранжевая обводка с увеличением ярчности при наведении
				local orange_brightness = Lerp(self.hoverProgress, 0.7, 1.0)
				outline_color = Color(255 * orange_brightness, 165 * orange_brightness, 0, 200 * self.alphaAnim)
			end
			
			surface.SetDrawColor(outline_color)
			surface.DrawOutlinedRect(offset_x, offset_y + slide_offset, w * scale, h * scale, 1.5)
			
			-- Свечение при наведении (оранжевое)
			if self.hoverProgress > 0.5 and !locked then
				local glow = (self.hoverProgress - 0.5) * 2
				surface.SetDrawColor(255, 165, 0, 30 * glow * self.alphaAnim)
				surface.DrawOutlinedRect(offset_x - 1, offset_y + slide_offset - 1, 
				               w * scale + 2, h * scale + 2, 2)
			end
			
			-- Текст
			if !locked then
				-- Доступный SCP - белый цвет с возможным оранжевым оттенком при наведении
				local text_color = LerpColor(self.hoverProgress, 
				                           Color(255, 255, 255, 200 * self.alphaAnim),
				                           Color(255, 200, 100, 255 * self.alphaAnim)) -- белый -> оранжево-белый
				draw.SimpleText(weapons_table[i].name, "ImpactSmall", w / 2, h / 2, 
				               text_color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			else
				-- Заблокированный SCP
				if lockreason == 1 then
					local pulsate = math.sin(RealTime() * 3) * 0.5 + 0.5
					draw.SimpleText("REQUIRED LEVEL: "..weapons_table[i].level, "ImpactSmall", w / 2, 15, 
					               Color(255, 165 * pulsate, 0, 255 * self.alphaAnim), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				else
					local pulsate = math.sin(RealTime() * 2) * 0.5 + 0.5
					draw.SimpleText("ALREADY TAKEN", "ImpactSmall", w / 2, 15, 
					               Color(255, 165 * pulsate, 0, 255 * self.alphaAnim), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				end
				draw.SimpleText(weapons_table[i].name, "ImpactSmall", w / 2, h / 2, 
				               Color(255, 255, 255, 150 * self.alphaAnim), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
		end

		BREACH.Demote.Users.OnCursorEntered = function(self)
			self.CursorOnPanel = true
		end

		BREACH.Demote.Users.OnCursorExited = function(self)
			self.CursorOnPanel = false
		end

		BREACH.Demote.Users.DoClick = function(self)
			if locked then return end

			-- Анимация клика
			self.clickProgress = 1
			
			net.Start("SelectSCPClientside")
			net.WriteString(weapons_table[i].class)
			net.SendToServer()

			-- Задержка перед закрытием для анимации
			timer.Simple(0.15, function()
				if IsValid(BREACH.Demote.MainPanel) then
					BREACH.Demote.MainPanel:CloseMenu()
				end
			end)
			
			-- SCP062DE меню через 1 секунду
			timer.Simple(1, function()
				if LocalPlayer():GetRoleName() == "SCP062DE" then
					SCP062de_Menu()
				end
			end)
		end
	end
end

net.Receive("SCPSelect_Menu", function(len)
	local tab = net.ReadTable()
	timer.Simple(4,function()
		Select_SCP_Menu(tab)
	end)
end)

net.Receive( "ShowText", function( len )
	local com = net.ReadString()
	if com == "vote_fail" then
		LocalPlayer():PrintMessage( HUD_PRINTTALK, clang.votefail )
	elseif	com == "text_punish" then
		local name = net.ReadString()
		LocalPlayer():PrintMessage( HUD_PRINTTALK, string.format( clang.votepunish, name ) )
		LocalPlayer():PrintMessage( HUD_PRINTTALK, clang.voterules )
	elseif	com == "text_punish_end" then
		local data = net.ReadTable()
		local result
		if data.punish then 
			result = clang.punish
		else 
			result = clang.forgive
		end
		local vp, vf = data.punishvotes, data.forgivevotes
		//print( vp, vf )
		LocalPlayer():PrintMessage( HUD_PRINTTALK, string.format( clang.voteresult, data.punished, result ) )
		LocalPlayer():PrintMessage( HUD_PRINTTALK, string.format( clang.votes, vp + vf, vp, vf ) )
	elseif com == "text_punish_cancel" then
		LocalPlayer():PrintMessage( HUD_PRINTTALK, clang.votecancel )
	end
end)

    local function IsPlayerVisible(ply)
        if not IsValid(ply) then return false end
        
        local startPos = LocalPlayer():GetShootPos()
        local endPos = ply:GetShootPos()
        
        local trace = util.TraceLine({
            start = startPos,
            endpos = endPos,
            filter = function(ent) 
                if ent == LocalPlayer() or ent == ply then
                    return false
                end
                return true
            end
        })
        
        return not trace.Hit
    end

if CLIENT then
    local function DrawPlayerInfo(ply)
        if not IsValid(ply) or not ply:Alive() or ply == LocalPlayer() or LocalPlayer():GTeam() != TEAM_AR then return end
        if ply:GetNoDraw() then return end
        if not IsPlayerVisible(ply) then return end
        -- Получаем позицию головы
        local headBone = ply:LookupBone("ValveBiped.Bip01_Head1")
        if not headBone then return end
        
        local headPos, headAng = ply:GetBonePosition(headBone)
        if not headPos then return end
        
        -- Преобразуем 3D позицию в 2D экранные координаты
        local headScreenPos = headPos:ToScreen()
        
        -- Альтернативный способ получения размеров модели
        local center = ply:GetPos()
        local mins, maxs = ply:GetCollisionBounds()
        
        -- Углы bounding box'а
        local corners = {
            Vector(mins.x, mins.y, mins.z),
            Vector(mins.x, maxs.y, mins.z),
            Vector(maxs.x, maxs.y, mins.z),
            Vector(maxs.x, mins.y, mins.z),
            Vector(mins.x, mins.y, maxs.z),
            Vector(mins.x, maxs.y, maxs.z),
            Vector(maxs.x, maxs.y, maxs.z),
            Vector(maxs.x, mins.y, maxs.z)
        }
        
        -- Преобразуем углы в мировые координаты
        local screenCorners = {}
        for i, corner in ipairs(corners) do
            local worldPos = center + corner
            local screenPos = worldPos:ToScreen()
            table.insert(screenCorners, screenPos)
        end
        
        -- Находим границы рамки
        local minX, maxX = math.huge, -math.huge
        local minY, maxY = math.huge, -math.huge
        local anyVisible = false
        
        for _, corner in ipairs(screenCorners) do
            if corner.visible then
                anyVisible = true
                minX = math.min(minX, corner.x)
                maxX = math.max(maxX, corner.x)
                minY = math.min(minY, corner.y)
                maxY = math.max(maxY, corner.y)
            end
        end
        
        if not anyVisible then return end
        
        -- Рисуем рамку вокруг модели
        surface.SetDrawColor(255, 0, 0)
        surface.DrawOutlinedRect(minX, minY, maxX - minX, maxY - minY)
        
        -- Рисуем квадрат на месте головы (если виден)
        if headScreenPos.visible then
            local headSize = 20
            surface.SetDrawColor(gteams.GetColor(ply:GTeam()))
            surface.DrawRect(headScreenPos.x - headSize/2, headScreenPos.y - headSize/2, headSize, headSize)
        end
        
        -- Позиция для текста (над рамкой)
        local textX = minX
        local textY = minY - 75
        
        -- Фон для текста
        surface.SetDrawColor(0, 0, 0, 180)
        surface.DrawRect(textX - 5, textY - 15, 200, 80)
        
        -- Имя игрока
        draw.SimpleText(ply:GetNamesurvivor(), "RadioFont", textX, textY - 12, Color(255, 255, 255), TEXT_ALIGN_LEFT)
        
        -- HP игрока
        local hp = ply:Health()
        local hpColor = hp > 50 and Color(0, 255, 0) or (hp > 25 and Color(255, 255, 0) or Color(255, 0, 0))
        draw.SimpleText("HP: " .. hp, "RadioFont", textX, textY + 12, hpColor, TEXT_ALIGN_LEFT)
        
        -- Оружие в руках
        local weapon = ply:GetActiveWeapon()
        if IsValid(weapon) then
            local weaponName = weapon:GetPrintName() or weapon:GetClass()
            draw.SimpleText("Weapon: " .. weaponName, "RadioFont", textX, textY + 34, Color(200, 200, 200), TEXT_ALIGN_LEFT)
        end
    end

    hook.Add("HUDPaint", "DrawPlayerInfoBoxes", function()
		if LocalPlayer():GTeam() == TEAM_AR then
        	for _, ply in ipairs(player.GetAll()) do
				if ply:GTeam() != TEAM_SCP and ply:GTeam() != TEAM_AR and ply:GTeam() != TEAM_SPECTATOR then
        	   	 DrawPlayerInfo(ply)
				end
        	end
		end
    end)
end

if CLIENT then
    local function DrawDoorInfo(ply)
        if not IsValid(ply) then return end
		if IsValid(LocalPlayer():GetActiveWeapon()) and LocalPlayer():GetActiveWeapon():GetClass() == "kasanov_scp_079" then
        --if ply:GetNoDraw() then return end
        --if not IsPlayerVisible(ply) then return end
        -- Получаем позицию головы
        --local headBone = ply:LookupBone("ValveBiped.Bip01_Head1")
        --if not headBone then return end
        
        --local headPos, headAng = ply:GetBonePosition(headBone)
        --if not headPos then return end
        
        -- Преобразуем 3D позицию в 2D экранные координаты
        --local headScreenPos = headPos:ToScreen()
        
        -- Альтернативный способ получения размеров модели
        local center = ply:GetPos()
        local mins, maxs = ply:GetCollisionBounds()
        
        -- Углы bounding box'а
        local corners = {
            Vector(mins.x, mins.y, mins.z),
            Vector(mins.x, maxs.y, mins.z),
            Vector(maxs.x, maxs.y, mins.z),
            Vector(maxs.x, mins.y, mins.z),
            Vector(mins.x, mins.y, maxs.z),
            Vector(mins.x, maxs.y, maxs.z),
            Vector(maxs.x, maxs.y, maxs.z),
            Vector(maxs.x, mins.y, maxs.z)
        }
        
        -- Преобразуем углы в мировые координаты
        local screenCorners = {}
        for i, corner in ipairs(corners) do
            local worldPos = center + corner
            local screenPos = worldPos:ToScreen()
            table.insert(screenCorners, screenPos)
        end
        
        -- Находим границы рамки
        local minX, maxX = math.huge, -math.huge
        local minY, maxY = math.huge, -math.huge
        local anyVisible = false
        
        for _, corner in ipairs(screenCorners) do
            if corner.visible then
                anyVisible = true
                minX = math.min(minX, corner.x)
                maxX = math.max(maxX, corner.x)
                minY = math.min(minY, corner.y)
                maxY = math.max(maxY, corner.y)
            end
        end
        
        if not anyVisible then return end
        
        -- Рисуем рамку вокруг модели
        surface.SetDrawColor(255, 255, 255)
        surface.DrawOutlinedRect(minX, minY, maxX - minX, maxY - minY)
        
        -- Рисуем квадрат на месте головы (если виден)
        --if headScreenPos.visible then
        --    local headSize = 20
        --    surface.SetDrawColor(gteams.GetColor(ply:GTeam()))
        --    surface.DrawRect(headScreenPos.x - headSize/2, headScreenPos.y - headSize/2, headSize, headSize)
        --end
        
        -- Позиция для текста (над рамкой)
        local textX = minX
        local textY = minY - 75
        
        -- Фон для текста
       --surface.SetDrawColor(0, 0, 0, 180)
       --surface.DrawRect(textX - 5, textY - 15, 200, 80)
        
        -- Имя игрока
        draw.SimpleText("Гермо-Дверь - "..ply:EntIndex(), "RadioFont", textX, textY - 12, Color(255, 255, 255), TEXT_ALIGN_LEFT)
        
        -- HP игрока
        --local hp = ply:Health()
        --local hpColor = hp > 50 and Color(0, 255, 0) or (hp > 25 and Color(255, 255, 0) or Color(255, 0, 0))
        --draw.SimpleText("HP: " .. hp, "RadioFont", textX, textY + 12, hpColor, TEXT_ALIGN_LEFT)
        
        -- Оружие в руках
        --local weapon = ply:GetActiveWeapon()
        --if IsValid(weapon) then
        --    local weaponName = weapon:GetPrintName() or weapon:GetClass()
        --    draw.SimpleText("Weapon: " .. weaponName, "RadioFont", textX, textY + 34, Color(200, 200, 200), TEXT_ALIGN_LEFT)
        --end
		end
    end

	local function DrawTeslaInfo(ply)
        if not IsValid(ply) then return end
		if IsValid(LocalPlayer():GetActiveWeapon()) and LocalPlayer():GetActiveWeapon():GetClass() == "kasanov_scp_079" then
        --if ply:GetNoDraw() then return end
        --if not IsPlayerVisible(ply) then return end
        -- Получаем позицию головы
        --local headBone = ply:LookupBone("ValveBiped.Bip01_Head1")
        --if not headBone then return end
        
        --local headPos, headAng = ply:GetBonePosition(headBone)
        --if not headPos then return end
        
        -- Преобразуем 3D позицию в 2D экранные координаты
        --local headScreenPos = headPos:ToScreen()
        
        -- Альтернативный способ получения размеров модели
        local center = ply:GetPos()
        local mins, maxs = ply:GetCollisionBounds()
        
        -- Углы bounding box'а
        local corners = {
            Vector(mins.x, mins.y, mins.z),
            Vector(mins.x, maxs.y, mins.z),
            Vector(maxs.x, maxs.y, mins.z),
            Vector(maxs.x, mins.y, mins.z),
            Vector(mins.x, mins.y, maxs.z),
            Vector(mins.x, maxs.y, maxs.z),
            Vector(maxs.x, maxs.y, maxs.z),
            Vector(maxs.x, mins.y, maxs.z)
        }
        
        -- Преобразуем углы в мировые координаты
        local screenCorners = {}
        for i, corner in ipairs(corners) do
            local worldPos = center + corner
            local screenPos = worldPos:ToScreen()
            table.insert(screenCorners, screenPos)
        end
        
        -- Находим границы рамки
        local minX, maxX = math.huge, -math.huge
        local minY, maxY = math.huge, -math.huge
        local anyVisible = false
        
        for _, corner in ipairs(screenCorners) do
            if corner.visible then
                anyVisible = true
                minX = math.min(minX, corner.x)
                maxX = math.max(maxX, corner.x)
                minY = math.min(minY, corner.y)
                maxY = math.max(maxY, corner.y)
            end
        end
        
        if not anyVisible then return end
        
        -- Рисуем рамку вокруг модели
        surface.SetDrawColor(0, 174, 255)
        surface.DrawOutlinedRect(minX, minY, maxX - minX, maxY - minY)
        
        -- Рисуем квадрат на месте головы (если виден)
        --if headScreenPos.visible then
        --    local headSize = 20
        --    surface.SetDrawColor(gteams.GetColor(ply:GTeam()))
        --    surface.DrawRect(headScreenPos.x - headSize/2, headScreenPos.y - headSize/2, headSize, headSize)
        --end
        
        -- Позиция для текста (над рамкой)
        local textX = minX
        local textY = minY - 75
        
        -- Фон для текста
       --surface.SetDrawColor(0, 0, 0, 180)
       --surface.DrawRect(textX - 5, textY - 15, 200, 80)
        
        -- Имя игрока
        draw.SimpleText("Гермо-Дверь - "..ply:EntIndex(), "RadioFont", textX, textY - 12, Color(255, 255, 255), TEXT_ALIGN_LEFT)
        
        -- HP игрока
        --local hp = ply:Health()
        --local hpColor = hp > 50 and Color(0, 255, 0) or (hp > 25 and Color(255, 255, 0) or Color(255, 0, 0))
        --draw.SimpleText("HP: " .. hp, "RadioFont", textX, textY + 12, hpColor, TEXT_ALIGN_LEFT)
        
        -- Оружие в руках
        --local weapon = ply:GetActiveWeapon()
        --if IsValid(weapon) then
        --    local weaponName = weapon:GetPrintName() or weapon:GetClass()
        --    draw.SimpleText("Weapon: " .. weaponName, "RadioFont", textX, textY + 34, Color(200, 200, 200), TEXT_ALIGN_LEFT)
        --end
		end
    end

	local function DrawPlayerInfo2(ply)
        --if not IsValid(ply) or not ply:Alive() or ply == LocalPlayer() or LocalPlayer():GTeam() != TEAM_AR then return end
		if not IsValid(ply) then return end
		if IsValid(LocalPlayer():GetActiveWeapon()) and LocalPlayer():GetActiveWeapon():GetClass() == "kasanov_scp_079" then
		if not ply:Alive() then return end
        if ply:GetNoDraw() then return end
       -- if not IsPlayerVisible(ply) then return end
        -- Получаем позицию головы
        local headBone = ply:LookupBone("ValveBiped.Bip01_Head1")
        if not headBone then return end
        
        local headPos, headAng = ply:GetBonePosition(headBone)
        if not headPos then return end
        
        -- Преобразуем 3D позицию в 2D экранные координаты
        local headScreenPos = headPos:ToScreen()
        
        -- Альтернативный способ получения размеров модели
        local center = ply:GetPos()
        local mins, maxs = ply:GetCollisionBounds()
        
        -- Углы bounding box'а
        local corners = {
            Vector(mins.x, mins.y, mins.z),
            Vector(mins.x, maxs.y, mins.z),
            Vector(maxs.x, maxs.y, mins.z),
            Vector(maxs.x, mins.y, mins.z),
            Vector(mins.x, mins.y, maxs.z),
            Vector(mins.x, maxs.y, maxs.z),
            Vector(maxs.x, maxs.y, maxs.z),
            Vector(maxs.x, mins.y, maxs.z)
        }
        
        -- Преобразуем углы в мировые координаты
        local screenCorners = {}
        for i, corner in ipairs(corners) do
            local worldPos = center + corner
            local screenPos = worldPos:ToScreen()
            table.insert(screenCorners, screenPos)
        end
        
        -- Находим границы рамки
        local minX, maxX = math.huge, -math.huge
        local minY, maxY = math.huge, -math.huge
        local anyVisible = false
        
        for _, corner in ipairs(screenCorners) do
            if corner.visible then
                anyVisible = true
                minX = math.min(minX, corner.x)
                maxX = math.max(maxX, corner.x)
                minY = math.min(minY, corner.y)
                maxY = math.max(maxY, corner.y)
            end
        end
        
        if not anyVisible then return end
        
        -- Рисуем рамку вокруг модели
        surface.SetDrawColor(255, 0, 0)
        surface.DrawOutlinedRect(minX, minY, maxX - minX, maxY - minY)
        
        -- Рисуем квадрат на месте головы (если виден)
        if headScreenPos.visible then
            local headSize = 20
            surface.SetDrawColor(gteams.GetColor(ply:GTeam()))
            surface.DrawRect(headScreenPos.x - headSize/2, headScreenPos.y - headSize/2, headSize, headSize)
        end
        
        -- Позиция для текста (над рамкой)
        local textX = minX
        local textY = minY - 75
        
        -- Фон для текста
        surface.SetDrawColor(0, 0, 0, 180)
        surface.DrawRect(textX - 5, textY - 15, 200, 80)
        
        -- Имя игрока
        draw.SimpleText(ply:GetNamesurvivor(), "RadioFont", textX, textY - 12, Color(255, 255, 255), TEXT_ALIGN_LEFT)
        
        -- HP игрока
        local hp = ply:Health()
        local hpColor = hp > 50 and Color(0, 255, 0) or (hp > 25 and Color(255, 255, 0) or Color(255, 0, 0))
        draw.SimpleText("HP: " .. hp, "RadioFont", textX, textY + 12, hpColor, TEXT_ALIGN_LEFT)
        
        -- Оружие в руках
        local weapon = ply:GetActiveWeapon()
        if IsValid(weapon) then
            local weaponName = weapon:GetPrintName() or weapon:GetClass()
            draw.SimpleText("Weapon: " .. weaponName, "RadioFont", textX, textY + 34, Color(200, 200, 200), TEXT_ALIGN_LEFT)
        end
	end
    end

    hook.Add("HUDPaint", "DrawDoorInfoBoxes", function()
		if IsValid(LocalPlayer():GetActiveWeapon()) and LocalPlayer():GetActiveWeapon():GetClass() == "kasanov_scp_079" then
        	for _, v in ipairs(ents.GetAll()) do
				--if ply:GTeam() != TEAM_SCP and ply:GTeam() != TEAM_AR and ply:GTeam() != TEAM_SPECTATOR then
				if v:GetClass() == "func_door" and LocalPlayer():GetPos():Distance( v:GetPos() ) < 1000 then
        	   	 	DrawDoorInfo(v)
				end

				if v:GetClass() == "test_entity_tesla" and LocalPlayer():GetPos():Distance( v:GetPos() ) < 1000 then
        	   	 	DrawTeslaInfo(v)
				end
				if v:IsPlayer()  then
					DrawPlayerInfo2(v)
				end
				--end
        	end
		end
    end)
end

//kasanov side


local PLAYER = FindMetaTable('Player')


function PLAYER:HasPremiumSub()


    return self:GetNWInt("premium_sub", 0) > os.time()


end





--function ApplyColorFX()
--    hook.Remove("RenderScreenspaceEffects", "EnhancedColorFX")
--
--    if GetConVar("breach_config_contrast"):GetBool() then
--        --hook.Add("RenderScreenspaceEffects", "EnhancedColorFX", function()
--        --   local tab = {}
--        --   tab["$pp_colour_addr"] = 0
--        --   tab["$pp_colour_addg"] = 0
--        --   tab["$pp_colour_addb"] = 0
--        --   --tab["$pp_colour_brightness"] = GetConVar("colorfx_brightness"):GetFloat()
--        --   tab["$pp_colour_contrast"] = 1
--        --   tab["$pp_colour_colour"] = 2
--        --   tab["$pp_colour_mulr"] = 0
--        --   tab["$pp_colour_mulg"] = 0
--        --   tab["$pp_colour_mulb"] = 0
----
--        --   DrawColorModify(tab)
----
--        --    --if GetConVar("colorfx_bloom_enabled"):GetBool() then
--        --        local bloomIntensity = 0.3
--        --        DrawBloom(0.1, bloomIntensity, 9, 9, 1, 1, 1, 1, 1)
--        --    --end
--        --end)
--    end
--end
--ApplyColorFX()

--if IsValid(BREACH.Level.main_panel) then
--	BREACH.Level.main_panel:Remove()
--end