local E, L, V, P, G = unpack(ElvUI)
local EP = E.Libs.EP
local AddonName, Engine = ...

local _G = _G
local find = string.find
local GetAddOnMetadata = (C_AddOns and C_AddOns.GetAddOnMetadata) or GetAddOnMetadata
local GetBuildInfo = GetBuildInfo
local select = select
local tonumber = tonumber
local OKAY = OKAY

local TYMEUI = E:NewModule(AddonName, "AceConsole-3.0", "AceTimer-3.0", "AceHook-3.0")
local F = {}
local I = {}

Engine[1] = TYMEUI
Engine[2] = F
Engine[3] = I
Engine[4] = E
_G["TymeUI"] = Engine

TYMEUI.AddOnName = AddonName
TYMEUI.GitHash = GetAddOnMetadata(AddonName, "X-GitHash")
TYMEUI.DebugMode = false
TYMEUI.DevTag = ""
TYMEUI.DelayedWorldEntered = false
TYMEUI.MetaFlavor = GetAddOnMetadata(AddonName, "X-Flavor")
TYMEUI.ClientBuildVersion = select(4, GetBuildInfo())
TYMEUI.Version = GetAddOnMetadata(AddonName, "Version")

local defaults = {
  profile = {
      profileModule = {
          ProfileHasBeenSet = false
      }
  }
}

TYMEUI.Modules = {}

function TYMEUI:Initialize()
    -- Don't init second time
    if self.initialized then return end

    self.db = LibStub("AceDB-3.0"):New("TymeUIDB", defaults)

    -- Call pre init for ourselfs
    self:ModulePreInitialize(self)
  
    -- Mark dev release
    if self.GitHash then
      if find(self.GitHash, "alpha") then
        self.DevTag = F.String.Error("[ALPHA]")
      elseif find(self.GitHash, "beta") then
        self.DevTag = F.String.Error("[BETA]")
      elseif find(self.GitHash, "project%-version") then
        self.GitHash = "DEV" -- will be filled by changelog
        self.DevTag = F.String.Error("[DEV]")
      end
    end
  
    -- Set correct log level
    -- Higher number = more in-depth logs
    -- Log Level 5 is very spammy
    self.LogLevel = self.DebugMode and 4 or 3
  
    -- Check required ElvUI Version
    local ElvUIVersion = tonumber(E.version)
    local RequiredVersionString = GetAddOnMetadata(self.AddOnName, "X-ElvUIVersion")
    local RequiredVersion = tonumber(RequiredVersionString)
  
    E.PopupDialogs.ELVUI_MINIMUM_VERSION_REQUIRED = {
      text = I.Strings.Branding.Title
        .. " did not load because your version of |cff1784d1ElvUI|r |cffef5350"
        .. E.versionString
        .. "|r is insufficient.\n\nPlease install |cff1784d1ElvUI|r version |cff66bb6a"
        .. RequiredVersionString
        .. "|r or higher!",
      button1 = OKAY,
      showAlert = true,
    }
  
    -- ElvUI's version check
    if ElvUIVersion < 1 or (ElvUIVersion < RequiredVersion) then
      E:Delay(2, function()
        E:StaticPopup_Show("ELVUI_MINIMUM_VERSION_REQUIRED")
      end)
      return
    end

    -- Force ElvUI Setup to hide
    E.private.install_complete = E.version
  
    -- Lets go!
    self:InitializeModules()
end

function TYMEUI:OnProfileChanged(event, database, newProfileKey)
	
end
  
EP:HookInitialize(TYMEUI, TYMEUI.Initialize)