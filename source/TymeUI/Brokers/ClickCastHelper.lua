--[[
	LibDataBroker launcher that opens Blizzard's click-binding frame.

	A "broker" is just a table of text and callbacks published under a name; a
	display addon such as ChocolateBar or Titan Panel finds it and draws it.
]]

local ADDON, TymeUI = ...

local InCombatLockdown = InCombatLockdown
local LDB = LibStub("LibDataBroker-1.1")

LDB:NewDataObject("ClickCastHelper", {
	type = "launcher",
	label = "Click Cast Helper",
	icon = "Interface\\Icons\\inv_10_inscription2_repcontracts_80_scroll_uprez_color1",

	OnClick = function(_, button)
		if button ~= "LeftButton" then return end

		if InCombatLockdown() then
			TymeUI:Print("Click bindings cannot be changed in combat.")
		elseif ToggleClickBindingFrame then
			ToggleClickBindingFrame()
		end
	end,

	OnTooltipShow = function(tooltip)
		tooltip:AddLine("Click Cast Helper")
		tooltip:AddLine("Left click to toggle click bindings.")
	end,
})
