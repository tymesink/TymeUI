local TYMEUI, F, I, E = unpack(TymeUI)
local Profiles = TYMEUI:GetModule("Profiles")
local module = TYMEUI:NewModule("MasqueProfile", "AceHook-3.0")
local profileAddonName = 'Masque'
local profileDb = MasqueDB
module.Enabled = true;
module.Initialized = false;

local updatePosition = function(ldb, position)
    if ldb then
        ldb.position = position
    end
end

local updateGroups = function(groups)
    if groups then
        for groupName, groupData in pairs(groups) do
            groupData.SkinID = "Modern Enhanced"
            groupData.Gloss = true
            groupData.Backdrop = true
            if(groupName ~= 'Masque') then
                groupData.Inherit = false
            end
        end
    end
end

function module:LoadProfile()
    local profiles = profileDb.profiles
    if profiles then
        for profileName, profileData in pairs(profiles) do
            if profileName == 'Default' then
                updatePosition(profileData.LDB, 3)
                updateGroups(profileData.Groups)
            end
        end
    end
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