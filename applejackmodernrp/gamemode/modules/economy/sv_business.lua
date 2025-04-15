AJMRP.Economy = AJMRP.Economy or {}

AJMRP.Economy.Businesses = {
    ["bar"] = {
        name = "Bar",
        cost = 1000,
        income = 50, -- Per interaction
        maxInteractions = 5, -- Per minute
        cooldown = 60 -- Seconds
    }
}

function AJMRP.Economy:CreateBusiness(ply, businessID)
    local business = AJMRP.Economy.Businesses[businessID]
    if not business then
        AJMRP.ChatPrint(ply, "Invalid business type!")
        return false
    end
    if not AJMRP.Economy:CanAfford(ply, business.cost) then
        AJMRP.ChatPrint(ply, "Not enough money!")
        return false
    end
    AJMRP.Economy:TakeMoney(ply, business.cost)
    ply:SetNWString("AJMRP_Business", businessID)
    ply:SetNWInt("AJMRP_BusinessInteractions", 0)
    ply:SetNWInt("AJMRP_BusinessLastInteraction", 0)
    AJMRP.ChatPrint(ply, "Purchased " .. business.name .. " business!")
    return true
end

function AJMRP.Economy:InteractBusiness(customer, owner)
    local businessID = owner:GetNWString("AJMRP_Business", "")
    local business = AJMRP.Economy.Businesses[businessID]
    if not business then
        AJMRP.ChatPrint(customer, "This player doesn't own a business!")
        return false
    end
    local lastInteraction = owner:GetNWInt("AJMRP_BusinessLastInteraction", 0)
    local interactions = owner:GetNWInt("AJMRP_BusinessInteractions", 0)
    if CurTime() - lastInteraction < business.cooldown then
        AJMRP.ChatPrint(customer, "Business is on cooldown!")
        return false
    end
    if interactions >= business.maxInteractions then
        AJMRP.ChatPrint(customer, "Business is at max interactions for now!")
        return false
    end
    if not AJMRP.Economy:CanAfford(customer, business.income * 0.5) then
        AJMRP.ChatPrint(customer, "Not enough money!")
        return false
    end
    AJMRP.Economy:TakeMoney(customer, business.income * 0.5)
    AJMRP.Economy:AddMoney(owner, business.income)
    owner:SetNWInt("AJMRP_BusinessInteractions", interactions + 1)
    owner:SetNWInt("AJMRP_BusinessLastInteraction", CurTime())
    AJMRP.ChatPrint(customer, "You spent " .. AJMRP.Config.CurrencySymbol .. (business.income * 0.5) .. " at " .. owner:Nick() .. "'s " .. business.name .. "!")
    AJMRP.ChatPrint(owner, customer:Nick() .. " used your " .. business.name .. ", earned " .. AJMRP.Config.CurrencySymbol .. business.income .. "!")
    return true
end

-- Reset interactions every minute
hook.Add("Think", "AJMRP_Business_Reset", function()
    for _, ply in ipairs(player.GetAll()) do
        local businessID = ply:GetNWString("AJMRP_Business", "")
        if businessID ~= "" then
            local lastInteraction = ply:GetNWInt("AJMRP_BusinessLastInteraction", 0)
            if CurTime() - lastInteraction >= 60 then
                ply:SetNWInt("AJMRP_BusinessInteractions", 0)
            end
        end
    end
end)

concommand.Add("ajmrp_createbusiness", function(ply, cmd, args)
    if not args[1] then return end
    AJMRP.Economy:CreateBusiness(ply, args[1])
end)

concommand.Add("ajmrp_usebusiness", function(ply, cmd, args)
    local target = args[1] and player.GetByID(tonumber(args[1])) or ply
    if not IsValid(target) then
        AJMRP.ChatPrint(ply, "Invalid player!")
        return
    end
    AJMRP.Economy:InteractBusiness(ply, target)
end)