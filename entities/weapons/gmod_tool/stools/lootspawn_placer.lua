--[[
    LootSpawn Placer - 工具枪
    左键：放置刷新点
    右键：删除最近的刷新点
    工具面板中选择要绑定的战利品组
]]

TOOL.Category = "LootSpawn"
TOOL.Name = "#tool.lootspawn_placer.name"

TOOL.ClientConVar["group"] = ""

if CLIENT then
    language.Add("tool.lootspawn_placer.name", "LootSpawn 点位放置器")
    language.Add("tool.lootspawn_placer.desc", "放置和管理物品刷新点位")
    language.Add("tool.lootspawn_placer.left", "放置刷新点 (绑定选中的组)")
    language.Add("tool.lootspawn_placer.right", "删除最近的刷新点 (3米内)")
    language.Add("tool.lootspawn_placer.reload", "打开管理面板")
end

function TOOL:LeftClick(trace)
    if CLIENT then return true end
    if not trace.Hit then return false end

    local ply = self:GetOwner()
    if not IsValid(ply) or not ply:IsAdmin() then return false end

    local group = ply:GetInfo("lootspawn_placer_group")
    if not group or group == "" then
        ply:ChatPrint("[LootSpawn] 请先在工具面板中选择一个战利品组")
        return false
    end

    -- 检查组是否存在
    LOOTSPAWN.LoadGroups()
    if not LOOTSPAWN.Groups[group] then
        ply:ChatPrint("[LootSpawn] 战利品组 '" .. group .. "' 不存在")
        return false
    end

    LOOTSPAWN.LoadSpawns()

    local maxId = 0
    for _, s in ipairs(LOOTSPAWN.Spawns) do
        if s.id and s.id > maxId then maxId = s.id end
    end

    table.insert(LOOTSPAWN.Spawns, {
        id = maxId + 1,
        pos = { trace.HitPos.x, trace.HitPos.y, trace.HitPos.z },
        ang = { 0, 0, 0 },
        group = group
    })

    LOOTSPAWN.SaveSpawns()

    for _, p in ipairs(player.GetAll()) do
        if p:IsAdmin() then LOOTSPAWN.SyncToClient(p) end
    end

    ply:ChatPrint("[LootSpawn] 已添加点位 #" .. (maxId + 1) .. " -> " .. group)
    return true
end

function TOOL:RightClick(trace)
    if CLIENT then return true end
    if not trace.Hit then return false end

    local ply = self:GetOwner()
    if not IsValid(ply) or not ply:IsAdmin() then return false end

    LOOTSPAWN.LoadSpawns()

    local hitPos = trace.HitPos
    local closest = nil
    local closestDist = 90000 -- 300 units squared

    for _, spawn in ipairs(LOOTSPAWN.Spawns) do
        local pos = Vector(spawn.pos[1], spawn.pos[2], spawn.pos[3])
        local dist = hitPos:DistToSqr(pos)
        if dist < closestDist then
            closestDist = dist
            closest = spawn
        end
    end

    if not closest then
        ply:ChatPrint("[LootSpawn] 附近没有找到刷新点 (3米内)")
        return false
    end

    for i, s in ipairs(LOOTSPAWN.Spawns) do
        if s.id == closest.id then
            table.remove(LOOTSPAWN.Spawns, i)
            break
        end
    end

    LOOTSPAWN.SaveSpawns()

    for _, p in ipairs(player.GetAll()) do
        if p:IsAdmin() then LOOTSPAWN.SyncToClient(p) end
    end

    ply:ChatPrint("[LootSpawn] 已删除点位 #" .. closest.id)
    return true
end

function TOOL:Reload(trace)
    if CLIENT then return true end

    local ply = self:GetOwner()
    if not IsValid(ply) or not ply:IsAdmin() then return false end

    LOOTSPAWN.SyncToClient(ply)

    net.Start("lootspawn_open_panel")
    net.Send(ply)

    return true
end

-- ==================== 工具面板 ====================

function TOOL.BuildCPanel(cpanel)
    cpanel:AddControl("Header", {
        Description = "选择一个战利品组，然后左键点击地面放置刷新点。\n右键点击已有点位附近可删除。\nR键打开管理面板。"
    })

    -- 请求最新数据
    net.Start("lootspawn_request_data")
    net.SendToServer()

    -- 组选择下拉框
    local comboBox = vgui.Create("DComboBox", cpanel)
    comboBox:Dock(TOP)
    comboBox:DockMargin(4, 8, 4, 4)
    comboBox:SetTall(28)
    comboBox:SetValue("选择战利品组...")

    local function RefreshCombo()
        comboBox:Clear()
        for classname, data in pairs(LOOTSPAWN.ClientGroups or {}) do
            comboBox:AddChoice((data.name or classname) .. " [" .. classname .. "]", classname)
        end
    end

    RefreshCombo()

    comboBox.OnSelect = function(_, _, _, data)
        RunConsoleCommand("lootspawn_placer_group", data)
    end

    -- 刷新按钮
    local btnRefresh = vgui.Create("DButton", cpanel)
    btnRefresh:Dock(TOP)
    btnRefresh:DockMargin(4, 4, 4, 4)
    btnRefresh:SetTall(26)
    btnRefresh:SetText("刷新组列表")
    btnRefresh.DoClick = function()
        net.Start("lootspawn_request_data")
        net.SendToServer()

        timer.Simple(0.5, function()
            if IsValid(comboBox) then
                RefreshCombo()
            end
        end)
    end

    -- 打开管理面板按钮
    local btnPanel = vgui.Create("DButton", cpanel)
    btnPanel:Dock(TOP)
    btnPanel:DockMargin(4, 4, 4, 4)
    btnPanel:SetTall(26)
    btnPanel:SetText("打开管理面板")
    btnPanel.DoClick = function()
        net.Start("lootspawn_request_data")
        net.SendToServer()

        timer.Simple(0.3, function()
            LOOTSPAWN.OpenMainPanel()
        end)
    end

    -- 统计信息
    local lblInfo = vgui.Create("DLabel", cpanel)
    lblInfo:Dock(TOP)
    lblInfo:DockMargin(4, 8, 4, 4)
    lblInfo:SetWrap(true)
    lblInfo:SetAutoStretchVertical(true)

    lblInfo.Think = function(self)
        local groupCount = table.Count(LOOTSPAWN.ClientGroups or {})
        local spawnCount = #(LOOTSPAWN.ClientSpawns or {})
        self:SetText("当前地图: " .. game.GetMap() .. "\n组数量: " .. groupCount .. "\n点位数量: " .. spawnCount)
    end
end
