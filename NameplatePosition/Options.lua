-- Get the main addon object from AceAddon-3.0
local addonName, _ = ...
local NameplatePosition = LibStub("AceAddon-3.0"):GetAddon(addonName)

local AddonCompartmentModule = NameplatePosition:GetModule("AddonCompartmentModule")
local NameplateOffsetsModule = NameplatePosition:GetModule("NameplateOffsetsModule")


--------------------------------------------------
-- Options Table
--------------------------------------------------
-- Define the options table for AceConfig
local OptionsTable = {
    type = "group",
    name = "Nameplate Position",
    args = {
        nameplatePositionSettings = {
            type = "group",
            name = "Nameplate Position Settings",
            inline = true,
            order = 1,
            args = {
                anchorDirection = {
                    type = "select",
                    order = 2,
                    name = "Anchor Point",
                    desc = "Select which point on the unit frame is anchored to the base nameplate frame.",
                    width = 1,
                    values = {
                        Above = "Above",
                        Below = "Below",
                    },
                    get = function()
                        local value = GetCVar("NameplateOtherAtBase") == "1" and "Below" or "Above"
                        NameplatePosition.db.profile.anchorPoint = value
                        return value
                    end,
                    set = function(_, value)
                        NameplatePosition.db.profile.anchorPoint = value
                        if value == "Below" then
                            SetCVar("NameplateOtherAtBase", "1")
                        else
                            SetCVar("NameplateOtherAtBase", "0")
                        end
                        NameplateOffsetsModule:ApplyOffsetToAllUnits()
                    end,
                },
                spacer1 = {
                    type = "description",
                    order = 2.5,
                    name = " ",
                    width = "full",
                },
                aboveOffset = {
                    type = "range",
                    order = 3.1,
                    name = "Above Offset",
                    desc = "Vertical offset when Anchor Point is set to Above.",
                    min = -300,
                    max = 0,
                    step = 1,
                    width = 1,
                    hidden = function()
                        return NameplatePosition.db.profile.anchorPoint ~= "Above"
                    end,
                    get = function()
                        return NameplatePosition.db.profile.aboveOffset
                    end,
                    set = function(_, value)
                        NameplatePosition.db.profile.aboveOffset = value
                        NameplateOffsetsModule:ApplyOffsetToAllUnits()
                    end,
                },
                belowOffset = {
                    type = "range",
                    order = 3.2,
                    name = "Below Offset",
                    desc = "Vertical offset when Anchor Point is set to Below.",
                    min = 0,
                    max = 300,
                    step = 1,
                    width = 1,
                    hidden = function()
                        return NameplatePosition.db.profile.anchorPoint ~= "Below"
                    end,
                    get = function()
                        return NameplatePosition.db.profile.belowOffset
                    end,
                    set = function(_, value)
                        NameplatePosition.db.profile.belowOffset = value
                        NameplateOffsetsModule:ApplyOffsetToAllUnits()
                    end,
                },
                spacer3 = {
                    type = "description",
                    order = 3.5,
                    name = " ",
                    width = "full",
                },
                enableAddonCompartmentButton = {
                    type = "toggle",
                    order = 4,
                    name = "Show Addon Compartment Button",
                    desc = "Shows NameplatePosition in the addon compartment menu.",
                    width = 1,
                    get = function()
                        return NameplatePosition.db.profile.enableAddonCompartmentButton
                    end,
                    set = function(_, value)
                        NameplatePosition.db.profile.enableAddonCompartmentButton = value
                        AddonCompartmentModule:Refresh()
                    end,
                },
            },
        },
    },
}

--------------------------------------------------
-- Register Options
--------------------------------------------------
-- Register the options table with AceConfig and add it to the Blizzard options UI
LibStub("AceConfig-3.0"):RegisterOptionsTable("Nameplate Position", OptionsTable)
