SWEP.AbilityIcons = {
    {
        Name = "Ghost mode",
        Description = "None provided",
        Cooldown = 10,
        KEY = _G["KEY_R"],
        Icon = "nextoren/gui/special_abilities/special_invisible.png"
    },
    --{
    --    Name = "Dimension Travel",
    --    Description = "None provided",
    --    Cooldown = 15,
    --    KEY = _G["KEY_T"],
    --    Icon = "nextoren/gui/special_abilities/scp_106_trap.png"
    --},
    {
        Name = "Shadow attack",
        Description = "None provided",
        Cooldown = 10,
        KEY = _G["KEY_J"],
        Icon = "nextoren/gui/special_abilities/scp_106_dimensionteleport.png"
    }
}

SWEP.PrintName = "SCP-106"
SWEP.HoldType = "scp106"
SWEP.Base = "breach_scp_base"
SWEP.ViewModel = ""
SWEP.WorldModel = "models/cultist/items/blue_screwdriver/w_screwdriver.mdl"
function SWEP:Initialize()
    self:SetHoldType(self.HoldType)
end

function SWEP:SetupDataTables()
    self:NetworkVar("Bool", 0, "GhostMode")
    self:NetworkVar("Bool", 1, "InDimension")
    self:SetGhostMode(false)
    self:SetInDimension(false)
end

if SERVER then
    function Stuck(ply, pos)
        local t = {}
        t.start 	= pos or ply:GetPos()
        t.endpos 	= t.start
        t.filter 	= ply
        t.mask 		= MASK_PLAYERSOLID
        t.mins 		= ply:OBBMins()
        t.maxs 		= ply:OBBMaxs()
        t = util.TraceHull(t)
        
        local ent = t.Entity
        return t.StartSolid or (ent and (ent:IsWorld() or IsValid(ent)))
    end

    function FindPassableSpace(ply, direction, step)
        local OldPos = ply:GetPos()
        local Origin = ply:GetPos()
        
        for i = 1, 11 do
            Origin = Origin + (step * direction)
            if not Stuck(ply,Origin) then return true, Origin end
        end
        
        return false, OldPos
    end

    function UnStuck(ply, ang, scale)
        local NewPos = ply:GetPos()
        local OldPos = NewPos
        
        if not Stuck(ply) then return end
        local Ang = ang or ply:GetAngles()
        
        local Forward 	= Ang:Forward()
        local Right 	= Ang:Right()
        local Up 		= Ang:Up()
        
        local SearchScale = scale or 3
        local Found
        
        Found, NewPos = FindPassableSpace(ply, Forward, -SearchScale)
        if not Found then
            Found, NewPos = FindPassableSpace(ply, Right, SearchScale)
            if not Found then
                Found, NewPos = FindPassableSpace(ply, Right, -SearchScale)
                if not Found then
                    Found, NewPos = FindPassableSpace(ply, Up, -SearchScale)
                    if not Found then
                        Found, NewPos = FindPassableSpace(ply, Up, SearchScale)
                        if not Found then
                            Found, NewPos = FindPassableSpace(ply, Forward, SearchScale)
                            if not Found then
                                return false
                            end
                        end
                    end
                end
            end
        end
        
        if OldPos == NewPos then
            return false
        else        
            ply:SetPos(NewPos)
            return true
        end
    end

    local test_106_pos = {
        Vector(3408.0668945313, -14493.901367188, -2904.1489257813),
    }
    local horror_tbl = {
        "nextoren/others/horror/horror_0.ogg",
        "nextoren/others/horror/horror_1.ogg",
        "nextoren/others/horror/horror_2.ogg",
        "nextoren/others/horror/horror_3.ogg",
        "nextoren/others/horror/horror_4.ogg",
        "nextoren/others/horror/horror_5.ogg",
        "nextoren/others/horror/horror_9.ogg",
        "nextoren/others/horror/horror_10.ogg",
        "nextoren/others/horror/horror_16.ogg"
    }

    util.AddNetworkString("DimensionSequence")
    function CheckLabirintRandom(player, origin, blink_random, initial_pos)
        local all_good = false
        local protect_counter = 0
        while not all_good do
            protect_counter = protect_counter + 1
            if protect_counter > 4000 then break end
            --local random_vector = Vector(math.Rand(-28, -3035), math.Rand(-11700, -15375), math.Rand(-5142, -5142))
            local random_vector = table.Random(test_106_pos)
            player:SendLua('surface.PlaySound( "'..table.Random( horror_tbl )..'" )')
            --table.Random(test_106_pos)
            -- local nav_area = navmesh.GetNearestNavArea(random_vector)
            -- if nav_area then
            --     random_vector = nav_area:GetCenter()
            -- else
            --     continue
            -- end

           -- if random_vector.z > -4800 or (origin and random_vector == origin) then continue end
            if not origin then
                player:SetPos(random_vector)
                if player:GTeam() ~= TEAM_SCP then CreateSearchSequence(player, random_vector, initial_pos) end
                if not Stuck(player) then
					all_good = true
				else
                    UnStuck(player)
					-- player:SetPos(initial_pos)
					all_good = true
				end
            else
                if origin:DistToSqr(random_vector) <= 1048576 then -- 240^2
                    continue
                end
                return random_vector
            end
        end
    end

    function CreateSearchSequence(player, player_pos, initial_pos)
        local body_origin = CheckLabirintRandom(false, player_pos)
        player:PlayMusic(BR_MUSIC_DIMENSION_SCP106)
        net.Start("DimensionSequence")
        net.WriteVector(body_origin)
        net.WriteBool(true)
        net.Send(player)
        --player.Dimension_TouchEntity = ents.Create("touch_entity")
        --player.Dimension_TouchEntity:SetModel(player:GetModel())
        --player.Dimension_TouchEntity:SetOwner(player)
        --local position_to_return = initial_pos
        --player.Dimension_TouchEntity.OwnerName = player:GetNamesurvivor()
        --player.Dimension_TouchEntity:SetPos(body_origin)
        --player.Dimension_TouchEntity:Spawn()
        --player.Dimension_TouchEntity.Think = function(self)
        --    local owner = self:GetOwner() --print( "touch entity has been created at vector ", body_origin )
        --    if not (owner and owner:IsValid()) or owner:Health() <= 0 or owner:GetNamesurvivor() ~= self.OwnerName or owner:GetRoleName() == "Spectator" then self:Remove() end
        --end
--
        --player.Dimension_TouchEntity.TouchFunc = function(self, player)
        --    if player != self:GetOwner() then return end
--
        --    net.Start("DimensionSequence")
        --    net.Send(player)
        --    player:StopMusic()
        --    player:Freeze(true)
        --    player.canblink = nil
        --    timer.Simple(.25, function()
        --        if (player and player:IsValid()) and (self and self:IsValid()) then
        --            player:ScreenFade(SCREENFADE.OUT, color_white, .1, 1.25)
        --            net.Start("ForcePlaySound")
        --            net.WriteString("nextoren/charactersounds/stun_in.wav")
        --            net.Send(player)
        --            local unique_id = "TeleportMeAlready" .. player:SteamID64()
        --            timer.Create(unique_id, 0, 0, function()
        --                if player:GetPos():DistToSqr(position_to_return) < 6400 then
        --                    timer.Remove(unique_id)
        --                    return
        --                end
--
        --                --player:SetInDimension(false)
        --                player:SetPos(position_to_return)
        --            end)
        --        end
        --    end)
--
        --    player:ScreenFade(SCREENFADE.IN, color_white, .6, 1.3)
        --    timer.Simple(.6, function()
        --        if (player and player:IsValid()) and (self and self:IsValid()) then
        --            player:SetForcedAnimation("l4d_GetUpFrom_Incap_04", 5.2, function()
        --                if player:IsFemale() then
        --                    net.Start("ForcePlaySound")
        --                    net.WriteString("nextoren/charactersounds/breathing/breathing_female.wav")
        --                    net.Send(player)
        --                else
        --                    net.Start("ForcePlaySound")
        --                    net.WriteString("nextoren/others/player_breathing_knockout01.wav")
        --                    net.Send(player)
        --                end
--
        --                player:SetDSP(16)
        --                player:Freeze(true)
        --                player:SetNWEntity("NTF1Entity", player)
        --            end, function()
        --                player:ScreenFade(SCREENFADE.IN, color_black, .1, .75)
        --                player:SetDSP(1)
        --                player:Freeze(false)
        --                player:SetNWEntity("NTF1Entity", NULL)
        --            end)
--
        --            timer.Simple(1, function() if player and player:IsValid() then player.canblink = true end end)
        --            self:Remove()
        --        end
        --    end)
        --end
    end

    function SWEP:TeleportSequence(victim)
        if not (victim and victim:IsValid()) then return end
        victim:SetForcedAnimation("0_106_victum", 1.25, function()
            victim:SetMoveType(MOVETYPE_OBSERVER)
            victim:SetNWEntity("NTF1Entity", victim)
           -- victim:SetInDimension(true)
            timer.Simple(.25, function() if victim and victim:IsValid() and victim:Health() > 0 and victim:GTeam() ~= TEAM_SPEC then victim:ScreenFade(SCREENFADE.OUT, color_black, .1, 2.25) end end)
        end, function()
            victim:SetMoveType(MOVETYPE_WALK)
            victim:SetNWEntity("NTF1Entity", NULL)
            CheckLabirintRandom(victim, nil, nil, victim:GetPos())
            if victim.Teleported then victim.Teleported = nil end
        end)
    end

    function SWEP:OwnerTeleport(b_origin, b_leave)
        net.Start("ThirdPersonCutscene")
        net.WriteUInt(not b_origin and 7 or 4.25, 4)
        net.WriteBool(false)
        net.Send(self.Owner)
        if not b_origin then
            self.Owner:SetForcedAnimation("0_106_new_despawn_1", 2, function()
                self.Owner:Freeze(true)
                self.Owner:SetNotSolid(true)
                if not self:GetInDimension() then
                    self.DimensionEnterPosition = self.Owner:GetPos()
                    --self:SetInDimension(true)
                    --self.Owner:SetInDimension(true)
                end

                self:DrawTeleportDecal(self.Owner)
                timer.Simple(1.8, function() if self and self:IsValid() then self.Owner:ScreenFade(SCREENFADE.OUT, color_black, .1, 1.1) end end)
            end, function()
                if not b_leave then
                    CheckLabirintRandom(self.Owner)
                else
                    self.Owner:SetPos(self.DimensionEnterPosition)
                    self.DimensionEnterPosition = nil
                end

                self:DrawTeleportDecal(self.Owner)
                self.Owner:SetForcedAnimation("0_106_new_spawn_1", 4.25, function()
                    self:EmitSound("nextoren/scp/106/decay0.ogg", 75, 100, 1, CHAN_STATIC)
                    self.Owner:EmitSound("nextoren/scp/106/laugh.ogg", 75, 100, 1, CHAN_VOICE)
                end, function()
                    if b_leave then
                        --self.Owner:SetInDimension(false)
                        self.Owner:SetNotSolid(false)
                        --self:SetInDimension(false)
                        for i = 1, 3 do
                            self:ForbidAbility(i, false)
                        end
                    else
                        self.Owner:SetNotSolid(true)
                    end

                    self.Owner:Freeze(false)
                end)
            end)
        else
            self:DrawTeleportDecal(self.Owner)
            self.Owner:ScreenFade(SCREENFADE.OUT, color_black, .1, 1)
            self.Owner:SetForcedAnimation("0_106_new_spawn_1", 4.25, function()
                self:SetGhostMode(false)
                --self:SetInDimension(true)
                timer.Simple(7, function()
                    if (self and self:IsValid()) and (self.Owner and self.Owner:IsValid()) then
                        self.Owner:SetRunSpeed(125)
                        self.Owner:SetWalkSpeed(125)
                    end
                end)

                sound.Play("nextoren/scp/106/decay0.ogg", self:GetPos() + vector_up * 24, 80, math.random(90, 100), 1)
                self.Owner:EmitSound("nextoren/scp/106/laugh.ogg", 75, 100, 1, CHAN_VOICE)
                self.Owner:SetNoDraw(false)
            end, function()
                self.Owner:Freeze(false)
                self.Owner:SetNotSolid(false)
                --self:SetInDimension(false)
                self.Owner.Block_Use = nil
                for i = 1, 3 do
                    self:ForbidAbility(i, false)
                end
            end)
        end
    end

    function SWEP:DrawTeleportDecal(origin_ent, offset, with_trap, distant_attack)
        if not origin_ent:IsPlayer() then return end
        local trace = {} --print( origin_ent:GetShootPos() + offset )
        trace.start = origin_ent:GetShootPos() + (offset or vector_origin)
        trace.endpos = trace.start - (vector_up * 36200)
        trace.filter = origin_ent
        trace.mask = MASK_SHOT
        if distant_attack then
            local decal_origin = trace.start
            local check_trace = {}
            check_trace.start = decal_origin - origin_ent:GetForward() * 64
            check_trace.endpos = check_trace.start + origin_ent:GetForward() * 70
            check_trace.filter = origin_ent
            check_trace.mask = MASK_SHOT
            check_trace = util.TraceLine(check_trace)
            if check_trace.HitWorld or (check_trace.Entity and check_trace.Entity:IsValid()) and check_trace.Entity:GetClass():find("door") then
                timer.Remove("SCP106_RangeAttack")
                return
            end

            trace = util.TraceLine(trace)
            local shadoweffect = EffectData()
            shadoweffect:SetOrigin(trace.HitPos + trace.HitNormal)
            local recipients = RecipientFilter()
            recipients:AddAllPlayers()
            util.Effect("scp106_shadowattack", shadoweffect, true, recipients)
            if with_trap then
                local ents_withinadecal = ents.FindInSphere(decal_origin, 30)
                for i = 1, #ents_withinadecal do
                    local ent = ents_withinadecal[i]
                    if ent:IsPlayer() and not (ent:GTeam() == TEAM_SPEC or ent:GTeam() == TEAM_SCP) and not ent.Teleported then
                        ent.Teleported = true
                        self:TeleportSequence(ent)
                        util.Decal("Decal106", trace.HitPos + trace.HitNormal, trace.HitPos - trace.HitNormal, ent)
                    end
                end
            end
        else
            trace = util.TraceLine(trace)
            util.Decal("Decal106", trace.HitPos + trace.HitNormal, trace.HitPos - trace.HitNormal, origin_ent)
        end

        sound.Play("nextoren/scp/106/decay" .. math.random(1, 3) .. ".ogg", trace.HitPos + vector_up * 18, 75, math.random(90, 100), 1)
    end

    function SWEP:DistantAttack()
        net.Start("ThirdPersonCutscene")
        net.WriteUInt(4, 4)
        net.WriteBool(false)
        net.Send(self.Owner)
        self.Owner:SetForcedAnimation("0_106_new_range_attack", 3.5, function()
            self.Owner:Freeze(true)
            local unique_id = "SCP106_RangeAttack"
            local i = 1
            timer.Create(unique_id, 1.3, 1, function()
                if not (self and self:IsValid()) or self.Owner:Health() <= 0 or self.Owner:GTeam() ~= TEAM_SCP or self.Owner:GetRoleName() ~= "SCP106" then
                    timer.Remove(unique_id)
                    return
                end

                timer.Create(unique_id, .1, 24, function()
                    if not (self and self:IsValid()) or self.Owner:Health() <= 0 or self.Owner:GTeam() ~= TEAM_SCP or self.Owner:GetRoleName() ~= "SCP106" then
                        timer.Remove(unique_id)
                        return
                    end

                    local player_angles = self.Owner:GetAngles()
                    self:DrawTeleportDecal(self.Owner, self.Owner:GetForward() * (48 * i) + player_angles:Right() * 20 - player_angles:Forward() * 12, true, true)
                    i = i + 1
                end)
            end)
        end, function()
            self.Owner:Freeze(false)
            for i = 1, 2 do
                self:ForbidAbility(i, false)
            end
        end)
    end

    function SWEP:Think()
        if self:GetGhostMode() and not self.Owner:GetNoDraw() then self.Owner:SetNoDraw(true) end
    end
else -- ( CLIENT )
    --local OGRX = OGRX or {}
    local function CreateClientExit(client, pos)
        client.exit_ent = ents.CreateClientside("base_gmodentity")
        client.exit_ent:SetPos(pos + vector_up * 4)
        client.exit_ent:SetModel(client:GetModel())
        client.exit_ent:SetOwner(client)
        client.exit_ent:SetSkin(client:GetSkin())
        client.exit_ent:AddEffects(EF_BRIGHTLIGHT)
        client.exit_ent:AddEffects(EF_NOSHADOW)
        client.exit_ent:SetMaterial("lights/white001")
        client.exit_ent:SetAutomaticFrameAdvance(true)
        client.exit_ent:Spawn()
        for id in ipairs(client:GetBodyGroups()) do
            client.exit_ent:SetBodygroup(id, client:GetBodygroup(id))
        end

        for _, bonemerge in ipairs(client:GetChildren()) do
            if bonemerge:GetClass() == "ent_bonemerged" then ClientBoneMerge(client.exit_ent, bonemerge:GetModel()) end
        end

        client.exit_ent:SetSequence(client.exit_ent:LookupSequence("2ump_holding_jump"))
        client.exit_ent:SetPlaybackRate(1.0)
        if client.exit_ent.BoneMergedEnts then
            for _, v in ipairs(client.exit_ent.BoneMergedEnts) do
                if v and v:IsValid() then v:SetMaterial("lights/white001") end
            end
        end

        ParticleEffectAttach("death_evil3", PATTACH_POINT_FOLLOW, client.exit_ent, 1)
        ParticleEffectAttach("death_blood_slave2", PATTACH_POINT_FOLLOW, client.exit_ent, 3)
        
        client.exit_ent.Reverse = false
        client.exit_ent.Think = function(self)
            self:NextThink(CurTime())
            if self:GetCycle() >= .99 then self:SetCycle(0) end
            self:SetCycle(self:GetCycle() + .001)
            if self.DeathTime then
                if not self.EndParticleCreated then
                    self.EndParticleCreated = true
                    self:StopParticles()
                    timer.Simple(.05, function()
                        if self and self:IsValid() then
                            ParticleEffectAttach("death_telc", PATTACH_POINT_FOLLOW, self, 1)
                            ParticleEffectAttach("burning_character_glow_b_white", PATTACH_POINT_FOLLOW, self, 3)
                        end
                    end)
                end

                if self.DeathTime < CurTime() then
                    if not self.ForceDeath then
                        gasblind = 8
                        local owner = self:GetOwner()
                        owner.FOVStartDecrease = nil
                        owner.FOVTest = 20
                        timer.Simple(8, function()
                            LocalPlayer().FOVStartDecrease = true
                            surface.PlaySound("nextoren/charactersounds/stun_out.wav")
                        end)
                    end

                    self:Remove()
                end
            end
            return true
        end
    end

    net.Receive("DimensionSequence", function()
        local ent_origin = net.ReadVector()
        local start = net.ReadBool()
        local client = LocalPlayer()

        if start then
            client:ConCommand("stopsound")

            CreateClientExit(client, ent_origin)
                       
            client.CustomRenderHook = true
            
            local old_name = client:GetNamesurvivor()
            local material_clr = Material("pp/colour")
            local check_time = 0
            local brightness = -.01

            client.snd_HeartBeat = CreateSound(client, "nextoren/charactersounds/heartbeat.wav")

            timer.Simple(1, function() -- дада я \ хуя ниче не работает
                if client.snd_HeartBeat then
                    client.snd_HeartBeat:Play()
                end
            end)

            hook.Add("RenderScreenspaceEffects", "Dimension_ScreenRender", function()
                local client = LocalPlayer()
               
                if client:Health() <= 0 or (not client:GetInDimension() or client:GetNamesurvivor() ~= old_name or not IsValid(client.exit_ent))then
                    if IsValid(client.exit_ent) and not client.exit_ent.DeathTime then
                        client.exit_ent.DeathTime = CurTime() + 0.25
                        client.exit_ent.ForceDeath = true
                    end

                    client.CustomRenderHook = nil
                    if client.snd_HeartBeat then
                        client.snd_HeartBeat:Stop()
                        client.snd_HeartBeat = nil
                    end

                    hook.Remove("RenderScreenspaceEffects", "Dimension_ScreenRender")
                    return
                end

                if check_time < CurTime() then
                    check_time = CurTime() + 1
                    local snd_volume = 1 - math.Clamp(client:GetPos():Distance(client.exit_ent:GetPos()) / 1200, 0, .95) -- 1200 - max distance
                    client.snd_HeartBeat:ChangeVolume(snd_volume, 0)
                end

                render.UpdateScreenEffectTexture()
                if f_started then
                    brightness = -1
                elseif brightness == -1 then
                    brightness = -.01
                end

                material_clr:SetFloat("$pp_colour_brightness", brightness)
                material_clr:SetFloat("$pp_colour_contrast", 5)
                material_clr:SetFloat("$pp_colour_colour", .45)
                render.SetMaterial(material_clr)
                render.DrawScreenQuad()
            end)
        else
            local client = LocalPlayer()
            if client.exit_ent and client.exit_ent:IsValid() then
                client.exit_ent:StopParticles()
                ParticleEffectAttach("death_telc", PATTACH_POINT_FOLLOW, client.exit_ent, 1)
                client.exit_ent.DeathTime = CurTime() + 2
            end
        end
    end)

    function SWEP:CalcViewModelView()
        if not self:GetInDimension() then return end
        local dynamic_light = DynamicLight(self:EntIndex())
        if dynamic_light then
            dynamic_light.Pos = self:GetPos() + self:GetUp() * 64
            dynamic_light.r = 140
            dynamic_light.g = 0
            dynamic_light.b = 0
            dynamic_light.Brightness = 4
            dynamic_light.Size = 280
            dynamic_light.Decay = 2500
            dynamic_light.DieTime = CurTime() + .1
        end
    end

    function SWEP:DrawWorldModel()
        if not self:GetInDimension() then return end
        local dynamic_light = DynamicLight(self:EntIndex())
        if dynamic_light then
            dynamic_light.Pos = self:GetPos() + self:GetUp() * 64
            dynamic_light.r = 140
            dynamic_light.g = 0
            dynamic_light.b = 0
            dynamic_light.Brightness = 4
            dynamic_light.Size = 280
            dynamic_light.Decay = 2500
            dynamic_light.DieTime = CurTime() + .1
        end
    end

    function SWEP:Think()
        if self:GetGhostMode() and not self.Tip_Received then
            self.Tip_Received = true
            BREACH.Player:ChatPrint(true, true, "Активирован режим \"Призрака\".")
            BREACH.Player:ChatPrint(true, true, "Ваша скорость передвижения увеличена в два раза.")
            BREACH.Player:ChatPrint(true, true, "В этом режиме Вы не можете никого атаковать. Люди, в свою очередь, никаким образом не смогут Вас увидеть.")
            BREACH.Player:ChatPrint(true, true, "Вы можете покинуть этот режим, нажав кнопку \"R\". Ваш персонаж появится на текущей позиции.")
        end

        if self.Owner:GetInDimension() and not self.Tip_Received_2 then
            self.Tip_Received_2 = true
            BREACH.Player:ChatPrint(true, true, "Теперь Вы находитесь в своём измерении.")
            BREACH.Player:ChatPrint(true, true, "С помощью клавиши \"H\" Вы можете вернуться на свою старую позицию, откуда был произведён вход в собственное измерение.")
            BREACH.Player:ChatPrint(true, true, "Вы можете продолжать телепортироваться по случайным точкам измерения с помощью способности на клавишу \"T\".")
        end
    end

    local exit_icon = Material("nextoren/gui/special_abilities/scp_106_trap.png")
    local clrgray = Color(198, 198, 198)
    local darkgray = Color(105, 105, 105)
    function SWEP:DrawHUDBackground()
        if not self.Deployed then
            self.Deployed = true
            self:Deploy()
        end

        if self.Owner:GetInDimension() then -- Fake icon
            local icon_x, icon_y = ScrW() / 2 - 32, ScrH() / 1.4
            surface.SetDrawColor(color_white)
            surface.SetMaterial(exit_icon)
            surface.DrawTexturedRect(icon_x, icon_y, 64, 64)
            if self.Owner:IsFrozen() or (self.AbilityIcons[2].CooldownTime or 0) > CurTime() then draw.RoundedBox(0, icon_x, icon_y, 64, 64, ColorAlpha(darkgray, 190)) end
            if input.IsKeyDown(KEY_H) then draw.RoundedBox(0, icon_x, icon_y, 64, 64, ColorAlpha(clrgray, 70)) end
            OGRX.outlineText("H", "HUDFont", icon_x + 64 - (32 / 4), icon_y + 22, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_RIGHT, color_black)
        end
    end
end

local prim_maxs = Vector(12, 4, 32)
function SWEP:PrimaryAttack()
    if self:GetGhostMode() then return end
    self:SetNextPrimaryFire(CurTime() + 1)
    if CLIENT then return end
    local trace = {}
    trace.start = self.Owner:GetShootPos()
    trace.endpos = trace.start + self.Owner:GetAimVector() * 90
    trace.filter = self.Owner
    trace.mins = -prim_maxs
    trace.maxs = prim_maxs
    trace = util.TraceHull(trace)
    local hit_ent = trace.Entity
    if hit_ent:IsPlayer() and hit_ent:GTeam() ~= TEAM_SCP and hit_ent:GetMoveType() ~= MOVETYPE_OBSERVER then
        if self.Owner:GetInDimension() then
            self.Owner:SetHealth(math.min(self.Owner:Health() + hit_ent:Health(), self.Owner:GetMaxHealth()))
            self.Owner:EmitSound("nextoren/scp/106/laugh.ogg", 75, 100, 1, CHAN_VOICE)
            hit_ent:Kill()
            self.Owner:AddToStatistics("SCP-106 Dimension kill", 150)
        else
            hit_ent.BodyOrigin = hit_ent:GetPos()
            --hit_ent:SetInDimension(true)
            self:DrawTeleportDecal(hit_ent)
            self:TeleportSequence(hit_ent)
        end
    end
end

function SWEP:CanSecondaryAttack()
    return false
end

function SWEP:Deploy()
    hook.Add("PlayerButtonDown", "SCP106_DimensionTeleport", function(caller, button)
        if caller:GetRoleName() ~= "SCP106" then return end
        local wep = caller:GetActiveWeapon()
        if wep == NULL or not wep.AbilityIcons then return end
        if button == KEY_T and not ((wep.AbilityIcons[2].CooldownTime or 0) > CurTime() or self.AbilityIcons[2].Forbidden) then
            wep.AbilityIcons[2].CooldownTime = CurTime() + wep.AbilityIcons[2].Cooldown
            if SERVER then
                for i = 1, 3, 2 do
                    self:ForbidAbility(i, true)
                end

                wep:OwnerTeleport()
                --caller:SetInDimension(true)
            else
                timer.Simple(.25, function()
                    hook.Add("SetupOutlines", "SCP106_DimensionVision", function()
                        local client = LocalPlayer()
                        if client:Health() <= 0 or client:GetRoleName() ~= "SCP106" or not client:GetInDimension() then
                            hook.Remove("SetupOutlines", "SCP106_DimensionVision")
                            return
                        end

                        local to_draw = {}
                        local players = player.GetAll()
                        for i = 1, #players do
                            local player = players[i]
                            if player and player:IsValid() and player ~= client and player:Health() > 0 and player:GTeam() ~= TEAM_SPEC and player:GetInDimension() then
                                to_draw[#to_draw + 1] = player
                                local bnmrges = player:LookupBonemerges()
                                for i = 1, #bnmrges do
                                    to_draw[#to_draw + 1] = bnmrges[i]
                                end
                            end
                        end

                        if #to_draw > 0 then outline.Add(to_draw, color_white, OUTLINE_MODE_BOTH) end
                    end)
                end)
            end
        elseif button == KEY_J and not ((wep.AbilityIcons[2].CooldownTime or 0) > CurTime() or self.AbilityIcons[2].Forbidden) then
            wep.AbilityIcons[2].CooldownTime = CurTime() + wep.AbilityIcons[2].Cooldown
            if CLIENT then return end
            for i = 1, 2 do
                self:ForbidAbility(i, true)
            end

            wep:DistantAttack()
        --elseif button == KEY_H and caller:GetInDimension() and not ((wep.AbilityIcons[2].CooldownTime or 0) > CurTime()) then
        --    wep.AbilityIcons[3].CooldownTime = CurTime() + wep.AbilityIcons[3].Cooldown
        --    if CLIENT then return end
        --    for i = 1, 3 do
        --        self:ForbidAbility(i, true)
        --    end
--
        --    wep:OwnerTeleport(false, true)
        end
    end)

    if self.AbilityIcons then
        for i = 1, #self.AbilityIcons do
            self.AbilityIcons[i].CooldownTime = CurTime() + 10
        end
    end

    if SERVER then
        self:DrawTeleportDecal(self.Owner)
        self.Owner:Freeze(true)
        self.Owner:EmitSound("nextoren/scp/106/decay0.ogg", 75, 100, 1, CHAN_STATIC)
        self.Owner:ScreenFade(SCREENFADE.OUT, color_black, .1, 2.5)
        timer.Simple(1.25, function()
            if not (self and self:IsValid()) then return end
            self.Owner:SetForcedAnimation("0_106_new_spawn_1", 4.25, function()
                net.Start("ThirdPersonCutscene")
                net.WriteUInt(4, 4)
                net.WriteBool(false)
                net.Send(self.Owner)
                --self:SetInDimension(true)
            end, function()
                --self:SetInDimension(false)
                self.Owner:SetMoveType(MOVETYPE_WALK)
                self.Owner:SetCustomCollisionCheck(true)
                self.Owner:Freeze(false)
            end)
        end)
    else
        local material_clr = Material("pp/colour")
        hook.Add("RenderScreenspaceEffects", "SCP106_GhostModeProccessing", function()
            local client = LocalPlayer()
            if client:Health() <= 0 or client:GTeam() ~= TEAM_SCP or client:GetRoleName() ~= "SCP106" then
                if client.CustomRenderHook then client.CustomRenderHook = nil end
                hook.Remove("RenderScreenspaceEffects", "SCP106_GhostModeProccessing")
                return
            end

            local wep = client:GetActiveWeapon()
            if wep == NULL then return end
            if not wep:GetGhostMode() then
                if client.CustomRenderHook then client.CustomRenderHook = nil end
                return
            end

            if not client.CustomRenderHook then client.CustomRenderHook = true end
            render.UpdateScreenEffectTexture()
            material_clr:SetFloat("$pp_colour_brightness", .1)
            material_clr:SetFloat("$pp_colour_contrast", 1)
            material_clr:SetFloat("$pp_colour_colour", .1)
            material_clr:SetFloat("$pp_colour_addr", .1)
            render.SetMaterial(material_clr)
            render.DrawScreenQuad()
        end)
    end
end

function SWEP:Reload()
    if self.AbilityIcons and ((self.AbilityIcons[1].CooldownTime or 0) > CurTime() or self.AbilityIcons[1].Forbidden) then return end
    self.AbilityIcons[1].CooldownTime = CurTime() + self.AbilityIcons[1].Cooldown
    local is_ghostmode = self:GetGhostMode()
    if is_ghostmode then
        local check_trace = {}
        check_trace.start = self.Owner:GetShootPos()
        check_trace.endpos = check_trace.start + self.Owner:GetAimVector() * 16
        check_trace.mask = MASK_SHOT
        check_trace.filter = self.Owner
        check_trace = util.TraceLine(check_trace)
        if check_trace.Entity and check_trace.Entity:IsValid() then
            if CLIENT then BREACH.Player:ChatPrint(true, true, "Вы не можете выйти из режима \"Призрака\" в этом месте.") end
            self.AbilityIcons[1].CooldownTime = CurTime() + 3
            return
        end
    end

    if CLIENT then return end
    self:DrawTeleportDecal(self.Owner)
    self.Owner:EmitSound("nextoren/scp/106/laugh.ogg", 75, 100, 1, CHAN_VOICE)
    if not is_ghostmode then
        for i = 2, 3 do
            self:ForbidAbility(i, true)
        end

        local unique_id = "DecalDraw" .. self.Owner:SteamID()
        local i = 1
        timer.Create(unique_id, .75, 2, function()
            if not (self and self:IsValid()) then
                timer.Remove(unique_id)
                return
            end

            self:DrawTeleportDecal(self.Owner, self.Owner:GetAimVector() * (24 * i))
            i = i + 1
        end)

        self.Owner:SetForcedAnimation("0_106_new_despawn_2", 3, function()
            self.Owner:Freeze(true)
            net.Start("ThirdPersonCutscene")
            net.WriteUInt(3, 4)
            net.WriteBool(false)
            net.Send(self.Owner)
            self.Owner:ScreenFade(SCREENFADE.OUT, color_black, 2.25, 1.25)
        end, function()
            self.Owner:SetNoDraw(true)
            self.Owner:SetNotSolid(true)
            self.Owner:Freeze(false)
            self.Owner.Block_Use = true -- Prevent Player_Use hook from call
            self.Owner:SetRunSpeed(220)
            self.Owner:SetWalkSpeed(220)
            self:SetGhostMode(true)
        end)
    else
        self.Owner:Freeze(true)
        self.Owner:SetRunSpeed(165)
        self.Owner:SetWalkSpeed(165)
        self:OwnerTeleport(true)
    end
end

function SWEP:OnRemove()
    local players = player.GetAll()
    local scp106_exists
    for i = 1, #players do
        local player = players[i]
        if player:GetRoleName() == "SCP106" then
            scp106_exists = true
            break
        end
    end

    if not scp106_exists then hook.Remove("PlayerButtonDown", "SCP106_DimensionTeleport") end
end