--[[
    LootSpawn System Loader
    加载 lootspawn 子目录下的所有文件
]]

local BASE = GM.FolderName .. "/gamemode/modules/lootspawn/"

-- Shared
if SERVER then AddCSLuaFile(BASE .. "sh_lootspawn.lua") end
include(BASE .. "sh_lootspawn.lua")

-- Server
if SERVER then
    include(BASE .. "sv_lootspawn.lua")
end

-- Client
if SERVER then
    AddCSLuaFile(BASE .. "cl_lootspawn_panel.lua")
    AddCSLuaFile(BASE .. "cl_lootspawn_hud.lua")
end

if CLIENT then
    include(BASE .. "cl_lootspawn_panel.lua")
    include(BASE .. "cl_lootspawn_hud.lua")
end

MsgC(Color(0, 200, 100), "[LootSpawn] ", color_white, "系统文件已加载\n")
