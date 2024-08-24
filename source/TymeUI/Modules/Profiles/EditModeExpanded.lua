local TYMEUI, F, I, E = unpack(TymeUI)
local PF = TYMEUI:GetModule("Profiles")
local db = EditModeExpandedADB

function PF:LoadEditModeExpandedProfile()
    F.Chat('chat', 'Load EditModeExpanded Profile');
    if db then
        db.global.EMEOptions.backpack = false
        db.global.EMEOptions.chatButtons = false
        db.global.EMEOptions.achievementAlert = false
        db.global.EMEOptions.lfg = false
    else
        F.Chat('chat', 'EditModeExpandedADB is not available.')
    end
end