function AJMRP.Jobs:SetJob(ply, team)
    if not AJMRP.Config.Jobs[team] then return false end
    local job = AJMRP.Config.Jobs[team]
    if job.max > 0 and team.NumPlayers(team) >= job.max then
        ply:ChatPrint("This job is full!")
        return false
    end
    ply:SetTeam(team)
    ply:SetModel(table.Random(job.model))
    for _, wep in ipairs(job.weapons) do
        ply:Give(wep)
    end
    AJMRP:SavePlayerData(ply) -- Save to MySQL
    ply:ChatPrint("You are now a " .. job.name .. "!")
    return true
end

concommand.Add("ajmrp_setjob", function(ply, cmd, args)
    local teamID = tonumber(args[1])
    if teamID then
        AJMRP.Jobs:SetJob(ply, teamID)
    end
end)