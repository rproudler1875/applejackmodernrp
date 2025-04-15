AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("config/sh_config.lua")
AddCSLuaFile("core/sh_core.lua")
AddCSLuaFile("core/cl_core.lua")
AddCSLuaFile("core/sh_util.lua")
AddCSLuaFile("modules/economy/sh_economy.lua")
AddCSLuaFile("modules/economy/cl_economy.lua")
AddCSLuaFile("modules/economy/sh_business.lua")
AddCSLuaFile("modules/jobs/sh_jobs.lua")
AddCSLuaFile("modules/jobs/cl_jobs.lua")
AddCSLuaFile("modules/factions/sh_factions.lua")
AddCSLuaFile("modules/factions/cl_factions.lua")
AddCSLuaFile("modules/survival/sh_survival.lua")
AddCSLuaFile("modules/survival/cl_survival.lua")
AddCSLuaFile("entities/entities/ajmrp_cooking_station.lua")
AddCSLuaFile("lua/vgui/ajmrp_bio_ui.lua")
AddCSLuaFile("lua/vgui/ajmrp_cooking_ui.lua")
AddCSLuaFile("lua/vgui/ajmrp_trade_ui.lua")

include("shared.lua")
include("config/sh_config.lua")
include("core/sh_core.lua")
include("core/sh_util.lua")
include("config/sv_config.lua")
include("core/sv_core.lua")
include("modules/economy/sv_economy.lua")
include("modules/economy/sv_business.lua")
include("modules/economy/sv_inventory.lua")
include("modules/jobs/sv_jobs.lua")
include("modules/factions/sv_factions.lua")
include("modules/survival/sh_survival.lua")
include("modules/survival/sv_survival.lua")

function GM:PlayerInitialSpawn(ply)
    ply:SetTeam(TEAM_CITIZEN)
    ply:SetModel("models/player/group01/male_01.mdl")
    AJMRP:LoadPlayerData(ply)
end

function GM:PlayerSpawn(ply)
    self.BaseClass:PlayerSpawn(ply) -- Call Sandbox spawn
    AJMRP.Core:SetupPlayer(ply)
end