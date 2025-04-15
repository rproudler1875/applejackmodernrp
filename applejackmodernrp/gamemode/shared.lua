GM.Name = "AppleJack Modernised RP"
GM.Author = "xAI Community"
GM.Email = ""
GM.Website = ""

-- Derive from Sandbox
DeriveGamemode("sandbox")

-- Shared enums
AJMRP = AJMRP or {}
AJMRP.VERSION = "1.0.0"

-- Initialize tables
AJMRP.Core = AJMRP.Core or {}
AJMRP.Economy = AJMRP.Economy or {}
AJMRP.Jobs = AJMRP.Jobs or {}
AJMRP.Factions = AJMRP.Factions or {}
AJMRP.Survival = AJMRP.Survival or {}
AJMRP.Properties = AJMRP.Properties or {}

-- Shared config
function AJMRP:SetupTeams()
    team.SetUp(TEAM_CITIZEN, "Citizen", Color(50, 200, 50))
    team.SetUp(TEAM_POLICE, "Police", Color(50, 50, 200))
    team.SetUp(TEAM_GANGSTER, "Gangster", Color(200, 50, 50))
    team.SetUp(TEAM_SHOPKEEPER, "Shopkeeper", Color(200, 200, 50))
    team.SetUp(TEAM_PARAMEDIC, "Paramedic", Color(50, 200, 200))
    team.SetUp(TEAM_HACKER, "Hacker", Color(100, 100, 100))
    team.SetUp(TEAM_MECHANIC, "Mechanic", Color(200, 100, 50))
end

-- Initialize shared
function GM:Initialize()
    AJMRP:SetupTeams()
end