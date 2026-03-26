local addonName, _ = ...
local NameplatePosition = LibStub("AceAddon-3.0"):GetAddon(addonName)

local AddonCompartmentModule = NameplatePosition:NewModule("AddonCompartmentModule")
local aceDialog = LibStub("AceConfigDialog-3.0")

-----------------------------------
-- Initialization
-----------------------------------
function AddonCompartmentModule:OnInitialize()
    self.compartmentData = {
        text = "NameplatePosition",
        icon = "Interface\\Icons\\ability_hunter_snipershot",
        notCheckable = true,
        registerForAnyClick = true,
        func = function()
            aceDialog:Open("Nameplate Position")
        end,
        funcOnEnter = function()
            GameTooltip:SetOwner(UIParent, "ANCHOR_CURSOR")
            GameTooltip:AddLine("NameplatePosition")
            GameTooltip:AddLine("Left-click: Open Options", 1, 1, 1)
            GameTooltip:Show()
        end,
        funcOnLeave = function()
            GameTooltip:Hide()
        end,
    }


    -- Apply initial visibility from settings (register with AddonCompartmentFrame if enabled)
    self:Refresh()
end

--------------------------------------------------
-- Refresh (show/hide based on options)
--------------------------------------------------
function AddonCompartmentModule:Refresh()
    local show = NameplatePosition.db.profile.enableAddonCompartmentButton

    if show then
        -- Register if not already registered
        if not self._compartmentRegistered then
            AddonCompartmentFrame:RegisterAddon(self.compartmentData)
            self._compartmentRegistered = true
        end
    else
        -- Remove entry if registered
        if self._compartmentRegistered then
            -- Find and remove our entry from AddonCompartmentFrame.registeredAddons
            for i = 1, #AddonCompartmentFrame.registeredAddons do
                if AddonCompartmentFrame.registeredAddons[i] == self.compartmentData then
                    table.remove(AddonCompartmentFrame.registeredAddons, i)
                    AddonCompartmentFrame:UpdateDisplay()
                    break
                end
            end
            self._compartmentRegistered = nil
        end
    end
end


