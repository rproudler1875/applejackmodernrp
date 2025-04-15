AJMRP.Economy = AJMRP.Economy or {}

function AJMRP.Economy:GetBusiness(ply)
    return ply:GetNWString("AJMRP_Business", "")
end