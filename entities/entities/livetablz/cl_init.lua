include('shared.lua')

local screen_mat = Material( "nextoren_hud/overlay/lzscreen.png" )
local clr = Color( 30, 144, 200 )
local preparing_clr = Color( 0, 255, 255 )
local danger_clr = Color( 255, 24, 24 )

function ENT:UpdateStats()

	self.TotalSciencePlayers = 0
	self.TotalPlayers = 0

	local players = player.GetAll()

	for i = 1, #players do

		local player = players[ i ]

		if ( player:GTeam() != TEAM_SPEC && player:Health() > 0 && player:IsLZ() ) then

			self.TotalPlayers = self.TotalPlayers + 1

			if ( player:GTeam() == TEAM_SCI || player:GTeam() == TEAM_SPECIAL ) then

				self.TotalSciencePlayers = self.TotalSciencePlayers + 1

			end

		end

	end

end

function ENT:Draw()

	self:DrawModel()

	if ( LocalPlayer():GetPos():DistToSqr( self:GetPos() ) > 250000 ) then return end

  local oang = self:GetAngles()
  local ang = self:GetAngles()

  local pos = self:GetPos()

  ang:RotateAroundAxis( oang:Up(), 90 )
  ang:RotateAroundAxis( oang:Right(), -90 )
  ang:RotateAroundAxis( oang:Up(), 90 )

  if ( cltime - 570 < 90 ) then

    clr = Color( 250, 128, 114 )

	else

		clr = color_white

  end

  cam.Start3D2D( pos + oang:Forward() * -6 + oang:Up() * 13 + oang:Right() * -3, ang, 0.07 )

    draw.RoundedBox( 0, -420, -10, 700, 370, color_black )
    surface.SetDrawColor( color_white )
    surface.SetMaterial( screen_mat )
    surface.DrawTexturedRect( -420, -10, 700, 370 )

		local emergency_mode = self:GetEmergencyMode()

		if ( emergency_mode ) then

			if ( !self.TotalPlayers ) then

				self:UpdateStats()
				self.NextUpdateStats = CurTime() + 2

			elseif ( self.NextUpdateStats < CurTime() ) then

				self:UpdateStats()

			end

			draw.SimpleText( L"l:livetablz_1", "ImpactBig", -68, 80, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			draw.SimpleText( L"l:livetablz_2" .. self.TotalPlayers, "ImpactSmall", -68, 120, ColorAlpha( preparing_clr, 180 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTEk )
			draw.SimpleText( L"l:livetablz_3" .. self.TotalSciencePlayers, "ImpactSmall", -68, 185, ColorAlpha( preparing_clr, 200 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

			cam.End3D2D()

			return
		else

    	draw.SimpleText( L"l:livetablz_4", "ImpactBig", -68, 80, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

		end

		if ( preparing || !gamestarted ) then

			draw.SimpleText( L"l:livetablz_5", "ImpactSmall", -68, 120, ColorAlpha( preparing_clr, 180 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTEk )
			draw.SimpleText( L"l:livetablz_6", "ImpactSmall", -68, 185, ColorAlpha( preparing_clr, 200 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

		elseif (  cltime - self:GetDecontTimer() > 0 ) then

			self.Decontamination_Time = timer.TimeLeft("LZDecont") || 0

			draw.SimpleText( L"l:livetablz_7", "ImpactSmall", -80, 120, clr, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			draw.SimpleText( "     " .. string.ToMinutesSeconds( self.Decontamination_Time ), "ImpactBig3m", -101, 185, clr, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			draw.OutlinedBox( -195, 140, 250, 100, 4, clr )

		else

			draw.SimpleText( L"l:livetablz_8", "ImpactSmall", -80, 185, ColorAlpha( danger_clr, 180 * Pulsate( 2 ) ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

		end


  cam.End3D2D()

end
