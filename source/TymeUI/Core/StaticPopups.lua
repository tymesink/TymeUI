local TYMEUI, F, I, E = unpack(TymeUI)

local StaticPopupDialogs = _G.StaticPopupDialogs
local StaticPopup_Show = StaticPopup_Show

StaticPopupDialogs.RESET_PROFILE = {
	text = 'Are you sure you want to reload your addon profiles?',
	button1 = ACCEPT,
	button2 = CANCEL,
	OnAccept = function()
		TYMEUI.db.profile.ProfileAddons = {}
		ReloadUI()
	end,
	showAlert = true,
	whileDead = true,
	hideOnEscape = false,
}

StaticPopupDialogs.RELOAD_UI_FORCE = {
	text = 'A reload of the UI is required to apply the changes. Please reload now.',
	button1 = ACCEPT,
	OnAccept = ReloadUI,
	showAlert = true,
	whileDead = true,
	hideOnEscape = false,
}


function TYMEUI:StaticPopup_ReloadUI()
	StaticPopup_Show('RELOAD_UI_FORCE')
end

function TYMEUI:StaticPopup_ResetProfile()
	StaticPopup_Show('RESET_PROFILE')
end