local TYMEUI, F, I, E = unpack(TymeUI)
local Profiles = TYMEUI:GetModule("Profiles")
local module = TYMEUI:NewModule("ElvUIProfile", "AceHook-3.0")
local profileAddonName = 'ElvUI'
module.Enabled = true;
module.Initialized = false;

local _G = _G
local next, ipairs = next, ipairs
local FCF_DockFrame, FCF_UnDockFrame = FCF_DockFrame, FCF_UnDockFrame
local FCF_GetChatWindowInfo = FCF_GetChatWindowInfo
local FCF_SetChatWindowFontSize = FCF_SetChatWindowFontSize
local loot = LOOT:match "^.?[\128-\191]*"
local trade = TRADE:match "^.?[\128-\191]*"
local crushFnc = TYMEUI.DevRelease and F.Table.CrushDebug or F.Table.Crush

-- Local Tables
local pf = {
	actionbar = {},
	auras = {
		buffs = {},
		debuffs = {},
	},
	bags = {},
	chat = {},
	cooldown = {},
	databars = {},
	datatexts = {
		panels = {},
	},
	general = {},
	nameplates = {},
	movers = {},
	tooltip = {},
	unitframe = {
		colors = {},
		units = {},
	},
}

local SetupProfile = function()
	-- Setup Unit Tables & Disable Info Panel
	for _, unit in next,
	{
		"player",
		"target",
		"targettarget",
		"targettargettarget",
		"focus",
		"focustarget",
		"pet",
		"pettarget",
		"boss",
		"arena",
		"party",
		"raid1",
		"raid2",
		"raid3",
		"raidpet",
		"tank",
		"assist",
	}
	do
		pf.unitframe.units[unit] = {
			infoPanel = {
				enable = false,
			},
		}
	end

	crushFnc(pf.databars, {
		["threat"] = {
			["width"] = 140,
			["height"] = 15,
		},
		["honor"] = {
			["width"] = 320,
			["height"] = 15,
			["showBubbles"] = true,
		},
		["reputation"] = {
			["enable"] = true,
			["textFormat"] = "CUR",
			["width"] = 320,
			["height"] = 15,
			["showBubbles"] = true,
		},
		["statusbar"] = "Rain",
		["experience"] = {
			["width"] = 515,
			["height"] = 15,
			["showBubbles"] = true,
		},
		["customTexture"] = true
	})

	crushFnc(pf.datatexts, {
		panels = {
			MinimapPanel = {
				enable = false
			},
			RightChatDataPanel = {
				"Bags",
				"Volume",
				"DPS"
			},
			LeftChatDataPanel = {
				[3] = "Currencies"
			}
		}
	})

	crushFnc(pf.movers, {
		["QueueStatusMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,95",
		["PetAB"] = "BOTTOM,ElvUIParent,BOTTOM,0,235",
		["ElvAB_1"] = "BOTTOM,ElvUIParent,BOTTOM,0,191",
		["LeftChatMover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,0,3",
		["BelowMinimapContainerMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-1,-262",
		["ElvAB_4"] = "BOTTOM,ElvUIParent,BOTTOM,148,60",
		["VehicleLeaveButton"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,552,230",
		["AltPowerBarMover"] = "TOP,ElvUIParent,TOP,0,-53",
		["BossButton"] = "BOTTOM,ElvUIParent,BOTTOM,214,237",
		["ReputationBarMover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,477,8",
		["ZoneAbility"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,594,108",
		["ElvAB_2"] = "BOTTOM,ElvUIParent,BOTTOM,0,149",
		["AddonCompartmentMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-215,-28",
		["TotemTrackerMover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,417,27",
		["BNETMover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,0,208",
		["ShiftAB"] = "BOTTOMLEFT,UIParent,BOTTOMLEFT,634,211",
		["ThreatBarMover"] = "BOTTOMRIGHT,UIParent,BOTTOMRIGHT,-622,260",
		["HonorBarMover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-476,8",
		["ElvAB_6"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,0,295",
		["TooltipMover"] = "TOPLEFT,ElvUIParent,TOPLEFT,510,-34",
		["PowerBarContainerMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,322",
		["PrivateAurasMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-217,-211",
		["ElvUIBagMover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-274,257",
		["MicrobarMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,27",
		["RightChatMover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,0,3",
		["ExperienceBarMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,8",
		["GMMover"] = "TOPLEFT,ElvUIParent,TOPLEFT,251,-21",
		["ElvAB_3"] = "BOTTOM,ElvUIParent,BOTTOM,-148,60"
	})

	crushFnc(pf.general, {
		-- General AFK Mode
		afk = false,
		afkChat = false,
		afkSpin = false,
		taintLog = true,
		interruptAnnounce = 'NONE',
		autoRepair = 'NONE',
		autoTrackReputation = true,
		autoAcceptInvite = false,
		hideErrorFrame = true,
		hideZoneText = false,
		enhancedPvpMessages = true,
		objectiveFrameHeight = 480,
		objectiveFrameAutoHide = true,
		objectiveFrameAutoHideInKeystone = false,
		topPanel = false,
		topPanelSettings = {
			transparent = true,
			height = 22,
			width = 0
		},
		bottomPanel = true,
		bottomPanelSettings = {
			transparent = true,
			height = 28,
			width = 0
		},
		resurrectSound = true,
		stickyFrames = false,
		talkingHeadFrameBackdrop = true,

		-- General Colors
		backdropcolor = F.Table.HexToRGB("#1a1a1a"),
		backdropfadecolor = F.Table.HexToRGB("#292929CC"),
		bordercolor = F.Table.HexToRGB("#000000"),

		-- AltPowerBar
		altPowerBar = {
			enable = false,
		},

		privateAuras = {
			enable = true,
		},

		queueStatus = {
			enable = true,
		},
	})

	crushFnc(pf.chat, {
		panelSnapLeftID = 1,
		tabSelector = 'BOX',
		panelWidth = 475,
		panelHeight = 230,
		panelColor = {
			r = 0,
			g = 0.2274509966373444,
			b = 0.2000000178813934,
			a = 0.3190101981163025,
		},
		tabSelectorColor = {
			r = 0.09,
			g = 0.51,
			b = 0.82,
		},
		customTimeColor = {
			b = 0.5098039507865906,
			g = 0.7019608020782471,
			r = 0,
		},
		timeStampFormat = "%I:%M:%S %p ",
		timeStampLocalTime = true,
		channelAlerts = {
			PARTY = "pop2",
			GUILD = "kachink",
			INSTANCE = "doublehit",
		},
		keywords = "Court\nKort\nVayne\nBrewshot",
		historySize = 15,
	})

	crushFnc(pf.bags, {
		useBlizzardCleanup = false,
		clearSearchOnClose = false,
		junkIcon = false,
		moneyCoins = false,
		scrapIcon = false,
		showBindType = false,
		vendorGrays = {
			enable = false,
		},
		bagBar = {
			enable = true,
			showBackdrop = true,
		},
		spinner = {
			enable = true,
		},
	})

	crushFnc(pf.actionbar, {
		["chargeCooldown"] = true,
		["useDrawSwipeOnCharges"] = true,
		["flashAnimation"] = true,
		["transparent"] = true,
		["bar1"] = {
			["buttonSize"] = 42,
		},
		["bar2"] = {
			["enabled"] = true,
			["buttonSize"] = 42,
		},
		["bar3"] = {
			["buttonSize"] = 36,
			["buttons"] = 12,
		},
		["bar5"] = {
			["enabled"] = false,
		},
		["bar4"] = {
			["backdrop"] = false,
			["buttonsPerRow"] = 6,
			["buttonSize"] = 36,
		},
		["bar6"] = {
			["enabled"] = true,
			["buttonsPerRow"] = 1,
			["buttonSize"] = 40,
		},
		["barPet"] = {
			["backdrop"] = false,
			["buttonsPerRow"] = 10,
		},
		["microbar"] = {
			["enabled"] = true,
			["useIcons"] = false,
			["mouseover"] = true,
			["buttonSize"] = 24,
			["buttons"] = 11,
			["backdrop"] = true,
		}
	})

	crushFnc(pf.nameplates, {
		cutaway = {
			health = { enable = true, },
			power = { enable = true, },
		},
		threat = {
			indicator = true,
			enable = true,
		},
	})

	-- ! IMPORTANT ! --
	pf.gridSize = 76

	-- Merge Tables
	crushFnc(E.db, pf)

	-- Set Globals
	-- crushFnc(E.global, {
	--   uiScaleInformed = true,

	--   general = {
	--     commandBarSetting = "DISABLED",
	--   },
	-- })
end

local SetupProfilePrivate = function()
	local isBagsEnabled = true
	local BAG_ADDONS = { "Bagnon", "BetterBags", "Baggins", "Sorted", "Inventorian", "Baganator", "ArkInventory", "OneBag3", "Combuctor" }

	for _, addon in ipairs(BAG_ADDONS) do
		if F.IsAddOnEnabled(addon) then isBagsEnabled = false end
	end

	F.Table.Crush(E.private, {

		general = {
			raidUtility = false,
			totemTracker = false,
			lootRoll = false,
			queueStatus = true,
			worldMap = false,
			minimap = {
				enable = false
			},
		},

		unitframe = {
			enable = false,
			disabledBlizzardFrames = {
				castbar = false,
				player = false,
				target = false,
				focus = false,
				boss = false,
				arena = false,
				party = false,
				raid = false,
			}
		},

		actionbar = {
			enable = true,
			hideCooldownBling = false,
			masque = {
				actionbars = true,
				petBar = true,
				stanceBar = true,
			},
		},

		nameplates = {
			enable = true,
		},

		tooltip = {
			enable = false,
		},

		chat = {
			enable = true,
		},

		bags = {
			enable = isBagsEnabled,
			bagBar = true
		},

		auras = {
			enable = false,
			disableBlizzard = false,
			buffsHeader = false,
			debuffsHeader = false
		},

		skins = {
			ace3Enable = true,
			libDropdown = true,
			checkBoxSkin = true,
			parchmentRemoverEnable = false,
			blizzard = {
				enable = true,
				eventLog = true,
				worldmap = false,
				achievement = false,
				addonManager = false,
				alertframes = false,
				alliedRaces = false,
				animaDiversion = false,
				arena = false,
				arenaRegistrar = false,
				archaeology = false,
				artifact = false,
				azerite = false,
				azeriteEssence = false,
				azeriteRespec = false,
				bags = false,
				barber = false,
				battlefield = false,
				bgmap = false,
				bgscore = false,
				binding = false,
				blizzardOptions = false,
				bmah = false,
				calendar = false,
				channels = false,
				character = false,
				chromieTime = false,
				collections = false,
				communities = false,
				contribution = false,
				craft = false,
				covenantPreview = false,
				covenantRenown = false,
				covenantSanctum = false,
				deathRecap = false,
				dressingroom = false,
				editor = false,
				encounterjournal = false,
				engraving = false,
				expansionLanding = false,
				friends = false,
				garrison = false,
				genericTrait = false,
				gmChat = false,
				gossip = false,
				greeting = false,
				guild = false,
				guildBank = false,
				guildcontrol = false,
				guildregistrar = false,
				guide = false,
				islandQueue = false,
				islandsPartyPose = false,
				inspector = false,
				itemInteraction = false,
				itemUpgrade = false,
				lfg = false,
				lfguild = false,
				loot = false,
				losscontrol = false,
				macro = false,
				mail = false,
				majorFactions = false,
				merchant = false,
				mirrorTimers = false,
				misc = false,
				nonraid = false,
				objectiveTracker = false,
				obliterum = false,
				orderhall = false,
				perks = false,
				petition = false,
				petbattleui = false,
				playerChoice = false,
				pvp = false,
				quest = false,
				questChoice = false,
				questTimers = false,
				raid = false,
				reforge = false,
				runeforge = false,
				scrapping = false,
				socket = false,
				soulbinds = false,
				spellbook = false,
				stable = false,
				subscriptionInterstitial = false,
				tabard = false,
				talkinghead = false,
				talent = false,
				taxi = false,
				timemanager = false,
				torghastLevelPicker = false,
				tooltip = false,
				trade = false,
				trainer = false,
				transmogrify = false,
				tradeskill = false,
				voidstorage = false,
				weeklyRewards = false,
			}
		},

		theme = "classic"
	})
end

local SetuProfileGlobal = function()
	F.Table.Crush(E.global, {
		-- General
		general = {
			-- ultrawide = false,
			-- UIScale = 0.6,
			-- WorldMapCoordinates = {
			--   position = "BOTTOMRIGHT",
			-- },

			AceGUI = {
				width = 1070,
				height = 833,
			},
		},
	})
end

local function SetupChat()
	for _, name in ipairs(_G.CHAT_FRAMES) do
		local frame = _G[name]
		local id = frame:GetID()
		local chatName = FCF_GetChatWindowInfo(id)

		FCF_SetChatWindowFontSize(nil, frame, 13)

		-- move ElvUI default loot frame to the left chat, so that Recount/Skada can go to the right chat.
		if id == 4 and (chatName == (LOOT .. ' / ' .. TRADE) or chatName == (loot .. ' / ' .. trade)) then
			FCF_UnDockFrame(frame)
			FCF_DockFrame(frame)
		end
	end
end

function module:LoadProfile()
	SetupProfile()
	SetupProfilePrivate()
	SetuProfileGlobal()
	SetupChat()
end

function module:Initialize()
    -- Don't init second time
    if not self.Enabled then
        F.Chat('chat', self:GetName()..' is not enabled.');
		return
    end

    if self.Initialized then return end

    if Profiles:IsAddOnLoaded(profileAddonName, E.db) then
        self:LoadProfile()
    end
    
    -- We are done, hooray!
    self.Initialized = true
    F.Chat('chat', self:GetName()..':Initialized()');
end

Profiles:RegisterProfile(module)
