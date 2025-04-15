-- Client-side core functions
AJMRP.Core = AJMRP.Core or {}

function AJMRP.Core:InitClient()
    AJMRP.Core:Log("Client core initialized")
end

hook.Add("Initialize", "AJMRP_Core_ClientInit", function()
    AJMRP.Core:InitClient()
end)