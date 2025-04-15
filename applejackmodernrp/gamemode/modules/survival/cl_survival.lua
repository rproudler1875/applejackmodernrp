AJMRP.Survival = AJMRP.Survival or {}

function AJMRP.Survival:DrawHUD()
    local ply = LocalPlayer()
    local hunger = AJMRP.Survival:GetHunger(ply)
    local thirst = AJMRP.Survival:GetThirst(ply)
    local fatigue = AJMRP.Survival:GetFatigue(ply)

    local x, y = 10, ScrH() - 100
    draw.RoundedBox(4, x, y, 200, 20, Color(0, 0, 0, 200))
    draw.RoundedBox(4, x, y, 200 * (hunger / AJMRP.Config.Survival.HungerMax), 20, Color(200, 100, 50))
    draw.SimpleText("Hunger", "DermaDefault", x + 5, y + 5, Color(255, 255, 255))

    y = y + 25
    draw.RoundedBox(4, x, y, 200, 20, Color(0, 0, 0, 200))
    draw.RoundedBox(4, x, y, 200 * (thirst / AJMRP.Config.Survival.ThirstMax), 20, Color(50, 100, 200))
    draw.SimpleText("Thirst", "DermaDefault", x + 5, y + 5, Color(255, 255, 255))

    y = y + 25
    draw.RoundedBox(4, x, y, 200, 20, Color(0, 0, 0, 200))
    draw.RoundedBox(4, x, y, 200 * (fatigue / AJMRP.Config.Survival.FatigueMax), 20, Color(100, 50, 200))
    draw.SimpleText("Fatigue", "DermaDefault", x + 5, y + 5, Color(255, 255, 255))
end

hook.Add("HUDPaint", "AJMRP_Survival_HUD", function()
    AJMRP.Survival:DrawHUD()
end)