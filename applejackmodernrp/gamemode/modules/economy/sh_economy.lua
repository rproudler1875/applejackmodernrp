AJMRP.Economy = AJMRP.Economy or {}

function AJMRP.Economy:GetMoney(ply)
    return ply:GetNWInt("AJMRP_Money", AJMRP.Config.StartingMoney)
end

function AJMRP.Economy:CanAfford(ply, amount)
    return AJMRP.Economy:GetMoney(ply) >= amount
end