local TYMEUI, F, I, E = unpack(TymeUI)
local PF = TYMEUI:GetModule("Profiles")
local module = TYMEUI:NewModule("WIMProfile", "AceHook-3.0")

module.Enabled = true
module.Initialized = false
module.ReloadUI = false
module.Name = 'WIM'

local profileDb = WIM3_Data

function module:LoadProfile()

	if profileDb.modules == nil then
		profileDb.modules = {}
	end

	if profileDb.modules.MinimapIcon == nil then
		profileDb.modules.MinimapIcon = {}
	end

	profileDb.modules.MinimapIcon.enabled = false
	return true
end

function module:Initialize()
	-- Don't init second time
	if self.Initialized then return end

	if PF:CanLoadProfileForAddon(module.Name, profileDb) then
		local loaded = self:LoadProfile()
		if loaded then
			module.ReloadUI = true
			TYMEUI:PrintMessage(module.Name .. ' => Profile Loaded', I.Constants.ColorHex.brightblue)

			-- We are done, hooray!
			self.Initialized = true
		end
	end
end

PF:RegisterProfile(module)