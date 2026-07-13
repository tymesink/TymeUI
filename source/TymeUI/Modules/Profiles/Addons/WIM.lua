local TYMEUI = unpack(TymeUI)
local PF = TYMEUI:GetModule("Profiles")

PF:NewProfileModule('WIM', function() return WIM3_Data end, function(profileDb)
	if profileDb.modules == nil then
		profileDb.modules = {}
	end

	if profileDb.modules.MinimapIcon == nil then
		profileDb.modules.MinimapIcon = {}
	end

	profileDb.modules.MinimapIcon.enabled = false
	return true
end)
