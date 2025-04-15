AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("config/sh_config.lua")
AddCSLuaFile("core/sh_core.lua")
AddCSLuaFile("core/cl_core.lua")
AddCSLuaFile("modules/economy/sh_economy.lua")
AddCSLuaFile("modules/economy/cl_economy.lua")
AddCSLuaFile("modules/jobs/sh_jobs.lua")
AddCSLuaFile("modules/jobs/cl_jobs.lua")

include("shared.lua")
include("config/sv_config.lua")
include("core/sv_core.lua")
include("modules/economy/sv_economy.lua")
include("modules/jobs/sv_jobs.lua")

function GM:PlayerInitialSpawn(ply)
    ply:SetTeam(TEAM_CITIZEN)
    ply:SetModel("models/player/group01/male_01.mdl")
    AJMRP:LoadPlayerData(ply)
end

function GM:PlayerSpawn(ply)
    self.BaseClass:PlayerSpawn(ply) -- Call Sandbox spawn
    AJMRP.Core:SetupPlayer(ply)
end