-- Client-side economy UI
AJMRP.Economy = AJMRP.Economy or {}

function AJMRP.Economy:DrawHUD()
    -- Placeholder for money display
    local money = AJMRP.Economy:GetMoney(LocalPlayer())
    draw.SimpleText(AJMRP.Config.CurrencySymbol .. money, "DermaDefault", 50, 50, Color(255, 255, 255))
end

-- hook.Add("HUDPaint", "AJMRP_Economy_HUD", function()
--     AJMRP.Economy:DrawHUD()
-- end)