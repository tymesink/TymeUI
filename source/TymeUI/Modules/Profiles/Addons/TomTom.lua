local TYMEUI = unpack(TymeUI)
local PF = TYMEUI:GetModule("Profiles")

PF:NewProfileModule('TomTom', function() return TomTomDB end, function(profileDb)
	profileDb.profiles.Default.block.enable = false
	return true
end)
