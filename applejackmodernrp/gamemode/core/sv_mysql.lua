require("mysqloo")

AJMRP.MySQL = AJMRP.MySQL or {}

function AJMRP.MySQL:Connect()
    if not AJMRP.Config.Server.MySQL.Enabled then
        AJMRP.Core:Log("MySQL disabled, using placeholders.")
        return false
    end
    local db = mysqloo.connect(
        AJMRP.Config.Server.MySQL.Host,
        AJMRP.Config.Server.MySQL.Username,
        AJMRP.Config.Server.MySQL.Password,
        AJMRP.Config.Server.MySQL.Database,
        AJMRP.Config.Server.MySQL.Port
    )
    db.onConnected = function()
        AJMRP.Core:Log("MySQL connected successfully!")
        AJMRP.MySQL:SetupTables()
    end
    db.onConnectionFailed = function(_, err)
        AJMRP.Core:Log("MySQL connection failed: " .. err)
    end
    db:connect()
    return true
end

function AJMRP.MySQL:SetupTables()
    local query = db:query([[
        CREATE TABLE IF NOT EXISTS ajmrp_players (
            steamid VARCHAR(20) PRIMARY KEY,
            bio TEXT,
            money INT,
            inventory TEXT,
            business VARCHAR(50),
            faction VARCHAR(50),
            faction_rank VARCHAR(50),
            property VARCHAR(50)
        )
    ]])
    query.onSuccess = function()
        AJMRP.Core:Log("MySQL tables set up successfully!")
    end
    query.onError = function(_, err)
        AJMRP.Core:Log("MySQL table setup failed: " .. err)
    end
    query:start()
end

function AJMRP.MySQL:LoadPlayer(ply)
    if not AJMRP.Config.Server.MySQL.Enabled then return end
    local query = db:query("SELECT * FROM ajmrp_players WHERE steamid = '" .. ply:SteamID() .. "'")
    query.onSuccess = function(q, data)
        if #data > 0 then
            local row = data[1]
            if row.bio then
                ply:SetNWString("AJMRP_Bio", row.bio)
            end
            if row.money then
                AJMRP.Economy:SetMoney(ply, tonumber(row.money))
            end
            if row.inventory then
                ply:SetNWString("AJMRP_Inventory", row.inventory)
            end
            if row.business then
                ply:SetNWString("AJMRP_Business", row.business)
            end
            if row.faction then
                ply:SetNWString("AJMRP_Faction", row.faction)
                ply:SetNWString("AJMRP_FactionRank", row.faction_rank or "Member")
            end
            if row.property then
                ply:SetNWString("AJMRP_Property", row.property)
            end
        else
            local ins = db:query(string.format(
                "INSERT INTO ajmrp_players (steamid, money, inventory) VALUES ('%s', %d, '{}')",
                ply:SteamID(), AJMRP.Config.StartingMoney
            ))
            ins:start()
        end
    end
    query:start()
end

function AJMRP.MySQL:SavePlayer(ply)
    if not AJMRP.Config.Server.MySQL.Enabled then return end
    local query = db:query(string.format(
        "REPLACE INTO ajmrp_players (steamid, bio, money, inventory, business, faction, faction_rank, property) VALUES ('%s', '%s', %d, '%s', '%s', '%s', '%s', '%s')",
        ply:SteamID(),
        db:escape(ply:GetNWString("AJMRP_Bio", "")),
        AJMRP.Economy:GetMoney(ply),
        db:escape(ply:GetNWString("AJMRP_Inventory", "{}")),
        ply:GetNWString("AJMRP_Business", ""),
        ply:GetNWString("AJMRP_Faction", ""),
        ply:GetNWString("AJMRP_FactionRank", ""),
        ply:GetNWString("AJMRP_Property", "")
    ))
    query.onError = function(_, err)
        AJMRP.Core:Log("MySQL save failed for " .. ply:Nick() .. ": " .. err)
    end
    query:start()
end

hook.Add("InitPostEntity", "AJMRP_MySQL_Connect", function()
    AJMRP.MySQL:Connect()
end)