-- AddCSLuaFile()

-- SWEP.Spawnable = true -- (Boolean) Can be spawned via the menu
-- SWEP.AdminOnly = false -- (Boolean) Admin only spawnable

-- SWEP.WeaponName = "v92_eq_unarmed" -- (String) Name of the weapon script
-- SWEP.PrintName = "Руки Вортигонта" -- (String) Printed name on menu

-- SWEP.ViewModelFOV = 90 -- (Integer) First-person field of view

-- SWEP.droppable				= false

-- if ( CLIENT ) then

-- 	SWEP.BounceWeaponIcon = false
-- 	SWEP.InvIcon = Material( "nextoren/gui/icons/hand.png" )

-- end

-- SWEP.UnDroppable = true
-- SWEP.UseHands = true
-- SWEP.WorldModel = ""
-- SWEP.CustomHoldtype = "vort3"

-- function SWEP:CanPrimaryAttack()

-- 	return false

-- end

-- function SWEP:CanPrimaryAttack()

-- 	return false

-- end

-- function SWEP:CanSecondaryAttack( )

-- 	return false

-- end

-- function SWEP:Reload() end



SWEP.Category = "BREACH SCP"
SWEP.PrintName = "Big Brother Look At You"
SWEP.Base = "breach_scp_base"
SWEP.Slot = 1
SWEP.SlotPos = 1
SWEP.DrawCrosshair = false
SWEP.WorldModel = ""
SWEP.ViewModel = ""
SWEP.HoldType = "testhold"
SWEP.maxs = Vector( 8, 10, 5 )
SWEP.UnDroppable = true

SWEP.AbilityIcons = {

  {

    [ "Name" ] = "Charge",
    [ "Description" ] = "Вы совершаете рывок к жертве.",
    [ "Cooldown" ] = 35,
    [ "CooldownTime" ] = 0,
    [ "KEY" ] = _G[ "KEY_R" ],
    [ "Using" ] = false,
    [ "Icon" ] = "nextoren/gui/special_abilities/scp_542_blood.png",
    [ "Abillity" ] = nil

  },
  {

    [ "Name" ] = "Melee grab",
    [ "Description" ] = "Вы хватаете жертву поблизости.",
    [ "Cooldown" ] = 35,
    [ "CooldownTime" ] = 0,
    [ "KEY" ] = _G[ "KEY_F" ],
    [ "Using" ] = false,
    [ "Icon" ] = "nextoren/gui/special_abilities/scp_542_meleegrab.png",
    [ "Abillity" ] = nil

  }

}

function SWEP:DrawHUD() end

function SWEP:SetupDataTables()

  self:NetworkVar( "Bool", 0, "Charging" )
  self:NetworkVar( "Int", 0, "NextGrab" )

end

function SWEP:AnimationsChange( rage )

	if ( SERVER ) then

		net.Start( "ChangeAnimations" )

			net.WriteEntity( self.Owner )
			net.WriteBool( rage )

		net.Broadcast()

	end

	if ( rage ) then

		self.Owner.SafeModelWalk = self.Owner:LookupSequence( "0_SCP_542_charge" )
		self.Owner.SafeRun = self.Owner:LookupSequence( "0_SCP_542_charge" )

	else

		self.Owner.SafeModelWalk = self.Owner:LookupSequence( "walk_all" )
		self.Owner.SafeRun = self.Owner:LookupSequence( "run_all" )

	end

end

function SWEP:VoiceLine( s_sound )

  if ( self.Voice_Line && self.Voice_Line:IsPlaying() ) then

    self.Voice_Line:Stop()

  end

--   self.Voice_Line = CreateSound( self.Owner, s_sound )
--   self.Voice_Line:SetDSP( 17 )
--   self.Voice_Line:Play()

end

function SWEP:Deploy()

  self:SetHoldType( self.HoldType )

  self.dmg_info_drain = DamageInfo()
  self.dmg_info_drain:SetDamageType( DMG_BLAST )
  self.dmg_info_drain:SetInflictor( self )

  self:SetNextGrab( 0 )

  self.UsingSpecialAbility = nil

  self:SetCharging( false )

  if ( SERVER ) then

		self.Owner:DrawWorldModel( false )

    hook.Add( "PlayerButtonDown", "SCP_542_Meleegrab", function( ply, butt )

      if ( butt == KEY_F ) then

        if ( ply:GetRoleName() == "SCP542" ) then

          local wep = ply:GetActiveWeapon()

          if ( wep != NULL && ( wep.GetNextGrab && wep:GetNextGrab() ) < CurTime() ) then

            local target = ply:GetEyeTrace().Entity

            if ( target:IsPlayer() && target:GTeam() != TEAM_SCP && target:GetPos():DistToSqr( ply:GetPos() ) < 6400 ) then

              local wep = ply:GetActiveWeapon()

              wep:SetNextGrab( CurTime() + 35 )
              wep:Grab( ply, target, true )

            end

          end

        end

      end

    end )

	end

  if ( CLIENT ) then

    local clr_red = Color( 150, 0, 0, 190 )
    local clr_green = Color( 0, 150, 0, 190 )
    local clr_yellow = Color( 150, 0, 150, 190 )

    local forbidden_team = TEAM_SCP

    hook.Add( "PreDrawOutlines", "DrawPlayersHealth", function()

      local client = LocalPlayer()

      if ( client:Health() <= 0 || client:GetRoleName() != "SCP542" ) then

        hook.Remove( "PreDrawOutlines", "DrawPlayersHealth" )

        return
      end

      local players = player.GetAll()

      for i = 1, #players do

        local player = players[ i ]

        if ( player:GTeam() == TEAM_SPEC || player:GTeam() == TEAM_SCP ) then

          table.remove( players, i )

        end

      end

      local draw_tab = {

        [ "MaxHealth" ] = {},
        [ "NormalHealth" ] = {},
        [ "LowHealth" ] = {}

      }

      local wep = client:GetActiveWeapon()

      local type = 2

      for _, v in ipairs( players ) do

        if ( v != client && v:GTeam() != forbidden_team && v:Health() > 0 ) then

          local hp, maxhp = v:Health(), v:GetMaxHealth()

          if ( !wep.UsingSpecialAbility ) then

            if ( !client:CanSee( v ) || v:GetNoDraw() ) then continue end

            if ( hp > maxhp * .75 ) then

              draw_tab[ "MaxHealth" ][ #draw_tab[ "MaxHealth" ] + 1 ] = v

            elseif ( hp > maxhp * .4 ) then

              draw_tab[ "NormalHealth" ][ #draw_tab[ "NormalHealth" ] + 1 ] = v

            else

              draw_tab[ "LowHealth" ][ #draw_tab[ "LowHealth" ] + 1 ] = v

            end

          else

            type = 0

            if ( v:GetNoDraw() ) then continue end

            local distance = client:GetPos():DistToSqr( v:GetPos() )
            local max_distance = ( 4000 * 4000 )

            local hp_scaled_distance = max_distance * ( math.Clamp( maxhp - hp, 1, maxhp ) / maxhp )

            if ( distance < hp_scaled_distance ) then

              if ( hp > maxhp * .75 ) then

                draw_tab[ "MaxHealth" ][ #draw_tab[ "MaxHealth" ] + 1 ] = v

              elseif ( hp > maxhp * .4 ) then

                draw_tab[ "NormalHealth" ][ #draw_tab[ "NormalHealth" ] + 1 ] = v

              else

                draw_tab[ "LowHealth" ][ #draw_tab[ "LowHealth" ] + 1 ] = v

              end

            end

          end

        end

      end

      outline.Add( draw_tab[ "MaxHealth" ], clr_green, type )
      outline.Add( draw_tab[ "NormalHealth" ], clr_yellow, type )
      outline.Add( draw_tab[ "LowHealth" ], clr_red, type )

    end )

  end

end

function SWEP:PrimaryAttack()

  self:SetNextPrimaryFire( CurTime() + 1.6 )

  if ( self.Charging_Animations ) then return end

  local trace = {}
	trace.start = self.Owner:GetShootPos()
	trace.endpos = trace.start + self.Owner:GetAimVector() * 80
	trace.filter = self.Owner
	trace.mins = -self.maxs
	trace.maxs = self.maxs

  self.Owner:LagCompensation( true )

	trace = util.TraceHull( trace )

  self.Owner:LagCompensation( false )

  local target = trace.Entity

  self.Owner:SetAnimation( PLAYER_ATTACK1 )

  if ( CLIENT ) then

    if ( target && target:IsValid() && target:IsPlayer() && target:GTeam() != TEAM_SCP ) then

      local effectData = EffectData()
      effectData:SetOrigin( trace.HitPos )
      effectData:SetEntity( target )

      util.Effect( "BloodImpact", effectData )

    end

    return
  end

  if ( target && target:IsValid() && target:IsPlayer() && target:Health() > 0 && target:GTeam() != TEAM_SCP ) then

    self.dmginfo = DamageInfo()
    self.dmginfo:SetDamageType( DMG_SLASH )
    self.dmginfo:SetDamage( target:GetMaxHealth() * .2 )
    self.dmginfo:SetDamageForce( target:GetAimVector() * 40 )
    self.dmginfo:SetInflictor( self )
    self.dmginfo:SetAttacker( self.Owner )

    self.Owner:EmitSound( "npc/antlion/shell_impact4.wav" )
    self.Owner:MeleeViewPunch( self.dmginfo:GetDamage() )
    self.Owner:SetHealth( math.Clamp( self.Owner:Health() + self.dmginfo:GetDamage(), 0, self.Owner:GetMaxHealth() ) )

    target:MeleeViewPunch( self.dmginfo:GetDamage() )
    target:TakeDamageInfo( self.dmginfo )

  else

    self.Owner:SetAnimation( PLAYER_ATTACK1 )
    self.Owner:EmitSound( "npc/zombie/claw_miss"..math.random( 1, 2 )..".wav" )
    self.Owner:ViewPunch( AngleRand( 10, 2, 10 ) )

  end

end

local NextAttack_sec = 0

function SWEP:SecondaryAttack()

end

local vec_zero = vector_origin
function SWEP:Grab( ply, victim, melee )

  local angle_zero = Angle(0,0,0)
			ply:LagCompensation(true)
		local DASUKADAIMNEEGO = util.TraceLine( {
			start = ply:GetShootPos(),
			endpos = ply:GetShootPos() + ply:GetAimVector() * 130,
			filter = ply
		} )
		local target = DASUKADAIMNEEGO.Entity
		ply:LagCompensation(false)

		if !ply:IsOnGround() then
			ply:RXSENDNotify("l:strong_no_ground")
			ply:SetSpecialCD(CurTime() + 3)
			return
		end
		if !IsValid(target) or !target.GTeam or target:GTeam() == TEAM_SPEC then
			ply:RXSENDNotify("l:strong_look_on_them")
			ply:SetSpecialCD(CurTime() + 3)
			return
		end
		if target:HasGodMode() then return end
		if !ply:IsSuperAdmin() and target:GTeam() == TEAM_SCP and !target.IsZombie then
			ply:RXSENDNotify("l:strong_look_on_them")
			ply:SetSpecialCD(CurTime() + 3)
			return
		end
		ply:Freeze(true)
		target:Freeze(true)
		local pos = ply:GetShootPos() + ply:GetAngles():Forward()*44
		pos.z = ply:GetPos().z
		ply:SetMoveType(MOVETYPE_OBSERVER)
		net.Start( "ThirdPersonCutscene", true )

			net.WriteUInt( 6, 4 )

		net.Send( ply )
		target:SetMoveType(MOVETYPE_OBSERVER)
		ply:SetNWBool("IsNotForcedAnim", false)
		target:SetNWBool("IsNotForcedAnim", false)
		target:SetPos(pos)
		ply:SetSpecialCD(CurTime() + 65)
		local startcallbackattacker = function()
			--ply:SetNWEntity("NTF1Entity", ply)
			ply:Freeze(true)
			ply.ProgibTarget = target
			sound.Play("^nextoren/charactersounds/special_moves/bor/grab_start.wav", ply:GetPos(), 75, 100, 1)
			sound.Play("^nextoren/charactersounds/special_moves/bor/victim_struggle_6.wav", ply:GetPos(), 75, 100, 1)
			target.ProgibTarget = ply
			local vec_pos = target:GetShootPos() + ( ply:GetShootPos() - target:EyePos() ):Angle():Forward() * 1.5
			vec_pos.z = ply:GetPos().z
			target:SetPos(vec_pos)
			ply:SetNWAngle( "ViewAngles", ( target:GetShootPos() - ply:EyePos() ):Angle() )
			target:SetNWAngle( "ViewAngles", ( ply:GetShootPos() - target:EyePos() ):Angle() )
		end
		local stopcallbackattacker = function()
			ply:SetNWEntity("NTF1Entity", NULL)
			ply:SetNWAngle("ViewAngles", angle_zero)
			ply:Freeze(false)
			ply.ProgibTarget = nil
			ply:SetNWBool("IsNotForcedAnim", true)
			ply:SetMoveType(MOVETYPE_WALK)
		end
		local finishcallbackattacker = function()
			ply:SetNWEntity("NTF1Entity", NULL)
			ply:SetNWAngle("ViewAngles", angle_zero)
			target:SetNWAngle("ViewAngles", angle_zero)
			target:TakeDamage(1000000, ply, "КАЧОК СУКА ХУЯЧИТ")
			ply:Freeze(false)
			ply.ProgibTarget = nil
			ply:SetNWBool("IsNotForcedAnim", true)
			ply:SetMoveType(MOVETYPE_WALK)

			target:StopForcedAnimation()
			sound.Play("^nextoren/charactersounds/hurtsounds/fall/pldm_fallpain0"..math.random(1, 2)..".wav", ply:GetShootPos(), 75, 100, 1)
		end
		local startcallbackvictim = function()
			target:SetNWEntity("NTF1Entity", target)
			target:Freeze(true)
			target.ProgibTarget = ply
			ply.ProgibTarget = target
		end
		local stopcallbackvictim = function()
			target:SetNWEntity("NTF1Entity", NULL)
			target:SetNWAngle("ViewAngles", angle_zero)
			target:Freeze(false)
			target.ProgibTarget = nil
			target:SetNWBool("IsNotForcedAnim", true)
			target:SetMoveType(MOVETYPE_WALK)
		end
		local finishcallbackvictim = function()
			target:SetNWEntity("NTF1Entity", NULL)
			target:SetNWAngle("ViewAngles", angle_zero)
			target:Freeze(false)
			target.ProgibTarget = nil
			target:SetNWBool("IsNotForcedAnim", true)
			target:SetMoveType(MOVETYPE_WALK)
		end
		ply:SetForcedAnimation(ply:LookupSequence("1_bor_progib_attacker"), 5.5, startcallbackattacker, finishcallbackattacker, stopcallbackattacker)
		target:SetForcedAnimation(target:LookupSequence("1_bor_progib_resiver"), 5.5, startcallbackvictim, finishcallbackvictim, stopcallbackvictim)
		target:StopGestureSlot( GESTURE_SLOT_CUSTOM )

end

function SWEP:Reload()

  if ( self.AbilityIcons[ 1 ].CooldownTime > CurTime() ) then return end

  self.AbilityIcons[ 1 ].CooldownTime = CurTime() + self.AbilityIcons[ 1 ].Cooldown

  self.Owner:SetRunSpeed( self.Owner:GetRunSpeed() * 5 )
  self.Owner:SetWalkSpeed( self.Owner:GetWalkSpeed() * 5 )

  self.Owner:ConCommand( "+forward" )

  self:SetCharging( true )

  self.UniqueID = "ChargingFailed" .. self.Owner:SteamID64()

  self:AnimationsChange( true )

  timer.Create( self.UniqueID, 4, 1, function()

    if ( self && self:IsValid() && self.Owner != NULL ) then

      self:SetCharging( false )
      self.Owner:ConCommand( "-forward" )

    end

  end )

  timer.Simple( .25, function()

    self.Charging_Animations = true

  end )

end

SWEP.NextVoiceLine = 0

function SWEP:Think()

  if ( CLIENT && self.AbilityIcons[ 2 ].CooldownTime != self:GetNextGrab() ) then

    self.AbilityIcons[ 2 ].CooldownTime = self:GetNextGrab()

  end

	if ( SERVER && ( self.NextVoiceLine || 0 ) < CurTime() ) then

		local entities = ents.FindInSphere( self.Owner:GetPos(), 400 )

		for _, v in ipairs( entities ) do

			if ( v:IsPlayer() && !( v:GTeam() == TEAM_SPEC || v:GTeam() == TEAM_SCP || v:GTeam() == TEAM_DZ ) && self.Owner:IsLineOfSightClear( v ) && ( self.NextVoiceLine || 0 ) < CurTime() ) then

				self.NextVoiceLine = CurTime() + 70
        self:VoiceLine( "nextoren/scp/542/scp_542_playerdetect_"..math.random( 1, 4 )..".ogg" )

			end

		end

	end

  if ( self.Charging_Animations && !self:GetCharging() ) then

    self.Charging_Animations = nil

    self:AnimationsChange( false )

    self.Owner:SetRunSpeed( 150 )
    self.Owner:SetWalkSpeed( 150 )

    self.Alreadygrabbed = nil

  end

  if ( SERVER && self:GetCharging() && !self.Alreadygrabbed ) then

    for _, v in ipairs( ents.FindInSphere( self.Owner:GetPos(), 80 ) ) do

      if ( v && v:IsValid() && v:IsPlayer() && v != self.Owner && !( v:GTeam() == TEAM_SPEC || v:GTeam() == TEAM_SCP ) && self.Owner:GetEyeTrace().Entity == v ) then

        self.Alreadygrabbed = true
        self:Grab( self.Owner, v )

      end

    end

  end

end

function SWEP:OnRemove()

  if ( ( self.Owner && self.Owner:IsValid() ) ) then

    self.Owner:ConCommand( "-forward" )

  end

  local players = player.GetAll()

  for i = 1, #players do

    local player = players[ i ]

    if ( player && player:IsValid() && player:GetRoleName() == "SCP542" ) then return end

  end

  hook.Remove( "PlayerButtonDown", "SCP_542_Meleegrab" )

end