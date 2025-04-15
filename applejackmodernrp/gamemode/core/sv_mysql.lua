AJMRP.MySQL = AJMRP.MySQL or {}

-- Safely load mysqloo module
local mysqloo_module
local success, mysqloo_result = pcall(require, "mysqloo")
if not success then
    AJMRP.Core:Log("mysqloo module not found! MySQL functionality disabled.")
    AJMRP.Config.Server = AJMRP.Config.Server or {}
    AJMRP.Config.Server.MySQL = { Enabled = false }
else
    mysqloo_module = mysqloo_result
    AJMRP.Core:Log("mysqloo module loaded successfully.")
end

function AJMRP.MySQL:Connect()
    -- Initialize config if missing
    AJMRP.Config.Server = AJMRP.Config.Server or {}
    AJMRP.Config.Server.MySQL = AJMRP.Config.Server.MySQL or { Enabled = false }
    
    AJMRP.Core:Log("MySQL Enabled status: " .. tostring(AJMRP.Config.Server.MySQL.Enabled))
    AJMRP.Core:Log("mysqloo module available: " .. tostring(mysqloo_module ~= nil))
    if not AJMRP.Config.Server.MySQL.Enabled or not mysqloo_module then
        AJMRP.Core:Log("MySQL disabled or mysqloo module unavailable, using placeholders.")
        return false
    end
    AJMRP.Core:Log("Attempting to connect to MySQL at " .. AJMRP.Config.Server.MySQL.Host .. ":" .. AJMRP.Config.Server.MySQL.Port)
    self.db = mysqloo_module.connect(
        AJMRP.Config.Server.MySQL.Host,
        AJMRP.Config.Server.MySQL.Username,
        AJMRP.Config.Server.MySQL.Password,
        AJMRP.Config.Server.MySQL.Database,
        AJMRP.Config.Server.MySQL.Port
    )
    self.db.onConnected = function()
        AJMRP.Core:Log("MySQL connected successfully to database: " .. AJMRP.Config.Server.MySQL.Database)
        AJMRP.MySQL:SetupTables()
    end
    self.db.onConnectionFailed = function(_, err)
        AJMRP.Core:Log("MySQL connection failed: " .. tostring(err))
        self.db = nil -- Clear invalid connection
    end
    self.db:connect()
    return true
end

function AJMRP.MySQL:SetupTables()
    if not self.db then
        AJMRP.Core:Log("No database connection available for table setup!")
        return
    end
    AJMRP.Core:Log("Setting up MySQL tables...")
    local query = self.db:query([[
        CREATE TABLE IF NOT EXISTS ajmrp_players (
            steamid VARCHAR(20) PRIMARY KEY,
            bio TEXT,
            money INT DEFAULT 0,
            inventory TEXT DEFAULT '{}',
            business VARCHAR(50) DEFAULT '',
            faction VARCHAR(50) DEFAULT '',
            faction_rank VARCHAR(50) DEFAULT '',
            property VARCHAR(50) DEFAULT ''
        )
    ]])
    query.onSuccess = function()
        AJMRP.Core:Log("MySQL tables set up successfully!")
    end
    query.onError = function(_, err)
        AJMRP.Core:Log("MySQL table setup failed: " .. tostring(err))
    end
    query:start()
end

function AJMRP.MySQL:LoadPlayer(ply)
    if not AJMRP.Config.Server.MySQL.Enabled or not self.db then
        AJMRP.Core:Log("MySQL disabled or no database connection for player load: " .. ply:Nick())
        return
    end
    AJMRP.Core:Log("Loading MySQL data for player: " .. ply:Nick())
    local query = self.db:query("SELECT * FROM ajmrp_players WHERE steamid = '" .. self.db:escape(ply:SteamID()) .. "'")
    query.onSuccess = function(q, data)
        if #data > 0 then
            local row = data[1]
            AJMRP.Core:Log("Loaded MySQL data for " .. ply:Nick())
            if row.bio and row.bio ~= "" then
                ply:SetNWString("AJMRP_Bio", row.bio)
            end
            if row.money then
                AJMRP.Economy:SetMoney(ply, tonumber(row.money) or AJMRP.Config.StartingMoney)
            end
            if row.inventory and row.inventory ~= "" then
                ply:SetNWString("AJMRP_Inventory", row.inventory)
            end
            if row.business and row.business ~= "" then
                ply:SetNWString("AJMRP_Business", row.business)
            end
            if row.faction and row.faction ~= "" then
                ply:SetNWString("AJMRP_Faction", row.faction)
                ply:SetNWString("AJMRP_FactionRank", row.faction_rank or "Member")
            end
            if row.property and row.property ~= "" then
                ply:SetNWString("AJMRP_Property", row.property)
            end
        else
            AJMRP.Core:Log("No MySQL data for " .. ply:Nick() .. ", initializing new record.")
            local ins = self.db:query(string.format(
                "INSERT INTO ajmrp_players (steamid, money, inventory) VALUES ('%s', %d, '{}')",
                self.db:escape(ply:SteamID()), AJMRP.Config.StartingMoney
            ))
            ins.onSuccess = function()
                AJMRP.Core:Log("Initialized MySQL record for " .. ply:Nick())
            end
            ins.onError = function(_, err)
                AJMRP.Core:Log("Failed to initialize MySQL record for " .. ply:Nick() .. ": " .. tostring(err))
            end
            ins:start()
        end
    end
    query.onError = function(_, err)
        AJMRP.Core:Log("MySQL load failed for " .. ply:Nick() .. ": " .. tostring(err))
    end
    query:start()
end

function AJMRP.MySQL:SavePlayer(ply)
    if not AJMRP.Config.Server.MySQL.Enabled or not self.db then
        AJMRP.Core:Log("MySQL disabled or no database connection for player save: " .. ply:Nick())
        return
    end
    AJMRP.Core:Log("Saving MySQL data for player: " .. ply:Nick())
    local query = self.db:query(string.format(
        "REPLACE INTO ajmrp_players (steamid, bio, money, inventory, business, faction, faction_rank, property) VALUES ('%s', '%s', %d, '%s', '%s', '%s', '%s', '%s')",
        self.db:escape(ply:SteamID()),
        self.db:escape(ply:GetNWString("AJMRP_Bio", "")),
        AJMRP.Economy:GetMoney(ply),
        self.db:escape(ply:GetNWString("AJMRP_Inventory", "{}")),
        self.db:escape(ply:GetNWString("AJMRP_Business", "")),
        self.db:escape(ply:GetNWString("AJMRP_Faction", "")),
        self.db:escape(ply:GetNWString("AJMRP_FactionRank", "")),
        self.db:escape(ply:GetNWString("AJMRP_Property", ""))
    ))
    query.onSuccess = function()
        AJMRP.Core:Log("Saved MySQL data for " .. ply:Nick())
    end
    query.onError = function(_, err)
        AJMRP.Core:Log("MySQL save failed for " .. ply:Nick() .. ": " .. tostring(err))
    end
    query:start()
end

function AJMRP.MySQL:TestConnection(ply)
    if not AJMRP.Config.Server.MySQL.Enabled or not mysqloo_module then
        AJMRP.ChatPrint(ply, "MySQL is disabled or mysqloo module is unavailable.")
        return
    end
    if not self.db then
        AJMRP.ChatPrint(ply, "No active MySQL connection.")
        return
    end
    local query = self.db:query("SELECT 1")
    query.onSuccess = function()
        AJMRP.ChatPrint(ply, "MySQL connection test successful!")
    end
    query.onError = function(_, err)
        AJMRP.ChatPrint(ply, "MySQL connection test failed: " .. tostring(err))
    end
    query:start()
end

-- Only connect if mysqloo was successfully loaded
if success then
    hook.Add("InitPostEntity", "AJMRP_MySQL_Connect", function()
        AJMRP.MySQL:Connect()
    end)
end

-- Command to test MySQL connection
concommand.Add("ajmrp_testmysql", function(ply)
    if not IsValid(ply) then return end -- Server console only for now
    AJMRP.MySQL:TestConnection(ply)
end)