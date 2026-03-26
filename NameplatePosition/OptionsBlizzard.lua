-----------------------------------
-- Blizzard Options
-----------------------------------
local blizzardOptions = {
    type = "group",
    name = "",
    args = {
        title = {
            type = "description",
            name = "|cffffff00NameplatePosition|r",
            fontSize = "large",
            order = 1,
        },
        author = {
            type = "description",
            name = "Author: TheQuibbler",
            fontSize = "medium",
            order = 2,
        },
        usage = {
            type = "description",
            name = "\nOpen the full settings window with |cff00ffff/npp|r.\nSettings window can also be opened through the Addon Compartment menu at the minimap.",
            fontSize = "medium",
            order = 3,
        },
    },
}

LibStub("AceConfig-3.0"):RegisterOptionsTable("NameplatePosition", blizzardOptions)
LibStub("AceConfigDialog-3.0"):AddToBlizOptions("NameplatePosition", "NameplatePosition")
