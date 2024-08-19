local TYMEUI, F, E, I, V, P, G = unpack((select(2, ...)))
local PF = TYMEUI:GetModule("Profiles")

local next = next

function PF:BuildProfile()
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
  --local databars = { "experience", "reputation", "honor", "threat", "azerite", "petExperience" }
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
  --local panels = { "LeftChatDataPanel", "RightChatDataPanel", "MinimapPanel" }
  local panels = { "MinimapPanel" }
  for _, panel in next, panels do
    pf.datatexts.panels[panel] = {
      enable = false,
    }
  end

  -- Movers
  F.Table.Crush(
    pf.movers,
    {
      -- F.Position(1, 2, 3)
      -- 1 => Anchor position of SELECTED FRAME
      -- 2 => Anchor Parent
      -- 3 => Anchor position of PARENT FRAME

      AddonCompartmentMover = F.Position("TOPRIGHT", "UIParent", "TOPRIGHT", -212,-28),
      ThreatBarMover = F.Position("BOTTOM", "UIParent", "BOTTOM", -2, 44),
      VOICECHAT = F.Position("TOPLEFT", "UIParent", "TOPLEFT", 254, -18),
      LootFrameMover = F.Position("TOPLEFT", "UIParent", "TOPLEFT", 235, -558),
      HonorBarMover = F.Position("BOTTOMLEFT", "UIParent", "BOTTOMLEFT", 520, 5),
      AlertFrameMover = F.Position("TOPLEFT", "UIParent", "TOPLEFT", 508, -165),
      BNETMover = F.Position("BOTTOMLEFT", "UIParent", "BOTTOMLEFT", 0, 240),
    }
  )

  -- General
  F.Table.Crush(pf.general, {
    -- General AFK Mode
    afk = false,
    afkChat = false,
	  afkSpin = false,
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
      enable = false,
    },
  })


  -- Bags
  F.Table.Crush(pf.chat, {
    panelSnapLeftID = 1,
    panelSnapRightID = 4,
    tabSelector = "BOX",
    panelColor = {
      r = 0,
      g = 0.2274509966373444,
      b = 0.2000000178813934,
      a = 0.3190101981163025,
    },
  })


  -- Bags
  F.Table.Crush(pf.bags, {
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
  pf.general.taintLog = false
  -- ! --
  return pf
end

function PF:ElvUIProfilePrivate()
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
      queueStatus = false,
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
        enable = false,
        eventLog = false,
        misc = false,
        blizzardOptions = false,
        petbattleui = false,
        binding = false,
        loot = false,
        covenantPreview = false,
        inspect = false,
        debug = false,
        lfg = false,
        tooltip = false,
        bmah = false,
        worldmap = false,
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

function PF:ElvUIProfileGlobal()
  F.Table.Crush(E.global, {
    -- General
    general = {
      ultrawide = false,

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