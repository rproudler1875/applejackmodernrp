function AJMRP:OpenF4Menu()
    local frame = vgui.Create("DFrame")
    frame:SetSize(800, 600)
    frame:Center()
    frame:SetTitle("AppleJack Modernised RP - F4 Menu")
    frame:MakePopup()

    local jobList = vgui.Create("DListView", frame)
    jobList:Dock(FILL)
    jobList:AddColumn("Job")
    jobList:AddColumn("Description")
    jobList:AddColumn("Salary")

    for teamID, job in pairs(AJMRP.Config.Jobs) do
        jobList:AddLine(job.name, job.description, AJMRP.Config.CurrencySymbol .. job.salary)
    end

    jobList.OnRowSelected = function(panel, row)
        local job = AJMRP.Config.Jobs[row]
        RunConsoleCommand("ajmrp_setjob", row)
    end
end

concommand.Add("ajmrp_f4menu", function()
    AJMRP:OpenF4Menu()
end)