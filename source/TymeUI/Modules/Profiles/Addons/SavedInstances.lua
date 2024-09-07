local TYMEUI, F, I, E = unpack(TymeUI)
local PF = TYMEUI:GetModule("Profiles")
local module = TYMEUI:NewModule("SavedInstancesProfile", "AceHook-3.0")

module.Enabled = true
module.Initialized = false
module.ReloadUI = false
module.Name = 'SavedInstances'

local profileDb = SavedInstancesDB

function module:LoadProfile()
	local profile = {
		["MinimapIcon"] = {
			["showInCompartment"] = true,
			["hide"] = true,
		},
	}
	F.Table.Crush(profileDb, profile)
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