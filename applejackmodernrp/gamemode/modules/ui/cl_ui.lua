function AJMRP:OpenF4Menu()
    local frame = vgui.Create("DFrame")
    frame:SetSize(800, 600)
    frame:Center()
    frame:SetTitle("AppleJack Modernised RP - F4 Menu")
    frame:MakePopup()

    local tabs = vgui.Create("DPropertySheet", frame)
    tabs:Dock(FILL)

    -- Jobs Tab
    local jobPanel = vgui.Create("DPanel")
    local jobList = vgui.Create("DListView", jobPanel)
    jobList:Dock(FILL)
    jobList:AddColumn("Job")
    jobList:AddColumn("Tier")
    jobList:AddColumn("Description")
    jobList:AddColumn("Salary")

    for teamID, job in pairs(AJMRP.Config.Jobs) do
        for _, tier in ipairs(job.tiers) do
            jobList:AddLine(job.name, tier.name, job.description, AJMRP.Config.CurrencySymbol .. job.salary)
        end
    end

    jobList.OnRowSelected = function(panel, row)
        local teamID = math.floor((row - 1) / #AJMRP.Config.Jobs[TEAM_CITIZEN].tiers) + 1
        RunConsoleCommand("ajmrp_setjob", teamID)
    end

    tabs:AddSheet("Jobs", jobPanel, "icon16/user.png")

    -- Factions Tab
    local factionPanel = vgui.Create("DPanel")
    local factionLabel = vgui.Create("DLabel", factionPanel)
    factionLabel:SetPos(10, 10)
    factionLabel:SetText("Faction Management (Coming Soon)")
    tabs:AddSheet("Factions", factionPanel, "icon16/group.png")
end

concommand.Add("ajmrp_f4menu", function()
    AJMRP:OpenF4Menu()
end)