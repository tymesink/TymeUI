local TYMEUI, F, I, E = unpack(TymeUI)


E.PopupDialogs.RESET_PROFILE = {
	text = 'Are you sure you want to reload your addon profiles?',
	button1 = ACCEPT,
	button2 = CANCEL,
	OnAccept = function(self)
    	TYMEUI.db.profile.ProfileAddons = {}
    	ReloadUI()
	end,
	showAlert = true,
	whileDead = true,
	hideOnEscape = false,
}

E.PopupDialogs.RELOAD_UI_FORCE = {
	text = 'A reload of the UI is required to apply the changes. Please reload now.',
	button1 = ACCEPT,
	OnAccept = ReloadUI,
	showAlert = true,
	whileDead = true,
	hideOnEscape = false,
}


function TYMEUI:StaticPopup_ReloadUI()
	E:StaticPopup_Show('RELOAD_UI_FORCE')
end

function TYMEUI:StaticPopup_ResetProfile()
  	E:StaticPopup_Show('RESET_PROFILE')
end