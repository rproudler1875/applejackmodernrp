AJMRP.Economy = AJMRP.Economy or {}

function AJMRP.Economy:AddItem(ply, itemID, amount)
    local inventory = ply:GetNWString("AJMRP_Inventory", "{}")
    inventory = util.JSONToTable(inventory) or {}
    inventory[itemID] = (inventory[itemID] or 0) + (amount or 1)
    ply:SetNWString("AJMRP_Inventory", util.TableToJSON(inventory))
    AJMRP:SavePlayerData(ply)
    AJMRP.ChatPrint(ply, "Received " .. (amount or 1) .. "x " .. (AJMRP.Config.Items[itemID].name or itemID) .. ".")
end

function AJMRP.Economy:RemoveItem(ply, itemID, amount)
    local inventory = ply:GetNWString("AJMRP_Inventory", "{}")
    inventory = util.JSONToTable(inventory) or {}
    if not inventory[itemID] or inventory[itemID] < (amount or 1) then
        return false
    end
    inventory[itemID] = inventory[itemID] - (amount or 1)
    if inventory[itemID] <= 0 then
        inventory[itemID] = nil
    end
    ply:SetNWString("AJMRP_Inventory", util.TableToJSON(inventory))
    AJMRP:SavePlayerData(ply)
    return true
end

function AJMRP.Economy:HasItem(ply, itemID, amount)
    local inventory = ply:GetNWString("AJMRP_Inventory", "{}")
    inventory = util.JSONToTable(inventory) or {}
    return (inventory[itemID] or 0) >= (amount or 1)
end

concommand.Add("ajmrp_additem", function(ply, cmd, args)
    if not args[1] then return end
    local amount = tonumber(args[2]) or 1
    AJMRP.Economy:AddItem(ply, args[1], amount)
end)