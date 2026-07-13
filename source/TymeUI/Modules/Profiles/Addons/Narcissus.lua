local TYMEUI = unpack(TymeUI)
local PF = TYMEUI:GetModule("Profiles")

PF:NewProfileModule('Narcissus', function() return NarcissusDB end, function(profileDb)
	profileDb.AFKScreen = true
	profileDb.AKFScreenDelay = true
	profileDb.ShowMinimapButton = false
	return true
end)
