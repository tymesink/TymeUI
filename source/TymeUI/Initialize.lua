local AddonName, Engine = ...

local _G = _G
local find = string.find
local GetAddOnMetadata = (C_AddOns and C_AddOns.GetAddOnMetadata) or GetAddOnMetadata
local GetBuildInfo = GetBuildInfo
local select = select
local tonumber = tonumber
local OKAY = OKAY
local UnitFullName = UnitFullName
local UnitClass = UnitClass

local AceAddon = LibStub("AceAddon-3.0")

local TYMEUI = AceAddon:NewAddon(AddonName, "AceConsole-3.0", "AceTimer-3.0", "AceHook-3.0", "AceEvent-3.0")
local F = {}
local I = {}
local E = {}

Engine[1] = TYMEUI
Engine[2] = F
Engine[3] = I
Engine[4] = E
_G["TymeUI"] = Engine

local playerName, playerRealm = UnitFullName("player")
E.myname = playerName or "player"
E.myrealm = playerRealm or ""
E.mynameRealm = E.myrealm ~= "" and (E.myname .. "-" .. E.myrealm) or E.myname
E.myclass = select(2, UnitClass("player"))
E.Libs = {
  LSM = LibStub("LibSharedMedia-3.0", true)
}
E.TagFunctions = {}
function E:ClassColor(class, useDefault)
  local color = RAID_CLASS_COLORS[class or self.myclass]
  if not color then
    return { r = 1, g = 1, b = 1, a = 1 }
  end
  if useDefault then
    return color
  end
  return { r = color.r, g = color.g, b = color.b, a = color.a or 1 }
end
function E:UpdateCooldownSettings()
  -- no-op placeholder to keep prior call sites safe without ElvUI
end

TYMEUI.AddOnName = AddonName
TYMEUI.GitHash = GetAddOnMetadata(AddonName, "X-GitHash")
TYMEUI.DebugMode = false
TYMEUI.DelayedWorldEntered = false
TYMEUI.MetaFlavor = GetAddOnMetadata(AddonName, "X-Flavor")
TYMEUI.ClientBuildVersion = select(4, GetBuildInfo())
TYMEUI.Version = GetAddOnMetadata(AddonName, "Version")
TYMEUI.PlayerNameRealm = E.mynameRealm

local defaults = {
  profile = {
    ProfileAddons = {}
  }
}

TYMEUI.Modules = {}

function TYMEUI:OnInitialize()
  if self.initialized then return end

  self.db = LibStub("AceDB-3.0"):New("TymeUIDB", defaults)

  -- Call pre init for ourselves
  if self.ModulePreInitialize then
    self:ModulePreInitialize(self)
  end
    
  -- Set correct log level
  -- Higher number = more in-depth logs
  -- Log Level 5 is very spammy
  self.LogLevel = self.DebugMode and 4 or 3

  -- Defer module initialization until player login so dependent addons are loaded
  self:RegisterEvent("PLAYER_LOGIN", "HandlePlayerLogin")
  self.initialized = true
end

function TYMEUI:HandlePlayerLogin()
  self:UnregisterEvent("PLAYER_LOGIN")
  self:InitializeModules()
end

function TYMEUI:OnProfileChanged(event, database, newProfileKey)
    -- placeholder for future profile change handling
end