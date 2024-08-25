local TYMEUI, F, I, E = unpack(TymeUI)
local Profiles = TYMEUI:NewModule("Profiles", "AceHook-3.0")
local _G = _G


Profiles.RegisteredProfiles = {}

function TYMEUI:HandleResetProfileCommand(msg)
	TYMEUI:StaticPopup_ResetProfile()
end

local function errorhandler(err)
	return _G.geterrorhandler()(err)
end

function Profiles:RegisterProfile(profile)
	if not profile then return end
	
	local name = profile:GetName()
    if not self.RegisteredProfiles[name] then
        self.RegisteredProfiles[name] = profile
    end
end

function Profiles:InitializeProfiles()
	F.Chat('chat', 'Profiles/Core.lua => Initializing Profiles')

	for profileName, profile in pairs(self.RegisteredProfiles) do
        if not profile.initialized then
            F.Log.InjectLogger(profile)
            if profile.Initialize then 
                xpcall(profile.Initialize, errorhandler, profile) 
            end
        end
    end
end

function Profiles:IsAddOnLoaded(addonName, profiledb)
	if not F.IsAddOnEnabled(addonName) then
		F.Chat('chat', addonName .. 'is not available');
		return false
	end

	if not profiledb then
		F.Chat('chat', addonName .. ' profileDB is not available');
		return false
	end

	return true
end

function Profiles:ElvUIInstallComplete()
	if not F.IsAddOnEnabled('ElvUI') then
		F.Chat('chat', 'Profiles:ElvUI addon has not loaded');
		return false
	end

	if not E.private.install_complete then
		F.Chat('chat', 'Profiles:ElvUI install not complete, skipping profile setup');
		return false
	end

	return true
end

function Profiles:Initialize()
	-- Don't init second time
	if self.Initialized then return end
	
	TYMEUI:RegisterChatCommand("resetprofile", "HandleResetProfileCommand")
	Profiles.db = TYMEUI.db.profile.profileModule

	local reloadui = false;
	local initialized = self.db.Initialized
	if initialized == nil or initialized == false then
		F.Chat('chat', 'Setting profiles...');

		if not self:ElvUIInstallComplete() then	return end

		self:InitializeProfiles()
		self.db.Initialized = true
		TYMEUI:StaticPopup_ReloadUI()
	end

	-- We are done, hooray!
	F.Chat('chat', 'Profiles:Initialized()');
	self.Initialized = true
end

TYMEUI:RegisterModule(Profiles:GetName())
