AJMRP.Survival = AJMRP.Survival or {}

function AJMRP.Survival:GetHunger(ply)
    return ply:GetNWFloat("AJMRP_Hunger", AJMRP.Config.Survival.HungerMax)
end

function AJMRP.Survival:GetThirst(ply)
    return ply:GetNWFloat("AJMRP_Thirst", AJMRP.Config.Survival.ThirstMax)
end

function AJMRP.Survival:GetFatigue(ply)
    return ply:GetNWFloat("AJMRP_Fatigue", AJMRP.Config.Survival.FatigueMax)
end