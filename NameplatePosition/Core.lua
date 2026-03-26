local addonName, NameplatePosition_namespace = ...

--------------------------------------------------
-- Initialize Addon with AceAddon
--------------------------------------------------
-- Create the main addon object using AceAddon-3.0 and AceConsole-3.0
local NameplatePosition = LibStub("AceAddon-3.0"):NewAddon(addonName, "AceConsole-3.0")

--------------------------------------------------
-- Initialization
--------------------------------------------------
-- Initializes addon systems and delegates runtime behavior to dedicated modules.
function NameplatePosition:OnInitialize()
    -- Set up saved variables with default profile values
    local defaults = NameplatePosition_namespace.DefaultProfile or {}
    self.db = LibStub("AceDB-3.0"):New("NameplatePositionDB", defaults, true)

    -- Force everyone onto the shared "Default" profile so settings carry across characters
    self.db:SetProfile("Default")
    
    -- Register slash command /npp to open config
    self:RegisterChatCommand("npp", "OpenConfig")
    self:RegisterChatCommand("nameplateposition", "OpenConfig")
end

--------------------------------------------------
-- Slash Command
--------------------------------------------------
-- Open the configuration dialog when /npp is used
function NameplatePosition:OpenConfig()
    local aceDialog = LibStub("AceConfigDialog-3.0")
    local status = aceDialog:GetStatusTable("Nameplate Position")
    status.width = status.width or 650
    status.height = status.height or 350
    aceDialog:Open("Nameplate Position")
end