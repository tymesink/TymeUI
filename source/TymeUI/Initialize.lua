local E, L, V, P, G = unpack(ElvUI)
local EP = E.Libs.EP
local addonName, addon = ...

local _G = _G
local find = string.find
local GetAddOnMetadata = (C_AddOns and C_AddOns.GetAddOnMetadata) or GetAddOnMetadata
local GetBuildInfo = GetBuildInfo
local select = select
local tonumber = tonumber
local OKAY = OKAY

local TYMEUI = E:NewModule(addonName, "AceConsole-3.0", "AceTimer-3.0", "AceHook-3.0")
V.TYMEUI = {}
P.TYMEUI = {}
G.TYMEUI = {}
local F = {}
local I = {}

addon[1] = TYMEUI
addon[2] = F
addon[3] = E
addon[4] = I
addon[5] = V.TYMEUI
addon[6] = P.TYMEUI
addon[7] = G.TYMEUI
addon[8] = L
_G[addonName] = addon

TYMEUI.AddOnName = addonName
TYMEUI.GitHash = GetAddOnMetadata(addonName, "X-GitHash")
TYMEUI.DebugMode = false
TYMEUI.DevTag = ""
TYMEUI.DelayedWorldEntered = false
TYMEUI.MetaFlavor = GetAddOnMetadata(addonName, "X-Flavor")
TYMEUI.ClientBuildVersion = select(4, GetBuildInfo())
TYMEUI.Version = GetAddOnMetadata(addonName, "Version")

TYMEUI.IsVanilla = TYMEUI.MetaFlavor == "Vanilla"
TYMEUI.IsCata = TYMEUI.MetaFlavor == "Cata"
TYMEUI.IsRetail = TYMEUI.MetaFlavor == "Mainline"

TYMEUI.Modules = {}
TYMEUI.Modules.Changelog = TYMEUI:NewModule("Changelog", "AceEvent-3.0", "AceTimer-3.0")
TYMEUI.Modules.Options = TYMEUI:NewModule("Options")
TYMEUI.Modules.Skins = TYMEUI:NewModule("Skins", "AceHook-3.0", "AceEvent-3.0")
TYMEUI.Frame = CreateFrame('Frame')

function TYMEUI:Initialize()
    -- Don't init second time
    if self.initialized then return end

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
  
EP:HookInitialize(TYMEUI, TYMEUI.Initialize)