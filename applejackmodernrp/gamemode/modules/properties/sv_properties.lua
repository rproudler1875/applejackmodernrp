AJMRP.Properties = AJMRP.Properties or {}

AJMRP.Properties.List = {
    ["house_1"] = {
        name = "Small House",
        price = 5000,
        doors = {}, -- Populated dynamically
        furniture = {}
    }
}

function AJMRP.Properties:SetupDoors()
    for _, door in ipairs(ents.FindByClass("func_door")) do
        door:SetNWString("AJMRP_Owner", "")
    end
end

function AJMRP.Properties:BuyProperty(ply, propertyID)
    local prop = AJMRP.Properties.List[propertyID]
    if not prop then
        AJMRP.ChatPrint(ply, "Invalid property!")
        return false
    end
    if not AJMRP.Economy:CanAfford(ply, prop.price) then
        AJMRP.ChatPrint(ply, "Not enough money!")
        return false
    end
    AJMRP.Economy:TakeMoney(ply, prop.price)
    ply:SetNWString("AJMRP_Property", propertyID)
    for _, door in ipairs(ents.FindByClass("func_door")) do
        if not AJMRP.Properties:IsOwned(door) then
            door:SetNWString("AJMRP_Owner", ply:SteamID())
            table.insert(prop.doors, door)
            if #prop.doors >= 2 then break end -- Limit to 2 doors per property
        end
    end
    AJMRP:SavePlayerData(ply)
    AJMRP.ChatPrint(ply, "Purchased " .. prop.name .. " for " .. AJMRP.Config.CurrencySymbol .. prop.price .. "!")
    return true
end

function AJMRP.Properties:AddFurniture(ply, propertyID, furnitureType)
    local prop = AJMRP.Properties.List[propertyID]
    if not prop then
        AJMRP.ChatPrint(ply, "Invalid property!")
        return false
    end
    if ply:GetNWString("AJMRP_Property", "") ~= propertyID then
        AJMRP.ChatPrint(ply, "You don't own this property!")
        return false
    end
    local furniture = {
        ["chair"] = { model = "models/props_c17/chair02a.mdl", price = 100 },
        ["table"] = { model = "models/props_c17/furnitureTable001a.mdl", price = 200 }
    }
    local furn = furniture[furnitureType]
    if not furn then
        AJMRP.ChatPrint(ply, "Invalid furniture type!")
        return false
    end
    if not AJMRP.Economy:CanAfford(ply, furn.price) then
        AJMRP.ChatPrint(ply, "Not enough money!")
        return false
    end
    AJMRP.Economy:TakeMoney(ply, furn.price)
    table.insert(prop.furniture, { type = furnitureType, model = furn.model, pos = ply:GetPos() + Vector(0, 0, 50) })
    local ent = ents.Create("prop_physics")
    ent:SetModel(furn.model)
    ent:SetPos(ply:GetPos() + Vector(0, 0, 50))
    ent:Spawn()
    AJMRP:SavePlayerData(ply)
    AJMRP.ChatPrint(ply, "Added " .. furnitureType .. " to your " .. prop.name .. "!")
    return true
end

hook.Add("InitPostEntity", "AJMRP_Properties_Setup", function()
    AJMRP.Properties:SetupDoors()
end)

concommand.Add("ajmrp_buyproperty", function(ply, cmd, args)
    if not args[1] then return end
    AJMRP.Properties:BuyProperty(ply, args[1])
end)

concommand.Add("ajmrp_addfurniture", function(ply, cmd, args)
    if not args[1] or not args[2] then return end
    AJMRP.Properties:AddFurniture(ply, args[1], args[2])
end)