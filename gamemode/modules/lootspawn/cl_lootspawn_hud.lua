--[[
    Loot Spawn System - Client HUD & Edit Mode
    编辑模式：左键放点位，右键删点位，F4退出
    显示所有点位标记和 HUD 提示
]]

local COLOR_SPAWN = Color(0, 200, 100, 200)
local COLOR_SPAWN_HOVER = Color(255, 200, 0, 220)
local COLOR_TEXT_BG = Color(0, 0, 0, 180)
local COLOR_WHITE = Color(255, 255, 255)
local COLOR_RED = Color(255, 80, 80)
local COLOR_GREEN = Color(80, 255, 80)
local COLOR_HUD_BG = Color(20, 20, 20, 200)

-- ==================== 点位标记渲染 ====================

hook.Add("PostDrawTranslucentRenderables", "LootSpawn_DrawMarkers", function()
    if not LOOTSPAWN.EditMode then return end

    local ply = LocalPlayer()
    if not IsValid(ply) then return end

    local spawns = LOOTSPAWN.ClientSpawns
    if not spawns then return end

    local eyePos = ply:EyePos()
    local aimPos = ply:GetEyeTrace().HitPos

    for _, spawn in ipairs(spawns) do
        local pos = Vector(spawn.pos[1], spawn.pos[2], spawn.pos[3])
        local dist = eyePos:DistToSqr(pos)

        if dist > 16000000 then continue end -- 4000 units

        -- 判断是否瞄准此点位
        local isHover = aimPos:DistToSqr(pos) < 90000 -- 300 units

        -- 画球体
        render.SetColorMaterial()
        render.DrawSphere(pos, 8, 12, 12, isHover and COLOR_SPAWN_HOVER or COLOR_SPAWN)

        -- 画文字标签
        if dist < 4000000 then -- 2000 units 内显示文字
            local ang = (eyePos - pos):Angle()
            ang:RotateAroundAxis(ang:Up(), -90)
            ang:RotateAroundAxis(ang:Forward(), 90)

            cam.Start3D2D(pos + Vector(0, 0, 20), ang, 0.1)
                local groupName = spawn.group or "?"
                local groupData = LOOTSPAWN.ClientGroups[groupName]
                local displayName = groupData and groupData.name or groupName

                local line1 = "#" .. (spawn.id or "?") .. "  " .. displayName
                local line2 = "[" .. groupName .. "]"

                surface.SetFont("DermaDefault")
                local tw1 = surface.GetTextSize(line1)
                local tw2 = surface.GetTextSize(line2)
                local tw = math.max(tw1, tw2)

                draw.RoundedBox(4, -tw / 2 - 8, -22, tw + 16, 44, COLOR_TEXT_BG)
                draw.SimpleText(line1, "DermaDefault", 0, -8, COLOR_WHITE, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                draw.SimpleText(line2, "DermaDefault", 0, 8, isHover and COLOR_SPAWN_HOVER or Color(180, 180, 180), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

                if isHover then
                    draw.SimpleText("右键删除", "DermaDefault", 0, 28, COLOR_RED, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                end
            cam.End3D2D()
        end
    end
end)

-- ==================== 编辑模式 HUD ====================

hook.Add("HUDPaint", "LootSpawn_EditModeHUD", function()
    if not LOOTSPAWN.EditMode then return end

    local scrW, scrH = ScrW(), ScrH()

    -- 顶部提示条
    draw.RoundedBox(6, scrW / 2 - 260, 8, 520, 60, COLOR_HUD_BG)

    draw.SimpleText("LootSpawn 编辑模式", "DermaDefaultBold", scrW / 2, 20, COLOR_GREEN, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

    local groupDisplay = LOOTSPAWN.EditGroup or "未选择"
    local groupData = LOOTSPAWN.ClientGroups[LOOTSPAWN.EditGroup]
    if groupData then
        groupDisplay = groupData.name .. " [" .. LOOTSPAWN.EditGroup .. "]"
    end

    draw.SimpleText("当前组: " .. groupDisplay, "DermaDefault", scrW / 2, 36, COLOR_WHITE, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    draw.SimpleText("左键=放置  右键=删除  F4=退出", "DermaDefault", scrW / 2, 52, Color(180, 180, 180), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

    -- 准星
    local cx, cy = scrW / 2, scrH / 2
    surface.SetDrawColor(COLOR_GREEN)
    surface.DrawLine(cx - 10, cy, cx + 10, cy)
    surface.DrawLine(cx, cy - 10, cx, cy + 10)
end)

-- ==================== 编辑模式输入 ====================

hook.Add("PlayerButtonDown", "LootSpawn_EditInput", function(ply, button)
    if not LOOTSPAWN.EditMode then return end
    if not IsFirstTimePredicted() then return end

    -- F4 退出编辑模式
    if button == KEY_F4 then
        LOOTSPAWN.EditMode = false
        net.Start("lootspawn_edit_mode")
            net.WriteBool(false)
        net.SendToServer()
        chat.AddText(Color(0, 200, 100), "[LootSpawn] ", Color(255, 255, 255), "已退出编辑模式")
        return
    end

    -- 左键：放置点位
    if button == MOUSE_LEFT then
        if not LOOTSPAWN.EditGroup or LOOTSPAWN.EditGroup == "" then
            chat.AddText(Color(255, 80, 80), "[LootSpawn] ", Color(255, 255, 255), "未选择战利品组")
            return
        end

        local trace = ply:GetEyeTrace()
        if not trace.Hit then return end

        net.Start("lootspawn_add_spawn")
            net.WriteVector(trace.HitPos)
            net.WriteString(LOOTSPAWN.EditGroup)
        net.SendToServer()
        return
    end

    -- 右键：删除最近点位
    if button == MOUSE_RIGHT then
        local trace = ply:GetEyeTrace()
        if not trace.Hit then return end

        local hitPos = trace.HitPos
        local closest = nil
        local closestDist = 90000 -- 300 units

        for _, spawn in ipairs(LOOTSPAWN.ClientSpawns or {}) do
            local pos = Vector(spawn.pos[1], spawn.pos[2], spawn.pos[3])
            local dist = hitPos:DistToSqr(pos)
            if dist < closestDist then
                closestDist = dist
                closest = spawn
            end
        end

        if not closest then
            chat.AddText(Color(255, 80, 80), "[LootSpawn] ", Color(255, 255, 255), "附近没有点位 (3米内)")
            return
        end

        net.Start("lootspawn_remove_spawn")
            net.WriteUInt(closest.id, 32)
        net.SendToServer()

        -- 本地立即移除
        for i, s in ipairs(LOOTSPAWN.ClientSpawns) do
            if s.id == closest.id then
                table.remove(LOOTSPAWN.ClientSpawns, i)
                break
            end
        end
        return
    end
end)

-- 编辑模式下屏蔽左右键的默认行为（攻击/使用）
hook.Add("StartCommand", "LootSpawn_BlockAttack", function(ply, cmd)
    if not LOOTSPAWN.EditMode then return end
    if ply ~= LocalPlayer() then return end

    cmd:RemoveKey(IN_ATTACK)
    cmd:RemoveKey(IN_ATTACK2)
end)
