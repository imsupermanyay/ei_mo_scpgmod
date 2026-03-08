hook.Add("EntityTakeDamage", "NTF_POWER", function(target, dmginfo)
    if target:IsPlayer() and target:GTeam() == TEAM_SCP then

        local attacker = dmginfo:GetAttacker()
        
        if attacker:IsPlayer() then

            local wep = attacker:GetActiveWeapon()
            
            if IsValid(wep) then
                
                if wep:GetClass() == "cw_kk_ins2_p90_ntf" then

                    local originalDamage = dmginfo:GetDamage()

                    dmginfo:SetDamage(originalDamage * 2.5)
                end
                if wep:GetClass() == "cw_kk_ins2_dsr1" then

                    local originalDamage = dmginfo:GetDamage()

                    dmginfo:SetDamage(originalDamage * 150)
                end
                if wep:GetClass() == "weapon_gauss_rifle" then
                    local originalDamage = dmginfo:GetDamage()

                    dmginfo:SetDamage(originalDamage * 50)
                end
                if wep:GetClass() == "cw_kk_ins2_cultist_barrett" then

                    local originalDamage = dmginfo:GetDamage()

                    dmginfo:SetDamage(originalDamage * 9.5)
                end
                if wep:GetClass() == "cw_kk_ins2_deagle_scp" then
                    dmginfo:SetDamage(200)
                end
            end
        end
    end
end)