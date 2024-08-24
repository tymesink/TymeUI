local TYMEUI, F, I, E = unpack(TymeUI)


E.PopupDialogs.RESET_PROFILE = {
	text = 'Are you sure you want to reset your profile?',
	button1 = ACCEPT,
	button2 = CANCEL,
	OnAccept = function(self)
    TYMEUI.db.profile.profileModule.ProfileHasBeenSet = false
    ReloadUI()
	end,
	whileDead = 1,
	hideOnEscape = false,
}


function TYMEUI:StaticPopup_ReloadUI()
  E:StaticPopup_Show('CONFIG_RL')
end

function TYMEUI:StaticPopup_ResetProfile()
  E:StaticPopup_Show('RESET_PROFILE')
end