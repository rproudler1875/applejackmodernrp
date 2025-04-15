-- Client-side job UI
AJMRP.Jobs = AJMRP.Jobs or {}

function AJMRP.Jobs:DrawJobHUD()
    -- Placeholder for job display
    local job = AJMRP.Jobs:GetJob(LocalPlayer())
    draw.SimpleText("Job: " .. job.name, "DermaDefault", 50, 70, job.color)
end

-- hook.Add("HUDPaint", "AJMRP_Jobs_HUD", function()
--     AJMRP.Jobs:DrawJobHUD()
-- end)