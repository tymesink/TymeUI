local TYMEUI, F, I, E = unpack(TymeUI)
local PF = TYMEUI:GetModule("Profiles")
local db = MasqueDB

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

function PF:LoadMasqueProfile()
    F.Chat('chat', 'Load Masque Profile');
    if db then
        local profiles = db.profiles
        if profiles then
            for profileName, profileData in pairs(profiles) do
                if profileName == 'Default' then
                    updatePosition(profileData.LDB, 3)
                    updateGroups(profileData.Groups)
                end
            end
        end
    else
        F.Chat('chat', 'MasqueDB is not available.');
    end
end