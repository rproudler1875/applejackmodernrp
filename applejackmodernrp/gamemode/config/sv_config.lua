-- Ensure AJMRP and AJMRP.Config are initialized
AJMRP = AJMRP or {}
AJMRP.Config = AJMRP.Config or {}

-- Server-side configuration
AJMRP.Config.Server = AJMRP.Config.Server or {}

AJMRP.Config.Server.MaxProps = 100
AJMRP.Config.Server.MySQL = {
    Enabled = false,
    Host = "localhost",
    Username = "root",
    Password = "",
    Database = "ajmrp",
    Port = 3306
}