local TYMEUI, F, I, E = unpack(TymeUI)
local PF = TYMEUI:GetModule("Profiles")
local db = NarcissusDB

function PF:LoadNarcissusProfile()
    F.Chat('chat', 'Load Narcissus Profile');
    if db then
        db.AFKScreen = true
        db.AKFScreenDelay = true
        db.ShowMinimapButton = false
    else
        F.Chat('chat', 'NarcissusDB is not available.')
    end
end