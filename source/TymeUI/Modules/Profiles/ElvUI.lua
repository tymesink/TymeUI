local TYMEUI, F, I, E = unpack(TymeUI)
local PF = TYMEUI:GetModule("Profiles")

local _G = _G
local FCF_SetLocked = FCF_SetLocked
local FCF_DockFrame, FCF_UnDockFrame = FCF_DockFrame, FCF_UnDockFrame
local FCF_SavePositionAndDimensions = FCF_SavePositionAndDimensions
local FCF_GetChatWindowInfo = FCF_GetChatWindowInfo
local FCF_StopDragging = FCF_StopDragging
local FCF_SetChatWindowFontSize = FCF_SetChatWindowFontSize
local LeftChatToggleButton = _G.LeftChatToggleButton
local loot = LOOT:match"^.?[\128-\191]*"
local trade = TRADE:match"^.?[\128-\191]*"
local ElvUIVersion = tonumber(E.version)

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

  -- Setup DataBars Tables & Disable DataBars
  local databars = { "experience", "reputation", "azerite", "petExperience" }
  for _, databar in next, databars do
    pf.databars[databar] = {
      enable = false,
    }
  end
  pf.databars.threat = {
    width = 500
  }

  -- Setup DataText Panels Tables & Disable Panels
  pf.datatexts.panels = {
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
    },
  }

  -- Movers
  crushFnc(pf.movers, {
    -- F.Position(1, 2, 3)
    -- 1 => Anchor position of SELECTED FRAME
    -- 2 => Anchor Parent
    -- 3 => Anchor position of PARENT FRAME

    AddonCompartmentMover = F.Position("TOPRIGHT", "ElvUIParent", "TOPRIGHT", -213,-26),
    BNETMover = F.Position("BOTTOMLEFT", "UIParent", "BOTTOMLEFT", 0, 310),
    VOICECHAT = F.Position("TOPLEFT", "UIParent", "TOPLEFT", 261, -32),
    HonorBarMover = F.Position("BOTTOMLEFT", "UIParent", "BOTTOMLEFT", 619, 7),
    LeftChatMover = F.Position("BOTTOMLEFT", "ElvUIParent", "BOTTOMLEFT", 0, 4),
    GMMover = F.Position("BOTTOMLEFT", "ElvUIParent", "BOTTOMLEFT", 0, 374),
    AlertFrameMover = F.Position("TOPLEFT", "UIParent", "TOPLEFT", 493, -226),
    PowerBarContainerMover = F.Position("BOTTOM", "UIParent", "BOTTOM", 9, 337),
    PrivateAurasMover = F.Position("TOPRIGHT", "UIParent", "TOPRIGHT", -281, -278),
    ElvUIBagMover = F.Position("BOTTOMRIGHT", "UIParent", "BOTTOMRIGHT", -301, 262),
    AltPowerBarMover = F.Position("TOP", "UIParent", "TOP", 1, -50),
    ThreatBarMover = F.Position("BOTTOM", "UIParent", "BOTTOM", -2, 57),
    RightChatMover = F.Position("BOTTOMRIGHT", "ElvUIParent", "BOTTOMRIGHT", 0, 4),
    LootFrameMover = F.Position("TOPLEFT", "UIParent", "TOPLEFT", 424,-557),
    QueueStatusMover = F.Position("BOTTOM", "UIParent", "BOTTOM", -2, 101),
  })

  -- General
  crushFnc(pf.general, {
    -- General AFK Mode
    afk = false,
    afkChat = false,
	  afkSpin = false,
    taintLog = true,
    interruptAnnounce = 'NONE',
	  autoRepair = 'NONE',
    autoTrackReputation = false,
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


  -- Bags
  crushFnc(pf.chat, {
    panelSnapLeftID = 1,
    tabSelector = "BOX",
    panelWidth = 500,
    panelHeight = 230,
    panelColor = {
      r = 0,
      g = 0.2274509966373444,
      b = 0.2000000178813934,
      a = 0.3190101981163025,
    },
  })


  -- Bags
  crushFnc(pf.bags, {
    -- Bags Options
    useBlizzardCleanup = false,
    clearSearchOnClose = true,
    junkIcon = true,
    moneyCoins = false,
    scrapIcon = true,
    showBindType = true,
    vendorGrays = {
      enable = false,
    },

    -- Sort Spinner
    spinner = {
      enable = true,
    },
  })

  -- ! IMPORTANT ! --
  pf.dbConverted = E.version
  pf.actionbar.convertPages = false -- just don't !
  pf.convertPages = true -- don't you dare fuck the action bars up again
  pf.general.taintLog = true
  -- ! --
  
  -- Use Debug output in development mode
  

  -- Merge Tables
  crushFnc(E.db, pf)

  -- Set Globals
  crushFnc(E.global, {
    uiScaleInformed = true,

    general = {
      commandBarSetting = "DISABLED",
      UIScale = F.PixelPerfect(),
    },
  })
end

local SetupProfilePrivate = function()
  local isBagsEnabled = true

  local BAG_ADDONS = { "Bagnon", "BetterBags", "Baggins", "Sorted", "Inventorian", "Baganator", "ArkInventory", "OneBag3", "Combuctor" }

  for _, addon in ipairs(BAG_ADDONS) do
    if F.IsAddOnEnabled(addon) then isBagsEnabled = false end
  end

  F.Table.Crush(E.private, {
    
    install_complete = ElvUIVersion,

    general = {
      raidUtility = false,
      totemTracker = false,
      lootRoll = false,
      queueStatus = true,
      worldMap = true,
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
      enable = false,
      hideCooldownBling = false,
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

    -- Skins
    skins = {
      ace3Enable = true,
	    libDropdown = true,
	    checkBoxSkin = true,
      parchmentRemoverEnable = false,
      blizzard = {
        enable = true,
        eventLog = true,
        misc = false,
        blizzardOptions = false,
        petbattleui = false,
        binding = false,
        loot = false,
        covenantPreview = false,
        inspect = false,
        debug = true,
        lfg = false,
        tooltip = false,
        bmah = false,
        worldmap = true,
        questTimers = false,
        tutorials = false,
        addonManager = false,
        trade = false,
        genericTrait = false,
        timemanager = false,
        engraving = false,
        gossip = false,
        deathRecap = false,
        bags = false,
        guildcontrol = false,
        covenantRenown = false,
        guild = false,
        artifact = false,
        tradeskill = false,
        garrison = false,
        playerChoice = false,
        transmogrify = false,
        gbank = false,
        expansionLanding = false,
        craft = false,
        achievement = false,
        contribution = false,
        archaeology = false,
        adventureMap = false,
        mail = false,
        bgscore = false,
        stable = false,
        questChoice = false,
        guildBank = false,
        collections = false,
        orderhall = false,
        tabard = false,
        islandQueue = false,
        itemUpgrade = false,
        weeklyRewards = false,
        friends = false,
        islandsPartyPose = false,
        talkinghead = false,
        nonraid = false,
        azerite = false,
        guide = false,
        lfguild = false,
        gmChat = false,
        azeriteRespec = false,
        merchant = false,
        raid = false,
        chromieTime = false,
        losscontrol = false,
        taxi = false,
        reforge = false,
        objectiveTracker = false,
        spellbook = false,
        runeforge = false,
        arenaRegistrar = false,
        barber = false,
        majorFactions = false,
        covenantSanctum = false,
        guildregistrar = false,
        communities = false,
        azeriteEssence = false,
        mirrorTimers = false,
        battlefield = false,
        animaDiversion = false,
        channels = false,
        pvp = false,
        alliedRaces = false,
        help = false,
        auctionhouse = false,
        petition = false,
        greeting = false,
        obliterum = false,
        dressingroom = false,
        scrapping = false,
        quest = false,
        socket = false,
        macro = false,
        soulbinds = false,
        character = false,
        subscriptionInterstitial = false,
        itemInteraction = false,
        encounterjournal = false,
        alertframes = false,
        editor = false,
        perks = false,
        arena = false,
        torghastLevelPicker = false,
        trainer = false,
        talent = false,
        bgmap = false,
        voidstorage = false,
        calendar = false,
      }
    },
  })
end

local SetuProfileGlobal = function()
  F.Table.Crush(E.global, {
    -- General
    general = {
      ultrawide = false,
      UIScale = 0.6,
      WorldMapCoordinates = {
        position = "BOTTOMRIGHT",
      },

      AceGUI = {
        width = 1440,
        height = 810,
      },
    },
  })
end

local function SetupChat()
	for _, name in ipairs(_G.CHAT_FRAMES) do
		local frame = _G[name]
		local id = frame:GetID()
		local chatName = FCF_GetChatWindowInfo(id)

		FCF_SetChatWindowFontSize(nil, frame, 14)

		-- move ElvUI default loot frame to the left chat, so that Recount/Skada can go to the right chat.
		if id == 4 and (chatName == (LOOT..' / '..TRADE) or chatName == (loot..' / '..trade)) then
			FCF_UnDockFrame(frame)
			frame:ClearAllPoints()
			frame:Point('BOTTOMLEFT', LeftChatToggleButton, 'TOPLEFT', 1, 3)
			FCF_SetWindowName(frame, 'Loot')
			FCF_DockFrame(frame)
			FCF_SetLocked(frame, 1)
			frame:Show()
		end
		if frame:GetLeft() then
			FCF_SavePositionAndDimensions(frame)
			FCF_StopDragging(frame)
		end
	end
end

function PF:LoadElvUIProfile()
  F.Chat('chat', 'Load ElvUI Profile');

  E:SetupCVars(true)
  E:SetupChat(true)
  SetupProfile()
  SetupProfilePrivate()
  SetuProfileGlobal()
  SetupChat()
  E:UpdateDB()
end