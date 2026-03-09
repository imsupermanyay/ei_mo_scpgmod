--[[
    Loot Spawn System - Client HUD
    在世界中显示刷新点标记（仅管理员持有工具枪时可见）
]]

local COLOR_SPAWN = Color(0, 200, 100, 200)
local COLOR_TEXT_BG = Color(0, 0, 0, 160)
local COLOR_WHITE = Color(255, 255, 255)

hook.Add("PostDrawTranslucentRenderables", "LootSpawn_DrawMarkers", function()
    local ply = LocalPlayer()
    if not IsValid(ply) or not ply:IsAdmin() then return end

    local wep = ply:GetActiveWeapon()
    if not IsValid(wep) or wep:GetClass() ~= "gmod_tool" then return end
    if ply:GetInfo("gmod_toolmode") ~= "lootspawn_placer" then return end

    local spawns = LOOTSPAWN.ClientSpawns
    if not spawns then return end

    local eyePos = ply:EyePos()

    for _, spawn in ipairs(spawns) do
        local pos = Vector(spawn.pos[1], spawn.pos[2], spawn.pos[3])
        local dist = eyePos:DistToSqr(pos)

        if dist > 4000000 then continue end -- 2000 units

        -- 画球体标记
        render.SetColorMaterial()
        render.DrawSphere(pos, 6, 12, 12, COLOR_SPAWN)

        -- 画文字标签
        local ang = (eyePos - pos):Angle()
        ang:RotateAroundAxis(ang:Up(), -90)
        ang:RotateAroundAxis(ang:Forward(), 90)

        cam.Start3D2D(pos + Vector(0, 0, 16), ang, 0.1)
            local text = "#" .. (spawn.id or "?") .. " [" .. (spawn.group or "?") .. "]"
            local tw = surface.GetTextSize(text)

            draw.RoundedBox(4, -tw / 2 - 6, -12, tw + 12, 24, COLOR_TEXT_BG)
            draw.SimpleText(text, "DermaDefault", 0, 0, COLOR_WHITE, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        cam.End3D2D()
    end
end)
