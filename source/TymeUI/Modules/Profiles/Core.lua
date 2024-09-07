local TYMEUI, F, I, E = unpack(TymeUI)
local Profiles = TYMEUI:NewModule("Profiles", "AceHook-3.0")
local _G = _G
local xpcall,pairs = xpcall,pairs

Profiles.Modules = {}
Profiles.ReloadUI = false
local profileDb = {}

local moduleDefault = {
	Enabled = false,
	ProfileLoaded = false
}

function TYMEUI:HandleResetProfileCommand(msg)
	TYMEUI:StaticPopup_ResetProfile()
end

local function errorhandler(err)
	return _G.geterrorhandler()(err)
end

local isProfileEnabled = function(module)
	if not module then return false end
	local name = module.Name

	
	if module.Enabled == nil then return false end
	if module.Enabled == false then 
		return false;
	end
	return true;
end

local initializeProfile = function(module)
	if not module then return false end
	local name = module.Name

	if module.Initialized == nil then return false end
	if module.Initialized == true then return true end

	TYMEUI:PrintMessage('Profiles => ' .. name .. ' Initializing...')

	F.Log.InjectLogger(module)
	xpcall(module.Initialize, errorhandler, module)
	if module.Initialized == false then 
		return false;
	end

	if Profiles.ReloadUI ~= true then
		Profiles.ReloadUI = module.ReloadUI
	end
	return true
end

local loadProfile = function(module)
	if not module then return false end
	local name = module.Name

	local profileInitialized = initializeProfile(module)
	if profileInitialized then
		profileDb[name].ProfileLoaded = true
		TYMEUI:PrintMessage('Profiles => ' .. name .. ' Initialized.  Waiting for Reloading UI')
	else
		profileDb[name].ProfileLoaded = false
		TYMEUI:PrintMessage('Profiles => ' .. name .. ' Failed to Initialize')
	end
end

local initializeProfiles = function()
    TYMEUI:PrintMessage('Profiles => Initializing Profiles')

    for moduleName, module in pairs(Profiles.Modules) do
        local name = module.Name
		
		if not profileDb[name] then
            profileDb[name] = F.Deepcopy(moduleDefault)
        end

		profileDb[name].Enabled = isProfileEnabled(module)
		if profileDb[name].Enabled == true then
			local profileLoaded = profileDb[name].ProfileLoaded
			if(profileLoaded == false) then
				loadProfile(module)
			else
				TYMEUI:PrintMessage('Profiles => ' .. name .. ' Already loaded')	
			end
		end
    end
end

function Profiles:Initialize()
	-- Don't init second time
	if self.Initialized then return end

	profileDb = TYMEUI.db.profile.ProfileAddons

    if not profileDb then
        profileDb = {}
    end

	
	TYMEUI:RegisterChatCommand("resetprofile", "HandleResetProfileCommand")

	if(self:ElvUIInstallComplete() == false) then
		return
	end

	initializeProfiles()

	if self.ReloadUI then
		TYMEUI:StaticPopup_ReloadUI()
	end

	-- We are done, hooray!
	TYMEUI:PrintMessage('Profiles:Initialized()');
	self.Initialized = true
end

function Profiles:RegisterProfile(module)
	if not module then return end
	
	local name = module.Name
    if not self.Modules[name] then
        self.Modules[name] = module
    end
end

function Profiles:CanLoadProfileForAddon(name, profiledb)	
	if not F.IsAddOnEnabled(name) then
		TYMEUI:PrintMessage(name .. ' => is not available');
		return false
	end

	if not profiledb then
		TYMEUI:PrintMessage(name .. ' => profileDB is not available');
		return false
	end

	return true
end

function Profiles:ElvUIInstallComplete()
	if not E.private.install_complete then
		TYMEUI:PrintMessage('ElvUI initial install not complete, skipping profile setup');
		return false
	end
	return true
end

TYMEUI:RegisterModule(Profiles:GetName())
