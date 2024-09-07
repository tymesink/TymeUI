local TYMEUI, F, I, E = unpack(TymeUI)
local PF = TYMEUI:GetModule("Profiles")
local module = TYMEUI:NewModule("SimpleAddonManagerProfile", "AceHook-3.0")

module.Enabled = true
module.Initialized = false
module.ReloadUI = false
module.Name = 'SimpleAddonManager'

local profileDb = SimpleAddonManagerDB

local addonsToEnable = {
    ["Ara_Broker_Reputations"] = true,
    ["Auctionator"] = true,
    ["BagBrother"] = true,
    ["Bagnon"] = true,
    ["Bagnon_Config"] = true,
    ["BlizzMove"] = true,
    ["Broker_PlayedTime"] = true,
    ["ChocolateBar"] = true,
    ["DBM-Affixes"] = true,
    ["DBM-BfA"] = true,
    ["DBM-Brawlers"] = true,
    ["DBM-BrokenIsles"] = true,
    ["DBM-Cataclysm"] = true,
    ["DBM-Challenges"] = true,
    ["DBM-Core"] = true,
    ["DBM-CountPack-Overwatch"] = true,
    ["DBM-Delves-WarWithin"] = true,
    ["DBM-Draenor"] = true,
    ["DBM-DragonIsles"] = true,
    ["DBM-GUI"] = true,
    ["DBM-KhazAlgar"] = true,
    ["DBM-Legion"] = true,
    ["DBM-Party-BC"] = true,
    ["DBM-Party-BfA"] = true,
    ["DBM-Party-Cataclysm"] = true,
    ["DBM-Party-Dragonflight"] = true,
    ["DBM-Party-Legion"] = true,
    ["DBM-Party-MoP"] = true,
    ["DBM-Party-Shadowlands"] = true,
    ["DBM-Party-Vanilla"] = true,
    ["DBM-Party-WarWithin"] = true,
    ["DBM-Party-WoD"] = true,
    ["DBM-Party-WotLK"] = true,
    ["DBM-PvP"] = true,
    ["DBM-Raids-BfA"] = true,
    ["DBM-Raids-BrokenIsles"] = true,
    ["DBM-Raids-Cata"] = true,
    ["DBM-Raids-Dragonflight"] = true,
    ["DBM-Raids-Legion"] = true,
    ["DBM-Raids-MoP"] = true,
    ["DBM-Raids-Vanilla"] = true,
    ["DBM-Raids-WarWithin"] = true,
    ["DBM-Raids-WoD"] = true,
    ["DBM-Raids-WoTLK"] = true,
    ["DBM-Scenario-MoP"] = true,
    ["DBM-SoundEventsPack"] = true,
    ["DBM-StatusBarTimers"] = true,
    ["DBM-Test"] = true,
    ["DBM-Test-WarWithin"] = true,
    ["DBM-TimelessIsle"] = true,
    ["DBM-VPVEM"] = true,
    ["DBM-WorldEvents"] = true,
    ["Details"] = true,
    ["DragonRider"] = true,
    ["EditModeExpanded"] = true,
    ["ElvUI"] = true,
    ["ElvUI_Libraries"] = true,
    ["ElvUI_Options"] = true,
    ["InFlight"] = true,
    ["InFlight_Load"] = true,
    ["Krowi_AchievementFilter"] = true,
    ["LibButtonGlow-1.0"] = true,
    ["LibSharedMedia-3.0"] = true,
    ["LinkWrangler"] = true,
    ["MountJournalEnhanced"] = true,
    ["Narcissus"] = true,
    ["Narcissus_Achievements"] = true,
    ["OPie"] = true,
    ["Postal"] = true,
    ["Quester"] = true,
    ["Rematch"] = true,
    ["SavedInstances"] = true,
    ["SharedMedia"] = true,
    ["SimpleAddonManager"] = true,
    ["Syndicator"] = true,
    ["TomTom"] = true,
    ["TinyPad"] = true,
    ["TymeUI"] = true,
    ["TymeUI_GuildFriends"] = true,
    ["WIM"] = true,
    ["ZygorGuidesViewer"] = true,
}

local countKeys = function(table)
    local count = 0
    for _ in pairs(table) do
        count = count + 1
    end
    return count
end

function module:LoadProfile()

    local profile = {}
    profile.config = {
        ["hideIcons"] = false,
        ["localizeCategoryName"] = true,
        ["searchBy"] = {
            ["author"] = false,
            ["name"] = true,
            ["title"] = true,
        },
        ["showVersions"] = false,
        ["minimap"] = {
            ["hide"] = true,
        },
        ["hookMenuButton"] = true,
        ["sorting"] = "smart",
        ["showSecureAddons"] = false,
        ["addonListStyle"] = "list",
        ["showMemoryInBrokerTtp"] = true,
        ["memoryUpdate"] = 0,
    }
    
    F.Table.Crush(profileDb.config, profile)

    if profileDb.set == nil then
        profileDb.set = {}
    end

    local setname = 'Default-Addons'
    profileDb.sets[setname] = {
        subSets = {},
        addonsCount = countKeys(addonsToEnable),
        addons = addonsToEnable,
    }

    local chatMessage = "/sam profile Default-Addons ignore"
    local editbox = ChatEdit_ChooseBoxForSend(DEFAULT_CHAT_FRAME)
    ChatEdit_ActivateChat(editbox)
    editbox:SetText(chatMessage)
    ChatEdit_OnEnterPressed(editbox)
    return true
end

function module:Initialize()
     -- Don't init second time
     if self.Initialized then return end

    if PF:CanLoadProfileForAddon(module.Name, profileDb) then
        local loaded = self:LoadProfile()
        if loaded then
            module.ReloadUI = true
            TYMEUI:PrintMessage(module.Name .. ' => Profile Loaded', I.Constants.ColorHex.brightblue)
            -- We are done, hooray!
			self.Initialized = true
        end
    else
        TYMEUI:PrintMessage(module.Name..' => Can not load profile')
    end
end

PF:RegisterProfile(module)