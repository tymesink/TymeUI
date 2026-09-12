--[[
	Slash commands.

	WoW's slash system upper-cases whatever the player typed before matching, so
	"/rl" already answers "/RL" and case variants do not need registering.
]]

local ADDON, TymeUI = ...

local HideUIPanel = HideUIPanel
local InCombatLockdown = InCombatLockdown
local ReloadUI = ReloadUI
local ShowUIPanel = ShowUIPanel
local select = select
local _G = _G

--- Binds one handler to one or more slash aliases.
-- `id` only has to be unique among all addons; it never appears to the player.
local function AddCommand(id, handler, ...)
	for i = 1, select("#", ...) do
		_G["SLASH_" .. id .. i] = "/" .. select(i, ...)
	end

	SlashCmdList[id] = handler
end

AddCommand("TYMEUI_RELOAD", function()
	ReloadUI()
end, "rl")

AddCommand("TYMEUI_ADDONS", function()
	local frame = _G.SimpleAddonManager
	if frame then
		frame:Show()
	else
		TymeUI:Print("SimpleAddonManager is not loaded.")
	end
end, "addon", "addons")

AddCommand("TYMEUI_EDITMODE", function()
	local frame = _G.EditModeManagerFrame
	if not frame then return end

	-- Edit Mode rearranges protected frames, so Blizzard blocks it in combat.
	if InCombatLockdown() then
		TymeUI:Print("Edit Mode is not available in combat.")
		return
	end

	if frame:IsShown() then
		HideUIPanel(frame)
	else
		ShowUIPanel(frame)
	end
end, "edit")

AddCommand("TYMEUI_OPTIONS", function()
	Settings.OpenToCategory()

	local panel = _G.SettingsPanel
	if panel and panel.AddOnsTab then
		panel.AddOnsTab:Click()
	end
end, "opt", "option", "options")
