--[[
    Loot Spawn System - Server
    数据保存/加载、刷新逻辑、网络通信、编辑模式
]]

LOOTSPAWN.Groups = LOOTSPAWN.Groups or {}
LOOTSPAWN.Spawns = LOOTSPAWN.Spawns or {}

local GROUP_PATH = "lootconfig/groups.json"

local function GetSpawnPath()
    return "lootconfig/spawns/" .. game.GetMap() .. ".json"
end

-- ==================== 文件读写 ====================

function LOOTSPAWN.LoadGroups()
    if not file.Exists(GROUP_PATH, "DATA") then
        LOOTSPAWN.Groups = {}
        return
    end
    local raw = file.Read(GROUP_PATH, "DATA")
    LOOTSPAWN.Groups = util.JSONToTable(raw) or {}
end

function LOOTSPAWN.SaveGroups()
    file.CreateDir("lootconfig")
    file.Write(GROUP_PATH, util.TableToJSON(LOOTSPAWN.Groups, true))
end

function LOOTSPAWN.LoadSpawns()
    local path = GetSpawnPath()
    if not file.Exists(path, "DATA") then
        LOOTSPAWN.Spawns = {}
        return
    end
    local raw = file.Read(path, "DATA")
    LOOTSPAWN.Spawns = util.JSONToTable(raw) or {}
end

function LOOTSPAWN.SaveSpawns()
    file.CreateDir("lootconfig/spawns")
    file.Write(GetSpawnPath(), util.TableToJSON(LOOTSPAWN.Spawns, true))
end

-- ==================== 刷新逻辑 ====================

function LOOTSPAWN.SpawnAll()
    LOOTSPAWN.LoadGroups()
    LOOTSPAWN.LoadSpawns()

    local count = 0
    for _, spawn in ipairs(LOOTSPAWN.Spawns) do
        local group = LOOTSPAWN.Groups[spawn.group]
        if not group or not group.items or #group.items == 0 then continue end

        local itemClass = LOOTSPAWN.PickWeightedItem(group.items)
        if not itemClass then continue end

        local ent = ents.Create(itemClass)
        if not IsValid(ent) then continue end

        local pos = Vector(spawn.pos[1], spawn.pos[2], spawn.pos[3])
        local ang = Angle(spawn.ang[1] or 0, spawn.ang[2] or 0, spawn.ang[3] or 0)

        ent:SetPos(pos)
        ent:SetAngles(ang)
        ent:Spawn()
        ent:Activate()
        count = count + 1
    end

    MsgC(Color(0, 200, 100), "[LootSpawn] ", color_white, "已刷新 " .. count .. " 个物品 (地图: " .. game.GetMap() .. ")\n")
end

-- ==================== 同步 ====================

function LOOTSPAWN.SyncToClient(ply)
    LOOTSPAWN.LoadGroups()
    LOOTSPAWN.LoadSpawns()

    local groupData = util.TableToJSON(LOOTSPAWN.Groups)
    local spawnData = util.TableToJSON(LOOTSPAWN.Spawns)

    net.Start("lootspawn_sync_groups")
        net.WriteUInt(#groupData, 32)
        net.WriteData(groupData, #groupData)
    net.Send(ply)

    net.Start("lootspawn_sync_spawns")
        net.WriteUInt(#spawnData, 32)
        net.WriteData(spawnData, #spawnData)
    net.Send(ply)
end

local function SyncToAllAdmins()
    for _, p in ipairs(player.GetAll()) do
        if p:IsAdmin() then LOOTSPAWN.SyncToClient(p) end
    end
end

-- ==================== 网络接收 ====================

net.Receive("lootspawn_request_data", function(len, ply)
    if not IsValid(ply) or not ply:IsAdmin() then return end
    LOOTSPAWN.SyncToClient(ply)
end)

net.Receive("lootspawn_save_group", function(len, ply)
    if not IsValid(ply) or not ply:IsAdmin() then return end

    local dataLen = net.ReadUInt(32)
    local raw = net.ReadData(dataLen)
    local data = util.JSONToTable(raw)
    if not data or not data.classname then return end

    LOOTSPAWN.LoadGroups()
    LOOTSPAWN.Groups[data.classname] = {
        classname = data.classname,
        name = data.name or data.classname,
        items = data.items or {}
    }
    LOOTSPAWN.SaveGroups()
    SyncToAllAdmins()

    MsgC(Color(0, 200, 100), "[LootSpawn] ", color_white, ply:Nick() .. " 保存了战利品组: " .. data.classname .. "\n")
end)

net.Receive("lootspawn_delete_group", function(len, ply)
    if not IsValid(ply) or not ply:IsAdmin() then return end

    local classname = net.ReadString()
    if not classname or classname == "" then return end

    LOOTSPAWN.LoadGroups()
    LOOTSPAWN.Groups[classname] = nil
    LOOTSPAWN.SaveGroups()
    SyncToAllAdmins()

    MsgC(Color(0, 200, 100), "[LootSpawn] ", color_white, ply:Nick() .. " 删除了战利品组: " .. classname .. "\n")
end)

net.Receive("lootspawn_add_spawn", function(len, ply)
    if not IsValid(ply) or not ply:IsAdmin() then return end

    local pos = net.ReadVector()
    local group = net.ReadString()
    if not group or group == "" then return end

    LOOTSPAWN.LoadSpawns()

    local maxId = 0
    for _, s in ipairs(LOOTSPAWN.Spawns) do
        if s.id and s.id > maxId then maxId = s.id end
    end

    table.insert(LOOTSPAWN.Spawns, {
        id = maxId + 1,
        pos = { pos.x, pos.y, pos.z },
        ang = { 0, 0, 0 },
        group = group
    })

    LOOTSPAWN.SaveSpawns()
    SyncToAllAdmins()

    ply:ChatPrint("[LootSpawn] 已添加点位 #" .. (maxId + 1) .. " -> " .. group)
end)

net.Receive("lootspawn_remove_spawn", function(len, ply)
    if not IsValid(ply) or not ply:IsAdmin() then return end

    local spawnId = net.ReadUInt(32)

    LOOTSPAWN.LoadSpawns()

    for i, s in ipairs(LOOTSPAWN.Spawns) do
        if s.id == spawnId then
            table.remove(LOOTSPAWN.Spawns, i)
            break
        end
    end

    LOOTSPAWN.SaveSpawns()
    SyncToAllAdmins()

    ply:ChatPrint("[LootSpawn] 已删除点位 #" .. spawnId)
end)

-- ==================== 编辑模式 ====================

-- 服务端记录谁在编辑模式中（用于 trace 权限校验）
LOOTSPAWN.EditingPlayers = LOOTSPAWN.EditingPlayers or {}

net.Receive("lootspawn_edit_mode", function(len, ply)
    if not IsValid(ply) or not ply:IsAdmin() then return end
    local enabled = net.ReadBool()
    LOOTSPAWN.EditingPlayers[ply:SteamID64()] = enabled or nil
end)

-- ==================== 聊天命令 ====================

hook.Add("PlayerSay", "LootSpawn_ChatCommand", function(ply, text)
    local lower = string.lower(text)
    if lower == "!lootspawn" or lower == "/lootspawn" then
        if not ply:IsAdmin() then
            ply:ChatPrint("[LootSpawn] 你没有权限使用此命令")
            return ""
        end

        LOOTSPAWN.SyncToClient(ply)

        net.Start("lootspawn_open_panel")
        net.Send(ply)

        return ""
    end
end)

-- ==================== 初始化 ====================

hook.Add("Initialize", "LootSpawn_Init", function()
    LOOTSPAWN.LoadGroups()
    LOOTSPAWN.LoadSpawns()
    MsgC(Color(0, 200, 100), "[LootSpawn] ", color_white, "系统已加载 - 组: " .. table.Count(LOOTSPAWN.Groups) .. " 点位: " .. #LOOTSPAWN.Spawns .. "\n")
end)

hook.Add("PlayerDisconnected", "LootSpawn_CleanupEditMode", function(ply)
    LOOTSPAWN.EditingPlayers[ply:SteamID64()] = nil
end)
