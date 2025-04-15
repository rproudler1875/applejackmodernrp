AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Cooking Station"
ENT.Author = "xAI Community"
ENT.Spawnable = true

function ENT:Initialize()
    if SERVER then
        self:SetModel("models/props_c17/furnitureStove001a.mdl")
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
        self:SetUseType(SIMPLE_USE)
    end
end

function ENT:Use(activator, caller)
    if not IsValid(caller) or not caller:IsPlayer() then return end
    -- TODO: Open cooking UI
    AJMRP.ChatPrint(caller, "Cooking station used (UI coming soon)!")
end