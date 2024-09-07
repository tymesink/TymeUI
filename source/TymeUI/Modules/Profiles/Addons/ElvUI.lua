local TYMEUI, F, I, E = unpack(TymeUI)
local PF = TYMEUI:GetModule("Profiles")
local module = TYMEUI:NewModule("ElvUIProfile", "AceHook-3.0")

module.Enabled = true
module.Initialized = false
module.ReloadUI = false
module.Name = 'ElvUI'

local profileDb = E.db

local _G = _G
local next, ipairs = next, ipairs
local FCF_DockFrame, FCF_UnDockFrame = FCF_DockFrame, FCF_UnDockFrame
local FCF_GetChatWindowInfo = FCF_GetChatWindowInfo
local FCF_SetChatWindowFontSize = FCF_SetChatWindowFontSize
local loot = LOOT:match "^.?[\128-\191]*"
local trade = TRADE:match "^.?[\128-\191]*"

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
	
	for _, databar in next, { "experience", "reputation", "honor", "threat", "azerite", "petExperience" } do
		pf.databars[databar] = {
		  enable = false,
		}
	end

	F.Table.Crush(pf.general, {
		loginmessage = false,
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
		talkingHeadFrameBackdrop = false,
		questRewardMostValueIcon = false,
		minimap = {
			clusterBackdrop = false,
			clusterDisable = false,
		},
		lootRoll = {
			qualityStatusBarBackdrop = false,
			qualityStatusBar = false,
		},

		-- General Colors
		--backdropcolor = F.Table.HexToRGB("#1a1a1a"),
		--backdropfadecolor = F.Table.HexToRGB("#292929CC"),
		--bordercolor = F.Table.HexToRGB("#000000"),
		backdropfadecolor = {
			["a"] = 0.69,
			["r"] = 0.13,
			["g"] = 0.13,
			["b"] = 0.13,
		},

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

	F.Table.Crush(pf.chat, {
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

	-- Disable UnitFrames InfoPanel
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

	-- Disable UnitFrames
	for _, unit in next,
	{
		"player",
		"target",
		"targettarget",
		"focus",
		"pet",
	}
	do
		pf.unitframe.units[unit] = {
			enable = false
		}
	end

	--pf.unitframe.cooldown.override = false;

	F.Table.Crush(pf.actionbar, {
		["bar1"] = {
		  ["enabled"] = false
		},
		["bar3"] = {
		  ["enabled"] = false
		},
		["bar4"] = {
		  ["enabled"] = false
		},
		["bar5"] = {
		  ["buttons"] = 12,
		  ["buttonsPerRow"] = 12,
		  ["enabled"] = false
		},
		["bar6"] = {
		  ["buttons"] = 6,
		  ["buttonsPerRow"] = 6
		},
		["barPet"] = {
		  ["enabled"] = false
		},
		["cooldown"] = {
		  ["override"] = false
		},
		["extraActionButton"] = {
		  ["hotkeytext"] = false
		},
		["microbar"] = {
		  ["buttons"] = 11
		},
		["stanceBar"] = {
		  ["enabled"] = false
		}
	})

	F.Table.Crush(pf.movers, {
		["AddonCompartmentMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,0,-44",
		["PowerBarContainerMover"] = "BOTTOM,UIParent,BOTTOM,0,342",
		["QueueStatusMover"] = "BOTTOM,UIParent,BOTTOM,0,87",
		["VOICECHAT"] = "TOPLEFT,UIParent,TOPLEFT,253,-82",
		["RightChatMover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,0,0",
		["ElvUIBagMover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-274,254",
		["LeftChatMover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,0,0",
		["BNETMover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,0,204",
	})

	F.Table.Crush(pf.cooldown, {
		["enable"] = false,
		["targetAura"] = false,
	})

	F.Table.Crush(pf.datatexts, {
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

	F.Table.Crush(pf.bags, {
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
			enable = false,
			showBackdrop = false,
		},
		spinner = {
			enable = false,
		},
	})

	pf.gridSize = 76
	pf.convertPages = true

	-- Merge Tables
	F.Table.Crush(E.db, pf)
end

local SetupProfilePrivate = function()
	local isBagsEnabled = true
	local BAG_ADDONS = { "Bagnon", "BetterBags", "Baggins", "Sorted", "Inventorian", "Baganator", "ArkInventory", "OneBag3", "Combuctor" }

	for _, addon in ipairs(BAG_ADDONS) do
		if F.IsAddOnEnabled(addon) then isBagsEnabled = false end
	end

	F.Table.Crush(E.private, {
		theme = "classic",
		general = {
			raidUtility = false,
			totemTracker = false,
			loot = false,
			lootRoll = false,
			queueStatus = true,
			worldMap = false,
			minimap = {
				enable = false
			},
		},
		bags = {
			enable = false
		},
		auras = {
			enable = false,
			disableBlizzard = false,
			buffsHeader = false,
			debuffsHeader = false
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
		nameplates = {
			enable = false,
		},
		actionbar = {
			enable = false
		},
		tooltip = {
			enable = false,
		},
		chat = {
			enable = true,
		},
		skins = {
			ace3Enable = true,
			libDropdown = true,
			checkBoxSkin = true,
			parchmentRemoverEnable = false,
			blizzard = {
				enable = true,
				eventLog = false,
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
	})
end

local SetuProfileGlobal = function()
	F.Table.Crush(E.global, {
		general = {
			ultrawide = false,
			UIScale = 0.64,
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
	if PF:ElvUIInstallComplete() == true then 
		SetupProfile()
		SetupProfilePrivate()
		SetuProfileGlobal()
		SetupChat()
		return true
	else
		return false
	end
end

function module:Initialize()
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
