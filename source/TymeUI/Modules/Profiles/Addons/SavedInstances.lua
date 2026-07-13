local TYMEUI, F = unpack(TymeUI)
local PF = TYMEUI:GetModule("Profiles")

PF:NewProfileModule('SavedInstances', function() return SavedInstancesDB end, function(profileDb)
	local profile = {
		["MinimapIcon"] = {
			["showInCompartment"] = true,
			["hide"] = true,
		},
	}
	F.Table.Crush(profileDb, profile)
	return true
end)
