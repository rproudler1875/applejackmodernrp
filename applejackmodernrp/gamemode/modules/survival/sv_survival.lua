AJMRP.Survival = AJMRP.Survival or {}

function AJMRP.Survival:InitPlayer(ply)
    ply:SetNWFloat("AJMRP_Hunger", AJMRP.Config.Survival.HungerMax)
    ply:SetNWFloat("AJMRP_Thirst", AJMRP.Config.Survival.ThirstMax)
    ply:SetNWFloat("AJMRP_Fatigue", AJMRP.Config.Survival.FatigueMax)
end

function AJMRP.Survival:UpdatePlayer(ply)
    local hunger = AJMRP.Survival:GetHunger(ply) - AJMRP.Config.Survival.HungerRate
    local thirst = AJMRP.Survival:GetThirst(ply) - AJMRP.Config.Survival.ThirstRate
    local fatigue = AJMRP.Survival:GetFatigue(ply) - AJMRP.Config.Survival.FatigueRate

    ply:SetNWFloat("AJMRP_Hunger", math.max(0, hunger))
    ply:SetNWFloat("AJMRP_Thirst", math.max(0, thirst))
    ply:SetNWFloat("AJMRP_Fatigue", math.max(0, fatigue))

    -- Apply status effects
    if hunger < AJMRP.Config.Survival.StatusEffects.Starvation.threshold then
        ply:SetWalkSpeed(200 * AJMRP.Config.Survival.StatusEffects.Starvation.speedMult)
        ply:SetRunSpeed(300 * AJMRP.Config.Survival.StatusEffects.Starvation.speedMult)
    else
        ply:SetWalkSpeed(200)
        ply:SetRunSpeed(300)
    end
end

hook.Add("PlayerInitialSpawn", "AJMRP_Survival_Init", function(ply)
    AJMRP.Survival:InitPlayer(ply)
end)

hook.Add("Think", "AJMRP_Survival_Update", function()
    for _, ply in ipairs(player.GetAll()) do
        AJMRP.Survival:UpdatePlayer(ply)
    end
end)