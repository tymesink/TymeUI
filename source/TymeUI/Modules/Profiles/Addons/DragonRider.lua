local TYMEUI, F, I, E = unpack(TymeUI)
local Profiles = TYMEUI:GetModule("Profiles")
local module = TYMEUI:NewModule("DragonRiderProfile", "AceHook-3.0")
local profileAddonName = 'DragonRider'
local profileDb = DragonRider_DB
module.Enabled = true;
module.Initialized = false;

local crushFnc = TYMEUI.DevRelease and F.Table.CrushDebug or F.Table.Crush
local default = {
    toggleModels = true,
    cooldownTimer = {
        aerialHalt = true,
        whirlingSurge = true,
        bronzeTimelock = true,
    },
    showtooltip = true,
    speedometerScale = 1,
    speedTextScale = 12,
    sideArt = true,
    speedometerPosX = 0,
    sideArtStyle = 1,
    multiplayer = true,
    speedometerPosPoint = 2,
    themeSpeed = 2,
    mainFrameSize = {
        height = 525,
        width = 550,
    },
    fadeSpeed = false,
    barStyle = 1,
    speedBarColor = {
        vigor = {
            a = 1,
            b = 0.6078431372549019,
            g = 0.5647058823529412,
            r = 0,
        },
        slow = {
            a = 1,
            b = 0,
            g = 0.3803921568627451,
            r = 0.7686274509803922,
        },
        over = {
            a = 1,
            b = 0.7647058823529411,
            g = 0.3019607843137255,
            r = 0.6588235294117647,
        },
    },
    speedometerPosY = 5,
    themeVigor = 1,
    tempFixes = {
        hideVigor = true,
    },
    vigorProgressStyle = 1,
    muteVigorSound = false,
    glyphDetector = true,
    lightningRush = true,
    fadeVigor = true,
    speedValUnits = 5,
    speedTextColor = {
        vigor = {
            b = 1,
            g = 1,
            r = 1,
        },
        slow = {
            b = 1,
            g = 1,
            r = 1,
        },
        over = {
            b = 1,
            g = 1,
            r = 1,
        },
    },
    DynamicFOV = false,
    useAccountData = false,
    statistics = {},
    raceData = {},
}

function module:LoadProfile()
    crushFnc(profileDb, default) -- Merge Tables
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