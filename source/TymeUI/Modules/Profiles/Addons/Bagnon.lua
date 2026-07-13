local TYMEUI = unpack(TymeUI)
local PF = TYMEUI:GetModule("Profiles")

PF:NewProfileModule('Bagnon', function() return Bagnon_Sets end, function(profileDb)
	profileDb.global = profileDb.global or {}
	profileDb.global.inventory = profileDb.global.inventory or {}
	profileDb.global.inventory.enabled = false
	return true
end)
