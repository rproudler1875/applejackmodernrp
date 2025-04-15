AJMRP.Factions = AJMRP.Factions or {}

function AJMRP.Factions:CreateFaction(ply, name, color)
    local factionID = name:lower()
    if AJMRP.Config.Factions[factionID] then
        AJMRP.ChatPrint(ply, "Faction already exists!")
        return false
    end
    AJMRP.Config.Factions[factionID] = {
        name = name,
        color = color or Color(100, 100, 100),
        ranks = {
            { name = "Leader", permissions = {"all"} },
            { name = "Member", permissions = {} }
        },
        bank = 0
    }
    AJMRP.Factions:JoinFaction(ply, factionID, "Leader")
    AJMRP.ChatPrint(ply, "Created faction: " .. name)
    -- TODO: Save to MySQL
    return true
end

function AJMRP.Factions:JoinFaction(ply, factionID, rank)
    local faction = AJMRP.Factions:GetFactionData(factionID)
    if not faction then return false end
    ply:SetNWString("AJMRP_Faction", factionID)
    ply:SetNWString("AJMRP_FactionRank", rank or "Member")
    AJMRP:SavePlayerData(ply)
    AJMRP.ChatPrint(ply, "Joined faction: " .. faction.name)
    return true
end

concommand.Add("ajmrp_createfaction", function(ply, cmd, args)
    if not args[1] then return end
    AJMRP.Factions:CreateFaction(ply, args[1], Color(tonumber(args[2]) or 100, tonumber(args[3]) or 100, tonumber(args[4]) or 100))
end)

concommand.Add("ajmrp_joinfaction", function(ply, cmd, args)
    if not args[1] then return end
    AJMRP.Factions:JoinFaction(ply, args[1])
end)