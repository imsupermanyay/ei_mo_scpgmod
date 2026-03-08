AddCSLuaFile()

ENT.Type        = "anim"
ENT.Category    = "Breach"

ENT.Model       = Model( "models/cultist/armory/armory.mdl" )

function ENT:Initialize()

  if ( SERVER ) then

    self:SetModel( self.Model )
    self:SetMoveType( MOVETYPE_NONE )

    self.BannedUsers = {}
  end

  self:SetSolid( SOLID_VPHYSICS )

end

if ( SERVER ) then

  ENT.Ammo_Quantity = {

    SMG1 = 600,
    AR2 = 600,
    Shotgun = 240,
    Revolver = 120,
    Pistol = 150,
    Sniper = 60,
    ["RPG_Rocket"] = 2,

  }

  local maxs = {

  	Pistol = 60,
  	Revolver = 30,
  	SMG1 = 120,
  	AR2 = 120,
  	Shotgun = 80,
    Sniper = 30,
    ["RPG_Rocket"] = 2,

  }

  local MTF_SETUP = {

    [role.MTF_Shock] = "Shotgun",
    [role.MTF_Security] = "Pistol",
    [role.MTF_Engi] = "Sniper",
    [role.MTF_Chem] = "SMG1",
    [role.MTF_Medic] = "SMG1",
    [role.MTF_HOF] = "Revolver",
    
  }

  local Teams_Setup = {

        [ role.SECURITY_Recruit ] = {

          weapon = { "cw_kk_ins2_ump45","breach_keycard_guard_2" },
          ammo = {"cw_kk_ins2_ump45", 120},
          --bodygroups = "11001001",
          bodygroups = "11000001",
          damage_modifiers = {
            ["HITGROUP_HEAD"] = 1,
            ["HITGROUP_CHEST"] = 0.8,
            ["HITGROUP_LEFTARM"] = 1,
            ["HITGROUP_RIGHTARM"] = 1,
            ["HITGROUP_STOMACH"] = 0.8,
            ["HITGROUP_GEAR"] = 0.8,
            ["HITGROUP_LEFTLEG"] = 1,
            ["HITGROUP_RIGHTLEG"] = 1
           },

        },

        [ role.SECURITY_Chief ] = {

          weapon = { "cw_kk_ins2_hk416c","breach_keycard_guard_4" },
          ammo = {"cw_kk_ins2_hk416c", 180},
          bodygroups = "12001001",
          bonemerge = "models/cultist/humans/balaclavas_new/balaclava_half.mdl",
          damage_modifiers = {
            ["HITGROUP_HEAD"] = 1,
            ["HITGROUP_CHEST"] = 0.8,
            ["HITGROUP_LEFTARM"] = 1,
            ["HITGROUP_RIGHTARM"] = 1,
            ["HITGROUP_STOMACH"] = 0.8,
            ["HITGROUP_GEAR"] = 0.8,
            ["HITGROUP_LEFTLEG"] = 1,
            ["HITGROUP_RIGHTLEG"] = 1
           },

        },

        [ role.SECURITY_Sergeant ] = {

          weapon = { "cw_kk_ins2_cstm_kriss","breach_keycard_guard_3" },
          ammo = {"cw_kk_ins2_cstm_kriss", 180},
          bodygroups = "22001001",
          damage_modifiers = {
            ["HITGROUP_HEAD"] = 0.8,
            ["HITGROUP_CHEST"] = 0.8,
            ["HITGROUP_LEFTARM"] = 0.8,
            ["HITGROUP_RIGHTARM"] = 0.8,
            ["HITGROUP_STOMACH"] = 0.8,
            ["HITGROUP_GEAR"] = 0.8,
            ["HITGROUP_LEFTLEG"] = 0.8,
            ["HITGROUP_RIGHTLEG"] = 0.8
           },

        },

        [ role.SECURITY_Corporal ] = {

          weapon = { "cw_kk_ins2_l1a1","breach_keycard_guard_2" },
          ammo = {"cw_kk_ins2_l1a1", 180},
          bodygroups = "10101001",
          bonemerge = "models/cultist/humans/balaclavas_new/balaclava_half.mdl",
          damage_modifiers = {
            ["HITGROUP_HEAD"] = 0.65,
            ["HITGROUP_CHEST"] = 0.8,
            ["HITGROUP_LEFTARM"] = 0.8,
            ["HITGROUP_RIGHTARM"] = 0.8,
            ["HITGROUP_STOMACH"] = 0.8,
            ["HITGROUP_GEAR"] = 0.8,
            ["HITGROUP_LEFTLEG"] = 0.9,
            ["HITGROUP_RIGHTLEG"] = 0.9
           },

        },

        [ role.SECURITY_OFFICER ] = {

          weapon = { "cw_kk_ins2_ump45","breach_keycard_guard_2" },
          ammo = {"cw_kk_ins2_ump45", 180},
          bodygroups = "10101001",
          bonemerge = "models/cultist/humans/balaclavas_new/head_balaclava_month.mdl",
          damage_modifiers = {
            ["HITGROUP_HEAD"] = 0.8,
            ["HITGROUP_CHEST"] = 0.8,
            ["HITGROUP_LEFTARM"] = 0.8,
            ["HITGROUP_RIGHTARM"] = 0.8,
            ["HITGROUP_STOMACH"] = 0.8,
            ["HITGROUP_GEAR"] = 0.8,
            ["HITGROUP_LEFTLEG"] = 0.9,
            ["HITGROUP_RIGHTLEG"] = 0.9
           },

        },

        [ role.SECURITY_OFFICER ] = {

          weapon = { "cw_kk_ins2_ump45","breach_keycard_guard_2" },
          ammo = {"cw_kk_ins2_ump45", 180},
          bodygroups = "10101001",
          bonemerge = "models/cultist/humans/balaclavas_new/head_balaclava_month.mdl", 
          damage_modifiers = {
            ["HITGROUP_HEAD"] = 0.8,
            ["HITGROUP_CHEST"] = 0.8,
            ["HITGROUP_LEFTARM"] = 0.8,
            ["HITGROUP_RIGHTARM"] = 0.8,
            ["HITGROUP_STOMACH"] = 0.8,
            ["HITGROUP_GEAR"] = 0.8,
            ["HITGROUP_LEFTLEG"] = 0.9,
            ["HITGROUP_RIGHTLEG"] = 0.9
           },

        },
       

        [ role.SECURITY_Shocktrooper ] ={

          weapon = { "cw_kk_ins2_cstm_ksg","breach_keycard_guard_3" },
          ammo = {"cw_kk_ins2_cstm_ksg", 40},
          bodygroups = "22011101",
          bonemerge = "models/cultist/humans/balaclavas_new/balaclava_full.mdl",
          damage_modifiers = {
            ["HITGROUP_HEAD"] = 0.65,
            ["HITGROUP_CHEST"] = 0.65,
            ["HITGROUP_LEFTARM"] = 0.65,
            ["HITGROUP_RIGHTARM"] = 0.65,
            ["HITGROUP_STOMACH"] = 0.65,
            ["HITGROUP_GEAR"] = 0.65,
            ["HITGROUP_LEFTLEG"] = 0.65,
            ["HITGROUP_RIGHTLEG"] = 0.65
           },

        },

        [ role.SECURITY_Warden ] = {

          weapon = { "cw_kk_ins2_hk416c","breach_keycard_guard_4" },
          ammo = {"cw_kk_ins2_hk416c", 160},
          bodygroups = "12001001",
          bonemerge = true,
          damage_modifiers = {
            ["HITGROUP_HEAD"] = 0.8,
            ["HITGROUP_CHEST"] = 0.8,
            ["HITGROUP_LEFTARM"] = 0.8,
            ["HITGROUP_RIGHTARM"] = 0.8,
            ["HITGROUP_STOMACH"] = 0.8,
            ["HITGROUP_GEAR"] = 0.8,
            ["HITGROUP_LEFTLEG"] = 0.8,
            ["HITGROUP_RIGHTLEG"] = 0.8
           },

        },

        [ role.SECURITY_IMVSOLDIER ] = {

          weapon = { "cw_kk_ins2_blackout","breach_keycard_guard_3" },
          ammo = {"cw_kk_ins2_blackout", 160},
          bodygroups = "22001001",
          bonemerge = "models/cultist/humans/balaclavas_new/balaclava_full.mdl",
          damage_modifiers = {
            ["HITGROUP_HEAD"] = 0.9,
            ["HITGROUP_CHEST"] = 0.8,
            ["HITGROUP_LEFTARM"] = 0.8,
            ["HITGROUP_RIGHTARM"] = 0.8,
            ["HITGROUP_STOMACH"] = 0.8,
            ["HITGROUP_GEAR"] = 0.8,
            ["HITGROUP_LEFTLEG"] = 0.8,
            ["HITGROUP_RIGHTLEG"] = 0.8
           },

        },
      }

  function ENT:Use( survivor )
    if ( ( self.NextUse || 0 ) > CurTime() ) then return end

    self.NextUse = CurTime() + 2

    local gteam = survivor:GTeam()

    --timer.Remove( self:EntIndex().."NiggaClose" )
    if !timer.Exists("NiggaClose") then
    self:ResetSequence( self:LookupSequence( "close" ) )
    timer.Create( "NiggaClose", 1, 1, function()
      self:ResetSequence( self:LookupSequence( "open" ) )
    end )
    end

    if ( gteam != TEAM_SECURITY and gteam != TEAM_GUARD ) or survivor:GetRoleName() == role.Dispatcher then
      survivor:RXSENDNotify("l:weaponry_cant_use")
      return
    end
    
    if gteam == TEAM_GUARD then

      if self.BannedUsers[survivor:GetNamesurvivor()] then
        survivor:RXSENDNotify("l:weaponry_took_ammo_already")
        return
      end
      

     --if survivor:GetRoleName() == role.MTF_Shock then
     --  survivor:BreachGive("cw_kk_ins2_nade_anm14")
     --end

      --self.BannedUsers[survivor:GetNamesurvivor()] = true

      local wep = survivor:GetActiveWeapon()

        if ( wep != NULL && wep.CW20Weapon ) then
        
          local current_ammo = survivor:GetAmmoCount( wep.Primary.Ammo )
        
          if ( !current_ammo ) then return end
        
          local max_ammo = maxs[ wep.Primary.Ammo ]
        
          if survivor:GetRoleName() == role.ClassD_Banned then max_ammo = math.floor(max_ammo/2) end
        
          if ( current_ammo >= max_ammo ) then
          
            BREACH.Players:ChatPrint( survivor, true, true, "l:ammocrate_max_ammo" )
          
            return
          
          elseif ( self.Ammo_Quantity[ wep.Primary.Ammo ] <= 0 ) then
          
            BREACH.Players:ChatPrint( survivor, true, true, "l:ammocrate_no_ammo" )
          
            return
          end
        
          --self.CloseTime = CurTime() + 1
          --self:ResetSequence( 1 )
        
          local have_ammo = self.Ammo_Quantity[ wep.Primary.Ammo ]
          local need_ammo = math.max( max_ammo - current_ammo, max_ammo )
        
          if ( need_ammo > have_ammo ) then
          
            need_ammo = have_ammo
          
          end
        
          survivor:SetAmmo( 999, wep.Primary.Ammo )
          survivor:EmitSound( "nextoren/equipment/ammo_pickup.wav", 75, math.random( 95, 105 ), .75, CHAN_STATIC )
        
          self.Ammo_Quantity[ wep.Primary.Ammo ] = self.Ammo_Quantity[ wep.Primary.Ammo ] - need_ammo
        
        else
        
          BREACH.Players:ChatPrint( survivor, true, true, "l:ammocrate_weapon_needed" )
        
        end

     -- local ammotype = "AR2"

      --if MTF_SETUP[survivor:GetRoleName()] then
      --  ammotype = MTF_SETUP[survivor:GetRoleName()]
      --end

      --local ammo = 30
--
      --for i, v in pairs(survivor:GetWeapons()) do
--
      --  if v.GetPrimaryAmmoType and v:GetPrimaryAmmoType() == game.GetAmmoID(ammotype) then
      --    ammo = v:GetMaxClip1()
      --  end
--
      --end
--
      --survivor:GiveAmmo(ammo*30, ammotype, true)

      survivor:EmitSound( "nextoren/equipment/ammo_pickup.wav", 75, math.random( 95, 105 ), .75, CHAN_STATIC )

    elseif gteam == TEAM_SECURITY then
      if gteam == TEAM_SECURITY and survivor:GetModel():find("mog.mdl") then
        survivor:RXSENDNotify("l:weaponry_took_uniform_already")
        return
      end
      if gteam != TEAM_SECURITY or !Teams_Setup[survivor:GetRoleName()] then
        survivor:RXSENDNotify("l:weaponry_cant_use")
        return
      end
      if survivor:GetMaxSlots() - survivor:GetPrimaryWeaponAmount() < #Teams_Setup[survivor:GetRoleName()].weapon then
        survivor:RXSENDNotify("l:weaponry_need_slots_pt1 "..tostring(#Teams_Setup[survivor:GetRoleName()].weapon).." l:weaponry_need_slots_pt2")
        return
      end

      if self.BannedUsers[survivor:GetNamesurvivor()] then
        survivor:RXSENDNotify("l:weaponry_took_ammo_already")
        return
      end

      self.BannedUsers[survivor:GetNamesurvivor()] = true
      
      survivor:CompleteAchievement("weaponry")
      local tab = Teams_Setup[survivor:GetRoleName()]
      survivor:EmitSound( Sound("nextoren/others/cloth_pickup.wav"), 125, 100, 1.25, CHAN_VOICE)
      survivor:ScreenFade(SCREENFADE.IN, color_black, 1, 1)
      if survivor:IsFemale() then
        survivor:SetModel("models/cultist/humans/mog/mog_woman_capt.mdl")
      else
        survivor:SetModel("models/cultist/humans/mog/mog.mdl")
        if tab.bonemerge and survivor:SteamID64() != "76561198867007475" and survivor:SteamID64() != "76561198342205739" then
          for _, bnmrg in ipairs(survivor:LookupBonemerges()) do
            if bnmrg:GetModel():find("male_head") or bnmrg:GetModel():find("balaclava") then
              local copytext = bnmrg:GetSubMaterial(0)
              local bnmrg_new
              if tab.bonemerge != true then
                bnmrg_new = Bonemerge(tab.bonemerge, survivor)
              else
                bnmrg_new = Bonemerge(PickHeadModel(), survivor)
              end
              bnmrg_new:SetSubMaterial(0, copytext)
              bnmrg:Remove()
            end
          end
        end
      end
      survivor:ClearBodyGroups()
      survivor:SetupHands()
      survivor:SetBodyGroups(tab.bodygroups)
      if survivor:SteamID64() == "76561198867007475" then
        if survivor:GetRoleName() == role.SECURITY_OFFICER then
          survivor:SetBodyGroups("11000001")
        end
        if survivor:GetRoleName() == role.SECURITY_IMVSOLDIER then
          survivor:SetBodyGroups("21001001")
        end
        if survivor:GetRoleName() == role.SECURITY_Shocktrooper then
          survivor:SetBodyGroups("21011101")
        end
        if survivor:GetRoleName() == role.SECURITY_Sergeant then
          survivor:SetBodyGroups("21000001")
        end
        if survivor:GetRoleName() == role.SECURITY_Chief then
          survivor:SetBodyGroups("11000001")
        end
        if survivor:GetRoleName() == role.SECURITY_Warden then
          survivor:SetBodyGroups("12110001")
        end
      end
      if survivor:SteamID64() == "76561198342205739" then
        if survivor:GetRoleName() == role.SECURITY_OFFICER then
          survivor:SetBodyGroups("11000001")
        end
        if survivor:GetRoleName() == role.SECURITY_IMVSOLDIER then
          survivor:SetBodyGroups("21000001")
        end
        if survivor:GetRoleName() == role.SECURITY_Shocktrooper then
          survivor:SetBodyGroups("21011101")
        end
        if survivor:GetRoleName() == role.SECURITY_Sergeant then
          survivor:SetBodyGroups("21000001")
        end
        if survivor:GetRoleName() == role.SECURITY_Chief then
          survivor:SetBodyGroups("11000001")
          for i, v in pairs(survivor:LookupBonemerges()) do
			    	if v:GetModel() == "models/cultist/humans/balaclavas_new/balaclava_half.mdl" then
			    		v:SetModel("models/cultist/humans/mog/heads/head_main.mdl")
			    	end
			    end
        end
        if survivor:GetRoleName() == role.SECURITY_Warden then
          survivor:SetBodyGroups("12110001")
        end
      end
      survivor.ScaleDamage = tab.damage_modifiers
      for _, wep in ipairs(tab.weapon) do
       survivor:BreachGive(wep)
      end
      survivor:GiveAmmo(tab.ammo[2], survivor:GetWeapon(tab.ammo[1]):GetPrimaryAmmoType(), true)
      survivor:RXSENDNotify("l:weaponry_mtf_armor_pt1 ", gteams.GetColor(TEAM_GUARD), "l:weaponry_mtf_armor_pt2")
    end
  end

end

if ( CLIENT ) then

  function ENT:Draw()

    self:DrawModel()

  end

end