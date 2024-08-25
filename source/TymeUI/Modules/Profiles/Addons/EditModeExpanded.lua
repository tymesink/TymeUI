local TYMEUI, F, I, E = unpack(TymeUI)
local Profiles = TYMEUI:GetModule("Profiles")
local module = TYMEUI:NewModule("EditModeExpandedProfile", "AceHook-3.0")
local profileAddonName = 'EditModeExpanded'
local profileDb = EditModeExpandedADB
module.Enabled = true;
module.Initialized = false;

local next = next
local layoutNameKey = '1-Default-UI';
local crushFnc = TYMEUI.DevRelease and F.Table.CrushDebug or F.Table.Crush
local customLayoutElements = {
    ExpansionLandingPageMinimapButton = {
		enabled = true,
        defaultY = 943.3999633789062,
        defaultX = 1912.833129882813,
        x = 2075.3330078125,
        y = 1095.333251953125
    },
    FocusSpellBar = {
        defaultY = 97.52613067626953,
        defaultX = 1380.702392578125,
        x = 1795.147094726563,
        y = 230.8586883544922,
        enabled = true,
        clamped = true,
        settings = {
            [16] = 100,
            [17] = {
                AnchorToDropdown = {
                    checked = 'FocusFrame',
                },
            },
        }
    },
    FocusToT = {
        defaultY = 63.52613830566406,
        defaultX = 1416.746215820313,
        x = 1492.598388671875,
        y = 116.8719177246094,
        enabled = true,
        clamped = true,
        settings = {
            [12] = {},
            [17] = {
                AnchorToDropdown = {
                    checked = 'FocusFrame',
                },
            },
        }
    },
    FocusFrame = {
		enabled = true,
        settings = {
            [12] = {},
        }
    },
    TargetSpellBar = {
        defaultY = 240,
        defaultX = 1390.466674804688,
        x = 1370.466796875,
        y = 341.6658630371094,
        enabled = true,
        clamped = true,
        settings = {
            [17] = {
                AnchorToDropdown = {
                    checked = 'TargetFrame',
                },
            },
        }
    },
    ToT = {
        defaultY = 206.0000305175781,
        defaultX = 1471.466674804688,
        x = 1565.633178710938,
        y = 271.8327331542969,
        enabled = true,
        clamped = true,
        settings = {
            [12] = {},
            [17] = {
                AnchorToDropdown = {
                    checked = 'TargetFrame',
                },
            },
        }
    },
	TargetBuffs = {
		defaultX = 1352.466674804688,
		defaultY = 225,
		x = 1374.133666992188,
		y = 263.3329772949219,
        defaultScale = 1,
		settings = {
            [17] = {
                AnchorToDropdown = {
                    checked = 'TargetFrame',
                },
            },
        },
		enabled = true,
		clamped = 1,
	}
}

local function updateLayoutElement(layoutElementKey, setting)
    local layoutElement = profileDb.global[layoutElementKey]
    if layoutElement and type(layoutElement.profiles) == "table" and next(layoutElement.profiles) ~= nil then
        local layoutSettings = layoutElement.profiles[layoutNameKey]
        if layoutSettings then
            crushFnc(layoutSettings, setting) -- Merge Tables
        end
    end
end

local function updateAllLayoutElements()
    for layoutElementKey, setting in pairs(customLayoutElements) do
        updateLayoutElement(layoutElementKey, setting)
    end
end

function module:LoadProfile()
    profileDb.global.EMEOptions.backpack = false
    profileDb.global.EMEOptions.chatButtons = false
    profileDb.global.EMEOptions.achievementAlert = false
    profileDb.global.EMEOptions.lfg = false

	profileDb.global.EMEOptions.targetCast = true
	profileDb.global.EMEOptions.targetFrameBuffs = true
	profileDb.global.EMEOptions.targetOfTarget = true

	profileDb.global.EMEOptions.focusCast = true
	profileDb.global.EMEOptions.focusFrame = true
	profileDb.global.EMEOptions.focusTargetOfTarget = true

	updateAllLayoutElements()
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