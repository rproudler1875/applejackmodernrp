AJMRP.Factions = AJMRP.Factions or {}

function AJMRP.Factions:GetFaction(ply)
    return ply:GetNWString("AJMRP_Faction", "Civilians")
end

function AJMRP.Factions:GetRank(ply)
    return ply:GetNWString("AJMRP_FactionRank", "Member")
end

function AJMRP.Factions:GetFactionData(factionID)
    return AJMRP.Config.Factions[factionID] or AJMRP.Config.Factions.DefaultFaction
end