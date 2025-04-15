AJMRP.Survival = AJMRP.Survival or {}

function AJMRP.Survival:InitPlayer(ply)
    ply:SetNWFloat("AJMRP_Hunger", AJMRP.Config.Survival.HungerMax)
    ply:SetNWFloat("AJMRP_Thirst", AJMRP.Config.Survival.ThirstMax)
    ply:SetNWFloat("AJMRP_Fatigue", AJMRP.Config.Survival.FatigueMax)
    ply:SetNWFloat("AJMRP_Stamina", AJMRP.Config.Survival.StaminaMax)
    ply:SetNWInt("AJMRP_FitnessSkill", 0)
end

function AJMRP.Survival:UpdatePlayer(ply)
    local hunger = AJMRP.Survival:GetHunger(ply) - AJMRP.Config.Survival.HungerRate
    local thirst = AJMRP.Survival:GetThirst(ply) - AJMRP.Config.Survival.ThirstRate
    local fatigue = AJMRP.Survival:GetFatigue(ply) - AJMRP.Config.Survival.FatigueRate
    local stamina = AJMRP.Survival:GetStamina(ply)
    local fitness = AJMRP.Survival:GetFitnessSkill(ply)
    local staminaRegen = AJMRP.Config.Survival.StaminaRegenRate * (1 + fitness * 0.1)

    if fatigue < AJMRP.Config.Survival.StatusEffects.Exhaustion.threshold then
        staminaRegen = staminaRegen * AJMRP.Config.Survival.StatusEffects.Exhaustion.staminaRegenMult
    end

    if ply:IsSprinting() and stamina > 0 then
        stamina = stamina - AJMRP.Config.Survival.StaminaSprintCost
    elseif stamina < AJMRP.Config.Survival.StaminaMax then
        stamina = math.min(AJMRP.Config.Survival.StaminaMax, stamina + staminaRegen)
    end

    ply:SetNWFloat("AJMRP_Hunger", math.max(0, hunger))
    ply:SetNWFloat("AJMRP_Thirst", math.max(0, thirst))
    ply:SetNWFloat("AJMRP_Fatigue", math.max(0, fatigue))
    ply:SetNWFloat("AJMRP_Stamina", math.max(0, stamina))

    -- Apply status effects
    if hunger < AJMRP.Config.Survival.StatusEffects.Starvation.threshold then
        ply:SetWalkSpeed(200 * AJMRP.Config.Survival.StatusEffects.Starvation.speedMult)
        ply:SetRunSpeed(300 * AJMRP.Config.Survival.StatusEffects.Starvation.speedMult)
    else
        ply:SetWalkSpeed(200)
        ply:SetRunSpeed(300)
    end

    if stamina <= 0 then
        ply:SetRunSpeed(ply:GetWalkSpeed())
    end
end

function AJMRP.Survival:AddFitnessSkill(ply, amount)
    local current = AJMRP.Survival:GetFitnessSkill(ply)
    ply:SetNWInt("AJMRP_FitnessSkill", current + amount)
    AJMRP:SavePlayerData(ply)
    AJMRP.ChatPrint(ply, "Gained " .. amount .. " Fitness Skill!")
end

local recipes = {
    { name = "Steak", hunger = 30, cost = 50 },
    { name = "Water Bottle", thirst = 40, cost = 20 }
}

net.Receive("AJMRP_CookRecipe", function(len, ply)
    local recipeID = net.ReadUInt(8)
    local recipe = recipes[recipeID]
    if not recipe then
        AJMRP.ChatPrint(ply, "Invalid recipe!")
        return
    end
    if not AJMRP.Economy:CanAfford(ply, recipe.cost) then
        AJMRP.ChatPrint(ply, "Not enough money!")
        return
    end
    AJMRP.Economy:TakeMoney(ply, recipe.cost)
    if recipe.hunger then
        ply:SetNWFloat("AJMRP_Hunger", math.min(AJMRP.Config.Survival.HungerMax, AJMRP.Survival:GetHunger(ply) + recipe.hunger))
    elseif recipe.thirst then
        ply:SetNWFloat("AJMRP_Thirst", math.min(AJMRP.Config.Survival.ThirstMax, AJMRP.Survival:GetThirst(ply) + recipe.thirst))
    end
    AJMRP.ChatPrint(ply, "Cooked " .. recipe.name .. "!")
end)

hook.Add("PlayerInitialSpawn", "AJMRP_Survival_Init", function(ply)
    AJMRP.Survival:InitPlayer(ply)
end)

hook.Add("Think", "AJMRP_Survival_Update", function()
    for _, ply in ipairs(player.GetAll()) do
        AJMRP.Survival:UpdatePlayer(ply)
    end
end)

hook.Add("PlayerTick", "AJMRP_Survival_Fitness", function(ply)
    if ply:IsSprinting() and math.random() < 0.01 then
        AJMRP.Survival:AddFitnessSkill(ply, 1)
    end
end)