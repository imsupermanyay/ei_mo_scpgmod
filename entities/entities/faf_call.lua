AddCSLuaFile()

ENT.Type = "anim"
ENT.Name = "NU7 Spawner"
ENT.Uses = 0
ENT.ObrIcon = Material( "nextoren/obr_call/obr_idle" )
ENT.Model = Model( "models/hunter/plates/plate4x24.mdl" )

function ENT:SetupDataTables()

  self:NetworkVar("Bool", 0, "Activate")
  self:NetworkVar("Bool", 1, "Called")
  self:NetworkVar("Bool", 2, "Hacking")
  self:NetworkVar("Int", 1, "CD")

end

local vec_spawn = Vector( -2883, 2269.2, 320.649048 )
local angle_spawn = Angle( 90, -90, 0 )

function ENT:Initialize()

  self:SetModel( self.Model )

  self:PhysicsInit( SOLID_NONE )
  self:SetMoveType(MOVETYPE_NONE)
  self:SetSolid( SOLID_NONE )
  self:SetActivate( true )
  self:SetCalled( false )
  self:SetCD( CurTime() + 480 )
  self:SetSolidFlags( bit.bor( FSOLID_TRIGGER, FSOLID_USE_TRIGGER_BOUNDS ) )
  self:SetRenderMode( 1 )

  self.Calling = false

  self:SetPos( vec_spawn )
  self:SetAngles( angle_spawn )
  self:AddEFlags( EFL_FORCE_CHECK_TRANSMIT )

  if ( SERVER ) then

    self:SetUseType( SIMPLE_USE )

  end
  self:SetColor( ColorAlpha( color_white, 1 ) )


end

function ENT:Use( activator, caller )
  if self:GetHacking() then
    return
  end

  if caller:GetRoleName() == role.ETT_C and caller:GTeam() == TEAM_ETT then
    --[[if !IsBigRound() then
      if timer.TimeLeft("RoundTime") > 480 then
        caller:RXSENDNotify("时间太早了")
        return
      end
    else
      if timer.TimeLeft("RoundTime") > 600 then
        caller:RXSENDNotify("时间太早了")
        return
      end
    end]]
    if timer.TimeLeft("RoundTime") < 300 then
      caller:RXSENDNotify("你成功呼叫了FAF, 但是时间太晚了...")
      return
    end
    caller:BrProgressBar("发送信息中...", 5, "nextoren/gui/icons/hand.png", target, false, function()
      self:SetHacking(true)
      self:EmitSound("^nextoren/others/monitor/start_hacking.wav")
      BREACH.Players:ChatPrint( player.GetAll(), true, true, "[通讯] 我们接收到了请求 一支常规武装部队即将抵达设施" )
        timer.Create("FAF_Iagent", 5, 1, function()
        BREACH.PowerfulFAFSupport(caller,true,10)
        self:SetHacking(false)
        self:Remove()
        end)
    end)
  end
end

function ENT:GetRotatedVec(vec)

	local v = self:WorldToLocal(vec)
	v:Rotate( self:GetAngles() )
	return self:LocalToWorld( v )

end

local clr_green = Color( 0, 200, 0 )
local clr_red = Color( 200, 0, 0 )

function ENT:Draw()

  local oang = self:GetAngles()
	local opos = self:GetPos()

  local ang = self:GetAngles()
  local pos = self:GetPos()

  ang:RotateAroundAxis( oang:Up(), 90 )
  ang:RotateAroundAxis( oang:Right(), 0 )
  ang:RotateAroundAxis( oang:Up(), 0 )
  self:DestroyShadow()

  if ( self:GetHacking() ) then

    self.ObrIcon = Material( "nextoren/obr_call/obr_window" )

  else

    self.ObrIcon = Material( "nextoren/gengxygao/site_19_alert.png" )

  end

  ------------------------------------------


  local up = self.Entity:GetUp()

  local position = self:GetRotatedVec(self.Entity:GetPos() + up * 2 + self.Entity:GetRight() * 4 )

  local _, maxs = self:GetCollisionBounds()

  local w = math.floor( math.max( maxs.x, maxs.y ) / 32 )
  local pos = self.Entity:GetPos() + up * 1

  render.SetMaterial( self.ObrIcon )
  render.DrawQuadEasy(
    position,
    up,
    18, 14,
    color_white,
    180
  )

  render.SetMaterial( self.ObrIcon )
  render.DrawQuadEasy(
    position,
    up*-1,
    18, 14,
    color_white,
    180
  )

  ------------------------------------------
 -- if ( !self:GetCalled() ) then

 --   cam.Start3D2D( pos + oang:Forward() * -3 + oang:Up() * 0.4 + oang:Right() * 2, ang, 0.1 )

  --    draw.SimpleText( "[落锤空降] 通讯已连接!", "LZTextVerySmall", 0, 0, clr_green, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

 --   cam.End3D2D()

 -- end

end

function ENT:UpdateTransmitState()
    return TRANSMIT_ALWAYS
end


if CLIENT then
local scarletmat = Material("nextoren_hud/faction_icons/fbispec.png")
local ultravector = Vector(-2847.375000, 2269.187500, 295.625000)
local shawms = shawms or {}

hook.Add("OnEntityCreated", "OBRCALL_SoftEntityList", function(ent)
    if ent:GetClass() == "obr_call" then
      table.insert(shawms, ent)
    end
  end)

  hook.Add("EntityRemoved", "OBRCALL_SoftEntityList", function(ent)
    if ent:GetClass() == "obr_call" then
      for k, v in pairs(shawms) do
        if !IsValid(v) then
          table.remove(shawms, k)
        end
      end
    end
  end)

hook.Add( "PostDrawTranslucentRenderables", "uiu_spy_draw_mark", function( bDepth, bSkybox )
  local client = LocalPlayer()
  for i=1, #shawms do
    local entity = shawms[i]
    if !IsValid(entity) then
      return
    end

    if client:GetRoleName() != role.SCI_SpyUSA or client:GetRoleName() != role.UIU_Agent_Information and entity:GetHacking() == false then
      return
    end
  
    if client:GetNWInt("CollectedDocument") == 0 then
      for k, v in ipairs(player.GetAll()) do
        if v:GetRoleName() == role.MTF_HOF then
          return
        end
      end
    end
    
    local capos = entity:GetPos()
    local ang = client:EyeAngles()
    ang:RotateAroundAxis( ang:Forward(), 90 )
    ang:RotateAroundAxis( ang:Right(), 90 )
    capos = capos + Vector(0,0, -25)
    local dist = client:GetPos():Distance(ultravector)
    local size = 140 * (math.Clamp(dist * .005, 1, 30))
      cam.Start3D2D( capos, ang, 0.1 )
      cam.IgnoreZ(true)
        surface.SetDrawColor(ColorAlpha(color_white, 255 - Pulsate(5) * 40))
        surface.SetMaterial(scarletmat)
        surface.DrawTexturedRect(-(size/2), -(size/2), size, size);
      cam.End3D2D()
      cam.IgnoreZ(false)
  end
end)

end