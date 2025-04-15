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
    if not ply:GetNWString("AJMRP_Bio", ""):len() > 0 then
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

concommand.Add("profile", function(ply, cmd, args)
    local target = args[1] and player.GetByID(tonumber(args[1])) or ply
    if not IsValid(target) then
        AJMRP.ChatPrint(ply, "Invalid player!")
        return
    end
    local bio = target:GetNWString("AJMRP_Bio", "No bio set.")
    AJMRP.ChatPrint(ply, target:Nick() .. "'s Bio: " .. bio)
end)