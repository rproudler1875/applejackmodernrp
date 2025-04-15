if SERVER then
    AddCSLuaFile()
    return
end

local function CreateBioUI(ply)
    local frame = vgui.Create("DFrame")
    frame:SetSize(400, 300)
    frame:Center()
    frame:SetTitle("Character Bio Creation")
    frame:MakePopup()
    frame:SetSizable(false)
    frame:SetDraggable(false)

    local label = vgui.Create("DLabel", frame)
    label:SetPos(10, 30)
    label:SetSize(380, 20)
    label:SetText("Enter your character's backstory (max 200 characters):")

    local bioEntry = vgui.Create("DTextEntry", frame)
    bioEntry:SetPos(10, 60)
    bioEntry:SetSize(380, 150)
    bioEntry:SetMultiline(true)
    bioEntry:SetMaximumCharCount(200)

    local submit = vgui.Create("DButton", frame)
    submit:SetPos(150, 220)
    submit:SetSize(100, 30)
    submit:SetText("Submit")
    submit.DoClick = function()
        local bio = bioEntry:GetValue()
        if bio:len() > 0 then
            net.Start("AJMRP_SetBio")
            net.WriteString(bio)
            net.SendToServer()
            frame:Close()
        else
            chat.AddText(Color(255, 0, 0), "[AJMRP] Bio cannot be empty!")
        end
    end
end

net.Receive("AJMRP_RequestBio", function()
    CreateBioUI(LocalPlayer())
end)