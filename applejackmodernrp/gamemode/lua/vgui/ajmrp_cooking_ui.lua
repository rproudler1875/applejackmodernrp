if SERVER then
    AddCSLuaFile()
    return
end

local recipes = {
    { name = "Steak", hunger = 30, ingredients = { ["meat"] = 1 } },
    { name = "Water Bottle", thirst = 40, ingredients = { ["water"] = 1 } }
}

local function CreateCookingUI()
    local frame = vgui.Create("DFrame")
    frame:SetSize(400, 300)
    frame:Center()
    frame:SetTitle("Cooking Station")
    frame:MakePopup()

    local recipeList = vgui.Create("DListView", frame)
    recipeList:SetPos(10, 30)
    recipeList:SetSize(380, 200)
    recipeList:AddColumn("Recipe")
    recipeList:AddColumn("Effect")
    recipeList:AddColumn("Ingredients")

    for _, recipe in ipairs(recipes) do
        local effect = recipe.hunger and ("Hunger +" .. recipe.hunger) or ("Thirst +" .. recipe.thirst)
        local ingredients = ""
        for itemID, amount in pairs(recipe.ingredients) do
            ingredients = ingredients .. (AJMRP.Config.Items[itemID].name or itemID) .. " x" .. amount .. ", "
        end
        ingredients = ingredients:sub(1, -3) -- Remove trailing comma
        recipeList:AddLine(recipe.name, effect, ingredients)
    end

    recipeList.OnRowSelected = function(panel, row)
        net.Start("AJMRP_CookRecipe")
        net.WriteUInt(row, 8)
        net.SendToServer()
    end
end

net.Receive("AJMRP_OpenCookingUI", function()
    CreateCookingUI()
end)