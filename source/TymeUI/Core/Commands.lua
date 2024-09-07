local TYMEUI, F, I, E = unpack(TymeUI)

local pairs = pairs
local tonumber, lower, wipe, next = tonumber, strlower, wipe, next

local ReloadUI = ReloadUI

local DisableAddOn = (C_AddOns and C_AddOns.DisableAddOn) or DisableAddOn
local EnableAddOn = (C_AddOns and C_AddOns.EnableAddOn) or EnableAddOn
local GetAddOnInfo = (C_AddOns and C_AddOns.GetAddOnInfo) or GetAddOnInfo
local GetNumAddOns = (C_AddOns and C_AddOns.GetNumAddOns) or GetNumAddOns

function TYMEUI:HandleAddonsChatCommand(msg)
    if F.IsAddOnLoaded("SimpleAddonManager") then
        local samFrame = _G["SimpleAddonManager"]
        if samFrame then
            samFrame:Show()
        else
            print("SimpleAddonManager frame not found.")
        end
    end
end

function TYMEUI:HandleReloadUIChatCommand(msg)
    ReloadUI();
end

function TYMEUI:HandleEditChatCommand(msg)
    F.ToggleFrame("EditModeManagerFrame");	
end

function TYMEUI:HandleOptionsChatCommand(msg)
    Settings.OpenToCategory();
    SettingsPanel.AddOnsTab:Click();
end


function TYMEUI:LoadCommands()
    self:RegisterChatCommand("addon", "HandleAddonsChatCommand")
    self:RegisterChatCommand("addons", "HandleAddonsChatCommand")
    self:RegisterChatCommand("rl", "HandleReloadUIChatCommand")
    self:RegisterChatCommand("RL", "HandleReloadUIChatCommand")
    self:RegisterChatCommand("edit", "HandleEditChatCommand")
    self:RegisterChatCommand("option", "HandleOptionsChatCommand")
    self:RegisterChatCommand("options", "HandleOptionsChatCommand")
    self:RegisterChatCommand("opt", "HandleOptionsChatCommand")
end
