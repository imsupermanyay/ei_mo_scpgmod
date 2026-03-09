--[[
    Loot Spawn System - Shared
    网络字符串注册、权重算法、共享工具函数
]]

LOOTSPAWN = LOOTSPAWN or {}

-- 网络字符串
if SERVER then
    util.AddNetworkString("lootspawn_open_panel")
    util.AddNetworkString("lootspawn_sync_groups")
    util.AddNetworkString("lootspawn_save_group")
    util.AddNetworkString("lootspawn_delete_group")
    util.AddNetworkString("lootspawn_sync_spawns")
    util.AddNetworkString("lootspawn_add_spawn")
    util.AddNetworkString("lootspawn_remove_spawn")
    util.AddNetworkString("lootspawn_request_data")
end

-- 权重随机选取
function LOOTSPAWN.PickWeightedItem(items)
    if not items or #items == 0 then return nil end

    local total = 0
    for _, v in ipairs(items) do
        total = total + (v.weight or 1)
    end

    if total <= 0 then return nil end

    local roll = math.random() * total
    local cumulative = 0
    for _, v in ipairs(items) do
        cumulative = cumulative + (v.weight or 1)
        if roll <= cumulative then
            return v.class
        end
    end

    return items[#items].class
end
