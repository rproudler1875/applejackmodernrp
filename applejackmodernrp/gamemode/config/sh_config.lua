AJMRP = AJMRP or {}
AJMRP.Config = AJMRP.Config or {}

-- Currency
AJMRP.Config.CurrencySymbol = "$"
AJMRP.Config.StartingMoney = 500

-- Jobs
TEAM_CITIZEN = 1
TEAM_POLICE = 2
TEAM_GANGSTER = 3
TEAM_SHOPKEEPER = 4
TEAM_PARAMEDIC = 5
TEAM_HACKER = 6
TEAM_MECHANIC = 7

AJMRP.Config.Jobs = {
    [TEAM_CITIZEN] = {
        name = "Citizen",
        color = Color(50, 200, 50),
        model = {"models/player/group01/male_01.mdl", "models/player/group01/female_01.mdl"},
        weapons = {},
        max = 0, -- Unlimited
        salary = 100,
        description = "A regular citizen living in the city.",
        tiers = {
            { level = 1, xp = 0, name = "Citizen", weapons = {} }
        }
    },
    [TEAM_POLICE] = {
        name = "Police",
        color = Color(50, 50, 200),
        model = {"models/player/police.mdl"},
        weapons = {"weapon_pistol"},
        max = 4,
        salary = 300,
        description = "Maintain law and order.",
        tiers = {
            { level = 1, xp = 0, name = "Rookie Cop", weapons = {"weapon_pistol"} },
            { level = 2, xp = 1000, name = "Detective", weapons = {"weapon_pistol", "weapon_smg1"} },
            { level = 3, xp = 5000, name = "Chief", weapons = {"weapon_pistol", "weapon_smg1", "weapon_shotgun"} }
        }
    },
    [TEAM_GANGSTER] = {
        name = "Gangster",
        color = Color(200, 50, 50),
        model = {"models/player/group03/male_01.mdl"},
        weapons = {"weapon_crowbar"},
        max = 6,
        salary = 150,
        description = "Live a life of crime.",
        tiers = {
            { level = 1, xp = 0, name = "Thug", weapons = {"weapon_crowbar"} },
            { level = 2, xp = 800, name = "Enforcer", weapons = {"weapon_crowbar", "weapon_pistol"} },
            { level = 3, xp = 4000, name = "Boss", weapons = {"weapon_crowbar", "weapon_pistol", "weapon_smg1"} }
        }
    },
    [TEAM_SHOPKEEPER] = {
        name = "Shopkeeper",
        color = Color(200, 200, 50),
        model = {"models/player/group02/male_02.mdl"},
        weapons = {},
        max = 3,
        salary = 200,
        description = "Run a shop and sell goods.",
        tiers = {
            { level = 1, xp = 0, name = "Shopkeeper", weapons = {} }
        }
    },
    [TEAM_PARAMEDIC] = {
        name = "Paramedic",
        color = Color(50, 200, 200),
        model = {"models/player/alyx.mdl"},
        weapons = {"weapon_medkit"},
        max = 3,
        salary = 250,
        description = "Heal players and respond to emergencies.",
        tiers = {
            { level = 1, xp = 0, name = "EMT", weapons = {"weapon_medkit"} },
            { level = 2, xp = 900, name = "Paramedic", weapons = {"weapon_medkit", "weapon_defibrillator"} }
        }
    },
    [TEAM_HACKER] = {
        name = "Hacker",
        color = Color(100, 100, 100),
        model = {"models/player/guerilla.mdl"},
        weapons = {"weapon_hacktool"},
        max = 2,
        salary = 200,
        description = "Bypass security systems for profit.",
        tiers = {
            { level = 1, xp = 0, name = "Script Kiddie", weapons = {"weapon_hacktool"} },
            { level = 2, xp = 1200, name = "Cybercriminal", weapons = {"weapon_hacktool", "weapon_emp"} }
        }
    },
    [TEAM_MECHANIC] = {
        name = "Mechanic",
        color = Color(200, 100, 50),
        model = {"models/player/mechanic.mdl"},
        weapons = {"weapon_wrench"},
        max = 3,
        salary = 220,
        description = "Repair vehicles and craft upgrades.",
        tiers = {
            { level = 1, xp = 0, name = "Apprentice", weapons = {"weapon_wrench"} },
            { level = 2, xp = 1000, name = "Master Mechanic", weapons = {"weapon_wrench", "weapon_toolgun"} }
        }
    }
}

-- Factions
AJMRP.Config.Factions = {
    DefaultFaction = {
        name = "Civilians",
        color = Color(100, 100, 100),
        ranks = {
            { name = "Member", permissions = {} }
        }
    }
}

-- Survival
AJMRP.Config.Survival = {
    HungerMax = 100,
    ThirstMax = 100,
    FatigueMax = 100,
    StaminaMax = 100,
    HungerRate = 0.05, -- Depletes per second
    ThirstRate = 0.07,
    FatigueRate = 0.03,
    StaminaSprintCost = 0.5, -- Per second
    StaminaRegenRate = 0.2,
    StatusEffects = {
        Starvation = { threshold = 20, speedMult = 0.7 },
        Dehydration = { threshold = 20, blur = true },
        Exhaustion = { threshold = 20, staminaRegenMult = 0.5 }
    }
}