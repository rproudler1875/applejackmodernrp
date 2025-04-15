-- Shared utility functions
AJMRP = AJMRP or {}

function AJMRP.ChatPrint(ply, msg)
    if SERVER then
        ply:ChatPrint("[AJMRP] " .. msg)
    elseif CLIENT and ply == LocalPlayer() then
        chat.AddText(Color(255, 255, 255), "[AJMRP] ", msg)
    end
end