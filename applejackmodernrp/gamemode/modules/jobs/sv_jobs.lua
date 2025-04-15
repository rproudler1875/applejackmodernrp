AJMRP.Jobs = AJMRP.Jobs or {}

function AJMRP.Jobs:GetPlayerXP(ply)
    return ply:GetNWInt("AJMRP_XP", 0)
end

function AJMRP.Jobs:AddXP(ply, amount)
    local current = AJMRP.Jobs:GetPlayerXP(ply)
    ply:SetNWInt("AJMRP_XP", current + amount)
    AJMRP:SavePlayerData(ply)
    AJMRP.Jobs:CheckTier(ply)
end

function AJMRP.Jobs:GetCurrentTier(ply)
    local job = AJMRP.Jobs:GetJob(ply)
    local xp = AJMRP.Jobs:GetPlayerXP(ply)
    local highestTier = job.tiers[1]
    for _, tier in ipairs(job.tiers) do
        if xp >= tier.xp and tier.level > highestTier.level then
            highestTier = tier
        end
    end
    return highestTier
end

function AJMRP.Jobs:CheckTier(ply)
    local tier = AJMRP.Jobs:GetCurrentTier(ply)
    if ply:GetNWString("AJMRP_Tier", "") ~= tier.name then
        ply:SetNWString("AJMRP_Tier", tier.name)
        ply:StripWeapons()
        for _, wep in ipairs(tier.weapons) do
            ply:Give(wep)
        end
        AJMRP.ChatPrint(ply, "Promoted to " .. tier.name .. "!")
    end
end

function AJMRP.Jobs:SetJob(ply, team)
    if not AJMRP.Config.Jobs[team] then return false end
    local job = AJMRP.Config.Jobs[team]
    if job.max > 0 and team.NumPlayers(team) >= job.max then
        AJMRP.ChatPrint(ply, "This job is full!")
        return false
    end
    ply:SetTeam(team)
    ply:SetNWInt("AJMRP_XP", 0) -- Reset XP for new job
    ply:SetModel(table.Random(job.model))
    local tier = AJMRP.Jobs:GetCurrentTier(ply)
    ply:SetNWString("AJMRP_Tier", tier.name)
    for _, wep in ipairs(tier.weapons) do
        ply:Give(wep)
    end
    AJMRP:SavePlayerData(ply)
    AJMRP.ChatPrint(ply, "You are now a " .. job.name .. " (" .. tier.name .. ")!")
    return true
end

concommand.Add("ajmrp_setjob", function(ply, cmd, args)
    local teamID = tonumber(args[1])
    if teamID then
        AJMRP.Jobs:SetJob(ply, teamID)
    end
end)

-- Test command to add XP
concommand.Add("ajmrp_addxp", function(ply, cmd, args)
    local amount = tonumber(args[1]) or 0
    AJMRP.Jobs:AddXP(ply, amount)
end)