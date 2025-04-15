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
        bank = 0,
        territories = {}
    }
    AJMRP.Factions:JoinFaction(ply, factionID, "Leader")
    AJMRP.ChatPrint(ply, "Created faction: " .. name)
    -- TODO: Save to MySQL
    return true
end

function AJMRP.Factions:JoinFaction(ply, factionID, rank)
    local faction = AJMRP.Factions:GetFactionData(factionID)
    if not faction then
        AJMRP.ChatPrint(ply, "Faction does not exist!")
        return false
    end
    ply:SetNWString("AJMRP_Faction", factionID)
    ply:SetNWString("AJMRP_FactionRank", rank or "Member")
    AJMRP:SavePlayerData(ply)
    AJMRP.ChatPrint(ply, "Joined faction: " .. faction.name)
    return true
end

function AJMRP.Factions:DepositBank(ply, factionID, amount)
    local faction = AJMRP.Factions:GetFactionData(factionID)
    if not faction then
        AJMRP.ChatPrint(ply, "Faction does not exist!")
        return false
    end
    if not AJMRP.Economy:CanAfford(ply, amount) then
        AJMRP.ChatPrint(ply, "Not enough money!")
        return false
    end
    AJMRP.Economy:TakeMoney(ply, amount)
    faction.bank = faction.bank + amount
    AJMRP.ChatPrint(ply, "Deposited " .. AJMRP.Config.CurrencySymbol .. amount .. " to " .. faction.name .. " bank.")
    -- TODO: Save to MySQL
    return true
end

function AJMRP.Factions:ClaimTerritory(ply, territory)
    local factionID = AJMRP.Factions:GetFaction(ply)
    local faction = AJMRP.Factions:GetFactionData(factionID)
    if not faction then return false end
    if not table.HasValue(faction.ranks[1].permissions, "all") and ply:GetNWString("AJMRP_FactionRank") ~= "Leader" then
        AJMRP.ChatPrint(ply, "Only leaders can claim territories!")
        return false
    end
    table.insert(faction.territories, territory)
    AJMRP.ChatPrint(ply, "Claimed territory: " .. territory)
    -- TODO: Implement territory bonuses/raids
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

concommand.Add("ajmrp_depositfaction", function(ply, cmd, args)
    if not args[1] or not args[2] then return end
    AJMRP.Factions:DepositBank(ply, args[1], tonumber(args[2]) or 0)
end)

concommand.Add("ajmrp_claimterritory", function(ply, cmd, args)
    if not args[1] then return end
    AJMRP.Factions:ClaimTerritory(ply, args[1])
end)