local TYMEUI, F, I, E = unpack(TymeUI)
local Profiles = TYMEUI:GetModule("Profiles")
local module = TYMEUI:NewModule("NarcissusProfile", "AceHook-3.0")
local profileAddonName = 'Narcissus'
local profileDb = NarcissusDB
module.Enabled = true;
module.Initialized = false;

function module:LoadProfile()
    profileDb.AFKScreen = true
    profileDb.AKFScreenDelay = true
    profileDb.ShowMinimapButton = false
end

function module:Initialize()
    -- Don't init second time
    if not self.Enabled then
        F.Chat('chat', self:GetName()..' is not enabled.');
        return
    end

    if self.Initialized then return end

    if Profiles:IsAddOnLoaded(profileAddonName, profileDb) then
        self:LoadProfile()
    end
    
    -- We are done, hooray!
    self.Initialized = true
    F.Chat('chat', self:GetName()..':Initialized()');
end

Profiles:RegisterProfile(module)