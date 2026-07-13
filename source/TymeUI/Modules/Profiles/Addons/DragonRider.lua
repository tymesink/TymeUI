local TYMEUI, F = unpack(TymeUI)
local PF = TYMEUI:GetModule("Profiles")

local profileDbDefault = {
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

PF:NewProfileModule('DragonRider', function() return DragonRider_DB end, function(profileDb)
	F.Table.Crush(profileDb, profileDbDefault) -- Merge Tables
	return true
end)