local TYMEUI, F, I, E = unpack(TymeUI)


E.PopupDialogs.RESET_PROFILE = {
	text = 'Are you sure you want to reset your profile?',
	button1 = ACCEPT,
	button2 = CANCEL,
	OnAccept = function(self)
    	TYMEUI.db.profile.profileModule.ProfileHasBeenSet = false
		TYMEUI.db.profile.profileModule.ElvUIProfileHasBeenSet = false
    	ReloadUI()
	end,
	whileDead = 1,
	hideOnEscape = false,
}

E.PopupDialogs.RESET_ELVUI_PROFILE = {
	text = 'Are you sure you want to reset ElvUI your profile?',
	button1 = ACCEPT,
	button2 = CANCEL,
	OnAccept = function(self)
		TYMEUI.db.profile.profileModule.ElvUIProfileHasBeenSet = false
    	ReloadUI()
	end,
	whileDead = 1,
	hideOnEscape = false,
}


function TYMEUI:StaticPopup_ReloadUI()
	PlaySound(850)
	E:StaticPopup_Show('CONFIG_RL')
end

function TYMEUI:StaticPopup_ResetProfile()
	PlaySound(850)
  	E:StaticPopup_Show('RESET_PROFILE')
end

function TYMEUI:StaticPopup_ResetElvUIProfile()
	PlaySound(850)
	E:StaticPopup_Show('RESET_ELVUI_PROFILE')
end