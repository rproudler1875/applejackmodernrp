AJMRP.Jobs = AJMRP.Jobs or {}

function AJMRP.Jobs:GetJob(ply)
    return AJMRP.Config.Jobs[ply:Team()] or AJMRP.Config.Jobs[TEAM_CITIZEN]
end

function AJMRP.Jobs:GetJobName(ply)
    return AJMRP.Jobs:GetJob(ply).name
end