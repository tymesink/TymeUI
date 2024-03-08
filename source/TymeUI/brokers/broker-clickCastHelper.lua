if not LibStub then error("TymeTweak-ClickCastHelper Broker requires LibStub") end
local lib = LibStub:GetLibrary("LibDataBroker-1.1")

local dataObject = lib:NewDataObject("ClickCastHelper", {
    type = "launcher",
    icon = "Interface\\Icons\\inv_10_inscription2_repcontracts_80_scroll_uprez_color1", -- replace with your icon
    label = "ClickCastHelper",

    OnClick = function(clickedframe, button)
		if button == "LeftButton" then
			if InCombatLockdown() then
				print("You can't access ClickCast bindings during combat.")
			else
				ToggleClickBindingFrame()
			end
		elseif button == "RightButton" then
			-- Do something else on right click if desired
		end
    end,

	OnTooltipShow = function(tooltip)
        tooltip:AddLine("Click Cast Helper")
        tooltip:AddLine("Left click to toggle ClickCast bindings.")
        tooltip:AddLine("Right click does nothing.")
    end,
})