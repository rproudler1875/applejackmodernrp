AJMRP.Properties = AJMRP.Properties or {}

function AJMRP.Properties:GetOwner(door)
    return door:GetNWString("AJMRP_Owner", "")
end

function AJMRP.Properties:IsOwned(door)
    return AJMRP.Properties:GetOwner(door) ~= ""
end