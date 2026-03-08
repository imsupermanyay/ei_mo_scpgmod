include("shared.lua")
local newrb_r = Material("nextoren_hud/round_box_3_big_r2.png")
function ENT:Draw()

	self:DrawModel()
--	local Distance = LocalPlayer():GetPos():DistToSqr( self:GetPos() )

	--if ( LocalPlayer():IsLineOfSightClear( self ) ) then

		local oang = self:GetAngles()
	  local ang = self:GetAngles()
	  local pos = self:GetPos()

	  ang:RotateAroundAxis( oang:Up(), 90 )
	  ang:RotateAroundAxis( oang:Right(), -111 )
	  ang:RotateAroundAxis( oang:Forward(), 0 )

	  cam.Start3D2D( pos + oang:Up() * 11 + oang:Right() * -0.5 + oang:Forward() * 11.4, ang, 0.07 )
        draw.RoundedBox( 0, -286, 141, 592, 171, Color( 0, 0, 0,255) )

       
            draw.SimpleText( L(self:GetItem()), "ImpactBig2", 20, 221, string.ToColor(self:GetTextColor()), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

            --surface.SetDrawColor(255, 255, 255);
	  	    --surface.SetMaterial(Material("nextoren/gui/icons/scp/1033.png"));
	  	    --surface.DrawTexturedRect(-220, 70, 200, 200);
            --draw.RoundedBox( 0, -220, 70, 200, 200, Color( 0, 0, 0,255) )
            --draw.SimpleText( "Not", "ImpactBig", -150 + 30, 145, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
            --draw.SimpleText( "Image", "ImpactBig", -150 + 30, 145 + 40, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
            --surface.SetDrawColor(Color(255,255,255));
	  	    --surface.SetMaterial(newrb_r);
	  	    --surface.DrawTexturedRect(-220, 70, 200, 200);
--
		    --draw.SimpleText( "Empty cell", "ImpactBig", 0, 85, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
            ----draw.SimpleText( "Class - SAFE", "ImpactBig", 0, 85 + 40, Main_Color, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
            --draw.SimpleText( "Access level - 0", "ImpactBig", 0, 85 + 40, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
            --draw.SimpleText( "Status - Locked", "ImpactBig", 0, 85 + 40 + 40 + 40, S_Color, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		cam.End3D2D()

	--end

end

