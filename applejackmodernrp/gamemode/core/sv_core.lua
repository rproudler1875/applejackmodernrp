-- Server-side core functions
AJMRP = AJMRP or {}
AJMRP.Core = AJMRP.Core or {}

function AJMRP.Core:SetupPlayer(ply)
    AJMRP.Core:Log(ply:Nick() .. " has been set up")
end

function AJMRP:LoadPlayerData(ply)
    -- Placeholder for MySQL loading
    AJMRP.Core:Log("Loading data for " .. ply:Nick())
end

function AJMRP:SavePlayerData(ply)
    -- Placeholder for MySQL saving
    AJMRP.Core:Log("Saving data for " .. ply:Nick())
end