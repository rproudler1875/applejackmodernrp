-- Server-side core functions
AJMRP = AJMRP or {}
AJMRP.Core = AJMRP.Core or {}

function AJMRP.Core:SetupPlayer(ply)
    AJMRP.Core:Log(ply:Nick() .. " has been set up")
end

function AJMRP:LoadPlayerData(ply)
    -- Placeholder for MySQL loading
    AJMRP.Core:Log("Loading data for " .. ply:Nick())
    -- Check if bio exists
    if ply:GetNWString("AJMRP_Bio", "") == "" then
        net.Start("AJMRP_RequestBio")
        net.Send(ply)
    end
end

function AJMRP:SavePlayerData(ply)
    -- Placeholder for MySQL saving
    AJMRP.Core:Log("Saving data for " .. ply:Nick())
end

util.AddNetworkString("AJMRP_SetBio")
util.AddNetworkString("AJMRP_RequestBio")
util.AddNetworkString("AJMRP_ProposeTrade")
util.AddNetworkString("AJMRP_TradeRequest")
util.AddNetworkString("AJMRP_AcceptTrade")

net.Receive("AJMRP_SetBio", function(len, ply)
    local bio = net.ReadString()
    if bio:len() <= 200 then
        ply:SetNWString("AJMRP_Bio", bio)
        AJMRP:SavePlayerData(ply)
        AJMRP.ChatPrint(ply, "Bio set successfully!")
    else
        AJMRP.ChatPrint(ply, "Bio too long!")
    end
end)

net.Receive("AJMRP_ProposeTrade", function(len, ply)
    local target = net.ReadEntity()
    local amount = net.ReadUInt(32)
    if not IsValid(target) or not AJMRP.Economy:CanAfford(ply, amount) then
        AJMRP.ChatPrint(ply, "Invalid trade!")
        return
    end
    net.Start("AJMRP_TradeRequest")
    net.WriteEntity(ply)
    net.WriteUInt(amount, 32)
    net.Send(target)
end)

net.Receive("AJMRP_AcceptTrade", function(len, ply)
    local proposer = net.ReadEntity()
    local amount = net.ReadUInt(32)
    if not IsValid(proposer) or not AJMRP.Economy:CanAfford(proposer, amount) then
        AJMRP.ChatPrint(ply, "Trade failed!")
        return
    end
    AJMRP.Economy:TakeMoney(proposer, amount)
    AJMRP.Economy:AddMoney(ply, amount)
    AJMRP.ChatPrint(proposer, "Trade accepted! You paid " .. AJMRP.Config.CurrencySymbol .. amount .. " to " .. ply:Nick() .. ".")
    AJMRP.ChatPrint(ply, "Trade accepted! You received " .. AJMRP.Config.CurrencySymbol .. amount .. " from " .. proposer:Nick() .. ".")
end)

concommand.Add("profile", function(ply, cmd, args)
    local target = args[1] and player.GetByID(tonumber(args[1])) or ply
    if not IsValid(target) then
        AJMRP.ChatPrint(ply, "Invalid player!")
        return
    end
    local bio = target:GetNWString("AJMRP_Bio", "No bio set.")
    AJMRP.ChatPrint(ply, target:Nick() .. "'s Bio: " .. bio)
end)

concommand.Add("ajmrp_trade", function(ply, cmd, args)
    local target = args[1] and player.GetByID(tonumber(args[1])) or nil
    if not IsValid(target) then
        AJMRP.ChatPrint(ply, "Invalid player!")
        return
    end
    net.Start("AJMRP_TradeRequest")
    net.WriteEntity(target)
    net.WriteUInt(0, 32) -- Trigger UI
    net.Send(ply)
end)