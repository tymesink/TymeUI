local TYMEUI, F, I, E = unpack(TymeUI)
local PF = TYMEUI:GetModule("Profiles")
local module = TYMEUI:NewModule("EditModeExpandedProfile", "AceHook-3.0")

module.Enabled = true
module.Initialized = false
module.ReloadUI = false
module.Name = 'EditModeExpanded'

local profileDb = EditModeExpandedADB
local EditModeManagerFrame = EditModeManagerFrame
local profileDbDefault = {
    profileKeys = {},
    global = {}
}

local getCurrentLayoutName = function ()
    local layoutInfo = EditModeManagerFrame:GetActiveLayoutInfo()
    return layoutInfo.layoutType.."-"..layoutInfo.layoutName
end

local setCustomLayoutProfile = function(profileName)
    local profile = {
        ["PetActionBar"] = {
            ["profiles"] = {
                [profileName] = {},
            },
        },
        ["GameMenuFrame"] = {
            ["profiles"] = {
                [profileName] = {
                    ["defaultScale"] = 1,
                    ["defaultY"] = 331.6666870117188,
                    ["defaultX"] = 938.6666870117188,
                    ["x"] = 938.6666870117188,
                    ["enabled"] = false,
                    ["y"] = 331.6666870117188,
                    ["clamped"] = 1,
                },
            },
        },
        ["PetFrame"] = {
            ["profiles"] = {
                [profileName] = {
                },
            },
        },
        ["TalkingHeadFrame"] = {
            ["y"] = 96,
            ["x"] = 397.6666870117188,
            ["profiles"] = {
                [profileName] = {
                    ["y"] = 96,
                    ["x"] = 397.6666870117188,
                    ["settings"] = {
                    },
                },
            },
        },
        ["MainStatusTrackingBarContainer"] = {
            ["profiles"] = {
                [profileName] = {
                    ["y"] = 0,
                    ["x"] = 781.166748046875,
                    ["settings"] = {
                    },
                },
            },
        },
        ["PlayerFrame"] = {
            ["profiles"] = {
                [profileName] = {
                    ["settings"] = {
                        [12] = {
                        },
                    },
                },
            },
        },
        ["TotemFrame"] = {
            ["profiles"] = {
                [profileName] = {
                    ["defaultScale"] = 1,
                    ["defaultY"] = 269.9999694824219,
                    ["settings"] = {
                        [16] = 100,
                        [10] = 0,
                    },
                    ["defaultX"] = 751.666748046875,
                    ["x"] = 814.1675415039062,
                    ["enabled"] = true,
                    ["y"] = 347.9997253417969,
                    ["clamped"] = 1,
                },
            },
        },
        ["DebuffFrame"] = {
            ["profiles"] = {
                [profileName] = {
                    ["settings"] = {
                        [12] = {
                        },
                    },
                },
            },
        },
        ["ChatFrameMenuButton"] = {
            ["profiles"] = {
                [profileName] = {
                    ["defaultScale"] = 1,
                    ["defaultY"] = 140.1666564941406,
                    ["defaultX"] = 407.0000305175781,
                    ["x"] = 407.0000305175781,
                    ["enabled"] = true,
                    ["y"] = 140.1666564941406,
                    ["clamped"] = 1,
                },
            },
        },
        ["VehicleSeatIndicator"] = {
            ["profiles"] = {
                [profileName] = {
                },
            },
        },
        ["EMEOptions"] = {
            ["lfg"] = false,
            ["chatButtons"] = false,
        },
        ["QueueStatusButton"] = {
            ["profiles"] = {
                [profileName] = {
                    ["defaultScale"] = 0.5,
                    ["defaultY"] = 107.5800018310547,
                    ["settings"] = {
                        [12] = {
                        },
                    },
                    ["defaultX"] = 1342.833251953125,
                    ["x"] = 1342.833251953125,
                    ["enabled"] = true,
                    ["y"] = 107.5800018310547,
                    ["clamped"] = 1,
                },
            },
        },
        ["TargetFrame"] = {
            ["profiles"] = {
                [profileName] = {
                    ["settings"] = {
                        [12] = {
                        },
                    },
                },
            },
        },
        ["BagsBar"] = {
            ["profiles"] = {
                [profileName] = {
                    ["settings"] = {
                    },
                },
            },
        },
        ["ContainerFrameCombinedBags"] = {
            ["profiles"] = {
                [profileName] = {
                    ["defaultScale"] = 1,
                    ["enabled"] = true,
                    ["clamped"] = 1,
                },
            },
        },
        ["CompactArenaFrame"] = {
            ["profiles"] = {
                [profileName] = {
                },
            },
        },
        ["MultiBar6"] = {
            ["profiles"] = {
                [profileName] = {
                },
            },
        },
        ["ExtraAbilityContainer"] = {
            ["profiles"] = {
                [profileName] = {
                },
            },
        },
        ["FocusSpellBar"] = {
            ["profiles"] = {
                [profileName] = {
                    ["defaultScale"] = 1.33299994468689,
                    ["defaultY"] = 96.7259292602539,
                    ["settings"] = {
                        [16] = 100,
                        [17] = {
                            ["AnchorToDropdown"] = {
                            },
                        },
                    },
                    ["defaultX"] = 1364.8984375,
                    ["x"] = 1794.898559570313,
                    ["enabled"] = true,
                    ["y"] = 230.0586090087891,
                    ["clamped"] = 1,
                },
            },
        },
        ["FocusToT"] = {
            ["profiles"] = {
                [profileName] = {
                    ["defaultScale"] = 1.33299994468689,
                    ["defaultY"] = 62.72593688964844,
                    ["settings"] = {
                        [12] = {
                        },
                        [17] = {
                            ["AnchorToDropdown"] = {
                            },
                        },
                    },
                    ["defaultX"] = 1400.942260742188,
                    ["x"] = 1490.964599609375,
                    ["enabled"] = true,
                    ["y"] = 116.9049530029297,
                    ["clamped"] = 1,
                },
            },
        },
        ["Achievements"] = {
            ["profiles"] = {
                [profileName] = {
                    ["defaultScale"] = 1,
                    ["defaultY"] = 128,
                    ["settings"] = {
                    },
                    ["defaultX"] = 1061.666625976563,
                    ["x"] = 1061.666625976563,
                    ["enabled"] = true,
                    ["y"] = 128,
                    ["clamped"] = 1,
                },
            },
        },
        ["FocusFrame"] = {
            ["profiles"] = {
                [profileName] = {
                    ["settings"] = {
                        [12] = {
                        },
                    },
                },
            },
        },
        ["MirrorTimerContainer"] = {
            ["profiles"] = {
                [profileName] = {
                },
            },
        },
        ["ChatFrame1"] = {
            ["profiles"] = {
                [profileName] = {
                },
            },
        },
        ["DurabilityFrame"] = {
            ["profiles"] = {
                [profileName] = {
                },
            },
        },
        ["MainMenuBar"] = {
            ["profiles"] = {
                [profileName] = {
                },
            },
        },
        ["PlayerCastingBarFrame"] = {
            ["profiles"] = {
                [profileName] = {
                },
            },
        },
        ["TargetSpellBar"] = {
            ["profiles"] = {
                [profileName] = {
                    ["defaultScale"] = 1,
                    ["defaultY"] = 240,
                    ["settings"] = {
                        [17] = {
                            ["AnchorToDropdown"] = {
                            },
                        },
                    },
                    ["defaultX"] = 1390.466674804688,
                    ["x"] = 1373.800048828125,
                    ["enabled"] = true,
                    ["y"] = 335.8329772949219,
                    ["clamped"] = 1,
                },
            },
        },
        ["PartyFrame"] = {
            ["settings"] = {
                [12] = {
                },
            },
            ["profiles"] = {
                [profileName] = {
                    ["settings"] = {
                        [12] = {
                        },
                    },
                },
            },
        },
        ["GameTooltipDefaultContainer"] = {
            ["profiles"] = {
                [profileName] = {
                },
            },
        },
        ["StanceBar"] = {
            ["profiles"] = {
                [profileName] = {
                    ["settings"] = {
                    },
                },
            },
        },
        ["MainMenuBarVehicleLeaveButton"] = {
            ["profiles"] = {
                [profileName] = {
                },
            },
        },
        ["ChatFrameChannelButton"] = {
            ["profiles"] = {
                [profileName] = {
                    ["defaultScale"] = 1,
                    ["defaultY"] = 175.8333129882813,
                    ["defaultX"] = 381.6666870117188,
                    ["x"] = 381.6666870117188,
                    ["enabled"] = true,
                    ["y"] = 175.8333129882813,
                    ["clamped"] = 1,
                },
            },
        },
        ["MultiBarRight"] = {
            ["profiles"] = {
                [profileName] = {
                },
            },
        },
        ["MultiBar7"] = {
            ["profiles"] = {
                [profileName] = {
                },
            },
        },
        ["MultiBar5"] = {
            ["profiles"] = {
                [profileName] = {
                },
            },
        },
        ["CompactRaidFrameManager"] = {
            ["defaultScale"] = 1,
            ["defaultY"] = 857.9999389648438,
            ["clamped"] = 0,
            ["defaultX"] = -200,
            ["y"] = 857.9999389648438,
            ["enabled"] = true,
            ["x"] = -200,
            ["profiles"] = {
                [profileName] = {
                    ["y"] = 857.9999389648438,
                    ["x"] = -200,
                    ["defaultX"] = -200,
                    ["enabled"] = true,
                    ["defaultY"] = 857.9999389648438,
                },
            },
        },
        ["ExpansionLandingPageMinimapButton"] = {
            ["profiles"] = {
                [profileName] = {
                    ["defaultScale"] = 1,
                    ["defaultY"] = 943.3999633789062,
                    ["settings"] = {
                        [12] = {
                        },
                    },
                    ["defaultX"] = 1912.833129882813,
                    ["x"] = 2064.499755859375,
                    ["enabled"] = true,
                    ["y"] = 1098.400146484375,
                    ["clamped"] = 1,
                },
            },
        },
        ["EncounterBar"] = {
            ["profiles"] = {
                [profileName] = {
                },
            },
        },
        ["MultiBarBottomLeft"] = {
            ["profiles"] = {
                [profileName] = {
                },
            },
        },
        ["PossessActionBar"] = {
            ["profiles"] = {
                [profileName] = {
                },
            },
        },
        ["ToT"] = {
            ["profiles"] = {
                [profileName] = {
                    ["defaultScale"] = 1,
                    ["defaultY"] = 206.0000305175781,
                    ["settings"] = {
                        [12] = {
                        },
                        [17] = {
                            ["AnchorToDropdown"] = {
                            },
                        },
                    },
                    ["defaultX"] = 1471.466674804688,
                    ["x"] = 1565.6328125,
                    ["enabled"] = true,
                    ["y"] = 269.3327026367188,
                    ["clamped"] = 1,
                },
            },
        },
        ["ObjectiveTrackerFrame"] = {
            ["profiles"] = {
                [profileName] = {
                    ["settings"] = {
                        [12] = {
                        },
                    },
                },
            },
        },
        ["CompactRaidFrameContainer"] = {
            ["settings"] = {
                [12] = {
                },
            },
            ["profiles"] = {
                [profileName] = {
                    ["settings"] = {
                        [12] = {
                        },
                    },
                },
            },
        },
        ["MicroMenuContainer"] = {
            ["profiles"] = {
                [profileName] = {
                    ["settings"] = {
                        [17] = {
                            ["PaddingDropdown"] = {
                            },
                        },
                        [12] = {
                        },
                    },
                },
            },
        },
        ["MinimapCluster"] = {
            ["profiles"] = {
                [profileName] = {
                    ["settings"] = {
                        [12] = {
                        },
                    },
                },
            },
        },
        ["MultiBarLeft"] = {
            ["profiles"] = {
                [profileName] = {
                },
            },
        },
        ["BuffFrame"] = {
            ["profiles"] = {
                [profileName] = {
                    ["settings"] = {
                        [12] = {
                        },
                    },
                },
            },
        },
        ["LootFrame"] = {
            ["profiles"] = {
                [profileName] = {
                },
            },
        },
        ["QuickJoinToastButton"] = {
            ["profiles"] = {
                [profileName] = {
                    ["defaultScale"] = 1,
                    ["defaultY"] = 202.1666717529297,
                    ["defaultX"] = 380.4999694824219,
                    ["x"] = 380.4999694824219,
                    ["enabled"] = true,
                    ["y"] = 202.1666717529297,
                    ["clamped"] = 1,
                },
            },
        },
        ["BossTargetFrameContainer"] = {
            ["profiles"] = {
                [profileName] = {
                    ["settings"] = {
                        [12] = {
                        },
                    },
                },
            },
        },
        ["SecondaryStatusTrackingBarContainer"] = {
            ["profiles"] = {
                [profileName] = {
                    ["y"] = 17,
                    ["x"] = 781.166748046875,
                    ["settings"] = {
                    },
                },
            },
        },
        ["MultiBarBottomRight"] = {
            ["profiles"] = {
                [profileName] = {
                },
            },
        },
        ["ArcheologyDigsiteProgressBar"] = {
            ["profiles"] = {
                [profileName] = {
                },
            },
        },
    }
    return profile
end


function module:LoadProfile()
    local profileName = getCurrentLayoutName();
    local layoutProfile = setCustomLayoutProfile(profileName)
    F.Table.Crush(profileDbDefault.global, layoutProfile) 
    return true
end

function module:Initialize()
    if not self.Enabled then
        TYMEUI:PrintMessage(module.ModuleName..' is not enabled.');
        return
    end

    -- Don't init second time
    if self.Initialized then return end

    if PF:CanLoadProfileForAddon(module.Name, profileDb) then
        local loaded = self:LoadProfile()
        if loaded == true then
            module.ReloadUI = true
            TYMEUI:PrintMessage(module.Name .. ' => Profile Loaded', I.Constants.ColorHex.brightblue)
            -- We are done, hooray!
			self.Initialized = true
        end
    end
end

PF:RegisterProfile(module)