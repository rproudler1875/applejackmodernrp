if SERVER then
    AddCSLuaFile()
    return
end

function AJMRP.Properties:OpenPropertyUI()
    local frame = vgui.Create("DFrame")
    frame:SetSize(400, 300)
    frame:Center()
    frame:SetTitle("Property Management")
    frame:MakePopup()

    local propertyList = vgui.Create("DListView", frame)
    propertyList:SetPos(10, 30)
    propertyList:SetSize(380, 200)
    propertyList:AddColumn("Property")
    propertyList:AddColumn("Price")

    for id, prop in pairs(AJMRP.Properties.List) do
        propertyList:AddLine(prop.name, AJMRP.Config.CurrencySymbol .. prop.price)
    end

    propertyList.OnRowSelected = function(panel, row)
        local propertyID = table.KeyFromValue(AJMRP.Properties.List, AJMRP.Properties.List[row])
        RunConsoleCommand("ajmrp_buyproperty", propertyID)
    end

    local furnitureButton = vgui.Create("DButton", frame)
    furnitureButton:SetPos(10, 240)
    furnitureButton:SetSize(100, 30)
    furnitureButton:SetText("Add Furniture")
    furnitureButton.DoClick = function()
        local propertyID = LocalPlayer():GetNWString("AJMRP_Property", "")
        if propertyID == "" then
            chat.AddText(Color(255, 0, 0), "[AJMRP] You don't own a property!")
            return
        end
        local menu = DermaMenu()
        menu:AddOption("Chair", function()
            RunConsoleCommand("ajmrp_addfurniture", propertyID, "chair")
        end)
        menu:AddOption("Table", function()
            RunConsoleCommand("ajmrp_addfurniture", propertyID, "table")
        end)
        menu:Open()
    end
end

concommand.Add("ajmrp_propertyui", function()
    AJMRP.Properties:OpenPropertyUI()
end)