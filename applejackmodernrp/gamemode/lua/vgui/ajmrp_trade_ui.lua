if SERVER then
    AddCSLuaFile()
    return
end

local function CreateTradeUI(ply, target)
    local frame = vgui.Create("DFrame")
    frame:SetSize(400, 300)
    frame:Center()
    frame:SetTitle("Trade with " .. target:Nick())
    frame:MakePopup()

    local moneyLabel = vgui.Create("DLabel", frame)
    moneyLabel:SetPos(10, 30)
    moneyLabel:SetText("Your Money Offer:")
    moneyLabel:SetSize(380, 20)

    local moneyEntry = vgui.Create("DTextEntry", frame)
    moneyEntry:SetPos(10, 60)
    moneyEntry:SetSize(380, 30)
    moneyEntry:SetNumeric(true)

    local submit = vgui.Create("DButton", frame)
    submit:SetPos(150, 100)
    submit:SetSize(100, 30)
    submit:SetText("Offer Trade")
    submit.DoClick = function()
        local amount = tonumber(moneyEntry:GetValue()) or 0
        if amount > 0 then
            net.Start("AJMRP_ProposeTrade")
            net.WriteEntity(target)
            net.WriteUInt(amount, 32)
            net.SendToServer()
            frame:Close()
        else
            chat.AddText(Color(255, 0, 0), "[AJMRP] Invalid amount!")
        end
    end
end

net.Receive("AJMRP_TradeRequest", function()
    local proposer = net.ReadEntity()
    local amount = net.ReadUInt(32)
    local frame = vgui.Create("DFrame")
    frame:SetSize(400, 300)
    frame:Center()
    frame:SetTitle("Trade Request from " .. proposer:Nick())
    frame:MakePopup()

    local label = vgui.Create("DLabel", frame)
    label:SetPos(10, 30)
    label:SetText(proposer:Nick() .. " offers " .. AJMRP.Config.CurrencySymbol .. amount)
    label:SetSize(380, 20)

    local accept = vgui.Create("DButton", frame)
    accept:SetPos(100, 60)
    accept:SetSize(100, 30)
    accept:SetText("Accept")
    accept.DoClick = function()
        net.Start("AJMRP_AcceptTrade")
        net.WriteEntity(proposer)
        net.WriteUInt(amount, 32)
        net.SendToServer()
        frame:Close()
    end

    local decline = vgui.Create("DButton", frame)
    decline:SetPos(210, 60)
    decline:SetSize(100, 30)
    decline:SetText("Decline")
    decline.DoClick = function()
        frame:Close()
    end
end)