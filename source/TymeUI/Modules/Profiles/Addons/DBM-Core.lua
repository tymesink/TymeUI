local TYMEUI = unpack(TymeUI)
local PF = TYMEUI:GetModule("Profiles")

PF:NewProfileModule('DBM-Core', function() return DBM_MinimapIcon end, function(profileDb)
	profileDb.hide = true
	return true
end)
