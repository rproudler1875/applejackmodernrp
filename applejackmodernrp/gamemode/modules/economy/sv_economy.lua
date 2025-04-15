-- Ensure AJMRP.Economy is initialized
AJMRP.Economy = AJMRP.Economy or {}

function AJMRP.Economy:SetMoney(ply, amount)
    ply:SetNWInt("AJMRP_Money", math.max(0, amount))
    AJMRP:SavePlayerData(ply) -- Save to MySQL (placeholder)
end

function AJMRP.Economy:AddMoney(ply, amount)
    AJMRP.Economy:SetMoney(ply, AJMRP.Economy:GetMoney(ply) + amount)
end

function AJMRP.Economy:TakeMoney(ply, amount)
    if not AJMRP.Economy:CanAfford(ply, amount) then return false end
    AJMRP.Economy:SetMoney(ply, AJMRP.Economy:GetMoney(ply) - amount)
    return true
end

hook.Add("PlayerInitialSpawn", "AJMRP_Economy_Init", function(ply)
    -- Safeguard for AJMRP.Config
    local startingMoney = (AJMRP.Config and AJMRP.Config.StartingMoney) or 500
    AJMRP.Economy:SetMoney(ply, startingMoney)
end)