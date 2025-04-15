AJMRP = AJMRP or {}
AJMRP.Config = AJMRP.Config or {}

-- Currency
AJMRP.Config.CurrencySymbol = "$"
AJMRP.Config.StartingMoney = 500

-- Jobs
AJMRP.Config.Jobs = {
    [TEAM_CITIZEN] = {
        name = "Citizen",
        color = Color(50, 200, 50),
        model = {"models/player/group01/male_01.mdl", "models/player/group01/female_01.mdl"},
        weapons = {},
        max = 0, -- Unlimited
        salary = 100,
        description = "A regular citizen living in the city."
    },
    [TEAM_POLICE] = {
        name = "Police",
        color = Color(50, 50, 200),
        model = {"models/player/police.mdl"},
        weapons = {"weapon_pistol"},
        max = 4,
        salary = 300,
        description = "Maintain law and order."
    },
    [TEAM_GANGSTER] = {
        name = "Gangster",
        color = Color(200, 50, 50),
        model = {"models/player/group03/male_01.mdl"},
        weapons = {"weapon_crowbar"},
        max = 6,
        salary = 150,
        description = "Live a life of crime."
    },
    [TEAM_SHOPKEEPER] = {
        name = "Shopkeeper",
        color = Color(200, 200, 50),
        model = {"models/player/group02/male_02.mdl"},
        weapons = {},
        max = 3,
        salary = 200,
        description = "Run a shop and sell goods."
    }
}