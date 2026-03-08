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

local staminaBars = {}
local lastStamina = 0

local healthBars = {}
local lastHealth = 0

local ratio, ratio2, mathRound = ScrW() / 1920, ScrH() / 1080, math.Round

-- Предварительная загрузка материалов углов (делается один раз, например, в HUDPaint)
local corner_materials = {
    tl = Material("nextoren_hud/round_boxe_1.png"), -- верхний левый
    tr = Material("nextoren_hud/round_boxe_2.png"), -- верхний правый
    br = Material("nextoren_hud/round_boxe_3.png"), -- нижний правый
    bl = Material("nextoren_hud/round_boxe_4.png")  -- нижний левый
}

-- Функция для рисования углов
function SigmaYgliDraw(x, y, w, h, color, cornerSize)
    -- Если размер угла не указан, вычисляем его автоматически
    cornerSize = cornerSize or math.min(w, h) * 0.1
    
    -- Устанавливаем цвет
    surface.SetDrawColor(color)
    
    -- Верхний левый угол
    surface.SetMaterial(corner_materials.bl)
    surface.DrawTexturedRect(x, y, cornerSize, cornerSize)
    
    -- Верхний правый угол
    surface.SetMaterial(corner_materials.br)
    surface.DrawTexturedRect(x + w - cornerSize, y, cornerSize, cornerSize)
    
    -- Нижний правый угол
    surface.SetMaterial(corner_materials.tr)
    surface.DrawTexturedRect(x + w - cornerSize, y + h - cornerSize, cornerSize, cornerSize)
    
    -- Нижний левый угол
    surface.SetMaterial(corner_materials.tl)
    surface.DrawTexturedRect(x, y + h - cornerSize, cornerSize, cornerSize)
end

-- Вариант функции с дополнительными параметрами
function SigmaYgliDrawEx(x, y, w, h, color, cornerSize, rotation)
    cornerSize = cornerSize or math.min(w, h) * 0.1
    rotation = rotation or 0
    
    surface.SetDrawColor(color)
    
    -- Углы с возможностью вращения
    local corners = {
        {mat = corner_materials.tl, x = x, y = y},
        {mat = corner_materials.tr, x = x + w - cornerSize, y = y},
        {mat = corner_materials.br, x = x + w - cornerSize, y = y + h - cornerSize},
        {mat = corner_materials.bl, x = x, y = y + h - cornerSize}
    }
    
    for _, corner in ipairs(corners) do
        surface.SetMaterial(corner.mat)
        surface.DrawTexturedRectRotated(
            corner.x + cornerSize/2, 
            corner.y + cornerSize/2, 
            cornerSize, 
            cornerSize, 
            rotation
        )
    end
end

local blur = Material( "pp/blurscreen" )
function DrawBlurRect(x, y, w, h)
	local X, Y = 0,0
	
	if GetConVar("breach_config_blur"):GetInt() == 1 then
	--if 2 == 1 then
	surface.SetDrawColor(255,255,255)
	surface.SetMaterial(blur)
		for i = 1, 5 do
			blur:SetFloat("$blur", (i / 4) * (4))
			blur:Recompute()
			render.UpdateScreenEffectTexture()
			render.SetScissorRect(x, y, x+w, y+h, true)
				surface.DrawTexturedRect(X * -1, Y * -1, ScrW(), ScrH())
			render.SetScissorRect(0, 0, 0, 0, false)
		end
	end
   
		local lightness = 125
   

		lightness = 175
	
   draw.RoundedBox(0,x,y,w,h,Color(0,0,0,lightness))
   surface.SetDrawColor(0,0,0)
   //surface.DrawOutlinedRect(x,y,w,h)
   
end

hook.Add("OnScreenSizeChanged", "ScreenScale", function() ratio, ratio2 = ScrW() / 1920, ScrH() / 1080 end)
OGRX = OGRX or {}
function OGRX.ScaleW(px)
    return mathRound(px * ratio)
end

function OGRX.ScaleH(px)
    return mathRound(px * ratio2)
end
local surface_SetFont = surface.SetFont
local surface_GetTextSize = surface.GetTextSize
local surface_SetTextColor = surface.SetTextColor
local surface_SetTextPos = surface.SetTextPos
local surface_DrawText = surface.DrawText
local Color = Color
local surface_SetMaterial = surface.SetMaterial
local surface_SetDrawColor = surface.SetDrawColor
local surface_DrawTexturedRect = surface.DrawTexturedRect
local math_Clamp = math.Clamp
local ScrW = ScrW
local ScrH = ScrH
local render_UpdateScreenEffectTexture = render.UpdateScreenEffectTexture
local textAlignMultiplier = {
	[TEXT_ALIGN_CENTER] = 0.5,
	[TEXT_ALIGN_BOTTOM] = 1,
	[TEXT_ALIGN_RIGHT] = 1,
	[TEXT_ALIGN_LEFT] = 0,
	[TEXT_ALIGN_TOP] = 0,
}
function OGRX.outlineText(text, font, x, y, color, xAlign, yAlign, outlineColor)


	xAlign = xAlign or 0


	yAlign = yAlign or 0


	surface_SetFont(font)


	local textWidth, textHeight = surface_GetTextSize(text)


	x = x - textWidth * textAlignMultiplier[xAlign]


	y = y - textHeight * textAlignMultiplier[yAlign]


	surface_SetTextColor(outlineColor) -- (0, 0, 0, outlineAlpha or color.a)


	surface_SetTextPos(x - 1, y - 1)


	surface_DrawText(text)


	surface_SetTextPos(x + 1, y - 1)


	surface_DrawText(text)


	surface_SetTextPos(x - 1, y + 1)


	surface_DrawText(text)


	surface_SetTextPos(x + 1, y + 1)


	surface_DrawText(text)


	surface_SetTextColor(color)


	surface_SetTextPos(x, y)


	surface_DrawText(text)


end

function draw.OutlinedBox( x, y, w, h, thickness, clr )
	surface.SetDrawColor( clr || color_white )
	surface.DrawRect( x, y, w, thickness )
	surface.DrawRect( x, y + h - thickness, w, thickness )
	surface.DrawRect( x, y + thickness, thickness, h - thickness * 2 )
	surface.DrawRect( x + w - thickness, y + thickness, thickness, h - thickness * 2 )
end

hook.Add("HUDPaint", "breachfunnycrosshair", function()

	--if LocalPlayer():IsSuperAdmin() then
		--draw.RoundedBox(15, ScrW()/2-2, ScrH()/2-2, 4, 4, color_white)
	--else
		hook.Remove("HUDPaint", "breachfunnycrosshair")
	--end

end)

local TeamIcons = {

	[ TEAM_CLASSD ] = { mat = Material( "nextoren/gui/roles_icon/class_d.png" ) },
	[ TEAM_SCI ] = { mat = Material( "nextoren/gui/roles_icon/sci.png" ) },
	[ TEAM_SECURITY ] = { mat = Material( "nextoren/gui/roles_icon/sb.png" ) },
	[ TEAM_GUARD ] = { mat = Material( "nextoren/gui/roles_icon/mtf.png" ) },
	[ TEAM_NTF ] = { mat = Material( "nextoren/gui/roles_icon/ntf.png" ) },
	[ TEAM_ETT ] = { mat = Material( "nextoren/gui/roles_icon_new/ettr1a.png" ) },
	[ TEAM_FAF ] = { mat = Material( "nextoren/gui/roles_icon/mtf.png" ) },--未完成
	[ TEAM_CHAOS ] = { mat = Material( "nextoren/gui/roles_icon/chaos.png" ) },
	[ TEAM_GOC ] = { mat = Material( "nextoren/gui/roles_icon/goc.png" ) },
	[ TEAM_SPECIAL ] = { mat = Material( "nextoren/gui/roles_icon/sci_special.png" ) },
	[ TEAM_QRT ] = { mat = Material( "nextoren/gui/roles_icon/obr.png" ) },
	[ TEAM_DZ ] = { mat = Material( "nextoren/gui/roles_icon/dz.png" ) },
	[ TEAM_SCP ] = { mat = Material( "nextoren/gui/roles_icon/scp.png" ) },
	[ TEAM_USA ] = { mat = Material( "nextoren/gui/roles_icon/fbi.png" ) },
	[ TEAM_SPEC ] = { mat = Material( "nextoren/gui/roles_icon/sci.png" ) },
	[ TEAM_COTSK ] = { mat = Material( "nextoren/gui/roles_icon/scarlet.png" ) },
	[ 1331 ] = { mat = Material( "nextoren/gui/roles_icon/fbi_agent.png" ) },
	[ TEAM_ALPHA1 ] = { mat = Material( "nextoren/gui/roles_icon/a1.png" ) },
	[ TEAM_AR ] = { mat = Material( "nextoren/gui/roles_icon/ar.png" ) },
	[ TEAM_CBG ] = { mat = Material( "nextoren/gui/roles_icon/crb.png" ) },
	[ TEAM_GRU ] = { mat = Material( "nextoren/gui/roles_icon/gru.png" ) },
	[ TEAM_COMBINE ] = { mat = Material( "nextoren/gui/roles_icon/cmb.png" ) },
	[ TEAM_RESISTANCE ] = { mat = Material( "nextoren/gui/roles_icon/rebel.png" ) },
	[ TEAM_AMERICA ] = { mat = Material( "nextoren/gui/roles_icon/america.png" ) },
	[ TEAM_NAZI ] = { mat = Material( "nextoren/gui/roles_icon/reich.png" ) },

}

function GetActivePlayers()
	local tab = {}
	for k,v in pairs(player.GetAll()) do
		if IsValid( v ) then

				table.ForceInsert(tab, v)

		end
	end
	return tab
end

surface.CreateFont( "SpectatorTimer", {
	font = "Conduit ITC",
	size = 28,
	weight = 800,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = true,
	additive = false,
	outline = false,
})

local blurMaterial = Material("pp/blurscreen")

function GM:HUDPaint()

  local client = LocalPlayer()
  local current_team = LocalPlayer():GTeam()
  local screenwidth = ScrW()
  local screenheight = ScrH()
--RunConsoleCommand("mp_show_voice_icons", "0")
  			if ( current_team == TEAM_SPEC or current_team == TEAM_ARENA ) or GetGlobalBool("AliveCanSeeRoundTime", false) then
				if ( !( preparing || postround ) && ( cltime > 0 or GetGlobalBool("NukeTime", false) ) ) then

					local time = string.ToMinutesSeconds( cltime )
					local col = color_white
					if GetGlobalBool("NukeTime", false) then
						col = Color(255,0,0)
						if timer.Exists("NukeTimer") then
							time = string.ToMinutesSeconds( timer.TimeLeft("NukeTimer") )
						elseif timer.Exists("NukeTimer2") then
							time = string.ToMinutesSeconds( timer.TimeLeft("NukeTimer2") )
					    else
							time = "!*:#$"
						end
					end
					surface.SetFont( "ImpactSmall" )
					local timer_w, timer_h = surface.GetTextSize( time )
					DrawBlurRect(screenwidth / 2 - timer_w / 2 - 2, screenheight * .1 - ( timer_h / 2 ) - 2, timer_w + 8, timer_h + 8)
        			surface.SetDrawColor(0, 0, 0, 255)
        			surface.DrawOutlinedRect(screenwidth / 2 - timer_w / 2 - 2, screenheight * .1 - ( timer_h / 2 ) - 2, timer_w + 8, timer_h + 8, 1)
					SigmaYgliDraw(screenwidth / 2 - timer_w / 2 - 2, screenheight * .1 - ( timer_h / 2 ) - 2, timer_w + 8, timer_h + 8, col, ScrW() / 64)

					draw.SimpleText( time, "ImpactSmall", screenwidth / 2, screenheight * .1, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )


					--draw.OutlinedBox( screenwidth / 2 - timer_w / 2 - 4, screenheight * .1 - ( timer_h / 2 ) - 2, timer_w + 8, timer_h + 8, 2, roleclr1 )
				end

			end

	if ( gamestarted != true ) then

		if ( !GetGlobalBool("EnoughPlayersCountDown", false) ) then

			if ( client.MusicPlaying ) then

				client.MusicPlaying = nil
				BREACH.Music:Stop()

			end

			local middlescreen = ScrW() / 2
			local screenheight_quarter = ScrH() / 4

			DrawBlurRect(ScrW()/ 128, ScrH() / 64, ScrW() / 6, ScrH() / 16)
        	surface.SetDrawColor(0, 0, 0, 255)
        	surface.DrawOutlinedRect(ScrW()/ 128, ScrH() / 64, ScrW() / 6, ScrH() / 16, 1)
			SigmaYgliDraw(ScrW()/ 128, ScrH() / 64, ScrW() / 6, ScrH() / 16, Color(255,255,255), ScrW() / 64)
			draw.DrawText( L"l:waiting_for_players", "ImpactSmall", ScrW()/ 104, ScrH() / 64, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			draw.DrawText( L"l:waiting_for_players_pt2 " .. " " .. 10 - #GetActivePlayers() .. L"  l:waiting_for_players_pt3", "ImpactSmall", ScrW()/ 104, ScrH() / 26, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )


		else

			if ( !client.MusicPlaying ) then

				client.MusicPlaying = true
				BREACH.Music:Play(BR_MUSIC_COUNTDOWN)

			end

			local time_left = math.Round( GetGlobalInt("EnoughPlayersCountDownStart", CurTime() + 180) - CurTime() )

			if ( time_left > 10 ) then

				local middle_screen = ScrW() / 2
				local screenheight = ScrH()
				DrawBlurRect(ScrW()/ 128, ScrH() / 64, ScrW() / 4.5, ScrH() / 16)
        		surface.SetDrawColor(0, 0, 0, 255)
        		surface.DrawOutlinedRect(ScrW()/ 128, ScrH() / 64, ScrW() / 4.5, ScrH() / 16, 1)
				SigmaYgliDraw(ScrW()/ 128, ScrH() / 64, ScrW() / 4.5, ScrH() / 16, Color(255,255,255), ScrW() / 64)
				draw.DrawText( #GetActivePlayers() .. L"l:starting_pt1", "ImpactSmall", ScrW()/ 104, ScrH() / 64, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
				local ltime = 720
				if #GetActivePlayers() >= 20 then ltime = 840 end
				--draw.DrawText( L"l:starting_pt2" .. string.ToMinutesSeconds( ltime ), "ImpactSmall", ScrW()/ 104, ScrH() / 26, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
				draw.DrawText( L"l:starting_pt3" .. time_left, "ImpactSmall", ScrW()/ 104, ScrH() / 26, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )

			else

				draw.DrawText( time_left, "Waiting", ScrW() / 2, ScrH() / 2, ColorAlpha( Color(255,0,0), 180 * Fluctuate( 3 ) ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

			end

		end

	end

  if ( BREACH.Nuked ) then
		--print( "yos" )
		if ( CurTime() - BREACH.NukeStart <= 0.2 ) then

			surface.SetDrawColor(255, 255, 255, 255 * math.Clamp( ( CurTime() - BREACH.NukeStart ) * 5, 0, 1) );

		else

			surface.SetDrawColor(255, 255, 255, 255 * ( 1 - math.Clamp( ( ( CurTime() - BREACH.NukeStart ) - 0.2) / 3, 0, 1) ) );

		end

		surface.DrawRect(0, 0, ScrW(), ScrH());
	end

	if ( BREACH.f_RoundStart ) then

		if ( CurTime() - BREACH.f_RoundStart <= 10 ) then

			if ( alpha < 255 ) then

				alpha = math.Approach( alpha, 255, FrameTime() * 256 )

			end

		else

			if ( alpha > 0 ) then

				alpha = math.Approach( alpha, 0, FrameTime() * 512 )

			end

		end

		surface.SetDrawColor( 0, 0, 0, alpha );

		if ( CurTime() - BREACH.f_RoundStart > 15 ) then

			BREACH.f_RoundStart = nil
			alpha = 0

		end

		surface.DrawRect( 0, 0, ScrW(), ScrH() )

	end

	if ( client.IntroBlackOut ) then

		if ( CurTime() - BREACH.NTFEnter <= .2 ) then

			surface.SetDrawColor( 0, 0, 0, 255 * math.Clamp( ( CurTime() - BREACH.NTFEnter ) * 5, 0, 1 ) )

		else

			surface.SetDrawColor( 0, 0, 0, 255 * ( 1 - math.Clamp( ( (CurTime() - BREACH.NTFEnter ) - 0.2) / 3, 0, 1) ) );

		end

		surface.DrawRect( 0, 0, ScrW(), ScrH() );

	end

	if ( client.BlackScreen ) then

		surface.SetDrawColor( color_black )
		surface.DrawRect( 0, 0, ScrW(), ScrH() )

	end

end

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
}

function GM:HUDDrawPickupHistory()
end

function GetAmmoString(tbl)
	for k, v in ipairs(tbl) do

			if v == "semi" or v == "auto" then
				return "МАГАЗИНЫ"

			elseif v == "bolt" then
				return "ПАТРОНЫ"

			elseif v == "pump" then
				return "КАРТЕЧИ"

			else
				return "БОЕЗАПАС"
			end

	end
end

local alpha_color = 0

hook.Add( "HUDShouldDraw", "HideHUDElements", function( name )
	if name == "CHudWeaponSelection" and GetConVar( "br_new_eq" ):GetInt() == 1 then
		return false
	end
	if hide[ name ] then return false end
end )

local MATS = {
	menublack = Material("nextoren_hud/inventory/menublack.png"),//Material("pp/blurscreen"),
	blanc = Material("hud_scp/texture_blanc.png"),
	meter = Material("hud_scp/meter.png"),
	time = Material("hud_scp/timeicon.png"),
	user = Material("hud_scp/user.png"),
	scp = Material("hud_scp/scp.png"),
	ammo = Material("hud_scp/ammoicon.png"),
	mag = Material("hud_scp/magicon.png"),
	blink = Material("hud_scp/blinkicon.png"),
	hp = Material("hud_scp/hpicon.png"),
	sprint = Material("hud_scp/sprinticon.png"),
}

surface.CreateFont( "TimeMisterFreeman", {
	font = "B52",
	extended = true,
	size = 24,
	antialias = true,
	shadow = false
})

surface.CreateFont( "Buba", {
	font = "Lorimer No 2 Stencil", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = true,
	size = 60,
	weight = 900,
	blursize = 0,
	scanlines = 0,
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

surface.CreateFont( "Buba7", {
	font = "Lorimer No 2 Stencil", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = true,
	size = 19,
	weight = 300,
	blursize = 0,
	scanlines = 0,
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

surface.CreateFont( "Buba6", {
	font = "Lorimer No 2 Stencil", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = true,
	size = 20,
	weight = 500,
	blursize = 0,
	scanlines = 0,
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


surface.CreateFont( "Buba5", {
	font = "Lorimer No 2 Stencil", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = true,
	size = 30,
	weight = 500,
	blursize = 0,
	scanlines = 3,
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

surface.CreateFont( "BubaChat", {
	font = "Lorimer No 2 Stencil", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = true,
	size = 18,
	weight = 500,
	blursize = 0,
	scanlines = 3,
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

surface.CreateFont( "Buba55", {
	font = "Lorimer No 2 Stencil", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = true,
	size = 45,
	weight = 500,
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

surface.CreateFont( "Buba3", {
	font = "Righteous", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = true,
	size = 30,
	weight = 400,
	blursize = 0,
	scanlines = 0,
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

local clr_red = Color( 255, 0, 0 )

function Pulsate( c )

  return math.abs( math.sin( CurTime() * c ) )

end

function Fluctuate( c )

  return ( math.cos( CurTime() * c ) + 1 ) * .5

end

surface.CreateFont( "Buba2", {
	font = "LittleMerry", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 48,
	weight = 800,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = true,
	additive = false,
	outline = false,
} )

function CreateKillFeed(data)

	if !GetConVar("breach_config_killfeed"):GetBool() then return end

	if !IsValid(KILLFEED_UI) then

		KILLFEED_UI = vgui.Create("DPanel")

		local scrw = ScrW()

		local w, h = scrw, ScrH()

		w = w/3.6

		KILLFEED_UI:SetSize(w, h)
		KILLFEED_UI:SetPos(scrw - w, 0)

		KILLFEED_UI.Paint = function(self, w, h)
		end

		local i_list = vgui.Create("DListLayout", KILLFEED_UI)
		i_list:Dock(FILL)

		KILLFEED_UI.list = i_list

	end

	local i_list = KILLFEED_UI.list

	local killfeed_font = "killfeed_font"
	local size_w, size_h = KILLFEED_UI:GetSize()

	local h = 1

	local all_text = ""

	for i = 1, #data do

		local v = data[i]

		if isstring(v) then
			all_text = all_text..v
		end

	end

	surface.SetFont(killfeed_font)
	local t_w, t_h = surface.GetTextSize(all_text)

	t_h = t_h + 5

	local text_gui = i_list:Add("DPanel")
	text_gui:Dock(TOP)

	text_gui:SetSize(size_w, t_h)
	text_gui.Paint = function() end

	text_gui:SetAlpha(0)
	text_gui:AlphaTo(255,1)

	text_gui:AlphaTo(0, 1, 6, function()

    text_gui:Remove()

	end)

	local _w = 0
	local _h = 0
	local prev = nil
	local lastcol = nil
	for i = 1, #data do
		local v = data[i]
		if isstring(v) then
			v = L(GetLangRole(v))
			local my_w = surface.GetTextSize(v)
			local text = vgui.Create("DPanel", text_gui)
			text:SetSize(my_w, t_h)
			if _w + my_w > size_w then
				_h = _h + t_h
				_w = 0
				text_gui:SetSize(size_w, t_h + _h)
			else
				text_gui:SetSize(size_w, t_h + _h)
				no = true
			end
			text:SetPos(_w, _h)
			local col = lastcol
			text.Paint = function(self, w, h)

				draw.DrawText(v, killfeed_font, 0, 0, col, TEXT_ALIGN_LEFT)

			end
			_w = _w + my_w
		elseif IsColor(v) then
			lastcol = v
		end

		prev = v

	end

end

net.Receive("breach_killfeed", function(len)
	local data = net.ReadTable() 
	CreateKillFeed(data)
end)

local clr_gray = Color( 198, 198, 198 )
local clr_green = Color( 0, 180, 0 )

local function UIU_Ending( complete )

	StopMusic()

	local status

	if ( complete ) then

		status = L"l:ending_mission_complete"
		BREACH.Music:Play(BR_MUSIC_UIU_WIN)
		--[[timer.Simple(0.1, function()
			surface.PlaySound( "nextoren/new_onp_end.wav" )
		end)]]

	else

		status = L"l:ending_mission_failed"
		--[[timer.Simple(0.1, function()
			surface.PlaySound( "nextoren/new_onp_end.wav" )
		end)]]
		BREACH.Music:Play(BR_MUSIC_UIU_LOOSE)

	end

	local client = LocalPlayer()

	local screenwidth, screenheight = ScrW(), ScrH()

	client.Ending_window = vgui.Create( "DPanel" )
	client.Ending_window:SetSize( screenwidth, screenheight )
	client.Ending_window.Name = L"l:cutscene_subject " .. client:GetNamesurvivor()
	if client:GetRoleName() == "UIU Spy" then
		client.Ending_window.Name = client.Ending_window.Name..L", l:cutscene_undercover_agent"
	end
	client.Ending_window.StartTime = CurTime()
	client.Ending_window.Status = L"l:cutscene_status " .. status
	client.Ending_window.Icon_Alpha = 0

	local screenmiddle_w, screenmiddle_h = screenwidth / 2, screenheight / 2

	local name_string_table, status_string_table = string.Explode( "", client.Ending_window.Name, true ), string.Explode( "", client.Ending_window.Status, true )

	local actual_string_1, actual_string_2 = "", ""

	client.Ending_window.Paint = function( self, w, h )
		
		draw.RoundedBox( 0, 0, 0, w, h, color_black )

		if ( self.Icon_Alpha < 255 ) then

			self.Icon_Alpha = math.Approach( self.Icon_Alpha, 255, RealFrameTime() * 256 )

		end

		surface.SetDrawColor( ColorAlpha( color_white, self.Icon_Alpha ) )
		surface.SetMaterial( TeamIcons[ TEAM_USA ].mat )
		surface.DrawTexturedRect( screenmiddle_w - 128, screenmiddle_h - 128, 256, 256 )

		if ( actual_string_1:len() != #name_string_table && ( self.NextSymbol || 0 ) < CurTime() ) then

			self.NextSymbol = CurTime() + .025
			actual_string_1 = actual_string_1 .. name_string_table[ #actual_string_1 + 1 ]

		elseif ( actual_string_2:len() != #status_string_table && ( self.NextSymbol || 0 ) < CurTime() ) then

			self.NextSymbol = CurTime() + .025
			actual_string_2 = actual_string_2 .. status_string_table[ #actual_string_2 + 1 ]

		end

		draw.SimpleTextOutlined( actual_string_1, "MainMenuFont", screenmiddle_w, screenmiddle_h * .9, desc_clr_gray, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black )
		draw.SimpleTextOutlined( actual_string_2, "MainMenuFont", screenmiddle_w, screenmiddle_h, desc_clr_gray, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black )

		if ( self.StartTime < CurTime() - 7 ) then

			if ( !self.alpha_variable ) then

				self.alpha_variable = 255

			end

			self.alpha_variable = math.Approach( self.alpha_variable, 0, RealFrameTime() * 512 )

			if ( self.alpha_variable == 0 ) then

				if ( !self.CallFade ) then

					self.CallFade = true
					FadeMusic( 10 )

				end

			end

			self:SetAlpha( self.alpha_variable )

		end

	end

end

local clr_text = Color( 180, 0, 0, 210 )

function UAStart()

	local client = LocalPlayer()

	if ( IsValid( client.Faction_intro ) ) then

		client.Faction_intro:Remove()

	end

	client:ConCommand( "stopsound" )

	client.Faction_intro = vgui.Create( "DPanel" )
	client.Faction_intro:SetSize( ScrW(), ScrH() )
	client.Faction_intro.StartTime = CurTime() + 2
	client.Faction_intro.Name = BREACH.TranslateString"l:cutscene_subject_name " .. client:GetNamesurvivor()
	client.Faction_intro.Time = BREACH.TranslateString"任务: 潜入设施,骇入设施终端呼叫支援"

	local name_string_table = string.Explode( "", client.Faction_intro.Name, true )
	local time_string_table = string.Explode( "", client.Faction_intro.Time )

	local actual_string_1, actual_string_2 = "", ""

	local screenmiddle_w, screenmiddle_h = ScrW() / 2, ScrH() / 2

	client.Faction_intro.Paint = function( self, w, h )

		draw.RoundedBox( 0, 0, 0, w, h, color_black )

		if ( ( self.StartTime - 8 ) < CurTime() ) then

			surface.SetDrawColor( ColorAlpha( color_white, 210 ) )
			surface.SetMaterial( Material( "nextoren/gui/roles_icon/fbi_agent.png" ) )
			surface.DrawTexturedRect( screenmiddle_w - 128, screenmiddle_h - 128, 256, 256 )

		end

		if ( ( self.StartTime - 6 ) < CurTime() && !self.MusicPlaying ) then

			self.MusicPlaying = true
			BREACH.Music:Play(BR_MUSIC_SPAWN_FBI_AGENTS_NEW)

		end

		if ( self.StartTime > CurTime() ) then return end

		if ( actual_string_1:len() != #name_string_table && ( self.NextSymbol || 0 ) < CurTime() ) then

			self.NextSymbol = CurTime() + .025
			actual_string_1 = actual_string_1 .. name_string_table[ #actual_string_1 + 1 ]

		elseif ( actual_string_2:len() != #time_string_table && ( self.NextSymbol || 0 ) < CurTime() ) then

			self.NextSymbol = CurTime() + .025
			actual_string_2 = actual_string_2 .. time_string_table[ #actual_string_2 + 1 ]

		end

		draw.SimpleTextOutlined( actual_string_1, "MainMenuFont", screenmiddle_w, screenmiddle_h * .9, clr_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black )
		draw.SimpleTextOutlined( actual_string_2, "MainMenuFont", screenmiddle_w, screenmiddle_h, clr_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black )

		if ( self.StartTime < CurTime() - 8 ) then

			if ( !self.alpha_variable ) then

				self.alpha_variable = 255

			end
			self.alpha_variable = math.Approach( self.alpha_variable, 0, RealFrameTime() * 512 )
			if self.alpha_variable != 255 and self.DescPlayed != true then
				self.DescPlayed = true
				DrawNewRoleDesc()
				net.Start("ProceedUnfreezeSUP")
				net.SendToServer()
			end
			self:SetAlpha( self.alpha_variable )

		end

	end

end

local clr_text = Color( 180, 0, 0, 210 )
function UIULJStart()

	local client = LocalPlayer()

	if ( IsValid( client.Faction_intro ) ) then

		client.Faction_intro:Remove()

	end

	client:ConCommand( "stopsound" )

	client.Faction_intro = vgui.Create( "DPanel" )
	client.Faction_intro:SetSize( ScrW(), ScrH() )
	client.Faction_intro.StartTime = CurTime() + 2
	client.Faction_intro.Name = BREACH.TranslateString"l:cutscene_subject_name " .. client:GetNamesurvivor()
	client.Faction_intro.Time = BREACH.TranslateString"l:cutscene_time_after_disaster " .. string.ToMinutesSeconds( GetRoundTime() - ( cltime - 23 ) )

	local name_string_table = string.Explode( "", client.Faction_intro.Name, true )
	local time_string_table = string.Explode( "", client.Faction_intro.Time )

	local actual_string_1, actual_string_2 = "", ""

	local screenmiddle_w, screenmiddle_h = ScrW() / 2, ScrH() / 2

	client.Faction_intro.Paint = function( self, w, h )

		draw.RoundedBox( 0, 0, 0, w, h, color_black )

		if ( ( self.StartTime - 8 ) < CurTime() ) then

			surface.SetDrawColor( ColorAlpha( color_white, 210 ) )
			surface.SetMaterial( Material( "nextoren/gui/roles_icon/fbi.png" ) )
			surface.DrawTexturedRect( screenmiddle_w - 128, screenmiddle_h - 128, 256, 256 )

		end

		if ( ( self.StartTime - 6 ) < CurTime() && !self.MusicPlaying ) then

			self.MusicPlaying = true
			BREACH.Music:Play(BR_MUSIC_SPAWN_FBI_B)

		end

		if ( self.StartTime > CurTime() ) then return end

		if ( actual_string_1:len() != #name_string_table && ( self.NextSymbol || 0 ) < CurTime() ) then

			self.NextSymbol = CurTime() + .025
			actual_string_1 = actual_string_1 .. name_string_table[ #actual_string_1 + 1 ]

		elseif ( actual_string_2:len() != #time_string_table && ( self.NextSymbol || 0 ) < CurTime() ) then

			self.NextSymbol = CurTime() + .025
			actual_string_2 = actual_string_2 .. time_string_table[ #actual_string_2 + 1 ]

		end

		draw.SimpleTextOutlined( actual_string_1, "MainMenuFont", screenmiddle_w, screenmiddle_h * .9, clr_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black )
		draw.SimpleTextOutlined( actual_string_2, "MainMenuFont", screenmiddle_w, screenmiddle_h, clr_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black )

		if ( self.StartTime < CurTime() - 2 ) then

			if ( !self.alpha_variable ) then

				self.alpha_variable = 255

			end
			self.alpha_variable = math.Approach( self.alpha_variable, 0, RealFrameTime() * 512 )
			if self.alpha_variable != 255 and self.DescPlayed != true then
				self.DescPlayed = true
				DrawNewRoleDesc()
				net.Start("ProceedUnfreezeSUP")
				net.SendToServer()
			end
			self:SetAlpha( self.alpha_variable )

		end

	end

end

local goc_icon = Material( "nextoren/gui/roles_icon/goc.png" )
local goc_clr = Color( 0, 198, 198 )

function GOCStart()

	local client = LocalPlayer()
	client:ConCommand( "stopsound" )

	BREACH.Music:Play(BR_MUSIC_SPAWN_GOC)
	

	local CutSceneWindow = vgui.Create( "DPanel" )
	CutSceneWindow:SetText( "" )
	CutSceneWindow:SetSize( ScrW(), ScrH() )
	CutSceneWindow.StartAlpha = 255
	CutSceneWindow.StartTime = CurTime() + 24.2
	CutSceneWindow.Name = BREACH.TranslateString("l:cutscene_subject_name ") .. client:GetNamesurvivor()
	CutSceneWindow.Status = BREACH.TranslateString("l:cutscene_objective l:cutscene_disaster_relief")
	CutSceneWindow.Time = BREACH.TranslateString("l:cutscene_time_after_disaster ")..string.ToMinutesSeconds( GetRoundTime() - cltime )

	local ExplodedString3 = string.Explode( "", CutSceneWindow.Time, true )
	local ExplodedString2 = string.Explode( "", CutSceneWindow.Status, true )
	local ExplodedString = string.Explode( "", CutSceneWindow.Name, true )

	local str = ""
	local str1 = ""
	local str2 = ""

	local count = 0
	local count1 = 0
	local count2 = 0

	CutSceneWindow.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, ColorAlpha( color_black, self.StartAlpha ) )

		if ( CutSceneWindow.StartTime <= CurTime() ) then

			surface.SetDrawColor( ColorAlpha( color_white, math.Clamp( self.StartAlpha - 40, 0, 255 ) ) )
			surface.SetMaterial( goc_icon )
			surface.DrawTexturedRect( ScrW() / 2 - 201, ScrH() / 2 - 201, 402, 402 )

			if ( CutSceneWindow.StartTime <= CurTime() - 6 ) then

				self.StartAlpha = math.Approach( self.StartAlpha, 0, RealFrameTime() * 20 )
				if self.StartAlpha != 255 and self.DescPlayed != true then
					self.DescPlayed = true
					DrawNewRoleDesc()
					net.Start("ProceedUnfreezeSUP")
					net.SendToServer()
				end

			end

			if ( ( self.NextSymbol || 0 ) <= SysTime() && count2 != #ExplodedString3 ) then

				count2 = count2 + 1
				self.NextSymbol = SysTime() + .07
				str = str..ExplodedString3[ count2 ]

			elseif ( ( self.NextSymbol || 0 ) <= SysTime() && count2 == #ExplodedString3 && count1 != #ExplodedString2 ) then

				count1 = count1 + 1
				self.NextSymbol = SysTime() + .07
				str1 = str1..ExplodedString2[ count1 ]

			elseif ( ( self.NextSymbol || 0 ) <= SysTime() && count2 == #ExplodedString3 && count1 == #ExplodedString2 && count != #ExplodedString ) then

				count = count + 1
				self.NextSymbol = SysTime() + .07
				str2 = str2..ExplodedString[ count ]

			end

			draw.SimpleTextOutlined( str, "TimeMisterFreeman", w / 2, h / 1.2, ColorAlpha( goc_clr, self.StartAlpha ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, ColorAlpha( clr_red, self.StartAlpha ) )
			draw.SimpleTextOutlined( str1, "TimeMisterFreeman", w / 2, h / 2 + 32, ColorAlpha( goc_clr, self.StartAlpha ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, ColorAlpha( clr_red, self.StartAlpha ) )
			draw.SimpleTextOutlined( str2, "TimeMisterFreeman", w / 2, h / 2 + 64, ColorAlpha( goc_clr, self.StartAlpha ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, ColorAlpha( clr_red, self.StartAlpha ) )

		end

		if ( self.StartAlpha <= 0 ) then

			FadeMusic( 15 )
			--Show_Spy( client:Team() )
			self:Remove()

		end

	end

end

local clr_text = Color( 180, 0, 0, 210 )
local onp_icon = TeamIcons[ TEAM_USA ].mat

function ONPStart()

	local client = LocalPlayer()

	if ( IsValid( client.Faction_intro ) ) then

		client.Faction_intro:Remove()

	end

	client:ConCommand( "stopsound" )

	client.Faction_intro = vgui.Create( "DPanel" )
	client.Faction_intro:SetSize( ScrW(), ScrH() )
	client.Faction_intro.StartTime = CurTime() + 12
	client.Faction_intro.Name = BREACH.TranslateString"l:cutscene_subject_name " .. client:GetNamesurvivor()
	client.Faction_intro.Time = BREACH.TranslateString"l:cutscene_time_after_disaster " .. string.ToMinutesSeconds( GetRoundTime() - ( cltime - 28 ) )

	local name_string_table = string.Explode( "", client.Faction_intro.Name, true )
	local time_string_table = string.Explode( "", client.Faction_intro.Time )

	local actual_string_1, actual_string_2 = "", ""

	local screenmiddle_w, screenmiddle_h = ScrW() / 2, ScrH() / 2

	client.Faction_intro.Paint = function( self, w, h )

		draw.RoundedBox( 0, 0, 0, w, h, color_black )

		if ( ( self.StartTime ) < CurTime() ) then

			surface.SetDrawColor( ColorAlpha( color_white, 210 ) )
			surface.SetMaterial( onp_icon )
			surface.DrawTexturedRect( screenmiddle_w - 128, screenmiddle_h - 128, 256, 256 )

		end

		if ( ( self.StartTime - 1.9 ) < CurTime() && !self.MusicPlaying ) then

			self.MusicPlaying = true
			BREACH.Music:Play(BR_MUSIC_SPAWN_FBI)

		end

		--if ( self.StartTime + 1 > CurTime() ) then return end

		if ( self.StartTime < CurTime() - 5 ) then

			if ( !self.alpha_variable ) then

				self.alpha_variable = 255

			end
			self.alpha_variable = math.Approach( self.alpha_variable, 0, RealFrameTime() * 512 )
			if self.alpha_variable != 255 and self.DescPlayed != true then
				self.DescPlayed = true
				DrawNewRoleDesc()
				net.Start("ProceedUnfreezeSUP")
				net.SendToServer()
			end
			self:SetAlpha( self.alpha_variable )

		end

	end

end

local clr_text = Color( 180, 0, 0, 210 )
local onp_icon = TeamIcons[ 1331 ].mat

function SHTURMONPStart()

	local client = LocalPlayer()

	if ( IsValid( client.Faction_intro ) ) then

		client.Faction_intro:Remove()

	end

	client:ConCommand( "stopsound" )

	client.Faction_intro = vgui.Create( "DPanel" )
	client.Faction_intro:SetSize( ScrW(), ScrH() )
	client.Faction_intro.StartTime = CurTime() + 2
	client.Faction_intro.Name = BREACH.TranslateString"l:cutscene_subject_name " .. client:GetNamesurvivor()
	client.Faction_intro.Time = BREACH.TranslateString"l:a1_task"

	local name_string_table = string.Explode( "", client.Faction_intro.Name, true )
	local time_string_table = string.Explode( "", client.Faction_intro.Time )

	local actual_string_1, actual_string_2 = "", ""

	local screenmiddle_w, screenmiddle_h = ScrW() / 2, ScrH() / 2

	client.Faction_intro.Paint = function( self, w, h )

		draw.RoundedBox( 0, 0, 0, w, h, color_black )

		if ( ( self.StartTime - 8 ) < CurTime() ) then

			surface.SetDrawColor( ColorAlpha( color_white, 210 ) )
			surface.SetMaterial( onp_icon )
			surface.DrawTexturedRect( screenmiddle_w - 128, screenmiddle_h - 128, 256, 256 )

		end

		if ( ( self.StartTime - 6 ) < CurTime() && !self.MusicPlaying ) then

			self.MusicPlaying = true
			BREACH.Music:Play(BR_MUSIC_SPAWN_FBI_AGENTS)

		end

		if ( self.StartTime > CurTime() ) then return end

		if ( actual_string_1:len() != #name_string_table && ( self.NextSymbol || 0 ) < CurTime() ) then

			self.NextSymbol = CurTime() + .025
			actual_string_1 = actual_string_1 .. name_string_table[ #actual_string_1 + 1 ]

		elseif ( actual_string_2:len() != #time_string_table && ( self.NextSymbol || 0 ) < CurTime() ) then

			self.NextSymbol = CurTime() + .025
			actual_string_2 = actual_string_2 .. time_string_table[ #actual_string_2 + 1 ]

		end

		draw.SimpleTextOutlined( actual_string_1, "MainMenuFont", screenmiddle_w, screenmiddle_h * .9, clr_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black )
		draw.SimpleTextOutlined( actual_string_2, "MainMenuFont", screenmiddle_w, screenmiddle_h, clr_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black )

		if ( self.StartTime < CurTime() - 8 ) then

			if ( !self.alpha_variable ) then

				self.alpha_variable = 255

			end
			self.alpha_variable = math.Approach( self.alpha_variable, 0, RealFrameTime() * 512 )
			if self.alpha_variable != 255 and self.DescPlayed != true then
				self.DescPlayed = true
				DrawNewRoleDesc()
				net.Start("ProceedUnfreezeSUP")
				net.SendToServer()
			end
			self:SetAlpha( self.alpha_variable )

		end

	end

end

function FAFStart()

	local clr_text = gteams.GetColor( TEAM_FAF )

	local client = LocalPlayer()

	if ( IsValid( client.Faction_intro ) ) then

		client.Faction_intro:Remove()

	end

	client:ConCommand( "stopsound" )
	client.Faction_intro = vgui.Create( "DPanel" )
	client.Faction_intro:SetSize( ScrW(), ScrH() )
	client.Faction_intro.StartTime = CurTime() + 10
	client.Faction_intro.Name = BREACH.TranslateString"l:cutscene_name " .. client:GetNamesurvivor()
	client.Faction_intro.Status = BREACH.TranslateString"你的任务是：探查设施威胁情况, 支援基金会作战单位"
	client.Faction_intro.Time = BREACH.TranslateString"l:cutscene_time_after_disaster " .. string.ToMinutesSeconds( GetRoundTime() - ( cltime - 10 ) )

	local name_string_table = string.Explode( "", client.Faction_intro.Name, true )
	local status_string_table = string.Explode( "", client.Faction_intro.Status, true )
	local time_string_table = string.Explode( "", client.Faction_intro.Time )

	local actual_string_1, actual_string_2, actual_string_3 = "", "", ""

	local screenmiddle_w, screenmiddle_h = ScrW() / 2, ScrH() / 2

	client.Faction_intro.Paint = function( self, w, h )

		draw.RoundedBox( 0, 0, 0, w, h, color_black )
		

		if ( ( self.StartTime - 9 ) < CurTime() ) then --15s时间过去1s
			surface.SetDrawColor( color_white )
			surface.SetMaterial( Material("nextoren/gui/roles_icon/mtf.png") )
			surface.DrawTexturedRect( screenmiddle_w - 128, screenmiddle_h - 128, 256, 256 )

		end

		
		if ( ( self.StartTime - 9 ) < CurTime() && !self.MusicPlaying ) then

			self.MusicPlaying = true
			BREACH.Music:Play(BR_MUSIC_SPAWN_FAF)

		end
		if ( self.StartTime > CurTime() ) then return end

		if ( actual_string_1:len() != #name_string_table && ( self.NextSymbol || 0 ) < CurTime() ) then

			self.NextSymbol = CurTime() + .025
			actual_string_1 = actual_string_1 .. name_string_table[ #actual_string_1 + 1 ]

		elseif ( actual_string_2:len() != #status_string_table && ( self.NextSymbol || 0 ) < CurTime() ) then

			self.NextSymbol = CurTime() + .025
			actual_string_2 = actual_string_2 .. status_string_table[ #actual_string_2 + 1 ]

		elseif ( actual_string_3:len() != #time_string_table && ( self.NextSymbol || 0 ) < CurTime() ) then

			self.NextSymbol = CurTime() + .025
			actual_string_3 = actual_string_3 .. time_string_table[ #actual_string_3 + 1 ]

		end
		draw.SimpleTextOutlined( actual_string_1, "MainMenuFont", screenmiddle_w, screenmiddle_h * .8, clr_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black )
		draw.SimpleTextOutlined( actual_string_2, "MainMenuFont", screenmiddle_w, screenmiddle_h * .9, clr_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black )
		draw.SimpleTextOutlined( actual_string_3, "MainMenuFont", screenmiddle_w, screenmiddle_h, clr_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black )



		if ( self.StartTime < CurTime() - 13 ) then

			if ( !self.alpha_variable ) then

				self.alpha_variable = 255

			end

			self.alpha_variable = math.Approach( self.alpha_variable, 0, RealFrameTime() * 512 )
			if self.alpha_variable != 255 and self.DescPlayed != true then
				self.DescPlayed = true
				DrawNewRoleDesc()
				net.Start("ProceedUnfreezeSUP")
				net.SendToServer()
			end
			self:SetAlpha( self.alpha_variable )

		end

	end
end

local dz_icon = TeamIcons[ TEAM_DZ ].mat

function SHStart()
	local clr_text = gteams.GetColor( TEAM_DZ )

	local client = LocalPlayer()

	if ( IsValid( client.Faction_intro ) ) then

		client.Faction_intro:Remove()

	end

	client:ConCommand( "stopsound" )

	timer.Simple( .25, function()

		surface.PlaySound( "nextoren/others/interdimension_travel.wav" )

	end )

	client.Faction_intro = vgui.Create( "DPanel" )
	client.Faction_intro:SetSize( ScrW(), ScrH() )
	client.Faction_intro.StartTime = CurTime() + 25
	client.Faction_intro.Name = BREACH.TranslateString"l:cutscene_subject_name " .. client:GetNamesurvivor()
	client.Faction_intro.Status = BREACH.TranslateString"l:cutscene_objective l:cutscene_scp_rescue"
	client.Faction_intro.Time = BREACH.TranslateString"l:cutscene_time_after_disaster " .. string.ToMinutesSeconds( GetRoundTime() - ( cltime - 23 ) )

	local name_string_table = string.Explode( "", client.Faction_intro.Name, true )
	local status_string_table = string.Explode( "", client.Faction_intro.Status, true )
	local time_string_table = string.Explode( "", client.Faction_intro.Time )

	local actual_string_1, actual_string_2, actual_string_3 = "", "", ""

	local screenmiddle_w, screenmiddle_h = ScrW() / 2, ScrH() / 2

	client.Faction_intro.Paint = function( self, w, h )

		draw.RoundedBox( 0, 0, 0, w, h, color_black )

		if ( ( self.StartTime - 8 ) < CurTime() ) then

			surface.SetDrawColor( ColorAlpha( color_white, 210 ) )
			surface.SetMaterial( dz_icon )
			surface.DrawTexturedRect( screenmiddle_w - 128, screenmiddle_h - 128, 256, 256 )

		end

		if ( ( self.StartTime - 6 ) < CurTime() && !self.MusicPlaying ) then

			self.MusicPlaying = true
			BREACH.Music:Play(BR_MUSIC_SPAWN_DZ)

		end

		if ( self.StartTime > CurTime() ) then return end

		if ( actual_string_1:len() != #name_string_table && ( self.NextSymbol || 0 ) < CurTime() ) then

			self.NextSymbol = CurTime() + .025
			actual_string_1 = actual_string_1 .. name_string_table[ #actual_string_1 + 1 ]

		elseif ( actual_string_2:len() != #status_string_table && ( self.NextSymbol || 0 ) < CurTime() ) then

			self.NextSymbol = CurTime() + .025
			actual_string_2 = actual_string_2 .. status_string_table[ #actual_string_2 + 1 ]

		elseif ( actual_string_3:len() != #time_string_table && ( self.NextSymbol || 0 ) < CurTime() ) then

			self.NextSymbol = CurTime() + .025
			actual_string_3 = actual_string_3 .. time_string_table[ #actual_string_3 + 1 ]

		end

		draw.SimpleTextOutlined( actual_string_1, "MainMenuFont", screenmiddle_w, screenmiddle_h * .8, clr_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black )
		draw.SimpleTextOutlined( actual_string_2, "MainMenuFont", screenmiddle_w, screenmiddle_h * .9, clr_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black )
		draw.SimpleTextOutlined( actual_string_3, "MainMenuFont", screenmiddle_w, screenmiddle_h, clr_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black )

		if ( self.StartTime < CurTime() - 8 ) then

			if ( !self.alpha_variable ) then

				self.alpha_variable = 255

			end

			self.alpha_variable = math.Approach( self.alpha_variable, 0, RealFrameTime() * 512 )
			if self.alpha_variable != 255 and self.DescPlayed != true then
				self.DescPlayed = true
				DrawNewRoleDesc()
				net.Start("ProceedUnfreezeSUP")
				net.SendToServer()
			end
			self:SetAlpha( self.alpha_variable )

		end

	end

end



local cult_icon = TeamIcons[ TEAM_COTSK ].mat

function CultStart()

	local clr_text = gteams.GetColor( TEAM_COTSK )

	local client = LocalPlayer()

	if ( IsValid( client.Faction_intro ) ) then

		client.Faction_intro:Remove()

	end

	client:ConCommand( "stopsound" )

	timer.Simple( 1, function()

		--surface.PlaySound( "nextoren/cultist_time_travel.ogg" )

	end )

	client.Faction_intro = vgui.Create( "DPanel" )
	client.Faction_intro:SetSize( ScrW(), ScrH() )
	client.Faction_intro.StartTime = CurTime() + 25
	client.Faction_intro.Name = BREACH.TranslateString"l:cutscene_name " .. client:GetNamesurvivor()
	client.Faction_intro.Status = BREACH.TranslateString"l:cutscene_objective l:cutscene_namaz"
	client.Faction_intro.Time = BREACH.TranslateString"l:cutscene_time_after_disaster " .. string.ToMinutesSeconds( GetRoundTime() - ( cltime - 23 ) )

	local name_string_table = string.Explode( "", client.Faction_intro.Name, true )
	local status_string_table = string.Explode( "", client.Faction_intro.Status, true )
	local time_string_table = string.Explode( "", client.Faction_intro.Time )

	local actual_string_1, actual_string_2, actual_string_3 = "", "", ""

	local screenmiddle_w, screenmiddle_h = ScrW() / 2, ScrH() / 2

	client.Faction_intro.Paint = function( self, w, h )

		draw.RoundedBox( 0, 0, 0, w, h, color_black )

		if ( ( self.StartTime - 9 ) < CurTime() ) then

			surface.SetDrawColor( ColorAlpha( color_white, 210 ) )
			surface.SetMaterial( cult_icon )
			surface.DrawTexturedRect( screenmiddle_w - 128, screenmiddle_h - 128, 256, 256 )

		end

		if ( ( self.StartTime - 24 ) < CurTime() && !self.MusicPlaying ) then

			self.MusicPlaying = true
			BREACH.Music:Play(BR_MUSIC_SPAWN_CULT)

		end

		if ( self.StartTime > CurTime() ) then return end

		if ( actual_string_1:len() != #name_string_table && ( self.NextSymbol || 0 ) < CurTime() ) then

			self.NextSymbol = CurTime() + .025
			actual_string_1 = actual_string_1 .. name_string_table[ #actual_string_1 + 1 ]

		elseif ( actual_string_2:len() != #status_string_table && ( self.NextSymbol || 0 ) < CurTime() ) then

			self.NextSymbol = CurTime() + .025
			actual_string_2 = actual_string_2 .. status_string_table[ #actual_string_2 + 1 ]

		elseif ( actual_string_3:len() != #time_string_table && ( self.NextSymbol || 0 ) < CurTime() ) then

			self.NextSymbol = CurTime() + .025
			actual_string_3 = actual_string_3 .. time_string_table[ #actual_string_3 + 1 ]

		end

		draw.SimpleTextOutlined( actual_string_1, "MainMenuFont", screenmiddle_w, screenmiddle_h * .8, clr_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black )
		draw.SimpleTextOutlined( actual_string_2, "MainMenuFont", screenmiddle_w, screenmiddle_h * .9, clr_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black )
		draw.SimpleTextOutlined( actual_string_3, "MainMenuFont", screenmiddle_w, screenmiddle_h, clr_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black )

		if ( self.StartTime < CurTime() - 8 ) then

			if ( !self.alpha_variable ) then

				self.alpha_variable = 255

			end

			self.alpha_variable = math.Approach( self.alpha_variable, 0, RealFrameTime() * 512 )
			if self.alpha_variable != 255 and self.DescPlayed != true then
				self.DescPlayed = true
				DrawNewRoleDesc()
				net.Start("ProceedUnfreezeSUP")
				net.SendToServer()
			end
			self:SetAlpha( self.alpha_variable )

		end

	end

end

function ETTStart()

	local clr_text = gteams.GetColor( TEAM_ETT )

	local client = LocalPlayer()

	if ( IsValid( client.Faction_intro ) ) then

		client.Faction_intro:Remove()

	end

	client:ConCommand( "stopsound" )
	
	--timer.Simple(FrameTime(), function()
		--BREACH.Music:Play(BR_MUSIC_SPAWN_VDV) --1111
	--end)

	client.Faction_intro = vgui.Create( "DPanel" )
	client.Faction_intro:SetSize( ScrW(), ScrH() )
	client.Faction_intro.StartTime = CurTime() + 25
	client.Faction_intro.Name = BREACH.TranslateString"l:cutscene_name " .. client:GetNamesurvivor()
	client.Faction_intro.Status = BREACH.TranslateString"你们的任务是探查设施情况, 必要时可以呼叫增员"
	client.Faction_intro.Time = BREACH.TranslateString"l:cutscene_time_after_disaster " .. string.ToMinutesSeconds( GetRoundTime() - ( cltime - 23 ) )

	local name_string_table = string.Explode( "", client.Faction_intro.Name, true )
	local status_string_table = string.Explode( "", client.Faction_intro.Status, true )
	local time_string_table = string.Explode( "", client.Faction_intro.Time )

	local actual_string_1, actual_string_2, actual_string_3 = "", "", ""

	local screenmiddle_w, screenmiddle_h = ScrW() / 2, ScrH() / 2

	client.Faction_intro.Paint = function( self, w, h )

		draw.RoundedBox( 0, 0, 0, w, h, color_black )
		
		
		if ( ( self.StartTime - 25 ) < CurTime() && !self.MusicPlaying ) then

			self.MusicPlaying = true
			BREACH.Music:Play(BR_MUSIC_SPAWN_ETTRA)

		end

		if ( ( self.StartTime - 10 ) < CurTime() ) then

			surface.SetDrawColor( color_white )
			surface.SetMaterial( TeamIcons[ TEAM_ETT ].mat )
			surface.DrawTexturedRect( screenmiddle_w - 128, screenmiddle_h - 128, 256, 256 )

		end

		if ( self.StartTime > CurTime() ) then return end

		if ( actual_string_1:len() != #name_string_table && ( self.NextSymbol || 0 ) < CurTime() ) then

			self.NextSymbol = CurTime() + .025
			actual_string_1 = actual_string_1 .. name_string_table[ #actual_string_1 + 1 ]

		elseif ( actual_string_2:len() != #status_string_table && ( self.NextSymbol || 0 ) < CurTime() ) then

			self.NextSymbol = CurTime() + .025
			actual_string_2 = actual_string_2 .. status_string_table[ #actual_string_2 + 1 ]

		elseif ( actual_string_3:len() != #time_string_table && ( self.NextSymbol || 0 ) < CurTime() ) then

			self.NextSymbol = CurTime() + .025
			actual_string_3 = actual_string_3 .. time_string_table[ #actual_string_3 + 1 ]

		end
		draw.SimpleTextOutlined( actual_string_1, "MainMenuFont", screenmiddle_w, screenmiddle_h * .8, clr_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black )
		draw.SimpleTextOutlined( actual_string_2, "MainMenuFont", screenmiddle_w, screenmiddle_h * .9, clr_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black )
		draw.SimpleTextOutlined( actual_string_3, "MainMenuFont", screenmiddle_w, screenmiddle_h, clr_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black )



		if ( self.StartTime < CurTime() - 5 ) then

			if ( !self.alpha_variable ) then

				self.alpha_variable = 255

			end

			self.alpha_variable = math.Approach( self.alpha_variable, 0, RealFrameTime() * 512 )
			if self.alpha_variable != 255 and self.DescPlayed != true then
				self.DescPlayed = true
				DrawNewRoleDesc()
				net.Start("ProceedUnfreezeSUP")
				net.SendToServer()
			end
			self:SetAlpha( self.alpha_variable )

		end

	end
end

local ntf_icon = TeamIcons[ TEAM_NTF ].mat

function NTFStart()

	local clr_text = gteams.GetColor( TEAM_NTF )

	local client = LocalPlayer()

	if ( IsValid( client.Faction_intro ) ) then

		client.Faction_intro:Remove()

	end

	client:ConCommand( "stopsound" )

	timer.Simple(FrameTime(), function()
		BREACH.Music:Play(BR_MUSIC_SPAWN_NTF)
	end)

	client.Faction_intro = vgui.Create( "DPanel" )
	client.Faction_intro:SetSize( ScrW(), ScrH() )
	client.Faction_intro.StartTime = CurTime() + 0.2

	local name_string_table = string.Explode( "", client.Faction_intro.Name, true )
	local status_string_table = string.Explode( "", client.Faction_intro.Status, true )
	local time_string_table = string.Explode( "", client.Faction_intro.Time )

	local actual_string_1, actual_string_2, actual_string_3 = "", "", ""

	local screenmiddle_w, screenmiddle_h = ScrW() / 2, ScrH() / 2

	client.Faction_intro.Paint = function( self, w, h )

		draw.RoundedBox( 0, 0, 0, w, h, color_black )

		if ( ( self.StartTime ) < CurTime() ) then

			surface.SetDrawColor( color_white )
			surface.SetMaterial( ntf_icon )
			surface.DrawTexturedRect( screenmiddle_w - 128, screenmiddle_h - 128, 256, 256 )

		end

		if ( self.StartTime < CurTime() - 2) then

			if ( !self.alpha_variable ) then

				self.alpha_variable = 255

			end

			self.alpha_variable = math.Approach( self.alpha_variable, 0, RealFrameTime() * 512 )
			if self.alpha_variable != 255 and self.DescPlayed != true then
				self.DescPlayed = true
				DrawNewRoleDesc()
				net.Start("ProceedUnfreezeSUP")
				net.SendToServer()
			end
			self:SetAlpha( self.alpha_variable )

		end

	end

end

function NEWGRUStart()

	local clr_text = gteams.GetColor( TEAM_GRU )

	local client = LocalPlayer()

	if ( IsValid( client.Faction_intro ) ) then

		client.Faction_intro:Remove()

	end

	--client:ConCommand( "stopsound" )

	--timer.Simple(FrameTime(), function()
	--	BREACH.Music:Play(BR_MUSIC_SPAWN_NTF)
	--end)

	client.Faction_intro = vgui.Create( "DPanel" )
	client.Faction_intro:SetSize( ScrW(), ScrH() )
	client.Faction_intro.StartTime = CurTime() + 0.2

	local name_string_table = string.Explode( "", client.Faction_intro.Name, true )
	local status_string_table = string.Explode( "", client.Faction_intro.Status, true )
	local time_string_table = string.Explode( "", client.Faction_intro.Time )

	local actual_string_1, actual_string_2, actual_string_3 = "", "", ""

	local screenmiddle_w, screenmiddle_h = ScrW() / 2, ScrH() / 2

	client.Faction_intro.Paint = function( self, w, h )

		draw.RoundedBox( 0, 0, 0, w, h, color_black )

		if ( ( self.StartTime ) < CurTime() ) then

			surface.SetDrawColor( color_white )
			surface.SetMaterial( TeamIcons[ TEAM_GRU ].mat )
			surface.DrawTexturedRect( screenmiddle_w - 128, screenmiddle_h - 128, 256, 256 )

		end

		if ( self.StartTime < CurTime() - 2) then

			if ( !self.alpha_variable ) then

				self.alpha_variable = 255

			end

			self.alpha_variable = math.Approach( self.alpha_variable, 0, RealFrameTime() * 512 )
			if self.alpha_variable != 255 and self.DescPlayed != true then
				self.DescPlayed = true
				DrawNewRoleDesc()
				net.Start("ProceedUnfreezeSUP")
				net.SendToServer()
			end
			self:SetAlpha( self.alpha_variable )

		end

	end

end

local ci_icon = Material( "nextoren/gui/roles_icon/chaos.png" )
local ranktable = {

	[ "CI Commander" ] = "CI Commander.",
	[ "CI Demoman" ] = "CI Demoman.",
	[ "CI Soldier" ] = "CI Soldier.",
	[ "CI Juggernaut" ] = "CI Juggernaut."

}

function CutScene()
	if GetGlobalBool("NoCutScenes", false) then return end

	APC_spawn_CI_Cutscene()

	local client = LocalPlayer()
	client:ConCommand( "stopsound" )

	BREACH.Music:Play( BR_MUSIC_SPAWN_CHAOS )

	local rank = ranktable[ client:GetRoleName() ]
	if rank == nil then
		rank = "ERROR"
	end

	local screenwidth, screenheight = ScrW(), ScrH()

	local CutSceneWindow = vgui.Create( "DPanel" )
	CutSceneWindow:SetText( "" )
	CutSceneWindow:SetSize( screenwidth, screenheight )
	CutSceneWindow.StartAlpha = 255
	CutSceneWindow.StartTime = CurTime() + 16
	CutSceneWindow.Name = rank .." " .. client:GetNamesurvivor()

	CutSceneWindow.Target = "护送D级人员疏散"
	CutSceneWindow.Time = string.ToMinutesSeconds( GetRoundTime() - cltime ) .. " 时间后"

	local ExplodedString = string.Explode( "", CutSceneWindow.Target, true )
	local ExplodedString2 = string.Explode( "", CutSceneWindow.Name, true )
	local ExplodedString3 = string.Explode( "", CutSceneWindow.Time, true )

	local str = ""
	local str1 = ""
	local str2 = ""

	local count = 0
	local count1 = 0
	local count2 = 0

	CutSceneWindow.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, ColorAlpha( color_black, self.StartAlpha ) )

		surface.SetDrawColor( ColorAlpha( color_white, self.StartAlpha ) )
		surface.SetMaterial( ci_icon )
		surface.DrawTexturedRect( screenwidth / 2 - 128, screenheight / 2 - 128, 256, 256 )

		if ( CutSceneWindow.StartTime <= CurTime() + 15 ) then

			if ( CutSceneWindow.StartTime <= CurTime() + 8 ) then

				self.StartAlpha = math.Approach( self.StartAlpha, 0, RealFrameTime() * 128 )

				if self.StartAlpha != 255 and self.DescPlayed != true then
					self.DescPlayed = true
					DrawNewRoleDesc()
				end

			end

			local n_systime = SysTime()

			if ( ( self.NextSymbol || 0 ) <= n_systime && count2 != #ExplodedString3 ) then

				count2 = count2 + 1
				self.NextSymbol = n_systime + .02
				str = str..ExplodedString3[ count2 ]

			elseif ( ( self.NextSymbol || 0 ) <= n_systime && count2 == #ExplodedString3 && count1 != #ExplodedString2 ) then

				count1 = count1 + 1
				self.NextSymbol = n_systime + .02
				str1 = str1..ExplodedString2[ count1 ]

			elseif ( ( self.NextSymbolTime || 0 ) <= n_systime && count2 == #ExplodedString3 && count1 == #ExplodedString2 && count != #ExplodedString ) then

				count = count + 1
				self.NextSymbol = n_systime + .02
				str2 = str2..ExplodedString[ count ]

			end

			draw.SimpleTextOutlined( str, "TimeMisterFreeman", w / 2, h / 2, ColorAlpha( clr_green, self.StartAlpha ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, ColorAlpha( clr_green, self.StartAlpha ) )
			draw.SimpleTextOutlined( str1, "TimeMisterFreeman", w / 2, h / 2 + 32, ColorAlpha( clr_green, self.StartAlpha ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, ColorAlpha( clr_green, self.StartAlpha ) )
			draw.SimpleTextOutlined( str2, "TimeMisterFreeman", w / 2, h / 2 + 64, ColorAlpha( clr_green, self.StartAlpha ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, ColorAlpha( clr_green, self.StartAlpha ) )

		end

		if ( self.StartAlpha <= 0 ) then

			FadeMusic( 10 )

			timer.Simple( 12, function()

				client.NoMusic = nil

			end )
			self:Remove()

		end

	end

end

local ci_icon = Material( "nextoren/gui/roles_icon/gru.png" )
local client = LocalPlayer()
local timer_Simple = timer.Simple
local surface_PlaySound = surface.PlaySound
local vgui_Create = vgui.Create
local utf8_explode = utf8.Explode
local draw_RoundedBox = draw.RoundedBox
local surface_SetDrawColor = surface.SetDrawColor
local math_Clamp = math.Clamp
local surface_SetMaterial = surface.SetMaterial
local surface_DrawTexturedRect = surface.DrawTexturedRect
local math_Approach = math.Approach
local net_Start = net.Start
local net_SendToServer = net.SendToServer
local timer_Remove = timer.Remove
local timer_Create = timer.Create
local hook_Remove = hook.Remove
local util_ScreenShake = util.ScreenShake
local math_min = math.min
local string_ToMinutesSeconds = string.ToMinutesSeconds
local GetPrepTime = GetPrepTime
local surface_SetFont = surface.SetFont
local surface_GetTextSize = surface.GetTextSize
local draw_DrawText = draw.DrawText
local os_date = os.date
local system_HasFocus = system.HasFocus
local system_FlashWindow = system.FlashWindow
local ents_CreateClientside = ents.CreateClientside
local draw_SimpleTextOutlined = draw.SimpleTextOutlined
local ranktable = {

	[ "GRU Commander" ] = "Капитан",
	[ "GRU Specialist" ] = "Прапорщик",
	[ "GRU Soldier" ] = "Сержант",
	[ "GRU Juggernaut" ] = "Лейтенант"

}

local heliStart = function(heliModel, heliPos, heliAngle)
    local heliEnt = ents_CreateClientside("base_gmodentity")
    heliEnt:SetModel(heliModel)
    heliEnt:SetPos(heliPos)
    heliEnt:SetAngles(heliAngle)

    heliEnt:Spawn()
    heliEnt:Activate()

    return heliEnt
end

local string_len = utf8.len
local string_sub = utf8.sub
local string_find = string.find

function utf8.StringToTable( str )

  local tbl = {}

  for i = 1, string_len( str ) do

    tbl[ i ] = string_sub( str, i, i )

  end

  return tbl

end

local totable = utf8.StringToTable

function utf8.Explode( separator, str, withpattern )

  if ( separator == "" ) then return totable( str ) end
  if ( withpattern == nil ) then withpattern = false end

  local ret = {}
  local current_pos = 1

  for i = 1, string_len( str ) do

    local start_pos, end_pos = string_find( str, separator, current_pos, !withpattern )

    if ( !start_pos ) then break end

    ret[ i ] = string_sub( str, current_pos, start_pos - 1 )
    current_pos = end_pos + 1

  end

  ret[ #ret + 1 ] = string_sub( str, current_pos )

  return ret

end

function GRUCutscene()
	local client = LocalPlayer()
    client:ConCommand("stopsound")
	timer_Simple(1, function()
	surface.PlaySound( "nextoren/new_gru_2.wav" )
	end)
    client.NoAutoMusic = true
    client.cantSeeNames = true

    --task.Create("GRUMusic", function() BREACH.Music:Play(BR_MUSIC_SPAWN_GRU) end)

    local rank = ranktable[client:GetRoleName()] or "ERROR"
    local sw, sh = ScrW(), ScrH()
    local midW, midH = sw * 0.5, sh * 0.5

    local panel = vgui_Create("EditablePanel")
    panel:SetSize(sw, sh)
    panel.StartAlpha = 255
    panel.StartTime = CurTime() + 12
    panel.Name = rank .. " " .. client:GetNamesurvivor() 
    panel.Time = string_ToMinutesSeconds(GetRoundTime() - cltime) .. " времени после Н.У.С"

    local tblName = utf8.Explode("", panel.Name, true)
    local tblTime = utf8.Explode("", panel.Time, true)
    local sName, sTime = "", "", ""
    local iName, iTime = 0, 0, 0

    panel.Paint = function(self, w, h)
        draw_RoundedBox(0, 0, 0, w, h, ColorAlpha(color_black, self.StartAlpha))

        surface_SetDrawColor(255, 255, 255, self.StartAlpha)
        surface_SetMaterial(Material("nextoren/gui/roles_icon/gru.png", "smooth"))
        surface_DrawTexturedRect(midW - OGRX.ScaleW(128), midH - OGRX.ScaleH(128), OGRX.ScaleW(256), OGRX.ScaleH(256))

        if CurTime() >= self.StartTime - 7 then
            if CurTime() >= self.StartTime then
                self.StartAlpha = math_Approach(self.StartAlpha, 0, RealFrameTime() * 128)
                if self.StartAlpha < 255 and not self.DescPlayed then
                    self.DescPlayed = true
                    DrawNewRoleDesc()
                end
            end

            local now = SysTime()
            if (self.NextSymbol or 0) <= now then
                if iTime < #tblTime then
                    iTime = iTime + 1
                    sTime = sTime .. tblTime[iTime]
                elseif iName < #tblName then
                    iName = iName + 1
                    sName = sName .. tblName[iName]
                end

                self.NextSymbol = now + 0.08
            end

            draw_SimpleTextOutlined(sTime, "MainMenuFont", midW, midH, ColorAlpha(Color(255, 0, 0), self.StartAlpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, ColorAlpha(color_black, self.StartAlpha))
            draw_SimpleTextOutlined(sName, "MainMenuFont", midW, midH + OGRX.ScaleH(32), ColorAlpha(Color(255, 0, 0), self.StartAlpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, ColorAlpha(color_black, self.StartAlpha))
        end

        if self.StartAlpha <= 0 then
            timer_Simple(12, function()
                if IsValid(client) then
                    client.NoAutoMusic = nil
                    client.cantSeeNames = nil
                    StopMusic(8)
                end
            end)

            self:Remove()
        end
    end

    local dlight = DynamicLight(client:EntIndex())
    if dlight then
        dlight.pos = Vector(14883.383789, 13000.545898, -15600.162109)
        dlight.r = 190
        dlight.g = 0
        dlight.b = 0
        dlight.brightness = 2.1
        dlight.Size = 900
        dlight.DieTime = CurTime() + 60
    end

    local heli = heliStart("models/ogrx/props/gru_heli/mil_mi-8_hip.mdl", Vector(-9378.6865234375, -2875.1049804688, 3494.4575195313), Angle(4, -92, 0))
    timer_Simple(10, function()
        if not IsValid(heli) or not IsValid(client) then return end
        local hoverSound = CreateSound(heli, "nextoren/others/helicopter/helicopter_propeller.wav")
        hoverSound:Play()
        timer_Simple(10, function()
            if not IsValid(heli) or not IsValid(client) then return end
            hoverSound:ChangeVolume(0, 1.5)
            timer_Simple(6, function()
                hoverSound:Stop()
                heli:Remove()
            end)
        end)
    end)

    client.Faction_intro = panel
end
--concommand.Add( "GRUTestCut", GRUCutscene )


local function Ending( status )

	if ( status == "Evacuated by CI" ) then
		status = "l:cutscene_evac_by_ci"
		surface.PlaySound( "nextoren/vo/acp/survivor_escaped_" .. math.random( 1, 3 ) .. ".wav" )

	elseif ( status == "Evacuated by Helicopter" ) then
		status = "l:cutscene_evac_by_heli"
		surface.PlaySound( "nextoren/vo/chopper/chopper_evacuate_evacuated.wav" )

	end

	timer.Simple( 1, function()

		BREACH.Music:Play(BR_MUSIC_ESCAPED)

	end )

	local name



	name = LocalPlayer():GetNamesurvivor() 

	local CutSceneWindow = vgui.Create( "DPanel" )
	CutSceneWindow:SetText( "" )
	CutSceneWindow:SetSize( ScrW(), ScrH() )
	CutSceneWindow.StartAlpha = 255
	CutSceneWindow.StartTime = CurTime() + 15
	CutSceneWindow.Name = BREACH.TranslateString"l:cutscene_subject_name " .. name
	CutSceneWindow.Status = BREACH.TranslateString"l:cutscene_status " .. BREACH.TranslateString(status)
	CutSceneWindow.Time = BREACH.TranslateString"l:cutscene_last_report_time " .. tostring( os.date( "%X" ) ) .. " " .. tostring( os.date( "%d/%m/%Y" ) ) .. BREACH.TranslateString" ( l:cutscene_time_after_disaster_for_last_report_time " .. string.ToMinutesSeconds( cltime ) .. " )"

	local ExplodedString = string.Explode( "", CutSceneWindow.Time, true )
	local ExplodedString2 = string.Explode( "", CutSceneWindow.Status, true )
	local ExplodedString3 = string.Explode( "", CutSceneWindow.Name, true )

	local str = ""
	local str1 = ""
	local str2 = ""

	local count = 0
	local count1 = 0
	local count2 = 0

	CutSceneWindow.Paint = function( self, w, h )

		draw.RoundedBox( 0, 0, 0, w, h, ColorAlpha( color_black, self.StartAlpha ) )

		if ( CutSceneWindow.StartTime <= CurTime() + 13 ) then

			if ( CutSceneWindow.StartTime <= CurTime() ) then

				self.StartAlpha = math.Approach( self.StartAlpha, 0, RealFrameTime() * 80 )

				if ( self.StartAlpha <= 0 ) then

					FadeMusic( 10 )
					self:Remove()

				end

			end

			if ( ( self.NextSymbol || 0 ) <= SysTime() && count2 != #ExplodedString3 ) then

				count2 = count2 + 1
				self.NextSymbol = SysTime() + .1
				str = str .. ExplodedString3[ count2 ]

			elseif ( ( self.NextSymbol || 0 ) <= SysTime() && count2 == #ExplodedString3 && count1 != #ExplodedString2 ) then

				count1 = count1 + 1
				self.NextSymbol = SysTime() + .1
				str1 = str1 .. ExplodedString2[ count1 ]

			elseif ( ( self.NextSymbol || 0 ) <= SysTime() && count2 == #ExplodedString3 && count1 == #ExplodedString2 && count != #ExplodedString ) then

				count = count + 1
				self.NextSymbol = SysTime() + .1
				str2 = str2 .. ExplodedString[ count ]

			end

			draw.SimpleTextOutlined( str, "TimeMisterFreeman", w / 2, h / 2, ColorAlpha( clr_gray, self.StartAlpha ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, ColorAlpha( clr_green, self.StartAlpha ) )
			draw.SimpleTextOutlined( str1, "TimeMisterFreeman", w / 2, h / 2 + 32, ColorAlpha( clr_gray, self.StartAlpha ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, ColorAlpha( clr_green, self.StartAlpha ) )
			draw.SimpleTextOutlined( str2, "TimeMisterFreeman", w / 2, h / 2 + 64, ColorAlpha( clr_gray, self.StartAlpha ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, ColorAlpha( clr_green, self.StartAlpha ) )

		end

	end

end

net.Receive( "Ending_HUD", function()

	local status = net.ReadString()

    local client = LocalPlayer()

	local current_team = client:GTeam()

	if ( current_team != TEAM_USA ) then

		Ending( status )

	else

		if ( status == "l:ending_mission_complete" ) then

			UIU_Ending( true )

		else

			UIU_Ending( false )

		end

	end

end )

local desc_clr_gray = Color( 198, 198, 198 )

local function Show_Spy_Extra( current_team, team_to_draw )

	local spy_table = {}
	local all_players = player.GetAll()

	for i = 1, #all_players do

		local player = all_players[ i ]

		if ( player:GTeam() == team_to_draw && player:GetRoleName():lower():find( "spy" ) ) then

			spy_table[ #spy_table + 1 ] = player

		end

	end

	if ( #spy_table == 0 ) then return end

	local team_clr = gteams.GetColor( team_to_draw )

	hook.Add( "PreDrawOutlines", "ShowSpyExtra", function()

		local client = LocalPlayer()
		if ( client:Health() <= 0 || client:GTeam() != current_team ) then

			hook.Remove( "PreDrawOutlines", "ShowSpyExtra" )
			return
		end

		local draw_ent = {}

		for _, v in ipairs( spy_table ) do

			if ( ( v && v:IsValid() ) && v:Health() > 0 && v:GTeam() == team_to_draw ) then

				draw_ent[ #draw_ent + 1 ] = v

			else

				table.RemoveByValue( spy_table, v )

			end

		end

		if ( #draw_ent > 0 ) then

			outline.Add( draw_ent, team_clr, 2 )

		end

	end )

end

local target_outline = Color(255,0,0)
hook.Add( "PreDrawOutlines", "UIU_SPY_TARGETS", function()
	local client = LocalPlayer()
	if client:GetRoleName() != role.SCI_SpyUSA then return end
	local plys = player.GetAll()
	local draw_ent = {}
	local mypos = client:GetPos()
	for i = 1, #plys do
		local ply = plys[i]
		if ply:HasWeapon("item_special_document") and ply:GetPos():DistToSqr(mypos) <= 120000 then
			draw_ent[#draw_ent + 1] = ply

			local bnmrgs = ply:LookupBonemerges()

			for i = 1, #bnmrgs do
				local bn = bnmrgs[i]
				if bn and bn:IsValid() then
					draw_ent[ #draw_ent + 1 ] = bn
				end
			end
		end
	end

	local rgdols = ents.FindByClass('prop_ragdoll')
	for i = 1, #rgdols do
		local rgdol = rgdols[i]
		if rgdol:GetNWBool("HasDocument") and rgdol:GetPos():DistToSqr(mypos) <= 120000 then
			draw_ent[#draw_ent + 1] = rgdol

		end
	end
	if ( #draw_ent > 0 ) then

			outline.Add( draw_ent, target_outline, 2 )

		end
end)

function Show_Spy( current_team )

	--if hook.Exists("PreDrawOutlines", "ShowSpy") then return end

	--print("check", current_team == TEAM_GOC)

	local spy_table = {}
	local all_players = player.GetAll()

	local client = LocalPlayer()

	local client_Team = LocalPlayer():GTeam()

	for i = 1, #all_players do

		local player = all_players[ i ]

		if ( player:GTeam() == current_team && player:GetRoleName():lower():find( "spy" ) && player != client ) then

			spy_table[ #spy_table + 1 ] = player

		end
		--print(client_Team)
		if client_Team == TEAM_CLASSD or client_Team == TEAM_CHAOS then
			--print(client_Team)
			if ( player:GetRoleName():find( "Stealthy" ) ) then

				spy_table[ #spy_table + 1 ] = player

			end

		end

	end

	local old_name_surv = LocalPlayer():GetNamesurvivor()
	local team_clr = color_white
	if current_team != TEAM_CHAOS then
		local team_clr = gteams.GetColor( current_team )
	end

	if team_clr == color_black then team_clr = color_white end

	hook.Add( "PreDrawOutlines", "ShowSpy", function()

		if ( client:Health() <= 0 || client:GTeam() != client_Team ) then

			hook.Remove( "PreDrawOutlines", "ShowSpy" )
			return
		end

		local draw_ent = {}

		for _, v in ipairs( spy_table ) do
			
			if ( ( v && v:IsValid() ) && v:Health() > 0 && ( ( v:GTeam() == current_team ) or (v:GetRoleName() == "Class-D Stealthy" and ( LocalPlayer():GTeam() == TEAM_CLASSD or LocalPlayer():GTeam() == TEAM_CHAOS ) ) ) ) then

				draw_ent[ #draw_ent + 1 ] = v

			else

				table.RemoveByValue( spy_table, v )

			end

		end

		if ( #draw_ent > 0 ) then

			outline.Add( draw_ent, team_clr, 2 )

		end

	end )

end

function EndRoundStats()

	local result = net.ReadString()

	local t_restart = net.ReadFloat()

	local client = LocalPlayer()

	local screenwidth, screenheight = ScrW(), ScrH()

	local general_panel = vgui.Create( "DPanel" )
	general_panel:SetText( "" )
	general_panel:SetSize( screenwidth, screenheight )
	general_panel:SetAlpha( 1 )
	general_panel.StartTime = RealTime()
	general_panel.StartFade = false
	timer.Simple( ( t_restart || 27 ) + 1, function()

		if ( general_panel && general_panel:IsValid() ) then

			general_panel.StartFade = true

		end

	end )

	general_panel.Paint = function( self, w, h )

		if ( self:GetAlpha() < 255 && general_panel.StartTime < RealTime() - .25 && !general_panel.StartFade ) then

			self:SetAlpha( math.Approach( self:GetAlpha(), 255, FrameTime() * 512 ) )

		elseif ( self:GetAlpha() > 0 && general_panel.StartTime < RealTime() - 20 && general_panel.StartFade ) then

			self:SetAlpha( math.Approach( self:GetAlpha(), 0, FrameTime() * 512 ) )

			if ( self:GetAlpha() == 0 && ( self && self:IsValid() ) ) then

				self:Remove()

			end

		end

	end
	local stats_panel = vgui.Create( "DPanel", general_panel )
	stats_panel:SetPos( screenwidth / 2.7, screenheight * .1 )
	stats_panel:SetSize( screenwidth / 4, screenheight / 3 )
	stats_panel:SetText( "" )
	stats_panel.NextSymbol = RealTime()

	local deathstr = false



	local counter = 0
	local counter2 = 0
	local str1 = "Hello"
	local str2 = "Pe0ple"

	local time;

	stats_panel.Paint = function( self, w, h )

		draw.RoundedBox( 0, 0, 0, w, h, ColorAlpha( color_black, math.Clamp( self:GetAlpha(), 0, 210 ) ) )
		draw.OutlinedBox( 0, 0, w, h, 2, ColorAlpha( desc_clr_gray, 190 ) )

		draw.SimpleText( "Round complete", "MainMenuFontmini", w / 2, 24, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

		draw.SimpleText( "Round result: " .. result, "MainMenuFont", w / 2, 64, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

		time = CurTime() + 18

		time2 = tostring(string.ToMinutesSeconds( cltime ) )


		draw.SimpleText( "Next round in  " .. time2, "MainMenuFontmini", w / 2, h * .7, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )



		if ( self.NextSymbol <= RealTime() ) then

			self.NextSymbol = RealTime() + .1
			counter = counter + 1

		elseif ( self.NextSymbol <= RealTime() ) then

			self.NextSymbol = RealTime() + .1
			counter2 = counter2 + 1

		end

		surface.SetDrawColor( color_white )
		surface.DrawLine( 0, 48, w, 48 )
		surface.DrawLine( 0, 49, w, 49 )

		draw.SimpleTextOutlined( str1, "MainMenuFontmini", 15, h * .3 + 30, ColorAlpha( color_white, 180 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT, 1.5, ColorAlpha( color_black, 180 ) )
		draw.SimpleTextOutlined( str2, "MainMenuFontmini", 15, h * .3 + 60, ColorAlpha( color_white, 180 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT, 1.5, ColorAlpha( color_black, 180 ) )

	end

end
net.Receive( "EndRoundStats", EndRoundStats )

local desc_clr = Color( 169, 169, 169 )
local desc_clr_gray = Color( 198, 198, 198 )

local mply = FindMetaTable( "Player" )

local clrgray = Color(198, 198, 198)
local clrgray2 = Color(180, 180, 180)
local clrred = Color(255, 0, 0)
local clrred2 = Color(198, 0, 0)

local mvpAnims = {}

function CreateMVPMenu(tab, first)
    if IsValid(MVP_MENU) then MVP_MENU:Remove() end

    MVP_MENU = vgui.Create("DPanel")
    local g = MVP_MENU

    g:SetSize(365, 447)
    g:SetPos(75, 0)
    g:CenterVertical(0.5)

    local x, y = g:GetPos()

    mvpAnims = {
        panel = {
            alpha = 0,
            xPos = first and -365 or x,
            scale = 0.8,
            targetX = x
        },
        title = {
            alpha = 0,
            yOffset = -20
        },
        timer = {
            alpha = 0,
            scale = 0
        },
        players = {},
        closeTime = CurTime() + 5
    }

    for i = 1, #tab.plys do
        mvpAnims.players[i] = {
            alpha = 0,
            xOffset = -50,
            delay = 0.2 + (i * 0.1)
        }
    end

    g.CreationTime = CurTime()

    g.Think = function(self)
        local currentTime = CurTime()
        local elapsed = currentTime - self.CreationTime
        
        if first then
            mvpAnims.panel.xPos = Lerp(FrameTime() * 6, mvpAnims.panel.xPos, mvpAnims.panel.targetX)
        end
        mvpAnims.panel.alpha = Lerp(FrameTime() * 8, mvpAnims.panel.alpha, 1)
        mvpAnims.panel.scale = Lerp(FrameTime() * 10, mvpAnims.panel.scale, 1)
        
        self:SetPos(mvpAnims.panel.xPos, y)
        self:SetAlpha(mvpAnims.panel.alpha * 255)

        if elapsed > 0.1 then
            mvpAnims.title.alpha = Lerp(FrameTime() * 6, mvpAnims.title.alpha, 1)
            mvpAnims.title.yOffset = Lerp(FrameTime() * 8, mvpAnims.title.yOffset, 0)
        end
        
        if elapsed > 0.3 then
            mvpAnims.timer.alpha = Lerp(FrameTime() * 6, mvpAnims.timer.alpha, 1)
            mvpAnims.timer.scale = Lerp(FrameTime() * 12, mvpAnims.timer.scale, 1)
        end
        
        for i = 1, #tab.plys do
            local playerAnim = mvpAnims.players[i]
            if elapsed > playerAnim.delay then
                playerAnim.alpha = Lerp(FrameTime() * 8, playerAnim.alpha, 1)
                playerAnim.xOffset = Lerp(FrameTime() * 10, playerAnim.xOffset, 0)
            end
        end

        local timeLeft = mvpAnims.closeTime - currentTime
        
        if timeLeft <= 0 then
            self:Remove()
        end
    end

    local dr = draw.RoundedBox
    local clr_gray = Color(27, 27, 27, 215)
    local clr_white = color_white
    local title = L(tab.title)

    g.Paint = function(self, w, h)
        local currentAlpha = mvpAnims.panel.alpha
        local currentScale = mvpAnims.panel.scale
        
        local scaledW = w * currentScale
        local scaledH = h * currentScale
        local offsetX = (w - scaledW) / 2
        local offsetY = (h - scaledH) / 2

        draw.RoundedBox(0, offsetX, offsetY, scaledW, scaledH, Color(20, 20, 20, 240 * currentAlpha))
        
        draw.RoundedBox(0, offsetX + 3, offsetY + 3, scaledW, scaledH, Color(0, 0, 0, 80 * currentAlpha))
        
        draw.RoundedBox(0, offsetX, offsetY, scaledW, 125, Color(40, 40, 40, 255 * currentAlpha))
        
        surface.SetDrawColor(255, 255, 255, 150 * currentAlpha)
        surface.DrawLine(offsetX, offsetY + 125, offsetX + scaledW, offsetY + 125)

        surface.SetDrawColor(255, 255, 255, 100 * currentAlpha)
        surface.DrawOutlinedRect(offsetX, offsetY, scaledW, scaledH)

        drawMultiLine(
            title, 
            "MVP_Font", 
            w/2, 
            15 + mvpAnims.title.yOffset, 
            w/2, 
            15, 
            Color(255, 255, 255, 255 * mvpAnims.title.alpha * currentAlpha), 
            TEXT_ALIGN_CENTER, 
            TEXT_ALIGN_CENTER, 
            1, 
            Color(0, 0, 0, 150 * mvpAnims.title.alpha * currentAlpha)
        )

        local timeLeft = mvpAnims.closeTime - CurTime()
        local timerText = math.Round(math.max(0, timeLeft), 1)
        local timerAlpha = mvpAnims.timer.alpha * currentAlpha
        
        draw.DrawText(
            timerText, 
            "MVP_Font", 
            w-10, 
            100, 
            Color(255, 255, 255, 255 * timerAlpha), 
            TEXT_ALIGN_RIGHT
        )
        
        if timeLeft < 3 and timeLeft > 0 then
            local pulse = math.sin(CurTime() * 8) * 0.3 + 0.7
            draw.DrawText(
                timerText, 
                "MVP_Font", 
                w-10, 
                100, 
                Color(255, 100, 100, 255 * timerAlpha * pulse), 
                TEXT_ALIGN_RIGHT
            )
        end
    end

    local plylist = vgui.Create("DListLayout", MVP_MENU)
    g.PlayersList = plylist
    plylist:SetSize(365, 320)
    plylist:SetPos(0, 127)
    plylist:SetAlpha(0)

    plylist.Think = function(self)
        self:SetAlpha(mvpAnims.panel.alpha * 255)
    end

    for i = 1, #tab.plys do
        local ply = tab.plys[i]
        local playerAnim = mvpAnims.players[i]

        local base = vgui.Create("DPanel", plylist)
        base:Dock(TOP)
        base:DockMargin(3, 3, 3, 3)
        base:SetSize(322, 30)
        base:SetAlpha(0)

        base.Think = function(self)
            self:SetAlpha(playerAnim.alpha * 255)
        end

        base.Paint = function(self, w, h)
            local playerAlpha = playerAnim.alpha
            local xOffset = playerAnim.xOffset
            
            draw.RoundedBox(0, xOffset, 0, w, h, Color(50, 50, 50, 200 * playerAlpha))
            
            if i <= 3 then
                local placeColors = {
                    Color(255, 215, 0, 80 * playerAlpha),   
                    Color(192, 192, 192, 80 * playerAlpha), 
                    Color(205, 127, 50, 80 * playerAlpha)   
                }
                draw.RoundedBox(0, xOffset, 0, w, h, placeColors[i])
            end

            surface.SetDrawColor(255, 255, 255, 50 * playerAlpha)
            surface.DrawOutlinedRect(xOffset, 0, w, h)


            draw.DrawText(
                i..":", 
                "MVP_Font", 
                5 + xOffset, 
                4, 
                Color(255, 255, 255, 255 * playerAlpha)
            )

            draw.DrawText(
                ply.name, 
                "MVP_Font", 
                50 + xOffset, 
                4, 
                Color(255, 255, 255, 255 * playerAlpha)
            )

            draw.DrawText(
                ply.value, 
                "MVP_Font", 
                w-5 + xOffset, 
                0, 
                Color(255, 255, 255, 255 * playerAlpha), 
                TEXT_ALIGN_RIGHT
            )
        end

        local plyavatar = vgui.Create("AvatarImage", base)
        plyavatar:SetSize(30, 30)
        plyavatar:SetPos(15 + playerAnim.xOffset, 0)
        plyavatar:SetSteamID(ply.id, 32)
        
        plyavatar.Think = function(self)
            local targetX = 15
            self:SetPos(targetX + playerAnim.xOffset, 0)
        end
    end

    timer.Simple(0.5, function()
        if IsValid(g) then
            g.ShakeTime = CurTime()
            g.OriginalX = mvpAnims.panel.targetX
            
            local oldThink = g.Think
            g.Think = function(self)
                oldThink(self)
                
                if self.ShakeTime and CurTime() - self.ShakeTime < 0.2 then
                    local shake = math.sin(CurTime() * 40) * 1 * (0.2 - (CurTime() - self.ShakeTime))
                    local currentX = mvpAnims.panel.xPos
                    self:SetPos(currentX + shake, y)
                end
            end
        end
    end)
end

net.Receive("MVPMenu", function(len)
    local data = net.ReadTable()
    CreateMVPMenu(data)
end)

surface.CreateFont( "HUDFontHead", {

    font = "Bauhaus",

	size = 36,

	weight = 100,

	blursize = 0,

	scanlines = 0,

	antialias = true,

	underline = false,

	italic = false,

	strikeout = false,

	symbol = false,

	rotary = false,

	shadow = false,

	additive = false,

	outline = false,

})


local LVLColorMax = Color( 220, 20, 60 )

local BrHeadIcons = {

  [ TEAM_CHAOS ] = Material( "nextoren_hud/faction_icons/chaosiconforhudspec.png" ),
  [ TEAM_GOC ] = Material( "nextoren_hud/faction_icons/gociconforhud.png" ),
  [ TEAM_DZ ] = Material( "nextoren_hud/faction_icons/dziconforhudspec.png" ),
  [ TEAM_NTF ] = Material( "nextoren_hud/faction_icons/ntfspec.png" ),
  [ TEAM_USA ] = Material( "nextoren_hud/faction_icons/fbispec.png" ),
  [ TEAM_COTSK ] = Material( "nextoren_hud/faction_icons/scarletspec.png" ),
  [ TEAM_GRU ] = Material( "nextoren_hud/faction_icons/gruspec.png" ),
  [ 1313 ] = Material( "nextoren_hud/faction_icons/fbi_agentspec.png" ),

}

--timer.Simple( .25, function()
  local Health    = "l:hud_health"
  local Level     = "l:scoreboard_level"
  local HighLevel = "l:hud_max_level"
  local offset    = Vector( 0, 0, 85 )
  local microphone_icon = Material( "nextoren_hud/microphone.png" )

  local getpixhandle = util.GetPixelVisibleHandle
  local pixvisible = util.PixelVisible

  local plTable = {}
  local plTableNextUpdate = 0

  function DrawNameSpectator()

    local client = LocalPlayer()

    if ( client:GTeam() != TEAM_SPEC ) then return end
    if GetConVar("breach_config_screenshot_mode"):GetInt() == 1 then return end

    if ( ( plTableNextUpdate || 0 ) < CurTime() ) then

      plTable = GetActivePlayers()
      plTableNextUpdate = CurTime() + .8

    end

    for i = 1, #plTable do

      local ply = plTable[ i ]

      if ( !( ply && ply:IsValid() ) ) then continue end

      if ply:GetNoDraw() or ply:IsDormant() then continue end

      local plytable = ply:GetTable()
	  
	  if !plytable["pixhandle"] then
		plytable["pixhandle"] = getpixhandle()
	  end
	  
	  local Visible = util.PixelVisible(ply:GetPos(), 64, plytable.pixhandle)

	  if ( !Visible || Visible < 0.1 ) then continue end

      if ( client:GetPos():DistToSqr( ply:GetPos() ) < 65536 ) then

        local player_team = ply:GTeam()

        if ( player_team == TEAM_SPEC || ply:Health() <= 0 ) then continue end
        if ( client:GetObserverTarget() == ply ) then continue end

        local pos = ply:GetPos()
        pos:Add( offset )

        local color = gteams.GetColor( player_team )

        local ang  = client:EyeAngles()
        ang:RotateAroundAxis( ang:Forward(), 90 )
        ang:RotateAroundAxis( ang:Right(), 90 )

        local Mat

        if ( BrHeadIcons[ player_team ] ) then

        	if BREACH:IsUiuAgent(ply:GetRoleName()) then

	          Mat = BrHeadIcons[ 1313 ]

            else

	          Mat = BrHeadIcons[ player_team ]

	        end

        end

        local plcolor = color
        local lvl = ply:GetNLevel()

        local surv_name = ply:GetNamesurvivor()
        local name = ply:Name()

        cam.Start3D2D( pos, ang, .1 )

          draw.SimpleText( L(Health) .. ": " .. ply:Health() .. " / " .. ply:GetMaxHealth(), "new_spec_2", 1, -30, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

          if ( surv_name != "none" ) then

            draw.SimpleText( name .. " (" .. surv_name .. ")", "new_spec_2", 0, 2, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
            draw.SimpleText( name .. " (" .. surv_name .. ")", "new_spec_2", 1, 0, plcolor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

          else

            draw.SimpleText( name, "new_spec_2", 0, 2, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
            draw.SimpleText( name, "new_spec_2", 1, 0, plcolor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

          end

          if ( lvl < 55 ) then

            draw.SimpleText( L(Level) .. " " .. lvl, "new_spec_2", 1, 30, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

          else

            draw.SimpleText( L(Level) .. ": " .. lvl, "new_spec_2", 1, 30, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER  )
            draw.SimpleText( "★ " .. L(HighLevel), "new_spec_2", 1, -60, LVLColorMax, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

          end

          local offset = -150

          if ( Mat ) then

            surface.SetDrawColor( color_white )
            surface.SetMaterial( Mat )
            surface.DrawTexturedRect( -28, -150, 64, 64 );

            offset = offset - 70

          end

          if ( ply:IsSpeaking() ) then

            surface.SetDrawColor( color_white )
            surface.SetMaterial( microphone_icon )
            surface.DrawTexturedRect( -28, offset, 64, 64 )

          end

        cam.End3D2D()

      end

    end

  end

  hook.Add( "PostDrawTranslucentRenderables", "DrawNames", DrawNameSpectator )

--end )


local ply = LocalPlayer()


function OpenAdminLogHistory(data)

	data = {
		{"ban", "5120512959", "2141251251", os.time() - 1000, 1250},
		{"ban", "5120512959", "2141251251", os.time() - 525, 1250},
		{"ban", "5120512959", "2141251251", os.time() - 61, 1250},
		{"ban", "5120512959", "2141251251", os.time() - 283, 1250},
		{"ban", "5120512959", "2141251251", os.time() - 43, 1250},
	}

	if IsValid(BREACH.AdminLogUI) then BREACH.AdminLogUI:Remove() end

	local scrw, scrh = ScrW(), ScrH()

	BREACH.AdminLogUI = vgui.Create("DFrame")
	BREACH.AdminLogUI:SetSize(scrw, scrh)

	BREACH.AdminLogUI.Think = function(self)
		gui.EnableScreenClicker(true)
	end

	BREACH.AdminLogUI.OnRemove = function(self)
		gui.EnableScreenClicker(false)
	end

	local list = vgui.Create("DListView", BREACH.AdminLogUI)
	list:Dock(FILL)

	list:AddColumn( "type" )
	list:AddColumn( "admin" )
	list:AddColumn( "victim" )
	list:AddColumn( "time" )
	list:AddColumn( "length" )

	for _, tab in pairs(data) do

		list:AddLine(tab[1], tab[2], tab[3], os.date("%H:%M:%S - %d/%m/%Y", tab[4]), string.NiceTime(tab[5]))

	end


end

local no_desc = CreateConVar("breach_config_no_role_description", 0, FCVAR_ARCHIVE, "Disables role description", 0, 1)

function DrawNewRoleDesc(str)
	local client = LocalPlayer()

	if !client:Alive() then return end
	if client:GTeam() == TEAM_SPEC then return end
	if client:Health() <= 0 then return end
	if no_desc:GetBool() then return end
	if (client.NoDesc) then return end

	timer.Remove("Remove_Desc")

	if IsValid(BREACH_DESC_LOGO) then BREACH_DESC_LOGO:Remove() end
	if IsValid(BREACH_DESC_PANEL) then BREACH_DESC_PANEL:Remove() end

	local mat = GetRoleIconByTeam(client:GTeam(), client:GetRoleName())
	local desc = BREACH.GetDescription(client:GetRoleName())

	-- Создаем основную панель
	BREACH_DESC_PANEL = vgui.Create("DPanel")
	BREACH_DESC_PANEL:SetAlpha(0)
	
	-- Создаем элементы
	local label = vgui.Create("DLabel", BREACH_DESC_PANEL)
	label:SetText(desc)
	label:SetFont("ChatFont_new")
	label:SetTextColor(color_White)
	label:SetWrap(true)
	
	local charname = vgui.Create("DLabel", BREACH_DESC_PANEL)
	charname:SetFont("ScoreboardHeader")
	local teamcol = gteams.GetColor(client:GTeam())
	if client:GTeam() == TEAM_USA then teamcol = color_white end
	charname:SetTextColor(ColorAlpha(teamcol, 235))
	charname:SetText(GetLangRole(client:GetRoleName()))
	
	-- Вычисляем оптимальный размер панели на основе текста
	charname:SizeToContents()
	local title_w, title_h = charname:GetSize()
	
	-- Создаем временный лейбл для вычисления размера текста с переносами
	local tempLabel = vgui.Create("DLabel")
	tempLabel:SetFont("ChatFont_new")
	tempLabel:SetText(desc)
	tempLabel:SetWrap(true)
	
	-- Пробуем разные ширины для оптимального размера текста
	local maxTextWidth = math.min(800, ScrW() * 0.7) -- Максимум 70% ширины экрана
	local minTextWidth = 300 -- Минимальная ширина текста
	
	-- Находим оптимальную ширину текста
	local optimalWidth = minTextWidth
	local bestHeight = 0
	
	for testWidth = minTextWidth, maxTextWidth, 50 do
		tempLabel:SetSize(testWidth, 0)
		tempLabel:SetAutoStretchVertical(true)
		tempLabel:SizeToContents()
		local test_w, test_h = tempLabel:GetSize()
		
		-- Ищем ширину, при которой высота минимальна (оптимальное соотношение)
		if bestHeight == 0 or test_h < bestHeight then
			optimalWidth = testWidth
			bestHeight = test_h
		end
		
		-- Если высота начала расти, значит мы нашли оптимальную ширину
		if test_h > bestHeight then
			break
		end
	end
	
	tempLabel:SetSize(optimalWidth, 0)
	tempLabel:SetAutoStretchVertical(true)
	tempLabel:SizeToContents()
	local text_w, text_h = tempLabel:GetSize()
	tempLabel:Remove()
	
	-- Вычисляем размеры панели
	local panelWidth = math.max(title_w + 50, text_w + 50) -- Ширина по самому широкому элементу + отступы
	local panelHeight = text_h / 32 + 120 -- Высота текста + отступы для заголовка и полей
	
	-- Ограничиваем максимальные размеры чтобы не выходила за экран
	local maxWidth = ScrW() * 0.8 -- Максимум 80% ширины экрана
	local maxHeight = ScrH() * 0.6 -- Максимум 60% высоты экрана
	
	panelWidth = math.min(panelWidth, maxWidth)
	panelHeight = math.min(panelHeight, maxHeight)
	
	-- Минимальные размеры
	panelWidth = math.max(panelWidth, 350)
	panelHeight = math.max(panelHeight, 150)
	
	BREACH_DESC_PANEL:SetSize(panelWidth, panelHeight)
	BREACH_DESC_PANEL:Center()
	BREACH_DESC_PANEL:SetPos(ScrW()/2 - panelWidth/2, ScrH() * 0.22)
	
	-- Позиционируем элементы
	charname:SetPos(panelWidth / 2 - title_w / 2, 15)
	
	label:SetSize(panelWidth - 40, panelHeight - 80)
	label:SetPos(20, 60)

	-- Анимации
	local anims = {
		panelAlpha = 0,
		panelScale = 0.7,
		panelYOffset = 50,
		logoAlpha = 0,
		logoScale = 0.3,
		logoYOffset = -80,
		titleAlpha = 0,
		titleYOffset = -10,
		textAlpha = 0,
		textYOffset = 10,
		fadeOut = 1
	}

	-- Запоминаем финальную позицию логотипа
	local finalLogoPos = {x = 0, y = 0}

	BREACH_DESC_PANEL.CreationTime = CurTime()
	BREACH_DESC_PANEL.CloseTimerSet = false
	BREACH_DESC_PANEL.IsFadingOut = false
	
	BREACH_DESC_PANEL.Think = function(self)
		local currentTime = CurTime()
		local elapsed = currentTime - self.CreationTime
		
		if self.IsFadingOut then
			-- Анимация исчезновения с уменьшением
			anims.fadeOut = Lerp(FrameTime() * 8, anims.fadeOut, 0)
			
			-- Уменьшаем масштаб для эффекта "схлопывания"
			anims.panelScale = Lerp(FrameTime() * 15, anims.panelScale, 0.3)
			anims.panelYOffset = Lerp(FrameTime() * 12, anims.panelYOffset, 20)
			anims.logoScale = Lerp(FrameTime() * 18, anims.logoScale, 0.1)
			-- Убираем сдвиг логотипа при исчезновении
			anims.titleAlpha = Lerp(FrameTime() * 10, anims.titleAlpha, 0)
			anims.textAlpha = Lerp(FrameTime() * 10, anims.textAlpha, 0)
			
			self:SetAlpha(anims.fadeOut * 255)
			
			if anims.fadeOut < 0.01 then
				self:Remove()
				if IsValid(BREACH_DESC_LOGO) then
					BREACH_DESC_LOGO:Remove()
				end
			end
			return
		end
		
		-- Анимация появления панели
		anims.panelAlpha = Lerp(FrameTime() * 10, anims.panelAlpha, 1)
		anims.panelScale = Lerp(FrameTime() * 12, anims.panelScale, 1)
		anims.panelYOffset = Lerp(FrameTime() * 15, anims.panelYOffset, 0)
		
		-- Последовательное появление элементов
		if elapsed > 0.1 then
			anims.logoAlpha = Lerp(FrameTime() * 8, anims.logoAlpha, 1)
			anims.logoScale = Lerp(FrameTime() * 15, anims.logoScale, 1)
			anims.logoYOffset = Lerp(FrameTime() * 12, anims.logoYOffset, -50)
		end
		
		if elapsed > 0.2 then
			anims.titleAlpha = Lerp(FrameTime() * 10, anims.titleAlpha, 1)
			anims.titleYOffset = Lerp(FrameTime() * 12, anims.titleYOffset, 0)
		end
		
		if elapsed > 0.3 then
			anims.textAlpha = Lerp(FrameTime() * 8, anims.textAlpha, 1)
			anims.textYOffset = Lerp(FrameTime() * 10, anims.textYOffset, 0)
		end
		
		-- Устанавливаем альфу панели
		self:SetAlpha(anims.panelAlpha * 255)
		
		-- Обновляем позицию с учетом анимации
		local panelX = ScrW()/2 - (panelWidth * anims.panelScale) / 2
		local panelY = ScrH() * 0.22 + anims.panelYOffset
		self:SetPos(panelX, panelY)
		
		-- Запускаем таймер закрытия только один раз после полного появления
		if elapsed > 1.5 and !self.CloseTimerSet and anims.panelAlpha > 0.95 then
			self.CloseTimerSet = true
			timer.Simple(15, function()
				if IsValid(BREACH_DESC_PANEL) then
					BREACH_DESC_PANEL.IsFadingOut = true
				end
				if IsValid(BREACH_DESC_LOGO) then
					BREACH_DESC_LOGO.IsFadingOut = true
				end
			end)
		end
	end

	BREACH_DESC_PANEL.Paint = function(self, w, h)
		local currentScale = anims.panelScale
		local currentAlpha = self.IsFadingOut and anims.fadeOut or anims.panelAlpha
		
		-- Применяем масштабирование
		local scaledW = w * currentScale
		local scaledH = h * currentScale
		local offsetX = (w - scaledW) / 2
		local offsetY = (h - scaledH) / 2

		-- Блюр эффект
		DrawBlurPanel(self)
		
		-- Фон панели с эффектом свечения при появлении
		local glowAlpha = math.sin(CurTime() * 8) * 0.2 + 0.8
		if not self.IsFadingOut and anims.panelAlpha > 0.9 then
			draw.RoundedBox(0, offsetX - 2, offsetY - 2, scaledW + 4, scaledH + 4, Color(teamcol.r, teamcol.g, teamcol.b, 30 * glowAlpha * currentAlpha))
		end
		
		-- Фон панели
		draw.RoundedBox(0, offsetX, offsetY, scaledW, scaledH, Color(20, 20, 20, 200 * currentAlpha))
		
		-- Тень (только при появлении)
		if not self.IsFadingOut or anims.fadeOut > 0.3 then
			draw.RoundedBox(0, offsetX + 2, offsetY + 2, scaledW, scaledH, Color(0, 0, 0, 80 * currentAlpha))
		end
		
		-- Обводка с эффектом
		local outlineAlpha = currentAlpha * (self.IsFadingOut and anims.fadeOut or 1)
		surface.SetDrawColor(255, 255, 255, 100 * outlineAlpha)
		surface.DrawOutlinedRect(offsetX, offsetY, scaledW, scaledH)
		
		-- Внутренняя обводка цветом команды
		if not self.IsFadingOut then
			surface.SetDrawColor(teamcol.r, teamcol.g, teamcol.b, 80 * currentAlpha)
			surface.DrawOutlinedRect(offsetX + 1, offsetY + 1, scaledW - 2, scaledH - 2)
		end
	end

	-- Анимация для заголовка
	charname.Think = function(self)
		if BREACH_DESC_PANEL.IsFadingOut then
			self:SetAlpha(anims.fadeOut * 255)
			self:SetPos(panelWidth / 2 - self:GetWide() / 2, 15 + anims.titleYOffset)
		else
			self:SetAlpha(anims.titleAlpha * 255)
			local targetY = 15 + anims.titleYOffset
			self:SetPos(panelWidth / 2 - self:GetWide() / 2, targetY)
		end
	end

	-- Анимация для текста
	label.Think = function(self)
		if BREACH_DESC_PANEL.IsFadingOut then
			self:SetAlpha(anims.fadeOut * 255)
		else
			self:SetAlpha(anims.textAlpha * 255)
		end
	end

	-- Создаем логотип
	BREACH_DESC_LOGO = vgui.Create("DImage")
	BREACH_DESC_LOGO:SetMaterial(mat)
	BREACH_DESC_LOGO:SetAlpha(0)
	BREACH_DESC_LOGO.IsFadingOut = false

	BREACH_DESC_LOGO.Think = function(self)
		if not IsValid(BREACH_DESC_PANEL) then 
			if IsValid(self) then
				self:Remove()
			end
			return 
		end
		
		local currentAlpha = anims.logoAlpha
		local currentScale = anims.logoScale
		local yOffset = anims.logoYOffset
		
		if self.IsFadingOut then
			-- Анимация исчезновения логотипа с уменьшением НА МЕСТЕ
			currentAlpha = anims.fadeOut * 215
			currentScale = anims.logoScale
			-- При исчезновении используем финальную позицию без смещения
			yOffset = -50 -- Фиксированная позиция над панелью
		else
			currentAlpha = 215 * anims.logoAlpha
		end
		
		self:SetAlpha(currentAlpha)
		
		-- Размер с анимацией
		local baseSize = 120
		local scaledSize = baseSize * currentScale
		self:SetSize(scaledSize, scaledSize)
		
		-- Позиционирование над панелью (фиксированная позиция)
		local panel_x, panel_y = BREACH_DESC_PANEL:GetPos()
		local panel_w = panelWidth * anims.panelScale
		local logo_x = panel_x + panel_w / 2 - scaledSize / 2
		local logo_y = panel_y - scaledSize + 10 + yOffset
		
		-- Сохраняем финальную позицию при первом появлении
		if not self.IsFadingOut and anims.logoAlpha > 0.9 and finalLogoPos.x == 0 then
			finalLogoPos.x = logo_x
			finalLogoPos.y = logo_y
		end
		
		-- При исчезновении используем финальную позицию
		if self.IsFadingOut and finalLogoPos.x ~= 0 then
			-- Центрируем уменьшающийся логотип относительно его финальной позиции
			local currentSize = baseSize * currentScale
			local finalSize = baseSize * 1 -- Исходный размер
			local centerX = finalLogoPos.x + finalSize / 2
			local centerY = finalLogoPos.y + finalSize / 2
			logo_x = centerX - currentSize / 2
			logo_y = centerY - currentSize / 2
		end
		
		self:SetPos(logo_x, logo_y)
		
		-- Автоудаление когда совсем прозрачный
		if self.IsFadingOut and anims.fadeOut < 0.01 and IsValid(self) then
			self:Remove()
		end
	end

	-- Эффект "ударной волны" при появлении
	timer.Simple(0.1, function()
		if IsValid(BREACH_DESC_PANEL) then
			BREACH_DESC_PANEL.ShakeTime = CurTime()
			
			local oldThink = BREACH_DESC_PANEL.Think
			BREACH_DESC_PANEL.Think = function(self)
				oldThink(self)
				
				if self.IsFadingOut then return end
				
				if self.ShakeTime and CurTime() - self.ShakeTime < 0.6 then
					local progress = (CurTime() - self.ShakeTime) / 0.6
					local intensity = (1 - progress) * 4
					local vibrateX = math.sin(CurTime() * 80) * intensity
					local vibrateY = math.cos(CurTime() * 60) * intensity
					
					local baseX = ScrW()/2 - (panelWidth * anims.panelScale) / 2
					local baseY = ScrH() * 0.22 + anims.panelYOffset
					
					self:SetPos(baseX + vibrateX, baseY + vibrateY)
				end
			end
		end
	end)

	---- Вращение логотипа при появлении
	--timer.Simple(0.2, function()
	--	if IsValid(BREACH_DESC_LOGO) then
	--		BREACH_DESC_LOGO.Rotation = 0
	--		BREACH_DESC_LOGO.RotateTime = CurTime()
	--		
	--		local oldPaint = BREACH_DESC_LOGO.Paint
	--		BREACH_DESC_LOGO.Paint = function(self, w, h)
	--			if not self.IsFadingOut and self.RotateTime and CurTime() - self.RotateTime < 1.0 then
	--				local rotProgress = (CurTime() - self.RotateTime) / 1.0
	--				self.Rotation = Lerp(rotProgress, -180, 0)
	--			elseif self.IsFadingOut then
	--				-- Вращение при исчезновении (убрал, чтобы не смещалось)
	--				-- self.Rotation = 0 -- Без вращения при исчезновении
	--			end
	--			
	--			surface.SetMaterial(mat)
	--			surface.SetDrawColor(255, 255, 255, self:GetAlpha())
	--			surface.DrawTexturedRectRotated(w/2, h/2, w, h, self.Rotation or 0)
	--		end
	--	end
	--end)
end

concommand.Add("br_description", DrawNewRoleDesc)

local BREACH = BREACH || {}
local gradient = Material("vgui/gradient-r")
local gradients = Material("gui/center_gradient")

function Camera_View( ply )

	ply.CameraEnabled = true

	if ply.CameraEnabled then

		fovcam = 60

		eyeAtt = ply:GetAttachment(ply:LookupAttachment("eyes"))

		if not CurView then
			CurView = angles
		else
			CurView = LerpAngle(mclamp(FrameTime() * (35 * (1 - mclamp(100, 0, 0.8))), 0, 1), CurView, angles + Angle(0, 0, eyeAtt.Ang.r * 0.1))
		end

		surface.PlaySound( "nextoren/Camera.ogg" )

		timer.Create("CameraSound", 5, 0, function()
			if !ply.CameraEnabled then return end
			surface.PlaySound( "nextoren/Camera.ogg" )
		end)

		hook.Add( "CalcView", "CameraView", function( ply, pos, ang, fov )

			if ply.CameraEnabled then

				local drawviewer = false

				local cameraviews = {
					origin = CamerasTable[ 1 ].Vector - Vector( 0, 0, 10 ),
					angles = CurView,
					fov = fovcam,
					drawviewer = true
				}

				return cameraviews
				  
			end

		end)
		

		BREACH.MainPanel_CamHud = vgui.Create( "DPanel" )
		BREACH.MainPanel_CamHud:SetSize( 1980, 1080 )
		BREACH.MainPanel_CamHud:SetPos( 0, 0 )
		BREACH.MainPanel_CamHud:SetText( "" )
		BREACH.MainPanel_CamHud.Paint = function( self, w, h )

			local cc_grain = surface.GetTextureID ( "overlays/cc_grain")
			local camcorder_noise = surface.GetTextureID ( "overlays/camcorder_noise")
			local camcorder_visor2 = surface.GetTextureID ( "overlays/camcorder_visor2")
			local camcorder_rec = surface.GetTextureID ( "overlays/camcorder_rec")
			local vignette = surface.GetTextureID ( "overlays/cc_vignette")
	
			local w,h = ScrW(),ScrH()
			surface.SetDrawColor ( 255, 255, 255, 255 )
			surface.SetTexture ( vignette )
			surface.DrawTexturedRect ( 0,0, w, h )
	
			local w,h = ScrW(),ScrH()
			surface.SetDrawColor ( 255, 255, 255, 255 )
			surface.SetTexture ( cc_grain )
			surface.DrawTexturedRect ( 0,0, w, h )
		
			local w,h = ScrW(),ScrH()
			surface.SetDrawColor ( 255, 255, 255, 255 )
			surface.SetTexture ( camcorder_noise )
			surface.DrawTexturedRect ( 0,0, w, h )
	
			local w,h = ScrW(),ScrH()
			
			surface.SetDrawColor ( 255, 255, 255, 255 )
			surface.SetTexture ( camcorder_visor2 )
			surface.DrawTexturedRect ( 0, 0, w, h )
			
			surface.SetDrawColor ( 255, 255, 255, 255 )
			surface.SetTexture ( camcorder_rec )
			surface.DrawTexturedRect ( w * 0.84, h * 0.14, 128, 64 )

			if camera_nvg == true then
			    local w,h = ScrW(),ScrH()

			    surface.SetDrawColor ( 136, 242, 173, 15 )
			    surface.DrawRect ( 0,0, w, h )

		    end
		

		end

		BREACH.MainPanel_Cameras = vgui.Create( "DPanel" )
		BREACH.MainPanel_Cameras:SetSize( 256, 256 )
		BREACH.MainPanel_Cameras:SetPos( ScrW() / 2 - 128, ScrH() / 2 - 128 )
		BREACH.MainPanel_Cameras:SetText( "" )
		BREACH.MainPanel_Cameras.DieTime = CurTime() + 10
		BREACH.MainPanel_Cameras.Paint = function( self, w, h )

			if ( !vgui.CursorVisible() ) then

				gui.EnableScreenClicker( false )
			end

			if ( input.IsKeyDown( KEY_F3 ) ) then

				if ( ( self.NextCall || 0 ) >= CurTime() ) then return end
	
				self.NextCall = CurTime() + 1

				if ( vgui.CursorVisible() ) then
	
					gui.EnableScreenClicker( false )
					BREACH.MainPanel228:SetVisible( false )
	
				else
	
					gui.EnableScreenClicker( true )
					BREACH.MainPanel228:SetVisible( true )
	
				end
	
			end

			if ( input.IsKeyDown( KEY_N ) ) then

				if ( ( self.NextCall2 || 0 ) >= CurTime() ) then return end
	
				self.NextCall2 = CurTime() + 1

				if ( !camera_nvg ) then
	
					camera_nvg = true
	
				else
	
					camera_nvg = false
	
				end
	
			end

			if ( input.IsKeyDown( KEY_C ) ) then

				if fovcam == 10 then return end
	
				fovcam = fovcam - 1
	
			end

			if ( input.IsKeyDown( KEY_M ) ) then

				if fovcam == 90 then return end
	
				fovcam = fovcam + 1
	
			end
			
		end

		local CLOSE2225 = vgui.Create( "DButton", MainPanel_Cameras )
		CLOSE2225:SetPos( 0, 1000 )
		CLOSE2225:SetSize( 350, 40 )
		CLOSE2225:SetText("")
		CLOSE2225:MoveToFront()
		CLOSE2225.DoClick = function()
	  
		  BREACH.MainPanel_Cameras:Remove()
		  BREACH.MainPanel_CamHud.Paint = function( self, w, h )
		  end
		  BREACH.MainPanel_CamHud:Remove()
		  BREACH.MainPanel228:Remove()
		  hook.Remove("CalcView", "CameraView")
		  gui.EnableScreenClicker( false )
		  CLOSE2225:Remove()
		  ply.CameraEnabled = false

		end
	  
		CLOSE2225.OnCursorEntered = function()
	  
		  surface.PlaySound( "nextoren/gui/main_menu/cursorentered_1.wav" )
	  
		end
	  
		CLOSE2225.FadeAlpha = 0

		surface.CreateFont("MainMenuFont", {

			font = "Conduit ITC",
			size = 24,
			weight = 800,
			blursize = 0,
			scanlines = 0,
			antialias = true,
			underline = false,
			italic = false,
			strikeout = false,
			symbol = false,
			rotary = false,
			shadow = true,
			additive = false,
			outline = false
		  
		  })
	  
		CLOSE2225.Paint = function(self, w, h)
	  
		  draw.SimpleText( "Назад", "MainMenuFont", 75, h / 2, clr1, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
	  
		  if ( self:IsHovered() ) then
	  
			self.FadeAlpha = math.Approach( self.FadeAlpha, 255, RealFrameTime() * 256 )
	  
		  else
	  
			self.FadeAlpha = math.Approach( self.FadeAlpha, 0, RealFrameTime() * 512 )
	  
			end
	  
		  surface.SetDrawColor( 138, 138, 138, self.FadeAlpha )
		  surface.SetMaterial( gradient )
		  surface.DrawTexturedRect(0, 0, w, h )
	  
		end

		BREACH.MainPanel228 = vgui.Create( "DPanel" )
		BREACH.MainPanel228:SetSize( 256, 768 )
		BREACH.MainPanel228:SetPos( ScrW() / 2 - 896, ScrH() / 2 - 384 )
		BREACH.MainPanel228:SetText( "" )
		BREACH.MainPanel228.DieTime = CurTime() + 10

		BREACH.ScrollPanel_Cameras = vgui.Create( "DScrollPanel", BREACH.MainPanel228 )
		BREACH.ScrollPanel_Cameras:Dock( FILL )

		for i = 1, #CamerasTable do

			BREACH.Cameras = BREACH.ScrollPanel_Cameras:Add( "DButton" )
			BREACH.Cameras:SetText( "" )
			BREACH.Cameras:Dock( TOP )
			BREACH.Cameras:SetSize( 256, 64 )
			BREACH.Cameras:DockMargin( 0, 0, 0, 2 )
			BREACH.Cameras.CursorOnPanel = false
			BREACH.Cameras.gradientalpha = 0
	
			BREACH.Cameras.Paint = function( self, w, h )
	
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
	
				draw.SimpleText( CamerasTable[ i ].Name, "ChatFont_new", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	
			end
	
			BREACH.Cameras.OnCursorEntered = function( self )
	
				self.CursorOnPanel = true
	
			end
	
			BREACH.Cameras.OnCursorExited = function( self )
	
				self.CursorOnPanel = false
	
			end
	
			BREACH.Cameras.DoClick = function( self )

				hook.Add( "CalcView", "CameraView", function( ply, pos, ang, fov )

					if ply.CameraEnabled then

						local drawviewer = false
	
						local cameraviews = {
							origin = CamerasTable[ i ].Vector - Vector( 0, 0, 10 ),
							angles = CurView,
							fov = fovcam,
							drawviewer = true
						}
	
						return cameraviews
						  
					end
	
				end)

				ply.CurCam = CamerasTable[ i ]
						  
	
			end



			BREACH.MainPanel228:SetVisible( false )

		end

	end



end
concommand.Add( "cameranew", Camera_View )

function Pulsate(c) --Использование флешей
	return (math.abs(math.sin(CurTime()*c)))
end

local bg_106_lerp = 0
local appeartextlerp = 0

local scp_106_texts = {
	"DEATH",
	"FEAR",
	"PAIN",
	"DESPAIR",
	"HOPELESS",
	"AGONY",
	"IMPOSSIBLE",
}

surface.CreateFont( "SCP106_TEXT", {

	font = "Segoe UI",--"Univers LT Std 47 Cn Lt",
	size = 35,
	weight = 0,
	antialias = true,
	extended = true,
	shadow = false,
	outline = true,
	italic = true,
	blursize = 1,
  
})

local function CreateSCP106Text()

	local msg = scp_106_texts[math.random(1, #scp_106_texts)]

	local text = vgui.Create("DLabel")
	text:SetText(msg)
	text:SetFont("SCP106_TEXT")
	text:SetTextColor(Color(155,0,0))
	text:SizeToContents()
	text:SetWide(text:GetWide()+20)
	text:SetPos(math.random(0, ScrW() - text:GetWide()), ScrH()-math.random(100,600))
	timer.Simple(4, function() if IsValid(text) then text:AlphaTo(0, 1, 0, function() if IsValid(text) then text:Remove() end end) end end)
	text:SetAlpha(0)
	text:AlphaTo(35,1)
	local original_x = text:GetX()
	local original_y = text:GetY()
	text.Think = function(self)

		if !LocalPlayer():GetInDimension() then self:Remove() end

		self:SetX(original_x + math.random(-8,8))
		self:SetY(original_y + math.random(-8,8))

	end

end

hook.Add( "HUDPaint", "SCP_106_creepy_visuals", function()

	if LocalPlayer():GetInDimension() and LocalPlayer():GTeam() != TEAM_SCP then

		local scrw, scrh = ScrW(), ScrH()

		bg_106_lerp = (math.abs(math.sin(CurTime()*math.Rand(0.3,0.4))))*100

		local bg_color = Color(0,0,0,bg_106_lerp)

		draw.RoundedBox(0, 0, 0, scrw, scrh, bg_color)

	end

end)

local XpAddInc = false
local XPPos = 0
local XPgained = 0
local newClassDescc = ""
local LevelUpIncnext = false
local LevelUpIncnext2 = false
local LevelUpAlpha = 0
local LevelUpAlpha3 = 0
local radiohud = 0
local expnotificationmat = Material("nextoren/gui/icons/notifications/breachiconfortips.png")

hook.Add( "HUDPaint", "EXPNotification", function()

	if ( !XpAddInc ) then return end

	if XpAddInc == true then
    -- XP Awarded
  	if XPPos < 100 then
    	XPPos = XPPos + 3
  	end
  else
    if XPPos > 0 then
      XPPos = XPPos - 3
    end
  end
	draw.RoundedBox(0, ScrW() - XPPos, ScrH() / 4, 100, 35, Color(0, 0, 0, 155))
	--draw.RoundedBox(0, ScrW() - XPPos, ScrH() / 4, 120, 35, Color(255, 0, 0, 155))
	surface.SetDrawColor( Color( 255, 0, 0, Pulsate(2)*180 ) )
	surface.DrawOutlinedRect( ScrW() - XPPos, ScrH() / 4, 100, 35 )
	if XpAddInc == true then
		draw.RoundedBox(0, ScrW() - XPPos - 31, ScrH() / 4, 30, 35, Color(0, 0, 0, 155))
		surface.SetDrawColor( Color( 0, 0, 0, 255 ) )
		surface.DrawOutlinedRect( ScrW() - XPPos - 31, ScrH() / 4, 30, 35 )
		surface.SetDrawColor( Color(255, 255, 255, 255) )
		surface.SetMaterial(expnotificationmat)
		surface.DrawTexturedRect(ScrW() - XPPos - 31,	ScrH() / 3.96, 32, 32)
	end
	-- XP Award BG
	draw.DrawText("+"..XPgained.." XP", "HUDFontTitle", ScrW() - (XPPos - 24), (ScrH() / 4) + 6, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)

end )

net.Receive("xpAwardnextoren", function(len) --XP Notification call
	XPgained = net.ReadFloat()
	XpAddInc = true
  
	timer.Simple(4, function()
	  XpAddInc = false
	end)
  
  
end)

function Intercom_Menu( ply )
	local clrgray = Color( 198, 198, 198, 200 )
	local gradient = Material( "vgui/gradient-r" )

	local inter_table = {

		[ 1 ] = { name = "Камеры видеонаблюдения", command = "cameranew" },
		[ 2 ] = { name = "Блокирование ворот Б на 180 секунд", class = nil },
		[ 3 ] = { name = "Блокирование ворот А на 180 секунд", class = nil },
		[ 4 ] = { name = "Передача голоса через интерком", class = nil },
		[ 5 ] = { name = "Запрос Отряда Быстрого Реагирования", class = nil }

	}

	BREACH.MainPanel_Inter = vgui.Create( "DPanel" )
	BREACH.MainPanel_Inter:SetSize( 256, 256 )
	BREACH.MainPanel_Inter:SetPos( ScrW() / 2 - 128, ScrH() / 2 - 128 )
	BREACH.MainPanel_Inter:SetText( "" )
	BREACH.MainPanel_Inter.DieTime = CurTime() + 10
	BREACH.MainPanel_Inter.Paint = function( self, w, h )

		if ( !vgui.CursorVisible() ) then

			gui.EnableScreenClicker( true )

		end

		draw.RoundedBox( 0, 0, 0, w, h, ColorAlpha( color_white, 120 ) )
		draw.OutlinedBox( 0, 0, w, h, 1.5, color_black )



	end

	BREACH.MainPanel_Inter.Disclaimer = vgui.Create( "DPanel" )
	BREACH.MainPanel_Inter.Disclaimer:SetSize( 256, 64 )
	BREACH.MainPanel_Inter.Disclaimer:SetPos( ScrW() / 2 - 128, ScrH() / 2 - ( 128 * 1.5 ) )
	BREACH.MainPanel_Inter.Disclaimer:SetText( "" )

	local client = LocalPlayer()

	BREACH.MainPanel_Inter.Disclaimer.Paint = function( self, w, h )

		draw.RoundedBox( 0, 0, 0, w, h, ColorAlpha( color_white, 120 ) )
		draw.OutlinedBox( 0, 0, w, h, 1.5, color_black )

		draw.DrawText( "Intercom Menu", "ChatFont_new", w / 2, h / 2 - 16, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

		if ( client:GetRoleName() != Dispatcher|| client:Health() <= 0 ) then

			if ( IsValid( BREACH.MainPanel_Inter ) ) then

				BREACH.MainPanel_Inter:Remove()

			end

			self:Remove()

			gui.EnableScreenClicker( false )

		end

	end

	BREACH.ScrollPanel_Inter = vgui.Create( "DScrollPanel", BREACH.MainPanel_Inter )
	BREACH.ScrollPanel_Inter:Dock( FILL )

	for i = 1, #inter_table do

		BREACH.Buttons_Inter = BREACH.ScrollPanel_Inter:Add( "DButton" )
		BREACH.Buttons_Inter:SetText( "" )
		BREACH.Buttons_Inter:Dock( TOP )
		BREACH.Buttons_Inter:SetSize( 256, 64 )
		BREACH.Buttons_Inter:DockMargin( 0, 0, 0, 2 )
		BREACH.Buttons_Inter.CursorOnPanel = false
		BREACH.Buttons_Inter.gradientalpha = 0

		BREACH.Buttons_Inter.Paint = function( self, w, h )

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

			draw.SimpleText( inter_table[ i ].name, "ChatFont_new", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

		end

		BREACH.Buttons_Inter.OnCursorEntered = function( self )

			self.CursorOnPanel = true

		end

		BREACH.Buttons_Inter.OnCursorExited = function( self )

			self.CursorOnPanel = false

		end

		BREACH.Buttons_Inter.DoClick = function( self )

			RunConsoleCommand(inter_table[ i ].command)

			BREACH.MainPanel_Inter.Disclaimer:Remove()
			BREACH.MainPanel_Inter:Remove()
			ply.Intercom = false
			gui.EnableScreenClicker( false )

		end

	end
end
concommand.Add( "testinter", Intercom_Menu )

BREACH.Demote = BREACH.Demote || {}
local clrgray = Color( 198, 198, 198 )
local clrgray2 = Color( 180, 180, 180 )
local clrred = Color( 255, 0, 0 )
local clrred2 = Color( 50,205,50 )
local textcd = 0
local gradienttt = Material( "nextoren_hud/inventory/menublack.png" )
function Choose_Faction()


	if CurTime() >= textcd then

		textcd = CurTime() + 0.1
		RXSENDNotify( "l:select_faction_ntfcmd" )

	end

	if IsValid(BREACH.Demote.MainPanel) then
		return
	end

	local teams_table = {

		{ name = "l:ClassD", team_id = TEAM_CLASSD, Icon = Material( "nextoren/gui/roles_icon/class_d.png" ) },
		{ name = "SCP", team_id = TEAM_SCP, Icon = Material( "nextoren/gui/roles_icon/scp.png" ) },
		{ name = "l:SCI", team_id = TEAM_SCI, Icon = Material( "nextoren/gui/roles_icon/sci.png" ) },
		{ name = "l:ntfcmd_unknowns", team_id = 22, Icon = Material("nextoren/gui/roles_icon/scp.png") }

	}



	BREACH.Demote.MainPanel = vgui.Create( "DPanel" )
	BREACH.Demote.MainPanel:SetSize( 256, 256 )
	BREACH.Demote.MainPanel:SetPos( ScrW() / 2 - 128, ScrH() / 2 - 128 )
	BREACH.Demote.MainPanel:SetText( "" )
	BREACH.Demote.MainPanel.Paint = function( self, w, h )

		if ( !vgui.CursorVisible() ) then

			gui.EnableScreenClicker( true )

		end

		draw.RoundedBox( 0, 0, 0, w, h, ColorAlpha( color_white, 120 ) )
		draw.OutlinedBox( 0, 0, w, h, 1.5, color_black )

		if ( input.IsKeyDown( KEY_BACKSPACE ) ) then

			self:Remove()
			BREACH.Demote.MainPanel.Disclaimer:Remove()
			gui.EnableScreenClicker( false )

		end

	end

	BREACH.Demote.MainPanel.Disclaimer = vgui.Create( "DPanel" )
	BREACH.Demote.MainPanel.Disclaimer:SetSize( 256, 64 )
	BREACH.Demote.MainPanel.Disclaimer:SetPos( ScrW() / 2 - 128, ScrH() / 2 - 192 )
	BREACH.Demote.MainPanel.Disclaimer:SetText( "" )

	local client = LocalPlayer()

	local title = L"l:ntfcmd_factionlist"

	BREACH.Demote.MainPanel.Disclaimer.Paint = function( self, w, h )

		draw.RoundedBox( 0, 0, 0, w, h, ColorAlpha( color_white, 120 ) )
		draw.OutlinedBox( 0, 0, w, h, 1.5, color_black )

		draw.DrawText( title, "ChatFont_new", w / 2, h / 2 - 16, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

		if ( client:GetRoleName() != role.NTF_Commander || client:Health() <= 0 ) then

			if ( IsValid( BREACH.Demote.MainPanel ) ) then

				BREACH.Demote.MainPanel:Remove()

			end

			self:Remove()

			gui.EnableScreenClicker( false )

		end

	end

	BREACH.Demote.ScrollPanel = vgui.Create( "DScrollPanel", BREACH.Demote.MainPanel )
	BREACH.Demote.ScrollPanel:Dock( FILL )

	for i = 1, #teams_table do

		BREACH.Demote.Users = BREACH.Demote.ScrollPanel:Add( "DButton" )
		BREACH.Demote.Users:SetText( "" )
		BREACH.Demote.Users:Dock( TOP )
		BREACH.Demote.Users:SetSize( 256, 64 )
		BREACH.Demote.Users:DockMargin( 0, 0, 0, 2 )
		BREACH.Demote.Users.CursorOnPanel = false
		BREACH.Demote.Users.gradientalpha = 0

		local name = L(teams_table[i].name)

		BREACH.Demote.Users.Paint = function( self, w, h )

			if ( self.CursorOnPanel ) then

				self.gradientalpha = math.Approach( self.gradientalpha, 255, FrameTime() * 128 )

			else

				self.gradientalpha = math.Approach( self.gradientalpha, 0, FrameTime() * 256 )

			end

			draw.RoundedBox( 0, 0, 0, w, h, color_black )
			draw.OutlinedBox( 0, 0, w, h, 1.5, clrgray )

			surface.SetDrawColor( ColorAlpha( color_white, self.gradientalpha ) )
			surface.SetMaterial( gradienttt )
			surface.DrawTexturedRect( 0, 0, w, h )

			surface.SetDrawColor( color_white )
			surface.SetMaterial( teams_table[ i ].Icon )
			surface.DrawTexturedRect( 0, h / 2 - 32, 64, 64 )

			draw.SimpleText( name, "ChatFont_new", 65, h / 2, clrgray, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )

		end

		BREACH.Demote.Users.OnCursorEntered = function( self )

			self.CursorOnPanel = true

		end

		BREACH.Demote.Users.OnCursorExited = function( self )

			self.CursorOnPanel = false

		end

		BREACH.Demote.Users.DoClick = function( self )

			net.Start( "NTF_Special_1" )

				net.WriteUInt( teams_table[ i ].team_id, 12 )

			net.SendToServer()

			BREACH.Demote.MainPanel:Remove()
			BREACH.Demote.MainPanel.Disclaimer:Remove()
			gui.EnableScreenClicker( false )

		end

	end

end

BREACH.Demote = BREACH.Demote || {}
local clrgray = Color( 198, 198, 198 )
local clrgray2 = Color( 180, 180, 180 )
local clrred = Color( 255, 0, 0 )
local clrred2 = Color( 50,205,50 )
local textcd = 0
local gradienttt = Material( "nextoren_hud/inventory/menublack.png" )
function Ci_Faction()


	if CurTime() >= textcd then

		textcd = CurTime() + 0.1
		RXSENDNotify( "渗透摄像头准备就绪请选择扫描人员-单击’删除’键关闭窗口" )

	end

	if IsValid(BREACH.Demote.MainPanel) then
		return
	end

	local teams_table = {

		{ name = "l:ClassD", team_id = TEAM_CLASSD, Icon = Material( "nextoren/gui/roles_icon/class_d.png" ) },

	}



	BREACH.Demote.MainPanel = vgui.Create( "DPanel" )
	BREACH.Demote.MainPanel:SetSize( 256, 256 )
	BREACH.Demote.MainPanel:SetPos( ScrW() / 2 - 128, ScrH() / 2 - 128 )
	BREACH.Demote.MainPanel:SetText( "" )
	BREACH.Demote.MainPanel.Paint = function( self, w, h )

		if ( !vgui.CursorVisible() ) then

			gui.EnableScreenClicker( true )

		end

		draw.RoundedBox( 0, 0, 0, w, h, ColorAlpha( color_white, 120 ) )
		draw.OutlinedBox( 0, 0, w, h, 1.5, color_black )

		if ( input.IsKeyDown( KEY_BACKSPACE ) ) then

			self:Remove()
			BREACH.Demote.MainPanel.Disclaimer:Remove()
			gui.EnableScreenClicker( false )

		end

	end

	BREACH.Demote.MainPanel.Disclaimer = vgui.Create( "DPanel" )
	BREACH.Demote.MainPanel.Disclaimer:SetSize( 256, 64 )
	BREACH.Demote.MainPanel.Disclaimer:SetPos( ScrW() / 2 - 128, ScrH() / 2 - 192 )
	BREACH.Demote.MainPanel.Disclaimer:SetText( "" )

	local client = LocalPlayer()

	local title = "入侵摄像头"

	BREACH.Demote.MainPanel.Disclaimer.Paint = function( self, w, h )

		draw.RoundedBox( 0, 0, 0, w, h, ColorAlpha( color_white, 120 ) )
		draw.OutlinedBox( 0, 0, w, h, 1.5, color_black )

		draw.DrawText( title, "ChatFont_new", w / 2, h / 2 - 16, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

		if ( client:GetRoleName() != role.Chaos_SM || client:Health() <= 0 ) then

			if ( IsValid( BREACH.Demote.MainPanel ) ) then

				BREACH.Demote.MainPanel:Remove()

			end

			self:Remove()

			gui.EnableScreenClicker( false )

		end

	end

	BREACH.Demote.ScrollPanel = vgui.Create( "DScrollPanel", BREACH.Demote.MainPanel )
	BREACH.Demote.ScrollPanel:Dock( FILL )

	for i = 1, #teams_table do

		BREACH.Demote.Users = BREACH.Demote.ScrollPanel:Add( "DButton" )
		BREACH.Demote.Users:SetText( "" )
		BREACH.Demote.Users:Dock( TOP )
		BREACH.Demote.Users:SetSize( 256, 64 )
		BREACH.Demote.Users:DockMargin( 0, 0, 0, 2 )
		BREACH.Demote.Users.CursorOnPanel = false
		BREACH.Demote.Users.gradientalpha = 0

		local name = L(teams_table[i].name)

		BREACH.Demote.Users.Paint = function( self, w, h )

			if ( self.CursorOnPanel ) then

				self.gradientalpha = math.Approach( self.gradientalpha, 255, FrameTime() * 128 )

			else

				self.gradientalpha = math.Approach( self.gradientalpha, 0, FrameTime() * 256 )

			end

			draw.RoundedBox( 0, 0, 0, w, h, color_black )
			draw.OutlinedBox( 0, 0, w, h, 1.5, clrgray )

			surface.SetDrawColor( ColorAlpha( color_white, self.gradientalpha ) )
			surface.SetMaterial( gradienttt )
			surface.DrawTexturedRect( 0, 0, w, h )

			surface.SetDrawColor( color_white )
			surface.SetMaterial( teams_table[ i ].Icon )
			surface.DrawTexturedRect( 0, h / 2 - 32, 64, 64 )

			draw.SimpleText( name, "ChatFont_new", 65, h / 2, clrgray, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )

		end

		BREACH.Demote.Users.OnCursorEntered = function( self )

			self.CursorOnPanel = true

		end

		BREACH.Demote.Users.OnCursorExited = function( self )

			self.CursorOnPanel = false

		end

		BREACH.Demote.Users.DoClick = function( self )

			net.Start( "CI_Special_1" )

				net.WriteUInt( teams_table[ i ].team_id, 12 )

			net.SendToServer()

			BREACH.Demote.MainPanel:Remove()
			BREACH.Demote.MainPanel.Disclaimer:Remove()
			gui.EnableScreenClicker( false )

		end

	end

end

hook.Add("Initialize", "Remove_Xyi", function()
	hook.Remove("PlayerTick", "TickWidgets")
end)

current_observer = current_observer || nil
function CreateInspectPanel(ply)
	current_observer = ply
	local client = LocalPlayer()

	if IsValid(INSPECT_PANEL) then INSPECT_PANEL:Remove() end

	local scrw, scrh = ScrW(), ScrH()

	local inspectAnims = {
		panelAlpha = 0,
		panelScale = 0.8,
		panelXOffset = 100,
		modelAlpha = 0,
		modelScale = 0.7,
		infoAlpha = 0,
		barsAlpha = 0,
		healthLerp = 0
	}

	INSPECT_PANEL = vgui.Create("DPanel")
	INSPECT_PANEL:SetSize(400, 200)
	INSPECT_PANEL:SetPos(scrw-459 + inspectAnims.panelXOffset, scrh/2-100)
	INSPECT_PANEL:SetAlpha(0)
	INSPECT_PANEL.CreationTime = CurTime()

	INSPECT_PANEL.Think = function(self)
		local currentTime = CurTime()
		local elapsed = currentTime - self.CreationTime
		
		if client:GetObserverTarget() != ply or client:GTeam() != TEAM_SPEC then
			self:Remove()
			return
		end

		inspectAnims.panelAlpha = Lerp(FrameTime() * 8, inspectAnims.panelAlpha, 1)
		inspectAnims.panelScale = Lerp(FrameTime() * 10, inspectAnims.panelScale, 1)
		inspectAnims.panelXOffset = Lerp(FrameTime() * 12, inspectAnims.panelXOffset, 0)
		
		if elapsed > 0.1 then
			inspectAnims.modelAlpha = Lerp(FrameTime() * 6, inspectAnims.modelAlpha, 1)
			inspectAnims.modelScale = Lerp(FrameTime() * 8, inspectAnims.modelScale, 1)
		end
		
		if elapsed > 0.3 then
			inspectAnims.infoAlpha = Lerp(FrameTime() * 6, inspectAnims.infoAlpha, 1)
		end
		
		if elapsed > 0.5 then
			inspectAnims.barsAlpha = Lerp(FrameTime() * 6, inspectAnims.barsAlpha, 1)
		end
		
		self:SetAlpha(inspectAnims.panelAlpha * 255)
		local targetX = scrw-459 + inspectAnims.panelXOffset
		local targetY = scrh/2-100
		self:SetPos(targetX, targetY)
	end

	local clr_black = Color(0,0,0,125)
	local clr_black2 = Color(0,0,0,200)

	local name = L"l:hud_nick "..ply:Nick()
	local charname = L"l:hud_charname "..ply:GetNamesurvivor()
	local gteam = ply:GTeam()
	local role_icon = GetRoleIconByTeam(ply:GTeam(), ply:GetRoleName())

	INSPECT_PANEL.Paint = function(self, w, h)
		local currentScale = inspectAnims.panelScale
		local currentAlpha = inspectAnims.panelAlpha
		
		local scaledW = w * currentScale
		local scaledH = h * currentScale
		local offsetX = (w - scaledW) / 2
		local offsetY = (h - scaledH) / 2

		draw.RoundedBox(0, offsetX, offsetY, scaledW, scaledH, Color(20, 20, 20, 200 * currentAlpha))
		

		draw.RoundedBox(0, offsetX + 2, offsetY + 2, scaledW, scaledH, Color(0, 0, 0, 80 * currentAlpha))
		
		local iconAlpha = 55 * inspectAnims.infoAlpha
		surface.SetDrawColor(Color(255,255,255,iconAlpha))
		surface.SetMaterial(role_icon)
		surface.DrawTexturedRect(offsetX + 195, offsetY, 200, 200)
	
		surface.SetDrawColor(255, 255, 255, 100 * currentAlpha)
		surface.DrawOutlinedRect(offsetX, offsetY, scaledW, scaledH)
		
		surface.SetDrawColor(80, 80, 80, 80 * currentAlpha)
		surface.DrawOutlinedRect(offsetX + 1, offsetY + 1, scaledW - 2, scaledH - 2)

		local textAlpha = 255 * inspectAnims.infoAlpha
		draw.DrawText(name, "BudgetLabel", offsetX + 200, offsetY + 25, Color(255, 255, 255, textAlpha))

		if gteam != TEAM_SCP then
			drawMultiLine(charname, "BudgetLabel", offsetX + 190, offsetY + 15, 200, 45, Color(255, 255, 255, textAlpha), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 0, Color(255, 255, 255, textAlpha))
		end
	end

	local mdl = vgui.Create("DModelPanel", INSPECT_PANEL)
	mdl:SetPos(10, 10)
	mdl:SetSize(180, 180)
	mdl:SetAlpha(0)
	mdl:SetModel(ply:GetModel())
	mdl.Entity:SetSkin(ply:GetSkin())
	mdl:SetFOV(15)

	local vec = Vector(0,0,-23)
	local seq = mdl.Entity:LookupSequence("idle_all_01")

	mdl.Think = function(self)
		self:SetAlpha(255)
		
		local currentScale = inspectAnims.modelScale
		local currentW = 180 * currentScale
		local currentH = 180 * currentScale
		local currentX = 10 + (180 - currentW) / 2
		local currentY = 10 + (180 - currentH) / 2
		
		self:SetPos(currentX, currentY)
		self:SetSize(currentW, currentH)
	end

	mdl.LayoutEntity = function(self, ent)
		ent:SetPos(vec)
		ent:SetAngles(Angle(-5,45,0))
	end

	for i = 0, ply:GetNumBodyGroups() do
		mdl.Entity:SetBodygroup(i, ply:GetBodygroup(i))
	end

	mdl.PaintCustom = function(self, w, h)
		local alpha = 125 * inspectAnims.modelAlpha
		draw.RoundedBox(0,0,0,w,h, Color(0,0,0,alpha))
	end

	mdl.PaintOver = function(self, w, h)
		local alpha = 255 * inspectAnims.modelAlpha
		surface.SetDrawColor(255, 255, 255, alpha)
		surface.DrawOutlinedRect(0,0,w,h,1)
	end

	local function CreateBar(name, y, col, func, func2)
		local bar = vgui.Create("DPanel", INSPECT_PANEL)
		bar:SetSize(180, 30)
		bar:SetPos(202, y)
		bar:SetAlpha(0)

		local lerp = 0
		local barLerp = 0

		bar.Think = function(self)
			self:SetAlpha(inspectAnims.barsAlpha * 255)
			barLerp = Lerp(FrameTime() * 6, barLerp, 1)
		end

		bar.Paint = function(self, w, h)
			local currentAlpha = inspectAnims.barsAlpha
			local barAlpha = 255 * currentAlpha
			
			if IsValid(ply) then
				local cur, max = func2()
				lerp = math.Approach(lerp, math.min(1, cur/max), FrameTime() * 0.4)
			else
				lerp = 0
			end

			draw.RoundedBox(0,0,0,w,h, Color(0,0,0,200 * currentAlpha))

			draw.DrawText(name, "BudgetLabel", 5, 3, Color(255, 255, 255, barAlpha))

			if IsValid(ply) then
				local cur, max = func2()
				draw.DrawText(math.floor(Lerp(lerp, 0, cur)).."/"..math.floor(max), "BudgetLabel", w-5, 3, Color(255, 255, 255, barAlpha), TEXT_ALIGN_RIGHT)
			end

			local barWidth = w * lerp * barLerp
			local pulse = math.sin(CurTime() * 3) * 0.1 + 0.9
			local barColor = Color(col.r * pulse, col.g * pulse, col.b * pulse, 255 * currentAlpha)
			
			draw.RoundedBox(0, 5, 20, barWidth - 10, 5, barColor)
			
			surface.SetDrawColor(255, 255, 255, 50 * currentAlpha)
			surface.DrawOutlinedRect(5, 20, w - 10, 5)
		end
	end

	local h_y = 155
	if ply:GTeam() == TEAM_SCP then
		h_y = 155
	end

	CreateBar(L"l:hud_health_capital", h_y, Color(255,0,0), function()
		if IsValid(ply) then
			local h = ply:Health() / ply:GetMaxHealth()
			inspectAnims.healthLerp = math.Approach(inspectAnims.healthLerp, math.min(1, h), FrameTime() * 0.4)
			return inspectAnims.healthLerp
		else
			return 0
		end
	end, function()
		if IsValid(ply) then
			return ply:Health(), ply:GetMaxHealth()
		else
			return 0, 0
		end
	end)

	mdl.Entity:SetSequence(seq)

	local tbl_bonemerged = ents.FindByClassAndParent("ent_bonemerged", ply)

	timer.Simple(0.2, function()
		if !IsValid(mdl) then return end

		if tbl_bonemerged then
			for i = 1, #tbl_bonemerged do
				local bonemerge = tbl_bonemerged[i]
				if !IsValid(bonemerge) then continue end
				
				local bnm
				if CORRUPTED_HEADS[bonemerge:GetModel()] then
					bnm = mdl:BoneMerged(bonemerge:GetModel(), bonemerge:GetSubMaterial(1), bonemerge:GetInvisible(), bonemerge:GetSkin(), Color(255,255,255))
				elseif bonemerge:GetModel():find('/hair/') then
					bnm = mdl:BoneMerged(bonemerge:GetModel(), bonemerge:GetSubMaterial(0), bonemerge:GetInvisible(), bonemerge:GetSkin(), string.ToColor(ply:GetNWString("HairColor")))
				else
					bnm = mdl:BoneMerged(bonemerge:GetModel(), bonemerge:GetSubMaterial(0), bonemerge:GetInvisible(), bonemerge:GetSkin(), Color(255,255,255))
				end
				bnm:SetSkin(bonemerge:GetSkin())
			end
		end

		if ply:GTeam() == TEAM_SCP and !ply:GetModel():find("/scp/") then
			mdl:MakeZombie()
		end
	end)

	timer.Simple(0.1, function()
		if IsValid(INSPECT_PANEL) then
			INSPECT_PANEL.ShakeTime = CurTime()
			
			local oldThink = INSPECT_PANEL.Think
			INSPECT_PANEL.Think = function(self)
				oldThink(self)
				
				if self.ShakeTime and CurTime() - self.ShakeTime < 0.4 then
					local progress = (CurTime() - self.ShakeTime) / 0.4
					local intensity = (1 - progress) * 3
					local vibrateX = math.sin(CurTime() * 70) * intensity
					local vibrateY = math.cos(CurTime() * 55) * intensity
					
					local baseX = scrw-459 + inspectAnims.panelXOffset
					local baseY = scrh/2-100
					
					self:SetPos(baseX + vibrateX, baseY + vibrateY)
				end
			end
		end
	end)
end

local uiu_doc_mat = Material( "nextoren/gui/icons/others/fbidocs_ico.png" )

local clr_bg = Color(0,0,0,200)
--[[
hook.Add("HUDPaint", "UIU_SPY_HUD", function()
	local client = LocalPlayer()
	local w, h = ScrW(), ScrH()
	if client:GetRoleName() == role.SCI_SpyUSA then

			draw.RoundedBox(0,w/2-26-3,11,49,49,clr_bg)

			surface.SetDrawColor(255, 255, 255);
			surface.SetMaterial(uiu_doc_mat);
			surface.DrawTexturedRect(w/2-26, 11+3, 42, 42);

			surface.SetDrawColor(color_white)
			surface.DrawOutlinedRect(w/2-26-3, 11, 48,48, 1)

			draw.RoundedBox(0,w/2-50-3, 65, 100,25,clr_bg)

			surface.SetDrawColor(color_white)
			surface.DrawOutlinedRect(w/2-50-3, 65, 100,25, 1)

			draw.DrawText(client:GetNWInt("CollectedDocument", 0).." / 3", "BudgetLabel", w/2-3, 70, color_white, TEXT_ALIGN_CENTER)

		end
end)
--]]

local hud_style = CreateConVar("breach_config_hud_style", 0, FCVAR_ARCHIVE, "Changes your HUD style", 0, 1)

local function toLines(text, font, mWidth)
		surface.SetFont(font)
		
		local buffer = { }
		local nLines = { }
	
		for word in string.gmatch(text, "%S+") do
			local w,h = surface.GetTextSize(table.concat(buffer, " ").." "..word)
			if w > mWidth then
				table.insert(nLines, table.concat(buffer, " "))
				buffer = { }
			end
			table.insert(buffer, word)
		end
			
		if #buffer > 0 then -- If still words to add.
			table.insert(nLines, table.concat(buffer, " "))
		end
		
		return nLines
end

local function drawMultiLine(text, font, mWidth, spacing, x, y, color, alignX, alignY, oWidth, oColor)
	local mLines = toLines(text, font, mWidth)
	
	for i,line in pairs(mLines) do
		if oWidth and oColor then
			draw.SimpleTextOutlined(line, font, x, y + (i - 1) * spacing, color, alignX, alignY, oWidth, oColor)
		else
			draw.SimpleText(line, font, x, y + (i - 1) * spacing, color, alignX, alignY)
		end
	end
			
	return (#mLines - 1) * spacing
		-- return #mLines * spacing
end

function BreachHUDInitialize()

local scale = 100
	local width = ScrW() * scale
	local height = ScrH() * scale
	local offset = ScrH() - height
	local ply = LocalPlayer()
local evaccolor = Color(255,0,0,100)
local frankin_lost = Sound( "nextoren/round_sounds/franklinlost.wav" )
local icon_x, icon_y = ScrW() / 2 - 32, ScrH() / 1.1
local approved_team = {
	[ TEAM_DZ ] = true,
	[ TEAM_SCP ] = true
}
local team_scp_index, team_dz_index = TEAM_SCP, TEAM_DZ
local outline_clr = Color( 255, 12, 0, 210 )
local scpstab = {}
local dztab = {}
local widthz = ScrW() * scale
local heightz = ScrH() * scale
local offset = ScrH() - heightz

function Choose_Weapon()

		local clrgray = Color( 198, 198, 198, 200 )
		local gradient = Material( "vgui/gradient-r" )
	
		local sound_table = {
	
			[ 1 ] = { name = "Searching", class = "br_sound_searching" },
			[ 2 ] = { name = "Random", class = "br_sound_random" },
			[ 3 ] = { name = "Class-D found", class = "br_sound_classd" },
			[ 4 ] = { name = "Stop!", class = "br_sound_stop" },
			[ 5 ] = { name = "Target Lost", class = "br_sound_lost" }
	
		}
	
		BREACH.Demote.MainPanel = vgui.Create( "DPanel" )
		BREACH.Demote.MainPanel:SetSize( 256, 256 )
		BREACH.Demote.MainPanel:SetPos( ScrW() / 2 - 128, ScrH() / 2 - 128 )
		BREACH.Demote.MainPanel:SetText( "" )
		BREACH.Demote.MainPanel.DieTime = CurTime() + 10
		BREACH.Demote.MainPanel.Paint = function( self, w, h )
	
			if ( !vgui.CursorVisible() ) then
	
				gui.EnableScreenClicker( true )
	
			end
	
			draw.RoundedBox( 0, 0, 0, w, h, ColorAlpha( color_white, 120 ) )
			draw.OutlinedBox( 0, 0, w, h, 1.5, color_black )
	
	
	
		end
	
		BREACH.Demote.MainPanel.Disclaimer = vgui.Create( "DPanel" )
		BREACH.Demote.MainPanel.Disclaimer:SetSize( 256, 64 )
		BREACH.Demote.MainPanel.Disclaimer:SetPos( ScrW() / 2 - 128, ScrH() / 2 - ( 128 * 1.5 ) )
		BREACH.Demote.MainPanel.Disclaimer:SetText( "" )
	
		local client = LocalPlayer()
	
		BREACH.Demote.MainPanel.Disclaimer.Paint = function( self, w, h )
	
			draw.RoundedBox( 0, 0, 0, w, h, ColorAlpha( color_white, 120 ) )
			draw.OutlinedBox( 0, 0, w, h, 1.5, color_black )
	
			draw.DrawText( "MTF Menu", "ChatFont_new", w / 2, h / 2 - 16, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	
			if ( client:GTeam() != TEAM_GUARD || client:Health() <= 0 ) then
	
				if ( IsValid( BREACH.Demote.MainPanel ) ) then
	
					BREACH.Demote.MainPanel:Remove()
	
				end
	
				self:Remove()
	
				gui.EnableScreenClicker( false )
	
			end
	
		end
	
		BREACH.Demote.ScrollPanel = vgui.Create( "DScrollPanel", BREACH.Demote.MainPanel )
		BREACH.Demote.ScrollPanel:Dock( FILL )
	
		for i = 1, #sound_table do
	
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
	
				draw.SimpleText( sound_table[ i ].name, "ChatFont_new", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	
			end
	
			BREACH.Demote.Users.OnCursorEntered = function( self )
	
				self.CursorOnPanel = true
	
			end
	
			BREACH.Demote.Users.OnCursorExited = function( self )
	
				self.CursorOnPanel = false
	
			end
	
			BREACH.Demote.Users.DoClick = function( self )
	
				RunConsoleCommand(sound_table[ i ].class)
	
				BREACH.Demote.MainPanel.Disclaimer:Remove()
				BREACH.Demote.MainPanel:Remove()
				gui.EnableScreenClicker( false )
	
			end
	
		end
	
	end
	concommand.Add( "choose_weapon", Choose_Weapon )

local ntf_icon = Material( "nextoren/gui/roles_icon/ntf.png" )

local scp173_lerp = 0
local tazer_lerp = 0

function HelicopterStart()

	local client = LocalPlayer()
	local mtfntf = CreateSound(client, "no_music/factions_spawn/ntf_intro.ogg" )
	client:ConCommand( "stopsound" )
	timer.Simple( 1.5, function()
		if ( client && client:IsValid() && client:GTeam() == TEAM_GUARD ) then
			mtfntf:Play()
		end
	end )
	local CutSceneWindow = vgui.Create( "DPanel" )
	CutSceneWindow:SetText( "" )
	CutSceneWindow:SetSize( ScrW(), ScrH() )
	CutSceneWindow.StartAlpha = 255
	CutSceneWindow.StartTime = CurTime() + 15
	CutSceneWindow.Name = "Имя субъекта: " .. client:GetNamesurvivor()
	CutSceneWindow.Status = "Местонахождение: ??? ( Внешняя часть Зоны-19 )"
	CutSceneWindow.Operation = "Операция: Лисья Нора "
	CutSceneWindow.Squad = "Подразделение: Фокстрот-1 "
	CutSceneWindow.Time = " ( Время: " .. string.ToMinutesSeconds( GetRoundTime() - cltime ) .. " )"

	local ExplodedString = string.Explode( "", CutSceneWindow.Time, true )
	local ExplodedString2 = string.Explode( "", CutSceneWindow.Status, true )
	local ExplodedString3 = string.Explode( "", CutSceneWindow.Name, true )
	local ExplodedString4 = string.Explode( "", CutSceneWindow.Squad, true )
	local ExplodedString5 = string.Explode( "", CutSceneWindow.Operation, true )


	local str = ""
	local str1 = ""
	local str2 = ""
	local str3 = ""
	local str4 = ""

	local count = 0
	local count1 = 0
	local count2 = 0
	local count3 = 0
	local count4 = 0
	CutSceneWindow.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h,  color_black, self.StartAlpha  )
		surface.SetDrawColor( 255,255,255, 40  )
		surface.SetMaterial( ntf_icon )
		surface.DrawTexturedRect( ScrW() / 2 - 128, ScrH() / 2 - 128, 256, 256 )
		if ( CutSceneWindow.StartTime <= CurTime() + 10 ) then
			if ( CutSceneWindow.StartTime <= CurTime() ) then
				self.StartAlpha = math.Approach( self.StartAlpha, 0, RealFrameTime() * 40 )
			end
			if ( ( self.NextSymbol || 0 ) <= SysTime() && count2 != #ExplodedString3 ) then
				count2 = count2 + 1
				if ( ExplodedString3[count2] != " " ) then
					surface.PlaySound( "common/talk.wav" )
				end
				self.NextSymbol = SysTime() + .08
				str = str..ExplodedString3[ count2 ]
			elseif ( ( self.NextSymbol || 0 ) <= SysTime() && count2 == #ExplodedString3 && count1 != #ExplodedString2 ) then
				count1 = count1 + 1
				if ( ExplodedString2[count1] != " " ) then
					surface.PlaySound( "common/talk.wav" )
				end
				self.NextSymbol = SysTime() + .08
				str1 = str1..ExplodedString2[ count1 ]
			elseif ( ( self.NextSymbol || 0 ) <= SysTime() && count2 == #ExplodedString3 && count1 == #ExplodedString2 && count != #ExplodedString ) then
				count = count + 1
				if ( ExplodedString[count] != " " ) then
					surface.PlaySound( "common/talk.wav" )
				end
				self.NextSymbol = SysTime() + .08
				str2 = str2..ExplodedString[ count ]
		    elseif ( ( self.NextSymbol || 0 ) <= SysTime() && count2 == #ExplodedString3 && count1 == #ExplodedString2 && count == #ExplodedString && count3 != #ExplodedString4 ) then
			    count3 = count3 + 1
			    if ( ExplodedString[count] != " " ) then
				    surface.PlaySound( "common/talk.wav" )
			    end
			    self.NextSymbol = SysTime() + .08
			    str3 = str3..ExplodedString[ count ]
		    elseif ( ( self.NextSymbol || 0 ) <= SysTime() && count2 == #ExplodedString3 && count1 == #ExplodedString2 && count == #ExplodedString && count3 == #ExplodedString4 && count4 != #ExplodedString5) then
			    count4 = count4 + 1
			    if ( ExplodedString[count] != " " ) then
				    surface.PlaySound( "common/talk.wav" )
			    end
			    self.NextSymbol = SysTime() + .08
			    str4 = str4..ExplodedString[ count ]
			end
			draw.SimpleTextOutlined( str, "HUDFont", w / 2, h / 2, Color( 198, 198, 198 , self.StartAlpha ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 180, self.StartAlpha ) )
			draw.SimpleTextOutlined( str1, "HUDFont", w / 2, h / 2 + 32, Color( 198, 198, 198 , self.StartAlpha ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 180, self.StartAlpha ) )
			draw.SimpleTextOutlined( str2, "HUDFont", w / 2, h / 2 + 64, Color( 198, 198, 198 , self.StartAlpha ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 180, self.StartAlpha ) )
			draw.SimpleTextOutlined( str3, "HUDFont", w / 2, h / 2 + 96, Color( 198, 198, 198 , self.StartAlpha ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 180, self.StartAlpha ) )
			draw.SimpleTextOutlined( str4, "HUDFont", w / 2, h / 2 + 128, Color( 198, 198, 198 , self.StartAlpha ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 180, self.StartAlpha ) )
		end
		if ( self.StartAlpha <= 0 ) then
			timer.Simple( 25, function()
				if ( client:GTeam() == TEAM_GUARD ) then
					mtfntf:FadeOut( 10 )
				end
			end )
			self:Remove()
		end
	end
end
--concommand.Add( "helikop", HelicopterStart )

local clr_gray = Color( 198, 198, 198 )
local clr_green = Color( 0, 180, 0 )

local klasuniad = Material( "nextoren/gui/roles_icon/class_d.png")
local chaosad = Material( "nextoren/gui/roles_icon/chaos.png")
local dzad = Material( "nextoren/gui/roles_icon/dz.png")
local fbiad = Material( "nextoren/gui/roles_icon/fbi.png")
local gocad = Material( "nextoren/gui/roles_icon/goc.png")
local mtfad = Material( "nextoren/gui/roles_icon/mtf.png")
local ntfad = Material( "nextoren/gui/roles_icon/ntf.png")
local scpad = Material( "nextoren/gui/roles_icon/scp.png")
local sciad = Material( "nextoren/gui/roles_icon/sci.png")
local sbad = Material( "nextoren/gui/roles_icon/sb.png")

local sssci = Material( "nextoren/gui/roles_icon/sci_special.png")

local scpmat = Material("nextoren/gui/roles_icon/scp.png")
local mtfmat = Material("nextoren/gui/roles_icon/mtf.png")
local sbmat = Material("nextoren/gui/roles_icon/sb.png")
local dzmat = Material("nextoren/gui/roles_icon/dz.png")
local chaosmat = Material("nextoren/gui/roles_icon/chaos.png")
local classdmat = Material("nextoren/gui/roles_icon/class_d.png")
local scarletmat = Material("nextoren/gui/roles_icon/scarlet.png")
local gocmat = Material("nextoren/gui/roles_icon/goc.png")
local grumat = Material("nextoren/gui/roles_icon/gru.png")
local fbimat = Material("nextoren/gui/roles_icon/fbi.png")
local scimat = Material("nextoren/gui/roles_icon/sci.png")
local specialscimat = Material("nextoren/gui/roles_icon/sci_special.png")
local ntfmat = Material("nextoren/gui/roles_icon/ntf.png")
local osnmat = Material("nextoren/gui/roles_icon/osn.png")
local obrmat = Material("nextoren/gui/roles_icon/obr.png")
local armat = Material("nextoren/gui/roles_icon/ar.png")
local a1mat = Material("nextoren/gui/roles_icon/a1.png")
local ettmat = Material("nextoren/gui/roles_icon_new/ettr1a.png")
local fafmat = Material("nextoren/gui/roles_icon/mtf.png") --未完成
local rho7mat = Material("nextoren/gui/roles_icon_new/rho7.png")
local crbmat = Material("nextoren/gui/roles_icon/crb.png")
local fbiagent = Material("nextoren/gui/roles_icon/fbi_agent.png")
local cmbmat = Material("nextoren/gui/roles_icon/cmb.png")
local rebelmat = Material("nextoren/gui/roles_icon/rebel.png")
local americamat = Material("nextoren/gui/roles_icon/america.png")
local reichmat = Material("nextoren/gui/roles_icon/reich.png")

function GetRoleIconByTeam(team, role)
	local roles_icons = scpmat
	if BREACH:IsUiuAgent(role) then return fbiagent end
	if team == TEAM_GUARD then
		roles_icons = mtfmat
	elseif team == TEAM_SECURITY then
		roles_icons = sbmat
	elseif team == TEAM_DZ then
		roles_icons = dzmat
	elseif team == TEAM_CHAOS then
		roles_icons = chaosmat
	elseif team == TEAM_CLASSD then
		roles_icons = classdmat
	elseif team == TEAM_COTSK then
		roles_icons = scarletmat
	elseif team == TEAM_GOC then
		roles_icons = gocmat
	elseif team == TEAM_GRU then
		roles_icons = grumat
	elseif team == TEAM_USA then
		roles_icons = fbimat
	elseif team == TEAM_SCI then
		roles_icons = scimat
	elseif team == TEAM_SPECIAL then
		roles_icons = specialscimat
	elseif team == TEAM_NTF then
		roles_icons = ntfmat
	elseif team == TEAM_ETT then
		roles_icons = ettmat
	elseif team == TEAM_FAF then
		roles_icons = fafmat
	elseif team == TEAM_OSN then
		roles_icons = osnmat
	elseif team == TEAM_QRT then
		roles_icons = obrmat
	elseif team == TEAM_RHO7 then
		roles_icons = rho7mat
	elseif team == TEAM_AR then
		roles_icons = armat
	elseif team == TEAM_ALPHA1 then
		roles_icons = a1mat
	elseif team == TEAM_CBG then
		roles_icons = crbmat
	elseif team == TEAM_SCP then
		roles_icons = scpmat
	elseif team == TEAM_COMBINE then
		roles_icons = cmbmat
	elseif team == TEAM_RESISTANCE then
		roles_icons = rebelmat
	elseif team == TEAM_AMERICA then
		roles_icons = americamat
	elseif team == TEAM_NAZI then
		roles_icons = reichmat
	end

	return roles_icons
end

local blinkblack = Color(0, 0, 0)
local blinkalmostblack = Color(0, 0, 0, 200)
local blinkmat = Material("nextoren_hud/ico_blink.png")
local tazermat = Material("rxsend/ui/tazer_ammo.png")
local icoindex = Material("nextoren_hud/ico_index.png")
local icoindex2 = Material("nextoren_hud/ico_index2.png")
local eyedropeffectclr = Color(10, 45, 255, 0)
local roleblack = Color(0, 0, 0)
local rolealmostblack = Color(0, 0, 0, 200)
local rolealmostwhite = Color(255, 255, 255, 200)
local roleblankcolor = Color(0, 0, 0, 200)
local rolemat = Material("nextoren_hud/ico_role.png")
local boostcolor = Color( 10, 45, 255, 0)
local hpcoloralmostwhite = Color(255,255,255,230)
local venenomat = Material("veneno.png")
local healthmat = Material("nextoren_hud/ico_health.png")
local healthmatnew = Material("nextoren_hud/ico_health_new.png")
local staminamat = Material("nextoren_hud/ico_stamina.png")
local staminamatnew = Material("nextoren_hud/ico_stamina_new.png")
local newr = Material("nextoren_hud/round_box_3.png")
local newrb = Material("nextoren_hud/round_box_3_big.png")
local newrr = Material("nextoren_hud/round_box_3_r.png")
local newrl = Material("nextoren_hud/round_box_3_l.png")

local draw = draw
local surface = surface
local GetGlobalBool = GetGlobalBool
local ScrW = ScrW
local ScrH = ScrH
local IsValid = IsValid

local gru_task_translations = {
	["Evacuation"] = "l:gru_hud_task_evacuation",
	["Срыв эвакуации"] = "l:gru_hud_task_evacuation",
	["MilitaryHelp"] = "l:gru_hud_task_militaryhelp",
	["Помощь военному персоналу"] = "l:gru_hud_task_militaryhelp",
	["[none]"] = "l:gru_hud_task_none"
}

local vec_forward = Vector( 70 )

function CanSeePlayer(ply)

	local value = LocalPlayer():GetAimVector():Dot( ( ply:GetPos() - LocalPlayer():GetPos() + vec_forward ):GetNormalized() )

	if !LocalPlayer():IsLineOfSightClear(ply:GetPos()) then return false end

	return ( value > .39 )

end

local data_levels_hud = {}

local data_levels = {
	[5] = {ico = Material("nextoren/gui/icons/level/lvl1.png", "smooth")},
	[10] = {ico = Material("nextoren/gui/icons/level/lvl2.png", "smooth")},
	[15] = {ico = Material("nextoren/gui/icons/level/lvl3.png", "smooth")},
	[20] = {ico = Material("nextoren/gui/icons/level/lvl4.png", "smooth")},
	[25] = {ico = Material("nextoren/gui/icons/level/lvl5.png", "smooth")},
	[30] = {ico = Material("nextoren/gui/icons/level/lvl6.png", "smooth")},
	[35] = {ico = Material("nextoren/gui/icons/level/lvl7.png", "smooth")},
	[40] = {ico = Material("nextoren/gui/icons/level/lvl8.png", "smooth")},
	[45] = {ico = Material("nextoren/gui/icons/level/lvl9.png", "smooth")},
}

for i, v in pairs(data_levels) do
	data_levels[i].widthpercentage = v.ico:Width()/v.ico:Height()
end

for i = 0, 5 do
	data_levels_hud[i] = data_levels[5]
end
for i = 6, 10 do
	data_levels_hud[i] = data_levels[10]
end
for i = 11, 15 do
	data_levels_hud[i] = data_levels[15]
end
for i = 16, 20 do
	data_levels_hud[i] = data_levels[20]
end
for i = 21, 25 do
	data_levels_hud[i] = data_levels[25]
end
for i = 26, 30 do
	data_levels_hud[i] = data_levels[30]
end
for i = 31, 35 do
	data_levels_hud[i] = data_levels[35]
end
for i = 36, 44 do
	data_levels_hud[i] = data_levels[40]
end
data_levels_hud[45] = data_levels[45]

-- Добавьте эти переменные в начало вашего файла (вне функции)
local tvar_health_smooth = 0
local tvar_health_last = 0
local tvar_shake = 0
local tvar_shake_time = 0

hook.Add( "HUDPaint", "Breach_HUD", function()
	if !IsValid(ply) then ply = LocalPlayer() end
	local client = ply
	local myteam = LocalPlayer():GTeam()
	local myrole = LocalPlayer():GetRoleName()
	if myteam == TEAM_CLASSD or myteam == TEAM_CHAOS then
		Show_Spy(TEAM_CHAOS)
	elseif myteam == TEAM_GOC then
		Show_Spy(TEAM_GOC)
	end

	if client:GTeam() == TEAM_SCP and client:GetPos().z < -4000 then
		--print("хуй")
		for k,v in pairs(player.GetAll()) do
			if v:GetPos().z < -4569 then
				outline.Add(v,Color(255,0,0),1)
			end
		end
	end
	
	if disablehud then return end
	if playing then return end
	--if GetGlobalBool("Evacuation_HUD", false) and !ply:Outside() then
		--evaccolor["a"] = Pulsate(2) * 7
		--draw.RoundedBox(0,0,0, ScrW(), ScrH(), evaccolor)
	--end
	local my_par = client:GetParent()
	if IsValid(client) and IsValid(my_par) and my_par:GetClass() == "prop_ragdoll" then return end
	if client:Health() <= 0 then return end --alive is slow
	local clienttable = client:GetTable()
	if clienttable.CameraEnabled == true then return end
	if LocalPlayer():GetInDimension() then return end
	if myteam == TEAM_AR then return end
	if LocalPlayer().br_scp079_mode then return end

	if client:GTeam() == TEAM_GRU then

				  --draw.RoundedBox(0, 10, scrh-50-50, 40, 40, roleblack);
	   	--draw.RoundedBox(0, ScrW() / 128, ScrH() / 64, ScrW() / 8, ScrH() / 9, Color(255,255,255,10));

		DrawBlurRect(ScrW() / 128, ScrH() / 64, ScrW() / 8, ScrH() / 9)
        surface.SetDrawColor(0, 0, 0, 255)
        surface.DrawOutlinedRect(ScrW() / 128, ScrH() / 64, ScrW() / 8, ScrH() / 9, 1)
		SigmaYgliDraw(ScrW() / 128, ScrH() / 64, ScrW() / 8, ScrH() / 9, Color(255,255,255), ScrW() / 64)

		draw.SimpleText(L"l:tasks_GRU_Name", "BudgetLabel", ScrW() / 15, ScrH() / 32, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);
		draw.SimpleText(L"l:tasks_first", "BudgetLabel", ScrW() / 64, ScrH() / 22, Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER);
		draw.SimpleText(L"l:tasks_second", "BudgetLabel", ScrW() / 64, ScrH() / 13, Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER);
		if GetGlobalInt("TASKS_GRU_1") != 5 then
			draw.SimpleText(L"l:tasks_1".. GetGlobalInt("TASKS_GRU_1") .." / 5", "BudgetLabel", ScrW() / 64, ScrH() / 16, Color(255,95,95), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER);
		else
			draw.SimpleText(L"l:tasks_1".. GetGlobalInt("TASKS_GRU_1") .." / 5 | ".."Готово", "BudgetLabel", ScrW() / 64, ScrH() / 16, Color(95,255,95), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER);
		end
		if GetGlobalInt("TASKS_GRU_2") >= 3 then
			draw.SimpleText(L"l:tasks_2".. GetGlobalInt("TASKS_GRU_2") .." / 3 | ".."Готово", "BudgetLabel", ScrW() / 64, ScrH() / 11, Color(95,255,95), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER);
		else
			draw.SimpleText(L"l:tasks_2".. GetGlobalInt("TASKS_GRU_2") .." / 3", "BudgetLabel", ScrW() / 64, ScrH() / 11, Color(255,95,95), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER);
		end
		if GetGlobalInt("TASKS_GRU_3") >= 3 then
			draw.SimpleText(L"l:tasks_3".. GetGlobalInt("TASKS_GRU_3") .." / 3 | ".."Готово", "BudgetLabel", ScrW() / 64, ScrH() / 9.5, Color(95,255,95), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER);
		else
			draw.SimpleText(L"l:tasks_3".. GetGlobalInt("TASKS_GRU_3") .." / 3", "BudgetLabel", ScrW() / 64, ScrH() / 9.5, Color(255,95,95), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER);
		end
		
		--surface.SetDrawColor(255, 255, 255);
	  	--surface.SetMaterial(Material("nextoren_hud/round_boxe_1.png"));
	  	--surface.DrawTexturedRect(ScrW() / 128, ScrH() / 10, ScrW() / 64, ScrW() / 64);
--
		--surface.SetDrawColor(255, 255, 255);
	  	--surface.SetMaterial(Material("nextoren_hud/round_boxe_2.png"));
	  	--surface.DrawTexturedRect(ScrW() / 8.5, ScrH() / 10, ScrW() / 64, ScrW() / 64);
--
--
		--surface.SetDrawColor(255, 255, 255);
	  	--surface.SetMaterial(Material("nextoren_hud/round_boxe_4.png"));
	  	--surface.DrawTexturedRect(ScrW() / 128, ScrH() / 64, ScrW() / 64, ScrW() / 64);
--
		--surface.SetDrawColor(255, 255, 255);
	  	--surface.SetMaterial(Material("nextoren_hud/round_boxe_3.png"));
	  	--surface.DrawTexturedRect(ScrW() / 8.5, ScrH() / 64, ScrW() / 64, ScrW() / 64);
	elseif client:GTeam() == TEAM_GUARD and client:GetModel() == "models/cultist/humans/mog/mog.mdl" then
		--draw.RoundedBox(0, ScrW() / 128, ScrH() / 64, ScrW() / 7, ScrH() / 9, Color(255,255,255,10));


		DrawBlurRect(ScrW() / 128, ScrH() / 64, ScrW() / 7, ScrH() / 9)
        surface.SetDrawColor(0, 0, 0, 255)
        surface.DrawOutlinedRect(ScrW() / 128, ScrH() / 64, ScrW() / 7, ScrH() / 9, 1)
		SigmaYgliDraw(ScrW() / 128, ScrH() / 64, ScrW() / 7, ScrH() / 9, Color(255,255,255), ScrW() / 64)
		draw.SimpleText(L"l:tasks_TG_Name", "BudgetLabel", ScrW() / 13, ScrH() / 32, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);
		draw.SimpleText(L"l:tasks_TG_first", "BudgetLabel", ScrW() / 64, ScrH() / 22, Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER);
		draw.SimpleText(L"l:tasks_TG_second", "BudgetLabel", ScrW() / 64, ScrH() / 13, Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER);
		if GetGlobalInt("TASKS_TG_1") < GetGlobalInt("TASKS_TG_1_min") then
			draw.SimpleText(L"l:tasks_TG_1".. GetGlobalInt("TASKS_TG_1") .." / " .. GetGlobalInt("TASKS_TG_1_min"), "BudgetLabel", ScrW() / 64, ScrH() / 16, Color(255,95,95), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER);
		else
			draw.SimpleText(L"l:tasks_TG_1".. GetGlobalInt("TASKS_TG_1") .." / "..GetGlobalInt("TASKS_TG_1_min").." | ".."Готово", "BudgetLabel", ScrW() / 64, ScrH() / 16, Color(95,255,95), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER);
		end
		if GetGlobalInt("TASKS_TG_2") >= GetGlobalInt("TASKS_TG_2_min") then
			draw.SimpleText(L"l:tasks_TG_2".. GetGlobalInt("TASKS_TG_2") .." / "..GetGlobalInt("TASKS_TG_2_min").." | ".."Готово", "BudgetLabel", ScrW() / 64, ScrH() / 11, Color(95,255,95), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER);
		else
			draw.SimpleText(L"l:tasks_TG_2".. GetGlobalInt("TASKS_TG_2") .." / ".. GetGlobalInt("TASKS_TG_2_min"), "BudgetLabel", ScrW() / 64, ScrH() / 11, Color(255,95,95), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER);
		end
		if GetGlobalInt("TASKS_TG_3") >= GetGlobalInt("TASKS_TG_3_min") then
			draw.SimpleText(L"l:tasks_TG_3".. GetGlobalInt("TASKS_TG_3") .." / "..GetGlobalInt("TASKS_TG_3_min").." | ".."Готово", "BudgetLabel", ScrW() / 64, ScrH() / 9.5, Color(95,255,95), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER);
		else
			draw.SimpleText(L"l:tasks_TG_3".. GetGlobalInt("TASKS_TG_3") .." / ".. GetGlobalInt("TASKS_TG_3_min"), "BudgetLabel", ScrW() / 64, ScrH() / 9.5, Color(255,95,95), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER);
		end
		
		--surface.SetDrawColor(255, 255, 255);
	  	--surface.SetMaterial(Material("nextoren_hud/round_boxe_1.png"));
	  	--surface.DrawTexturedRect(ScrW() / 128, ScrH() / 10, ScrW() / 64, ScrW() / 64);
--
		--surface.SetDrawColor(255, 255, 255);
	  	--surface.SetMaterial(Material("nextoren_hud/round_boxe_2.png"));
	  	--surface.DrawTexturedRect(ScrW() / 7.4, ScrH() / 10, ScrW() / 64, ScrW() / 64);
--
--
		--surface.SetDrawColor(255, 255, 255);
	  	--surface.SetMaterial(Material("nextoren_hud/round_boxe_4.png"));
	  	--surface.DrawTexturedRect(ScrW() / 128, ScrH() / 64, ScrW() / 64, ScrW() / 64);
--
		--surface.SetDrawColor(255, 255, 255);
	  	--surface.SetMaterial(Material("nextoren_hud/round_boxe_3.png"));
	  	--surface.DrawTexturedRect(ScrW() / 7.4, ScrH() / 64, ScrW() / 64, ScrW() / 64);

		
	--elseif client:GTeam() != TEAM_GRU and client:GTeam() != TEAM_SPEC then
--
	--	draw.RoundedBox(0, ScrW() / 128, ScrH() / 64, ScrW() / 8, ScrH() / 16, Color(255,255,255,10));
	--	draw.SimpleText("Задание на хэллоуин", "BudgetLabel", ScrW() / 15, ScrH() / 32, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);
	--	draw.SimpleText("Поиск вкусностей", "BudgetLabel", ScrW() / 64, ScrH() / 22, Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER);
	--	if ply:GetNWInt("TASKS_Hell") < 20 then
	--		draw.SimpleText("Сбор конфеток ".. ply:GetNWInt("TASKS_Hell") .." / 20", "BudgetLabel", ScrW() / 64, ScrH() / 16, Color(255,95,95), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER);
	--	else
	--		draw.SimpleText("Сбор конфеток ".. ply:GetNWInt("TASKS_Hell") .." / 20 | ".."Готово", "BudgetLabel", ScrW() / 64, ScrH() / 16, Color(95,255,95), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER);
	--	end
	--	
	--	surface.SetDrawColor(255, 255, 255);
	--  	surface.SetMaterial(Material("nextoren_hud/round_boxe_1.png"));
	--  	surface.DrawTexturedRect(ScrW() / 128, ScrH() / 20, ScrW() / 64, ScrW() / 64);
--
	--	surface.SetDrawColor(255, 255, 255);
	--  	surface.SetMaterial(Material("nextoren_hud/round_boxe_2.png"));
	--  	surface.DrawTexturedRect(ScrW() / 8.5, ScrH() / 20, ScrW() / 64, ScrW() / 64);
--
--
	--	surface.SetDrawColor(255, 255, 255);
	--  	surface.SetMaterial(Material("nextoren_hud/round_boxe_4.png"));
	--  	surface.DrawTexturedRect(ScrW() / 128, ScrH() / 64, ScrW() / 64, ScrW() / 64);
--
	--	surface.SetDrawColor(255, 255, 255);
	--  	surface.SetMaterial(Material("nextoren_hud/round_boxe_3.png"));
	--  	surface.DrawTexturedRect(ScrW() / 8.5, ScrH() / 64, ScrW() / 64, ScrW() / 64);
	--  	--surface.SetDrawColor(255, 255, 255);
----
	--  --surface.SetMaterial(newr);
	--  --surface.DrawTexturedRect(13, scrh-47-50, 34, 34);
--
	--  --surface.SetDrawColor(255, 255, 255, 75);
	--  --surface.DrawOutlinedRect(10, ScrH()-50-50, 40, 40);
	--	
	end
	local tvar = nil
	for k,v in pairs(player.GetAll()) do
		if v:GTeam() == TEAM_XMAS_VRAG then
			tvar = v
		end
	end

	-- А внутри функции рисования худа:
	if tvar then
	    local current_health = tvar:Health()
	    local max_health = tvar:GetMaxHealth()
	
	    -- Плавная интерполяция здоровья
	    if tvar_health_last != current_health then
	        tvar_health_last = current_health
	        tvar_shake = 5 -- Сила дрожания
	        tvar_shake_time = CurTime() + 0.3 -- Время дрожания
	    end
	
	    -- Плавное изменение отображаемого здоровья
	    tvar_health_smooth = Lerp(FrameTime() * 5, tvar_health_smooth, current_health)
	
	    -- Расчет дрожания
	    local shake_offset_x = 0
	    local shake_offset_y = 0
	
	    if tvar_shake > 0 then
	        if CurTime() < tvar_shake_time then
	            -- Эффект дрожания
	            local shake_intensity = tvar_shake * (tvar_shake_time - CurTime()) / 0.3
	            shake_offset_x = math.sin(CurTime() * 30) * shake_intensity
	            shake_offset_y = math.cos(CurTime() * 25) * shake_intensity
	        else
	            tvar_shake = 0
	        end
	    end
	
	    -- Применяем дрожание ко всем позициям отрисовки
	    local center_x = ScrW() / 2 + shake_offset_x
	    local center_y = ScrH() / 32 + shake_offset_y
	    local bar_x = ScrW() / 4 + shake_offset_x
	    local bar_y = ScrH() / 16 + shake_offset_y
	
	    draw.SimpleText("НОВОГОДНЯЯ ТВАРЬ", "ImpactBig", center_x, center_y, Color(255,61,61), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	
	    -- Фон бара
	    draw.RoundedBox(0, bar_x, bar_y, ScrW() / 2, ScrH() / 32, Color(255,255,255,10))
	
	    -- Основной бар здоровья с плавной анимацией
	    local health_percent = tvar_health_smooth / max_health
	    local bar_width = ScrW() / 2 * math.max(0, health_percent)
	
	    -- Эффект пульсации при низком здоровье
	    local pulse = 1
	    if health_percent < 0.3 then
	        pulse = 1 + math.sin(CurTime() * 5) * 0.1
	    end
	
	    -- Основной цвет бара
	    local bar_color = Color(196,39,39)
	    bar_color.r = math.min(255, bar_color.r * pulse)
	
	    draw.RoundedBox(0, bar_x, bar_y, bar_width, ScrH() / 32, bar_color)
	
	    -- Эффект "убывающего" здоровья (опционально)
	    if tvar_health_smooth < current_health then
	        local missing_width = ScrW() / 2 * ((current_health - tvar_health_smooth) / max_health)
	        draw.RoundedBox(0, bar_x + bar_width, bar_y, missing_width, ScrH() / 32, Color(255, 100, 100, 100))
	    end
	
	    -- Текст здоровья
	    draw.SimpleText(math.Round(tvar_health_smooth).." | "..max_health, "ImpactSmall", 
	                   center_x, ScrH() / 13 + shake_offset_y, 
	                   Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	
	    -- Угловые декорации с учетом дрожания
	    local corner_size = ScrW() / 64
	
	    surface.SetDrawColor(255, 255, 255)
	    surface.SetMaterial(Material("nextoren_hud/round_boxe_1.png"))
	    surface.DrawTexturedRect(bar_x, ScrH() / 15 + shake_offset_y, corner_size, corner_size)
	
	    surface.SetDrawColor(255, 255, 255)
	    surface.SetMaterial(Material("nextoren_hud/round_boxe_2.png"))
	    surface.DrawTexturedRect(ScrW() / 1.36 + shake_offset_x, ScrH() / 15 + shake_offset_y, corner_size, corner_size)
	
	    surface.SetDrawColor(255, 255, 255)
	    surface.SetMaterial(Material("nextoren_hud/round_boxe_4.png"))
	    surface.DrawTexturedRect(bar_x, bar_y, corner_size, corner_size)
	
	    surface.SetDrawColor(255, 255, 255)
	    surface.SetMaterial(Material("nextoren_hud/round_boxe_3.png"))
	    surface.DrawTexturedRect(ScrW() / 1.36 + shake_offset_x, bar_y, corner_size, corner_size)
	
	    -- Эффект вспышки при получении урона (опционально)
	    if tvar_shake > 0 and CurTime() < tvar_shake_time then
	        local flash_alpha = (tvar_shake_time - CurTime()) / 0.3 * 30
	        draw.RoundedBox(0, bar_x, bar_y, ScrW() / 2, ScrH() / 32, Color(255, 100, 100, flash_alpha))
	    end
	end
	if table.HasValue({TEAM_AMERICA,TEAM_COMBINE,TEAM_RESISTANCE,TEAM_NAZI},client:GTeam()) then
		draw.RoundedBox(0, ScrW() / 128, ScrH() / 64, ScrW() / 8, ScrH() / 9, Color(255,255,255,10))
		
    	draw.SimpleText("ТОП 5 ИГРОКОВ", "BudgetLabel", ScrW() / 15, ScrH() / 32, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		
    	local players = player.GetAll()
    	local playerScores = {}
		
    	for _, ply in ipairs(players) do
    	    if IsValid(ply) then
    	        local enemykill = ply:Frags()
    	        local score = enemykill
			
    	        table.insert(playerScores, {
    	            player = ply,
    	            score = score,
    	            name = ply:Nick()
    	        })
    	    end
    	end
	
    	table.sort(playerScores, function(a, b) 
    	    return a.score > b.score 
    	end)
	
    	local startY = ScrH() / 22
    	local lineHeight = ScrH() / 64
	
    	for i = 1, 5 do
    	    if playerScores[i] then
    	        local data = playerScores[i]
    	        local yPos = startY + (i-1) * lineHeight
    	        local color = i == 1 and Color(255, 215, 0) or Color(255, 255, 255)
			
    	        draw.SimpleText(
    	            i .. ". " .. string.sub(data.name, 1, 12) .. ": " .. math.Round(data.score, 2),
    	            "BudgetLabel", 
    	            ScrW() / 64, 
    	            yPos, 
    	            color, 
    	            TEXT_ALIGN_LEFT, 
    	            TEXT_ALIGN_CENTER
    	        )
    	    end
    	end
	
    	surface.SetDrawColor(255, 255, 255)
    	surface.SetMaterial(Material("nextoren_hud/round_boxe_1.png"))
    	surface.DrawTexturedRect(ScrW() / 128, ScrH() / 10, ScrW() / 64, ScrW() / 64)

    	surface.SetDrawColor(255, 255, 255)
    	surface.SetMaterial(Material("nextoren_hud/round_boxe_2.png"))
    	surface.DrawTexturedRect(ScrW() / 8.5, ScrH() / 10, ScrW() / 64, ScrW() / 64)

    	surface.SetDrawColor(255, 255, 255)
    	surface.SetMaterial(Material("nextoren_hud/round_boxe_4.png"))
    	surface.DrawTexturedRect(ScrW() / 128, ScrH() / 64, ScrW() / 64, ScrW() / 64)

    	surface.SetDrawColor(255, 255, 255)
    	surface.SetMaterial(Material("nextoren_hud/round_boxe_3.png"))
    	surface.DrawTexturedRect(ScrW() / 8.5, ScrH() / 64, ScrW() / 64, ScrW() / 64)
	end

	//surface.SetMaterial( MATS.menublack )
	//MATS.menublack:SetFloat("$blur", 5)
	//MATS.menublack:Recompute()
	//render.UpdateScreenEffectTexture()

	--if client:GTeam() == TEAM_GRU then
--
	--	draw.DrawText(BREACH.TranslateString("l:gru_hud_task").." "..BREACH.TranslateString(gru_task_translations[GetGlobalString("gru_objective", "[none]")]), "ChatFont_new", 285, ScrH() - 30)
--
	--end

	--if client:GTeam() == TEAM_ALPHA1 or client:GTeam() == TEAM_USA then
	--	for k,v in pairs(player.GetAll()) do
	--		if v:GetRoleName() == role.MTF_O5 and v:GetNWBool("ALPHACanSea") then
	--			outline.Add(v,Color(201,104,104),1)
	--			--	v:SetNWBool("ALPHACanSea",true)
	--			--	timer.Simple(5, function()
	--			--		v:SetNWBool("ALPHACanSea",false)
	--			--	end)
	--		end
	--	end
	--end

	if client:GetRoleName() == role.SCI_SPECIAL_VISION then
		for k,v in pairs(player.GetAll()) do
			if v:GTeam() == TEAM_SCP and v:GetNWBool("SCPCanSea") then
				outline.Add(v,Color(255,0,0),1)
			end
		end
	end




	--SetInDimension

	if ( ply:GTeam() == TEAM_SCP ) then
	
		hook.Add( "PreDrawOutlines", "Draw_other_scps", function()
	
		    if ( client:GTeam() != team_scp_index  ) then
	
			    clienttable["NextCheckSCP"] = nil
			    hook.Remove( "PreDrawOutlines", "Draw_other_scps" )
			    return
		    end
	
		    if ( ( clienttable["NextCheckSCP"] || 0 ) < CurTime() ) then
	
			clienttable["NextCheckSCP"] = CurTime() + 0
	
			local players_table = player.GetAll()
	
			for i = 1, #players_table do
	
			  local player = players_table[ i ]
	
			  if ( player != client && approved_team[ player:GTeam() ] && !player:IsFrozen() && !( table.HasValue( scpstab, player ) || table.HasValue( dztab, player ) ) ) then
	
				if ( player:GTeam() == team_scp_index ) then

					if player:GetRoleName() != "SCP173" then
	
					  scpstab[ #scpstab + 1 ] = player

					--else
						--if IsValid(player:GetActiveWeapon()) and player:GetActiveWeapon():GetClass() == "weapon_scp_173" then
							--scpstab[ #scpstab + 1 ] = player:GetActiveWeapon():GetStatue()
						--end

					end
	
				else
	
				  dztab[ #dztab + 1 ] = player

				    local bonemerged_tbl = ents.FindByClassAndParent("ent_bonemerged", dz)

				    if ( bonemerged_tbl && bonemerged_tbl:IsValid() ) then

					    for i = 1, #bonemerged_tbl do

					        dztab[ #dztab + 1 ] = bonemerged_tbl[i]

						end

					end
	
				end
	
			  end
	
			end
	
			if ( #scpstab > 0 ) then
	
			  for i = 1, #scpstab do
	
				local scp = scpstab[ i ]
	
				if ( !(IsValid(scp) and scp:IsPlayer()) or !( scp && scp:IsValid() ) || scp:Health() <= 0 || scp:GTeam() != team_scp_index ) then
					if IsValid(scp) and scp:GetClass() != "base_gmodentity" then
					  table.remove( scpstab, i )
					end
	
				end
	
			  end
	
			end
	
			if ( #dztab > 0 ) then
	
			  for i = 1, #dztab do
	
				local dz = dztab[ i ]
	
				if ( !( dz && dz:IsValid() ) || dz:Health() <= 0 || dz:GTeam() != team_dz_index ) then
	
				  table.remove( dztab, i )
	
				end
	
			  end
	
			end
	
		  end
	
		  if ( #scpstab > 0 ) then
	
			outline.Add( scpstab, outline_clr, 0 )
	
		  end
	
		  if ( #dztab > 0 ) then
			local dzcolor = gteams.GetColor( TEAM_DZ )
			outline.Add( dztab, dzcolor, 2 )
	
		  end
	
		end )
	end

	if IsValid( client ) then
		--spect box

		if ply:GTeam() == TEAM_SPEC then
			local ent = client:GetObserverTarget()
			--local obsstamina = ent.Stamina
			if IsValid(ent) then
				if ent:IsPlayer() then
					if current_observer != ent then
						CreateInspectPanel(ent)
					end
				end
			end
		end
	    local role = "none"
	  if !clang then return end
		if not clienttable.GetRoleName then
			player_manager.RunClass( client, "SetupDataTables" )
		elseif client:GTeam() != TEAM_SPEC then
			--role = clang[ply:GetRoleName()]
		else
			--local obs = ply:GetObserverTarget()
			--role = clang[ply:GetRoleName()]
			--if IsValid(obs) then
				--if obs.GetRoleName != nil then
					--role = clang[obs:GetRoleName()]
					--ply = obs
					--print(obs.stamina)
				--end
			--end
		end
		local hp = ply:Health()
		local maxhp = ply:GetMaxHealth()
		if !client.Stamina then client.Stamina = 100 end
		local stamina = math.Round(client.Stamina)
		local exhausted = clienttable.exhausted
		local color = gteams.GetColor(ply:GTeam())

		--[[if ply:GetActiveWeapon() != nil then
			local wep = ply:GetActiveWeapon()
			if wep.Clip1 and wep:Clip1() > -1 then
				ammo = wep:Clip1()
				mag = ply:GetAmmoCount( wep:GetPrimaryAmmoType() )
			end
		end]]



		local color = gteams.GetColor( ply:GTeam() )

		local scrw, scrh = ScrW(), ScrH()

	local width = 355
	local height = 120
	local x = 10
	local y = scrh - height - 10

	local lvlH = 70
	local lvlW = 95
	local vledOffsetH = scrh - 25 - 25

	local clientlevel = client:GetNLevel()

	local leveldata =	data_levels_hud[45]

	if data_levels_hud[clientlevel] then leveldata = data_levels_hud[clientlevel] end

	local defaultx = 45

	local icosize = 80

	local icowidth = math.floor(80*1)

	--surface.SetDrawColor( 255, 255, 255, 255 )
	--surface.SetMaterial( leveldata.ico )
	--surface.DrawTexturedRect( 300, scrh - 100, icowidth, icosize )

    surface.SetFont( "TimeLeft" )

    --draw.DrawText(clientlevel, "MainMenuFont", 300+icowidth/2 + 2, scrh - 35 - icosize/2 + 2, color_black, TEXT_ALIGN_CENTER)
    

 	   if client:GTeam() != TEAM_SPEC and ply:GTeam() != TEAM_SCP then

		    ----------------------------[BLINKhud]----------------------------
			--

			local bd = 3
			local blink = blinkHUDTime
		    if var == nil then 
			    var = 100; 
		    end

		    local scp173 = nil
		    local scps = gteams.GetPlayers(TEAM_SCP)
		    for i = 1, #scps do
		    	if IsValid(scps[i]) and scps[i]:GetRoleName() == SCP173 then scp173 = scps[i]:GetNWEntity("SCP173Statue") end
		    end
		    if #scps > 0 and IsValid(scp173) and CanSeePlayer(scp173) then
		    	scp173_lerp = Lerp(FrameTime()*10, scp173_lerp, 1)
		    else
		    	scp173_lerp = Lerp(FrameTime()*8, scp173_lerp, 0)
		    end
		    if scp173_lerp > 0.05 then
	            draw.RoundedBox(0, 10, scrh-50-150, 40, 40, ColorAlpha(blinkblack, scp173_lerp*255));
	            draw.RoundedBox(0, 60, scrh-44-150, 211, 28, ColorAlpha(blinkalmostblack, scp173_lerp*200));
	            surface.SetDrawColor(255, 255, 255, scp173_lerp*255);

	            surface.SetMaterial(blinkmat);
	            surface.DrawTexturedRect(13, scrh-47-150, 34, 34);

	            surface.SetDrawColor(255, 255, 255, scp173_lerp*75);
	            surface.DrawOutlinedRect(10, scrh-50-150, 40, 40);

	            surface.DrawOutlinedRect(60, scrh-44-150, 211, 28);

	            surface.SetDrawColor(255, 255, 255, scp173_lerp*200);
	            surface.SetMaterial(icoindex2);
			    local bbars = 0
			    local bbars = blink / bd * 16
			    if bbars > 16 then 
				    bbars = 16 
			    end
			    local col = ColorAlpha(color_white, scp173_lerp*255)

			    if eyedropeffect > CurTime() then
			    	eyedropeffectclr["a"] = Pulsate( 2 ) * 120
			    	col = eyedropeffectclr
			    end
			    surface.SetDrawColor(col)
			    surface.SetMaterial(icoindex2)
			    for i=1, bbars do
				    surface.DrawTexturedRect(62 + (i-1)*13, scrh-42-150, 12, 24);
			    end
			  end
		    blink = string.format("%.1f", blink)
		    bd = string.format("%.1f", bd)
			--

	end
	----------------------------[ROLEhud]----------------------------

	  if cl == nil then cl = rolealmostwhite; end
	  --draw.RoundedBox(0, 10, scrh-50-50, 40, 40, roleblack);
	  --draw.RoundedBox(0, 60, scrh-44-50, 175, 28, rolealmostblack);
	  surface.SetDrawColor(255, 255, 255);

	  surface.SetMaterial(newr);
	  surface.DrawTexturedRect(13, scrh-47-50, 34, 34);

	  --surface.SetDrawColor(255, 255, 255, 75);
	  --surface.DrawOutlinedRect(10, scrh-50-50, 40, 40);

	  

--clientlevel
	  --surface.DrawOutlinedRect(60, scrh-44-50, 175, 28);
	  surface.SetDrawColor(255, 255, 255);
	  surface.SetMaterial(newrl);
	  surface.DrawTexturedRect(60, scrh-44-50, 28, 28);

	  draw.SimpleText( clientlevel, "ImpactSmall2n", 30, scrh-44-35, rolealmostwhite, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);

		surface.SetDrawColor(255, 255, 255);
	  surface.SetMaterial(newrr);
	  surface.DrawTexturedRect(60  + 147, scrh-44-50, 28, 28);

	  local hud_obs = client:GetObserverTarget()
	  local hud_target = IsValid(hud_obs) and hud_obs or client
	  local hud_role = hud_target:GetRoleName()
	  local hud_role_color = gteams.GetColor(hud_target:GTeam())
	  draw.RoundedBox(0, 62, scrh-42-50, 171, 24, Color(hud_role_color.r,hud_role_color.g,hud_role_color.b,100));

	  draw.SimpleText( GetLangRole(hud_role), "BudgetLabel", 147, scrh-79, rolealmostwhite, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);

	--end
		if client:GTeam() != TEAM_SPEC then


		local screenwidth, screenheight = ScrW(), scrh
		----------------------------[HPhud]----------------------------
		boostcolor["a"] = Pulsate( 2 ) * 75

		local boosted = ply:GetBoosted()

		surface.SetDrawColor(255, 255, 255)
		surface.SetMaterial(healthmatnew)
		surface.DrawTexturedRect(13, scrh-47, 34, 34)

		surface.SetDrawColor(255, 255, 255)
		surface.SetMaterial(newr)
		surface.DrawTexturedRect(13, scrh-47, 34, 34)

		surface.SetDrawColor(255, 255, 255)
		surface.SetMaterial(newrl)
		surface.DrawTexturedRect(60, scrh-44, 28, 28)

		surface.SetDrawColor(255, 255, 255)
		surface.SetMaterial(newrr)
		surface.DrawTexturedRect(60 + 183, scrh-44, 28, 28)

		local currentHealth = math.Clamp(math.ceil(hp * 16 / maxhp), 0, 16)

		if math.abs(currentHealth - lastHealth) > 5 then
		    healthBars = {}
		end

		for i = 1, 16 do
		    if not healthBars[i] then
		        healthBars[i] = {
		            scale = 0,
		            alpha = 0,
		            pop = 0,
		            active = false
		        }
		    end
		end

		for i = 1, 16 do
		    local bar = healthBars[i]
		
		    if i <= currentHealth then
		        if not bar.active then
		            bar.active = true
		            bar.scale = 0
		            bar.alpha = 0
		            bar.pop = 0
		        end
			
		        if bar.scale < 1 then
		            bar.scale = Lerp(FrameTime() * 10, bar.scale, 1)
		        end
		        if bar.alpha < 1 then
		            bar.alpha = Lerp(FrameTime() * 8, bar.alpha, 1)
		        end
		    else
		        if bar.active then
		            bar.active = false
		            bar.pop = 0
		        end
			
		        if bar.scale > 0 then
		            bar.pop = Lerp(FrameTime() * 12, bar.pop, 1)
		            if bar.pop > 0.7 then
		                bar.scale = Lerp(FrameTime() * 15, bar.scale, 0)
		                bar.alpha = Lerp(FrameTime() * 12, bar.alpha, 0)
		            end
		        end
		    end
		end

		for i = 1, 16 do
		    local bar = healthBars[i]
		    if bar.alpha > 0.01 then
		        local xPos = 62 + (i-1) * 13
		        local yPos = scrh-42
			
		        local width = 12 * bar.scale
		        local height = 24 * bar.scale
		        local xOffset = (12 - width) / 2
		        local yOffset = (24 - height) / 2
			
		        if bar.pop > 0 then
		            local popScale = 1 + bar.pop * 0.4
		            width = 12 * bar.scale * popScale
		            height = 24 * bar.scale * popScale
		            xOffset = (12 - width) / 2
		            yOffset = (24 - height) / 2
		        end
			
		        local healthColor = Color(255, 255, 255, 100 * bar.alpha)
			
		        if boosted then
		            local boostAlpha = Pulsate(2) * 200 * bar.alpha
		            local boostColor = Color(0, 255, 0, boostAlpha)
		            draw.RoundedBox(2, xPos + xOffset - 2, yPos + yOffset - 2, 
		                           width + 4, height + 4, boostColor)
		        end
			
		        if bar.pop > 0.1 then
		            local popAlpha = (1 - bar.pop) * bar.alpha * 0.8
		            local popColor = Color(255, 50, 50, 120 * popAlpha)
		            local popSize = bar.pop * 10
				
		            draw.RoundedBox(4, xPos + xOffset - popSize/2, yPos + yOffset - popSize/2, 
		                           width + popSize, height + popSize, popColor)
		        end
			
		        draw.RoundedBox(2, xPos + xOffset, yPos + yOffset, width, height, healthColor)
			
		        if boosted and bar.active and bar.scale > 0.7 and bar.pop == 0 then
		            local glowAlpha = math.sin(RealTime() * 10) * 40 + 60
		            local glowColor = Color(0, 255, 0, glowAlpha * bar.alpha)
		            draw.RoundedBox(2, xPos + xOffset - 1, yPos + yOffset - 1, 
		                           width + 2, height + 2, glowColor)
		        end
		    end
		end

		if boosted then
		    boostcolor["a"] = Pulsate(2) * 120
		    draw.OutlinedBox(10, screenheight - 50, 40, 40, 2, boostcolor)
		end

		draw.SimpleText(hp .. " / " .. maxhp, "BudgetLabel", 165, scrh-29, hpcoloralmostwhite, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

		lastHealth = currentHealth
	----------------------------[STAMINAhud]----------------------------
			if ply:GTeam() != TEAM_SCP or ply.SCP035_IsWear then
			    local energized = ply:GetEnergized()
			    local adrenaline = ply:GetAdrenaline()
			
			    surface.SetDrawColor(255, 255, 255)
			    surface.SetMaterial(staminamatnew)
			    surface.DrawTexturedRect(13, scrh-47-100, 34, 34)
			
			    local currentStamina = math.Round(stamina / (ply:GetStaminaScale() * 100) * 16)
			    if currentStamina > 16 then 
			        currentStamina = 16 
			    end
			
			    if math.abs(currentStamina - lastStamina) > 5 then
			        staminaBars = {}
			    end
			
			    for i = 1, 16 do
			        if not staminaBars[i] then
			            staminaBars[i] = {
			                scale = 0,
			                alpha = 0,
			                pop = 0,
			                active = false
			            }
			        end
			    end
			
			    for i = 1, 16 do
			        local bar = staminaBars[i]
				
			        if i <= currentStamina then
			            if not bar.active then
			                bar.active = true
			                bar.scale = 0
			                bar.alpha = 0
			                bar.pop = 0
			            end
					
			            if bar.scale < 1 then
			                bar.scale = Lerp(FrameTime() * 10, bar.scale, 1)
			            end
			            if bar.alpha < 1 then
			                bar.alpha = Lerp(FrameTime() * 8, bar.alpha, 1)
			            end
			        else
			            if bar.active then
			                bar.active = false
			                bar.pop = 0
			            end
					
			            if bar.scale > 0 then
			                bar.pop = Lerp(FrameTime() * 12, bar.pop, 1)
			                if bar.pop > 0.7 then
			                    bar.scale = Lerp(FrameTime() * 15, bar.scale, 0)
			                    bar.alpha = Lerp(FrameTime() * 12, bar.alpha, 0)
			                end
			            end
			        end
			    end
			
			    surface.SetDrawColor(255, 255, 255)
			    surface.SetMaterial(newr)
			    surface.DrawTexturedRect(13, scrh-47-100, 34, 34)
			
			    surface.SetDrawColor(255, 255, 255)
			    surface.SetMaterial(newrl)
			    surface.DrawTexturedRect(60, scrh-44-100, 28, 28)
			
			    surface.SetDrawColor(255, 255, 255)
			    surface.SetMaterial(newrr)
			    surface.DrawTexturedRect(60 + 183, scrh-44-100, 28, 28)
			
			    for i = 1, 16 do
			        local bar = staminaBars[i]
			        if bar.alpha > 0.01 then
			            local xPos = 62 + (i-1) * 13
			            local yPos = scrh-42-100
					
			            local width = 12 * bar.scale
			            local height = 24 * bar.scale
			            local xOffset = (12 - width) / 2
			            local yOffset = (24 - height) / 2
					
			            if bar.pop > 0 then
			                local popScale = 1 + bar.pop * 0.4
			                width = 12 * bar.scale * popScale
			                height = 24 * bar.scale * popScale
			                xOffset = (12 - width) / 2
			                yOffset = (24 - height) / 2
			            end
					
			            local barColor
			            if energized then
			                barColor = Color(255, 255, 0, 100 * bar.alpha)
			            elseif adrenaline then
			                barColor = Color(0, 198, 198, 100 * bar.alpha)
			            elseif exhausted then
			                barColor = Color(255, 255, 255, 20 * bar.alpha)
			            else
			                barColor = Color(255, 255, 255, 100 * bar.alpha)
			            end
					
			            if bar.pop > 0.1 then
			                local popAlpha = (1 - bar.pop) * bar.alpha * 0.8
			                local popColor = Color(255, 50, 50, 0 * popAlpha)
			                local popSize = bar.pop * 10
						
			                draw.RoundedBox(4, xPos + xOffset - popSize/2, yPos + yOffset - popSize/2, 
			                               width + popSize, height + popSize, popColor)
			            end
					
			            draw.RoundedBox(2, xPos + xOffset, yPos + yOffset, width, height, barColor)
					
			            if (energized or adrenaline) and bar.active and bar.scale > 0.7 and bar.pop == 0 then
			                local glowAlpha = math.sin(RealTime() * 10) * 20 + 30
			                local glowColor
			                if energized then
			                    glowColor = Color(255, 255, 0, glowAlpha * bar.alpha)
			                else
			                    glowColor = Color(0, 198, 198, glowAlpha * bar.alpha)
			                end
			                draw.RoundedBox(2, xPos + xOffset - 1, yPos + yOffset - 1, 
			                               width + 2, height + 2, glowColor)
			            end
			        end
			    end
			
			    lastStamina = currentStamina
			end
	   end

	   local activeweapon = LocalPlayer():GetActiveWeapon()

	   if IsValid(activeweapon) and activeweapon:GetClass() == "item_tazer" and activeweapon:Clip1() < 100 and ply:KeyDown(IN_RELOAD) then
	   	tazer_lerp = Lerp(FrameTime()*2, tazer_lerp, 1)
	   else
	   	tazer_lerp = math.Approach(tazer_lerp, 0, FrameTime()*2)
	   end

	   if tazer_lerp != 0 then
		   draw.RoundedBox(0, scrw/2-40/2, scrh/1.3-50, 40, 60, ColorAlpha(blinkblack, tazer_lerp*235));

		   surface.SetDrawColor(255, 255, 255, tazer_lerp*235);
		   surface.SetMaterial(tazermat);
	     surface.DrawTexturedRect(scrw/2-34/2, scrh/1.3-47, 34, 34);

	     surface.SetDrawColor(245, 255, 250, tazer_lerp*255)
	     surface.DrawOutlinedRect(scrw/2-40/2, scrh/1.3-50, 40, 60);

	     if IsValid(activeweapon) and activeweapon:GetClass() == "item_tazer" then
	     	local clip = activeweapon:Clip1()
	     	local col = color_white
	     	local alpha = 255
	     	if clip <= 2 then
	     		col = Color(200,0,0)
	     		alpha = Pulsate(4)*255
	     	end
	     --	draw.SimpleTextOutlined(string Text, string font = DermaDefault, number x = 0, number y = 0, table color = Color( 255, 255, 255, 255 ), number xAlign = TEXT_ALIGN_LEFT, number yAlign = TEXT_ALIGN_TOP, number outlinewidth, table outlinecolor = Color( 255, 255, 255, 255 ))
		     draw.DrawText(clip, "tazer_font", scrw/2, scrh/1.3-13, ColorAlpha(col, tazer_lerp*alpha), TEXT_ALIGN_CENTER)
		   end
		end

	--surface.SetDrawColor( 255,  255,  255, endings )
    --surface.SetMaterial( self.icon || "nextoren/gui/icons/notifications/breachiconfortips.png" )
    --surface.DrawTexturedRect( 0, 0, w, h )


	-- Обновленный health бар
    --[[if ply:IsSpeaking() then
		surface.SetDrawColor(Color(255,255,255,255))
		surface.SetMaterial(Material("microphone.png"))
		surface.DrawTexturedRect(widthz * 0.145, heightz * 0.945 + offset, heightz * 0.034, heightz * 0.035)
    end]]
   --else
   	--DRAWHUDSTYLE(hud_style:GetInt(), ply)
   --end


 end
 	----------------------------[GAMEMODE Version]----------------------------

end ) --End HUDPaint hook

local offset = Vector( 0, 0, 85 )
local lvlcolor = Color(255, 255, 255, 255)
local angletoedit = Angle( 0, 0, 90 )
local talkcolor1 = Color( 255, 255, 255, 200 )
local talkcolor2 = Color( 0, 0, 0, 255 )
local cam = cam
local camstart3d2d = cam.Start3D2D
local camend3d2d = cam.End3D2D
local drawsimpletextoutlined = draw.SimpleTextOutlined

function GetColorByValue(value)
    -- Ограничиваем значение от 1 до 150
    value = math.Clamp(value, 1, 150)
    
    -- Нормализуем значение от 0 до 1
    local normalized = (value - 1) / 149
    
    -- Разбиваем на 6 цветовых сегментов для большего разнообразия
    if normalized < 0.16 then
        -- От темно-серого к темно-синему (1-25)
        local factor = normalized / 0.16
        return Color(
            math.floor(70 + factor * 30),      -- R: 70-100
            math.floor(70 + factor * 30),      -- G: 70-100
            math.floor(90 + factor * 40)       -- B: 90-130
        )
    elseif normalized < 0.32 then
        -- От темно-синего к темно-зеленому (25-48)
        local factor = (normalized - 0.16) / 0.16
        return Color(
            math.floor(60 - factor * 30),      -- R: 60-30
            math.floor(80 + factor * 40),      -- G: 80-120
            math.floor(110 + factor * 30)      -- B: 110-140
        )
    elseif normalized < 0.48 then
        -- От темно-зеленого к оливковому (48-72)
        local factor = (normalized - 0.32) / 0.16
        return Color(
            math.floor(40 + factor * 50),      -- R: 40-90
            math.floor(100 + factor * 40),     -- G: 100-140
            math.floor(120 - factor * 40)      -- B: 120-80
        )
    elseif normalized < 0.64 then
        -- От оливкового к приглушенному желтому (72-96)
        local factor = (normalized - 0.48) / 0.16
        return Color(
            math.floor(90 + factor * 40),      -- R: 90-130
            math.floor(130 + factor * 30),     -- G: 130-160
            math.floor(70 - factor * 40)       -- B: 70-30
        )
    elseif normalized < 0.80 then
        -- От желтого к оранжевому (96-120)
        local factor = (normalized - 0.64) / 0.16
        return Color(
            math.floor(130 + factor * 40),     -- R: 130-170
            math.floor(140 - factor * 40),     -- G: 140-100
            math.floor(40 + factor * 20)       -- B: 40-60
        )
    else
        -- От оранжевого к темно-красному (120-150)
        local factor = (normalized - 0.80) / 0.20
        return Color(
            math.floor(150 + factor * 50),     -- R: 150-200
            math.floor(90 - factor * 50),      -- G: 90-40
            math.floor(50 + factor * 20)       -- B: 50-70
        )
    end
end

function GetContrastTextColor(backgroundColor)
    -- Вычисляем яркость фона по формуле: 0.299*R + 0.587*G + 0.114*B
    local brightness = (backgroundColor.r * 0.299 + backgroundColor.g * 0.587 + backgroundColor.b * 0.114) / 255
    
    -- Если фон светлый - возвращаем темный текст, иначе светлый
    if brightness > 0.5 then
        return Color(0, 0, 0) -- Черный текст для светлого фона
    else
        return Color(255, 255, 255) -- Белый текст для темного фона
    end
end

-- Улучшенная версия с более точным определением контраста
function GetSmartContrastTextColor(backgroundColor)
    -- Альтернативная формула для определения контраста
    local luminance = (0.2126 * backgroundColor.r + 0.7152 * backgroundColor.g + 0.0722 * backgroundColor.b) / 255
    
    if luminance > 0.6 then
        return Color(0, 0, 0, 255) -- Черный
    elseif luminance > 0.4 then
        return Color(50, 50, 50, 255) -- Темно-серый
    elseif luminance > 0.2 then
        return Color(200, 200, 200, 255) -- Светло-серый
    else
        return Color(255, 255, 255, 255) -- Белый
    end
end

local whiteblack = ColorAlpha( color_white, 200 )
local offset = Vector( 0, 0, 20 )
local alivepl = {}

local team_index_spec, team_index_scp = TEAM_SPEC, TEAM_SCP

local max_distance = 90000 -- 300

function DrawTextInformation()

  local client = LocalPlayer()
  if ( client:GTeam() == team_index_spec ) then return end
  if GetConVar("breach_config_screenshot_mode"):GetInt() == 1 then return end

  if ( ( alivepl.NextUpdate || 0 ) < CurTime() ) then

    alivepl = player.GetAll()
    alivepl.NextUpdate = CurTime() + .8

  end

  for i = 1, #alivepl do

    local player = alivepl[ i ]

    if ( player == client ) then continue end
    if ( !( player && player:IsValid() ) ) then continue end

    if ( player:GetNoDraw() ) then continue end

    local speaking = player:IsSpeaking()
    local typing = player:IsTyping()

    if ( !( typing || speaking ) ) then continue end

    local Distance = client:GetPos():DistToSqr( player:GetPos() )
    if ( Distance > max_distance ) then continue end

    local player_team = player:GTeam()

    local BoneIndx = player:LookupBone( "ValveBiped.Bip01_Head1" )

    --local str = player:GetNW2String( "chattext", "" )

    if ( player_team == team_index_spec || player_team == team_index_scp ) then continue end

    if ( typing || speaking ) then

      if ( !isnumber( BoneIndx ) ) then continue end

      local BonePos = player:GetBonePosition( BoneIndx )
      BonePos:Add( offset )

      local eyeang = client:EyeAngles().y - 90
      local ang = Angle( 0, eyeang, 90 )

      cam.Start3D2D( BonePos, ang, .1 )

        if ( typing or speaking ) then

          draw.SimpleText( BREACH.TranslateString("l:speaks"), "char_title", 1, 45, whiteblack, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

        end

      cam.End3D2D()

    end

  end

end
hook.Add( "PostDrawTranslucentRenderables", "TalkingSpeakinginfo", DrawTextInformation)



end --BreachHUDInitialize function end

hook.Add("InitPostEntity", "BreachHUDInitialize", BreachHUDInitialize)

--autorefresh support
if isfunction(BreachHUDInitialize) then
	BreachHUDInitialize()
end
--from nextoren 1.0
local ANGLE = FindMetaTable("Angle")

function ANGLE:CalculateVectorDot( vec )
	local x = self:Forward():DotProduct( vec )
	local y = self:Right():DotProduct( vec )
	local z = self:Up():DotProduct( vec )

	return Vector( x, y, z )
end

--[[ HeadBob  Functions ]]--

local step = 0
local MovementDot = { x = 0, y = 0, z = 0 }
local vel = 0
local cos = 0
local plane = 0
local scale = 1
local y = 0

local team_spec_index, team_scp_index = TEAM_SPEC, TEAM_SCP

local forbidden_teams = {

	[ TEAM_SPEC ] = true,
	[ TEAM_SCP ] = true

}

hook.Add( "Think", "ViewBob_Think", function()

	local client = LocalPlayer()

	if ( !forbidden_teams[ client:GTeam() ] && client:Health() > 0 && client:GetMoveType() != MOVETYPE_NOCLIP ) then

		vel = client:GetVelocity()
		MovementDot = EyeAngles():CalculateVectorDot( vel )
		--print( MovementDot )
		step = 18

		if ( client:Health() < client:GetMaxHealth() * .3 ) then

			scale = 2
			step = 20

		end

		cos = math.cos( SysTime() * step )
		plane = ( math.max( math.abs( MovementDot.x ) - 100, 0 ) + math.max( math.abs( MovementDot.y ) - 100, 0 ) ) / 128

		y = math.cos( SysTime() * step / 2 ) * plane * scale

	end

end )

local vec_zero = vector_origin

hook.Add( "CalcViewModelView", "CalcViewModel", function( wep, v, oldPos, oldAng, ipos, iang )

	local client = LocalPlayer()

	if client:GetInDimension() then return end

	if ( !forbidden_teams[ client:GTeam() ] && client:Health() > 0 && ( ( !isnumber( vel ) && vel:Length2DSqr() > .25 ) || client:GetVelocity():Length2DSqr() > .25 ) && client:GetMoveType() != MOVETYPE_NOCLIP ) then

		local pos, ang

		if ( isfunction( wep.GetViewModelPosition ) ) then

			pos, ang = wep:GetViewModelPosition( ipos, iang )

		else

			pos = ipos
			ang = iang

		end

		local origin = Vector( 0, y, ( cos * plane ) * scale )
		origin:Rotate( ang )

		return origin + pos - ( transition != 0 && Vector( 0, 0, transition ) || vec_zero ), ang

	end

end )

----------------------------

local cam_1_lerp = 0
local cam_wait = 0
local cam_mode = 0

local function drawmat(x,y,w,h,mat)

  surface.SetDrawColor(color_white)
  surface.SetMaterial(mat)
  surface.DrawTexturedRect(x,y,w,h)

end

local cam_fov = 100
local my_cam_fov = cam_fov

local gradient = Material("vgui/gradient-r")
local gradient2 = Material("vgui/gradient-l")
local gradients = Material("gui/center_gradient")
local grad1 = Material("vgui/gradient-u")
local grad2 = Material("vgui/gradient-d")

function BREACH.OpenCameraMenu()
	if IsValid(BREACH.CAMERA_PANEL) then BREACH.CAMERA_PANEL:Remove() end
	if !LocalPlayer().br_camera_mode then return end
	if LocalPlayer():Health() <= 0 then return end
	BREACH.CAMERA_PANEL = vgui.Create("DPanel")
	BREACH.CAMERA_PANEL:SetSize(ScrW(), ScrH())
	BREACH.CAMERA_PANEL:MakePopup()
	BREACH.CAMERA_PANEL.Paint = function()
		draw.DrawText("[Legacy] NetLink V2", "ScoreboardHeader", 10, 10, nil, TEXT_ALIGN_LEFT)
		draw.DrawText("Видеовыход：Пиздатый", "ScoreboardHeader", 10, 70, nil, TEXT_ALIGN_LEFT)
		draw.DrawText("Аудиовыход：Нормальный", "ScoreboardHeader", 10, 110, nil, TEXT_ALIGN_LEFT)
		draw.DrawText("Маштаб: "..tostring(math.floor((100/cam_fov)*100)).."%", "ScoreboardHeader", 10, 110+40, nil, TEXT_ALIGN_LEFT)
	end
	local scrw, scrh = ScrW(), ScrH()
	BREACH.CAMERA_PANEL.Think = function(self)
	
		if !LocalPlayer().br_camera_mode or LocalPlayer():Health() <= 0 then
			self:Remove()
		end

	end

	local close = vgui.Create("DButton", BREACH.CAMERA_PANEL)

	close:SetSize(100,60)
	close:SetText("")

	close:SetPos(20,scrh-80)

	local col_bg = Color(0,0,0,100)

	close.DoClick = function()

		surface.PlaySound("nextoren/gui/camera/button_click.wav")
	
		LocalPlayer():ScreenFade(SCREENFADE.IN, color_black, 1, 1)
		LocalPlayer().br_camera_mode = false
		BREACH.CAMERA_PANEL:Remove()
		net.Start("camera_exit")
		net.SendToServer()

	end

	close.Paint = function(self, w, h)

		draw.RoundedBox(0, 0, 0, w, h, col_bg)

		DrawBlurPanel(self)

		drawmat(0,0,w,1,gradients)
		drawmat(0,h-1,w,1,gradients)

		surface.SetDrawColor(color_white)
		surface.SetMaterial(grad2)
		surface.DrawTexturedRect(1, 0, 1, h/2)
		surface.SetMaterial(grad1)
		surface.DrawTexturedRect(1, h/2, 1, h/2)

		surface.SetDrawColor(color_white)
		surface.SetMaterial(grad2)
		surface.DrawTexturedRect(w-1, 0, 1, h/2)
		surface.SetMaterial(grad1)
		surface.DrawTexturedRect(w-1, h/2, 1, h/2)
		draw.DrawText("End", "ScoreboardHeader", w/2,h/2-17, nil, TEXT_ALIGN_CENTER)
  end

  local next = vgui.Create("DButton", BREACH.CAMERA_PANEL)

	next:SetSize(100,60)
	next:SetText("")

	next.DoClick = function()
		surface.PlaySound("nextoren/gui/camera/button_click.wav")
		net.Start("camera_swap")
		net.WriteBool(true)
		net.SendToServer()
		LocalPlayer():ScreenFade(SCREENFADE.IN, color_black, 1, 1)
	end

	next:SetPos(scrw/2,scrh-140)

	next.Paint = function(self, w, h)

		draw.RoundedBox(0, 0, 0, w, h, col_bg)

		DrawBlurPanel(self)

		drawmat(0,0,w,1,gradients)
		drawmat(0,h-1,w,1,gradients)

		surface.SetDrawColor(color_white)
		surface.SetMaterial(grad2)
		surface.DrawTexturedRect(1, 0, 1, h/2)
		surface.SetMaterial(grad1)
		surface.DrawTexturedRect(1, h/2, 1, h/2)

		surface.SetDrawColor(color_white)
		surface.SetMaterial(grad2)
		surface.DrawTexturedRect(w-1, 0, 1, h/2)
		surface.SetMaterial(grad1)
		surface.DrawTexturedRect(w-1, h/2, 1, h/2)
		draw.DrawText("Next", "ScoreboardHeader", w/2,h/2-17, nil, TEXT_ALIGN_CENTER)
  end

  local prev = vgui.Create("DButton", BREACH.CAMERA_PANEL)

	prev:SetSize(100,60)
	prev:SetText("")

	prev:SetPos(scrw/2-100,scrh-140)

	prev.DoClick = function()
		surface.PlaySound("nextoren/gui/camera/button_click.wav")
		net.Start("camera_swap")
		net.WriteBool(false)
		net.SendToServer()
		LocalPlayer():ScreenFade(SCREENFADE.IN, color_black, 1, 1)
	end

	prev.Paint = function(self, w, h)

		draw.RoundedBox(0, 0, 0, w, h, col_bg)

		DrawBlurPanel(self)

		drawmat(0,0,w,1,gradients)
		drawmat(0,h-1,w,1,gradients)

		surface.SetDrawColor(color_white)
		surface.SetMaterial(grad2)
		surface.DrawTexturedRect(1, 0, 1, h/2)
		surface.SetMaterial(grad1)
		surface.DrawTexturedRect(1, h/2, 1, h/2)

		surface.SetDrawColor(color_white)
		surface.SetMaterial(grad2)
		surface.DrawTexturedRect(w-1, 0, 1, h/2)
		surface.SetMaterial(grad1)
		surface.DrawTexturedRect(w-1, h/2, 1, h/2)
		draw.DrawText("Last", "ScoreboardHeader", w/2,h/2-17, nil, TEXT_ALIGN_CENTER)
  end

  local zoomin = vgui.Create("DButton", BREACH.CAMERA_PANEL)

	zoomin:SetSize(170,60)
	zoomin:SetText("")

	zoomin:SetPos(scrw/2,scrh-80)

	zoomin.Paint = function(self, w, h)

		draw.RoundedBox(0, 0, 0, w, h, col_bg)

		DrawBlurPanel(self)

		drawmat(0,0,w,1,gradients)
		drawmat(0,h-1,w,1,gradients)

		surface.SetDrawColor(color_white)
		surface.SetMaterial(grad2)
		surface.DrawTexturedRect(1, 0, 1, h/2)
		surface.SetMaterial(grad1)
		surface.DrawTexturedRect(1, h/2, 1, h/2)

		surface.SetDrawColor(color_white)
		surface.SetMaterial(grad2)
		surface.DrawTexturedRect(w-1, 0, 1, h/2)
		surface.SetMaterial(grad1)
		surface.DrawTexturedRect(w-1, h/2, 1, h/2)
		draw.DrawText("+Fov", "ScoreboardHeader", w/2,h/2-17, nil, TEXT_ALIGN_CENTER)
  end

  zoomin.DoClick = function()
  	surface.PlaySound("nextoren/gui/camera/button_click.wav")
  	cam_fov = math.max(cam_fov - 10, 60)
  end

  local zoomout = vgui.Create("DButton", BREACH.CAMERA_PANEL)

	zoomout:SetSize(170,60)
	zoomout:SetText("")

	zoomout:SetPos(scrw/2-170,scrh-80)

	zoomout.DoClick = function()
		surface.PlaySound("nextoren/gui/camera/button_click.wav")
  	cam_fov = math.min(cam_fov + 10, 100)
  end

	zoomout.Paint = function(self, w, h)

		draw.RoundedBox(0, 0, 0, w, h, col_bg)

		DrawBlurPanel(self)

		drawmat(0,0,w,1,gradients)
		drawmat(0,h-1,w,1,gradients)

		surface.SetDrawColor(color_white)
		surface.SetMaterial(grad2)
		surface.DrawTexturedRect(1, 0, 1, h/2)
		surface.SetMaterial(grad1)
		surface.DrawTexturedRect(1, h/2, 1, h/2)

		surface.SetDrawColor(color_white)
		surface.SetMaterial(grad2)
		surface.DrawTexturedRect(w-1, 0, 1, h/2)
		surface.SetMaterial(grad1)
		surface.DrawTexturedRect(w-1, h/2, 1, h/2)
		draw.DrawText("-Fov", "ScoreboardHeader", w/2,h/2-17, nil, TEXT_ALIGN_CENTER)
  end

end

net.Receive("camera_enter", function(len)

	LocalPlayer():ScreenFade(SCREENFADE.IN, color_black, 1, 1)
	LocalPlayer().br_camera_mode = true
	BREACH.OpenCameraMenu()

end)

concommand.Add("enter_camera_mode", function()
	net.Start("camera_enter")
	net.SendToServer()
end)

function GM:CalcView( ply, origin, angles, fov )

	local data = {}
	data.origin = origin
	data.angles = angles
	data.fov = fov
	data.drawviewer = false

	if ply:GetInDimension() and ply:GTeam() != TEAM_SCP then
		data.angles = angles + Angle(math.Rand(-0.5,0.5),math.Rand(-0.5,0.5),0)
		return data
	end
	if ply:GetTable()["br_camera_mode"] then
		my_cam_fov = math.Approach(my_cam_fov, cam_fov, FrameTime()*30)
		data.fov = my_cam_fov
		data.angles.p = data.angles.p + 20
		if cam_wait == 0 then
			if cam_mode == 1 then
				cam_1_lerp = math.Approach(cam_1_lerp, -30, FrameTime()*8)
				if cam_1_lerp == -30 then
					cam_wait = 2
					cam_mode = 0
				end
			else
				cam_1_lerp = math.Approach(cam_1_lerp, 30, FrameTime()*8)
				if cam_1_lerp == 30 then
					cam_wait = 2
					cam_mode = 1
				end
			end
		else
			cam_wait = math.Approach(cam_wait, 0, FrameTime())
		end
		data.angles.y = data.angles.y - cam_1_lerp
		return data
	end

	if ( !forbidden_teams[ ply:GTeam() ] && ply:Health() > 0 && ( ( !isnumber( vel ) && vel:Length2DSqr() > .25 ) || ply:GetVelocity():Length2DSqr() > .25 ) && ply:GetMoveType() != MOVETYPE_NOCLIP ) then

		local pos = Vector( 0, y, ( cos * plane ) * scale )
		pos:Rotate( EyeAngles() )

		data.origin.x = origin.x + pos.x
		data.origin.y = origin.y + pos.y
		data.origin.z = origin.z + pos.z

		data.angles.p = angles.p + ( math.abs( math.cos( SysTime() * step / 2 ) ) * ( MovementDot.x || 1 ) / 400 ) * scale
		data.angles.y = angles.y + ( y / 6.4 )
		data.angles.r = angles.r + ( y / 4 ) * scale

	end

	local wep = ply:GetActiveWeapon()

	if ( wep != NULL && wep.CalcView ) then

		local vec, ang, ifov = wep:CalcView( ply, origin, angles, fov )

		data.origin = vec
		data.angles = ang
		data.fov = ifov

	end

	if ( ply.RealLean != 0 && ply:IsSolid() ) then

		if ( !ply.RealLean ) then

			ply.RealLean = 0

			return
		end

		local lean = ply.RealLean

		data.angles:RotateAroundAxis( data.angles:Forward(), lean )
		data.origin = data.origin + data.angles:Right() * lean

	end

	if ( ply.FOVTest && ply.FOVTest > 0 ) then

		if ( ply.FOVStartDecrease ) then

			ply.FOVTest = math.Approach( ply.FOVTest, 0, RealFrameTime() * 10 )

		end

		data.fov = data.fov - ply.FOVTest

	end

	--data.drawviewer = true
	--dir = dir || vector_origin

	--data.origin = ply:GetPos() + Vector( 0, -80, 74 )
	--data.angles = Angle( 10, 90, 0 )

	if ply:GTeam() == TEAM_SPEC then
		data.angles.r = 0
	end

	return data

end


local flag_color = Color(255, 255, 0)
local cibase = Vector(-3647.96484375, 2575.8522949219, 10.03125)
local ci_color = Color(29, 81, 56, 255)
local qrtbase = Vector(1728.6828613281, 4175.8920898438, 10.03125)
local qrt_color = Color(90, 90, 255, 255)

local shawms = shawms or {}

hook.Add("OnEntityCreated", "CTF_SoftEntityList", function(ent)
	if ent:GetClass() == "item_ctf_doc" then
		table.insert(shawms, ent)
	end
end)

hook.Add("EntityRemoved", "CTF_SoftEntityList", function(ent)
	if ent:GetClass() == "item_ctf_doc" then
		for k, v in pairs(shawms) do
			if !IsValid(v) then
				table.remove(shawms, k)
			end
		end
	end
end)

hook.Add("HUDPaint", "CTF_Paint", function()
	local client = LocalPlayer()

	for i=1, #shawms do
		local v = shawms[i]
		if IsValid(v) then
			local vpos = v:GetPos()
			local point = v:GetAngles():Up() * 7 + vpos --model has fucked up center
			local vec = point:ToScreen()

			if vec.visible then
				--draw.SimpleText("SHAWM", "BudgetLabel", vec.x, vec.y, flag_color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			end
		end
	end

	if GetGlobalString("RoundName") != "CTF" then return end

	if client:GTeam() == TEAM_CHAOS then
		local cibase_screen = cibase:ToScreen()

		if cibase_screen.visible then
			draw.SimpleText("CI", "BudgetLabel", cibase_screen.x, cibase_screen.y, ci_color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
	end

	if client:GTeam() == TEAM_QRT then
		local qrtbase_screen = qrtbase:ToScreen()

		if qrtbase_screen.visible then
			draw.SimpleText("QRT", "BudgetLabel", qrtbase_screen.x, qrtbase_screen.y, qrt_color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
	end
end)

net.Receive("Special_outline", function(len)

	local team = net.ReadUInt(16)
	if team == TEAM_CLASSD then team = TEAM_CHAOS end
	Show_Spy(team)

end)

local scarletmat = Material("nextoren/gui/roles_icon/ar.png")

hook.Add("PostDrawTranslucentRenderables", "support_trigger_ui", function(bDepth, bSkybox)
    local client = LocalPlayer()
    if not client:GetNWBool('ChipedByAndersonRobotik', false) then return end
    if not client:HasWeapon("kasanov_ar_disk") then return end
	--self:SetPos(Vector(1591, 4105, 64))
   --self:SetAngles(Angle(90,0,90))
    --local triggers = ents.FindByClass("kasanov_ar_spawn_monitor")
    --if #triggers == 0 then return end
    --local trigger = triggers[1]
    --if not IsValid(trigger) then return end

    local capos = Vector(1591, 4105, 64)
    local ang = client:EyeAngles()
    ang:RotateAroundAxis(ang:Forward(), 90)
    ang:RotateAroundAxis(ang:Right(), 90)
    capos = capos + Vector(0, -25, 5)
    
    local dist = client:GetPos():Distance(Vector(1591, 4105, 64))
    local size = 140 * math.Clamp(dist * .005, 1, 30)
    
    cam.Start3D2D(capos, ang, 0.1)
        cam.IgnoreZ(true)
        surface.SetDrawColor(ColorAlpha(color_white, 255 - Pulsate(5) * 40))
        surface.SetMaterial(scarletmat)
        surface.DrawTexturedRect(-(size / 2), -(size / 2), size, size)
        cam.IgnoreZ(false)
    cam.End3D2D()
end)

local scarletmat2 = Material("nextoren/gui/roles_icon/a1.png")

hook.Add("PostDrawTranslucentRenderables", "alpha_spec_ai", function(bDepth, bSkybox)
    local client = LocalPlayer()
    if not client:GetNWBool('can_sea_gaus', false) then return end
    --if not client:HasWeapon("kasanov_ar_disk") then return end
	--self:SetPos(Vector(1591, 4105, 64))
   --self:SetAngles(Angle(90,0,90))
    --local triggers = ents.FindByClass("kasanov_ar_spawn_monitor")
    --if #triggers == 0 then return end
    --local trigger = triggers[1]
    --if not IsValid(trigger) then return end
	for k,v in pairs(GAUS_PART) do
    	local capos = v
    	local ang = client:EyeAngles()
    	ang:RotateAroundAxis(ang:Forward(), 90)
    	ang:RotateAroundAxis(ang:Right(), 90)
    	capos = capos + Vector(0, -25, 5)
		
    	local dist = client:GetPos():Distance(v)
    	local size = 140 * math.Clamp(dist * .005, 1, 30)
		
    	cam.Start3D2D(capos, ang, 0.1)
    	    cam.IgnoreZ(true)
    	    surface.SetDrawColor(ColorAlpha(color_white, 255 - Pulsate(5) * 40))
    	    surface.SetMaterial(scarletmat2)
    	    surface.DrawTexturedRect(-(size / 2), -(size / 2), size, size)
    	    cam.IgnoreZ(false)
    	cam.End3D2D()
	end
end)
--DrawNewRoleDesc()

-- 定义一个变量来跟踪是否在FBI动画中
LocalPlayer().InFBICutscene = false

-- 接收开始动画的消息
net.Receive("FBI_Cutscene_Start", function()
    LocalPlayer().InFBICutscene = true
end)

-- 接收结束动画的消息
net.Receive("FBI_Cutscene_End", function()
    LocalPlayer().InFBICutscene = false
end)

-- 添加CreateMove钩子来阻止下蹲
hook.Add("CreateMove", "BlockCrouchDuringFBICutscene", function(cmd)
    if LocalPlayer().InFBICutscene then
        -- 移除下蹲按钮输入
        cmd:SetButtons(bit.band(cmd:GetButtons(), bit.bnot(IN_DUCK)))
    end
end)