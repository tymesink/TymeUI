local TYMEUI, F, I, E = unpack(TymeUI)
local Profiles = TYMEUI:GetModule("Profiles")
local module = TYMEUI:NewModule("ElvUIProfile", "AceHook-3.0")
local profileAddonName = 'ElvUI'
module.Enabled = true;
module.Initialized = false;

local _G = _G
local FCF_DockFrame, FCF_UnDockFrame = FCF_DockFrame, FCF_UnDockFrame
local FCF_GetChatWindowInfo = FCF_GetChatWindowInfo
local FCF_SetChatWindowFontSize = FCF_SetChatWindowFontSize
local loot = LOOT:match "^.?[\128-\191]*"
local trade = TRADE:match "^.?[\128-\191]*"
local ACTION_SLOTS = _G.NUM_PET_ACTION_SLOTS or 10
local STANCE_SLOTS = _G.NUM_STANCE_SLOTS or 10

local SetupProfile = function()
	local crushFnc = TYMEUI.DevRelease and F.Table.CrushDebug or F.Table.Crush

	-- Setup Local Tables
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

	-- Setup Unit Tables & Disable Info Panel
	for _, unit in
	next,
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
		statusbar = 'Rain',
		customTexture = true,
		experience = {
			enable = true,
			width = 515,
			height = 12,
			showBubbles = true
		},
		reputation = {
			enable = true,
			width = 222,
			height = 10,
			showBubbles = true
		},
		threat = {
			enable = true,
			width = 140
		},
		honor = {
			enable = true,
			showBubbles = true
		},
		azerite = {
			enable = false
		},
		petExperience = {
			enable = false
		}
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
		-- F.Position(1, 2, 3)
		-- 1 => Anchor position of SELECTED FRAME
		-- 2 => Anchor Parent
		-- 3 => Anchor position of PARENT FRAME

		AddonCompartmentMover = F.Position('TOPRIGHT', 'ElvUIParent', 'TOPRIGHT', -215, -28),
		AltPowerBarMover = F.Position('TOP', 'ElvUIParent', 'TOP', 0, -53),
		BelowMinimapContainerMover = F.Position('TOPRIGHT', 'ElvUIParent', 'TOPRIGHT', -1, -262),
		BNETMover = F.Position('BOTTOMLEFT', 'ElvUIParent', 'BOTTOMLEFT', 0, 208),
		BossButton = F.Position('BOTTOM', 'ElvUIParent', 'BOTTOM', 214, 237),
		ElvAB_1 = F.Position('BOTTOM', 'ElvUIParent', 'BOTTOM', 0, 191),
		ElvAB_2 = F.Position('BOTTOM', 'ElvUIParent', 'BOTTOM', 0, 149),
		ElvAB_3 = F.Position('BOTTOM', 'ElvUIParent', 'BOTTOM', -148, 60),
		ElvAB_4 = F.Position('BOTTOM', 'ElvUIParent', 'BOTTOM', 148, 60),
		ElvAB_6 = F.Position('BOTTOMRIGHT', 'ElvUIParent', 'BOTTOMRIGHT', 0, 295),
		ElvUIBagMover = F.Position('BOTTOMRIGHT', 'ElvUIParent', 'BOTTOMRIGHT', -274, 257),
		ExperienceBarMover = F.Position('BOTTOM', 'ElvUIParent', 'BOTTOM', 0, 135),
		GMMover = F.Position('TOPLEFT', 'ElvUIParent', 'TOPLEFT', 251, -21),
		HonorBarMover = F.Position('BOTTOMRIGHT', 'ElvUIParent', 'BOTTOMRIGHT', -477, 7),
		LeftChatMover = F.Position('BOTTOMLEFT', 'ElvUIParent', 'BOTTOMLEFT', 0, 3),
		MicrobarMover = F.Position('BOTTOM', 'ElvUIParent', 'BOTTOM', 0, 0),
		PetAB = F.Position('BOTTOM', 'ElvUIParent', 'BOTTOM', 0, 235),
		PowerBarContainerMover = F.Position('BOTTOM', 'ElvUIParent', 'BOTTOM', 0, 306),
		PrivateAurasMover = F.Position('TOPRIGHT', 'ElvUIParent', 'TOPRIGHT', -217, -211),
		QueueStatusMover = F.Position('BOTTOM', 'ElvUIParent', 'BOTTOM', 0, 95),
		ReputationBarMover = F.Position('BOTTOMLEFT', 'ElvUIParent', 'BOTTOMLEFT', 477, 7),
		RightChatMover = F.Position('BOTTOMRIGHT', 'ElvUIParent', 'BOTTOMRIGHT', 0, 3),
		ShiftAB = F.Position('BOTTOMLEFT', 'ElvUIParent', 'BOTTOMLEFT', 146, 353),
		ThreatBarMover = F.Position('BOTTOM', 'ElvUIParent', 'BOTTOM', -625, 261),
		TooltipMover = F.Position('TOPLEFT', 'ElvUIParent', 'TOPLEFT', 510, -34),
		TotemTrackerMover = F.Position('BOTTOMLEFT', 'ElvUIParent', 'BOTTOMLEFT', 417, 27),
		VehicleLeaveButton = F.Position('BOTTOMLEFT', 'ElvUIParent', 'BOTTOMLEFT', 552, 230),
		ZoneAbility = F.Position('BOTTOMLEFT', 'ElvUIParent', 'BOTTOMLEFT', 594, 108)

	})

	crushFnc(pf.general, {
		-- General AFK Mode
		afk = false,
		afkChat = false,
		afkSpin = false,
		taintLog = false,
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
		chargeCooldown = true,
		useDrawSwipeOnCharges = true,
		flashAnimation = true,
		transparent = true,
		convertPages = false, -- just don't !
		bar1 = {
			enabled = true,
			backdrop = false,
			buttonSize = 42,
			buttons = 12,
			buttonsPerRow = 12,
		},
		bar2 = {
			enabled = true,
			backdrop = false,
			buttonSize = 42,
			buttons = 12,
			buttonsPerRow = 12,
		},
		bar3 = {
			enabled = true,
			backdrop = false,
			buttonsPerRow = 6,
			buttonSize = 36,
			buttons = 12
		},
		bar4 = {
			enabled = true,
			backdrop = false,
			buttonsPerRow = 6,
			buttonSize = 36,
			buttons = 12
		},
		bar5 = {
			enabled = false,
		},
		bar6 = {
			enabled = true,
			backdrop = false,
			buttonSpacing = 2,
			buttonsPerRow = 1,
			buttonSize = 40,
			buttons = 12
		},
		bar7 = {
			enabled = false,
			buttonSize = 36,
		},
		bar8 = {
			enabled = false,
			buttonSize = 36
		},
		bar9 = {
			enabled = false,
			buttonSize = 36
		},
		bar10 = {
			enabled = false,
			buttonSize = 36
		},
		bar11 = {
			enabled = false,
			buttonSize = 36
		},
		bar12 = {
			enabled = false,
			buttonSize = 36
		},
		bar13 = {
			enabled = false,
			buttonSize = 36
		},
		bar14 = {
			enabled = false,
			buttonSize = 36
		},
		bar15 = {
			enabled = false,
			buttonSize = 36
		},
		barPet = {
			enabled         = true,
			backdrop        = false,
			buttonsPerRow   = ACTION_SLOTS,
			buttons         = ACTION_SLOTS,
			buttonSize      = 32,
			buttonHeight    = 32,
			buttonSpacing   = 2,
			backdropSpacing = 2,
			visibility      = '[petbattle] hide; [novehicleui,pet,nooverridebar,nopossessbar] show; hide',
		},
		stanceBar = {
			enabled = true,
			style = 'darkenInactive',
			mouseover = false,
			clickThrough = false,
			buttonsPerRow = STANCE_SLOTS,
			buttons = STANCE_SLOTS,
			point = 'TOPLEFT',
			backdrop = false,
			heightMult = 1,
			widthMult = 1,
			keepSizeRatio = true,
			buttonSize = 32,
			buttonHeight = 32,
			buttonSpacing = 2,
			backdropSpacing = 2,
			inheritGlobalFade = false,
			visibility = '[vehicleui][petbattle] hide; show'
		},
		totemBar = {
			enable = true,
			spacing = 4,
			keepSizeRatio = true,
			buttonSize = 32,
			buttonHeight = 32,
			flyoutDirection = 'UP',
			flyoutSize = 28,
			flyoutHeight = 28,
			flyoutSpacing = 2,
			font = 'PT Sans Narrow',
			fontOutline = 'OUTLINE',
			fontSize = 12,
			mouseover = false,
			visibility = '[vehicleui] hide;show',
		},
		microbar = {
			enabled = true,
			mouseover = false,
			useIcons = false,
			backdrop = true,
			buttonsPerRow = 12,
			buttonSize = 20,
			buttonHeight = 24,
			buttonSpacing = 2,
			keepSizeRatio = false,
			backdropSpacing = 2,
			heightMult = 1,
			widthMult = 1,
			visibility = '[petbattle] hide; show',
		}
	})

	for i = 1, 15 do
		if i ~= 11 and i ~= 12 then
			local barN = 'bar' .. i
			pf.actionbar[barN].visibility = '[vehicleui][petbattle][overridebar] hide; show'
		end
	end

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
	pf.convertPages = true -- don't you dare fuck the action bars up again

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

	local BAG_ADDONS = { "Bagnon", "BetterBags", "Baggins", "Sorted", "Inventorian", "Baganator", "ArkInventory", "OneBag3",
		"Combuctor" }

	for _, addon in ipairs(BAG_ADDONS) do
		if F.IsAddOnEnabled(addon) then isBagsEnabled = false end
	end

	F.Table.Crush(E.private, {

		general = {
			raidUtility = false,
			totemTracker = false,
			lootRoll = true,
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
			enable = false,
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
