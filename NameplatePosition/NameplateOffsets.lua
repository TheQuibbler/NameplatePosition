local addonName, addonTable = ...
local NameplatePosition = LibStub("AceAddon-3.0"):GetAddon(addonName)

local NameplateOffsetsModule = NameplatePosition:NewModule("NameplateOffsetsModule")

-----------------------------------
-- Initialization
-----------------------------------
function NameplateOffsetsModule:OnInitialize()
    self:InitializeRuntimeState()
    self.eventFrame = CreateFrame("Frame")
    self.eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
    self.eventFrame:RegisterEvent("NAME_PLATE_UNIT_ADDED")
    self.eventFrame:RegisterEvent("NAME_PLATE_UNIT_REMOVED")
    
    self.eventFrame:SetScript("OnEvent", function(_, event, ...)
        self:HandleCoreEvent(event, ...)
    end)
end

function NameplateOffsetsModule:InitializeRuntimeState()
    self.activeUnits = self.activeUnits or {}
    self.namePlateResizeHooked = self.namePlateResizeHooked or {}
end

-- Handles core addon events and delegates offset updates for active nameplates.
function NameplateOffsetsModule:HandleCoreEvent(event, ...)
    if event == "PLAYER_ENTERING_WORLD" then
        self:RefreshTrackedUnits()
        return
    end

    if event == "NAME_PLATE_UNIT_ADDED" then
        local unitToken = ...
        if self:ShouldApplyOffsetToUnit(unitToken) then
            self.activeUnits[unitToken] = true
            self:ApplyOffsetToUnit(unitToken)
        else
            self.activeUnits[unitToken] = nil
        end
        return
    end

    if event == "NAME_PLATE_UNIT_REMOVED" then
        local unitToken = ...
        self.activeUnits[unitToken] = nil
        return
    end
end

-- Reapplies offsets to all active plates and prunes stale unit tokens.
function NameplateOffsetsModule:ApplyOffsetToAllUnits()
    for unitToken in pairs(self.activeUnits) do
        if self:ShouldApplyOffsetToUnit(unitToken) then
            self:ApplyOffsetToUnit(unitToken)
        else
            self.activeUnits[unitToken] = nil
        end
    end
end


-----------------------------------
-- Event Handling
-----------------------------------
-- Returns true when unit token should receive offsets
function NameplateOffsetsModule:ShouldApplyOffsetToUnit(unitToken)
    if not unitToken or not UnitExists(unitToken) then
        return false
    end

    return UnitCanAttack("player", unitToken) == true
end

-- Rebuilds the tracked unit cache and reapplies offsets using the current profile scope.
function NameplateOffsetsModule:RefreshTrackedUnits()
    wipe(self.activeUnits)

    for index = 1, 80 do
        local unitToken = "nameplate" .. index
        if self:ShouldApplyOffsetToUnit(unitToken) then
            self.activeUnits[unitToken] = true
        end
    end

    self:ApplyOffsetToAllUnits()
end

-----------------------------------
-- Offset Logic
-----------------------------------
-- Reapplies offset only for the unit currently associated with the provided nameplate frame.
function NameplateOffsetsModule:ApplyOffsetToNamePlate(changedNamePlate)
    if not changedNamePlate then
        return
    end

    for unitToken in pairs(self.activeUnits) do
        local currentNamePlate = C_NamePlate.GetNamePlateForUnit(unitToken)
        if currentNamePlate == changedNamePlate then
            if self:ShouldApplyOffsetToUnit(unitToken) then
                self:ApplyOffsetToUnit(unitToken)
                return
            else
                self.activeUnits[unitToken] = nil
            end
        end
    end
end

-- Applies the current offsets to a specific visible nameplate unit.
function NameplateOffsetsModule:ApplyOffsetToUnit(unitToken)
    local namePlate = C_NamePlate.GetNamePlateForUnit(unitToken)
    if not namePlate then
        return
    end

    local unitFrame = namePlate.UnitFrame
    if not unitFrame or unitFrame:IsForbidden() then
        return
    end

    local framePoint
    local platePoint
    local offsetY

    local currentWidth = unitFrame:GetWidth()
    local currentHeight = unitFrame:GetHeight()

    if NameplatePosition.db.profile.anchorPoint == "Above" then
        framePoint, platePoint = "BOTTOM", "TOP"
        offsetY = NameplatePosition.db.profile.aboveOffset
    else
        framePoint, platePoint = "TOP", "BOTTOM"
        offsetY = NameplatePosition.db.profile.belowOffset
    end

    unitFrame:ClearAllPoints()
    unitFrame:SetPoint(framePoint, namePlate, platePoint, 0, offsetY)
    unitFrame:SetSize(currentWidth, currentHeight)
    unitFrame:EnableMouse(true)
    unitFrame:SetMouseClickEnabled(true)

    if not self.namePlateResizeHooked[namePlate] then
        self.namePlateResizeHooked[namePlate] = true
        namePlate:HookScript("OnSizeChanged", function(changedNamePlate)
            NameplateOffsetsModule:ApplyOffsetToNamePlate(changedNamePlate)
        end)
    end
end

