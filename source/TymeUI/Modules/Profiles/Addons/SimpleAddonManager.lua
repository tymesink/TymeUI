local TYMEUI, F, I, E = unpack(TymeUI)
local PF = TYMEUI:GetModule("Profiles")
local module = TYMEUI:NewModule("SimpleAddonManagerProfile", "AceHook-3.0")

module.Enabled = true
module.Initialized = false
module.ReloadUI = false
module.Name = 'SimpleAddonManager'

local profileDb = SimpleAddonManagerDB

local addonsToEnable = {
    ["DBM-TimelessIsle"] = true,
    ["Ara_Broker_Reputations"] = true,
    ["DBM-Scenario-MoP"] = true,
    ["BagBrother"] = true,
    ["Bagnon_Config"] = true,
    ["DBM-Raids-BfA"] = true,
    ["DBM-BrokenIsles"] = true,
    ["DragonRider"] = true,
    ["DBM-Raids-WoD"] = true,
    ["TinyPad"] = true,
    ["DBM-Party-Dragonflight"] = true,
    ["InFlight_Load"] = true,
    ["DBM-Party-WotLK"] = true,
    ["ElvUI_Options"] = true,
    ["DBM-VPVEM"] = true,
    ["LibSharedMedia-3.0"] = true,
    ["DBM-Brawlers"] = true,
    ["Narcissus"] = true,
    ["DBM-Raids-WarWithin"] = true,
    ["DBM-Party-WarWithin"] = true,
    ["DBM-Raids-WoTLK"] = true,
    ["DBM-Party-BfA"] = true,
    ["SavedInstances"] = true,
    ["LinkWrangler"] = true,
    ["DBM-Party-Vanilla"] = true,
    ["Bagnon_Masque"] = true,
    ["DBM-GUI"] = true,
    ["ElvUI"] = true,
    ["Auctionator"] = true,
    ["DBM-Raids-Cata"] = true,
    ["Broker_PlayedTime"] = true,
    ["DBM-WorldEvents"] = true,
    ["Masque"] = true,
    ["Bagnon"] = true,
    ["DBM-BfA"] = true,
    ["DBM-Party-BC"] = true,
    ["DBM-Raids-Legion"] = true,
    ["Bagnon_VoidStorage"] = true,
    ["BetterWardrobe_SourceData"] = true,
    ["DBM-SoundEventsPack"] = true,
    ["DBM-Raids-Dragonflight"] = true,
    ["WIM"] = true,
    ["ChocolateBar"] = true,
    ["DBM-StatusBarTimers"] = true,
    ["DBM-Draenor"] = true,
    ["DBM-Cataclysm"] = true,
    ["Details"] = true,
    ["DBM-DragonIsles"] = true,
    ["DBM-Legion"] = true,
    ["Narcissus_Achievements"] = true,
    ["DBM-CountPack-Overwatch"] = true,
    ["DBM-KhazAlgar"] = true,
    ["InFlight"] = true,
    ["DBM-Party-MoP"] = true,
    ["SharedMedia"] = true,
    ["BetterWardrobe"] = true,
    ["DBM-Challenges"] = true,
    ["DBM-Test"] = true,
    ["DBM-Party-WoD"] = true,
    ["BetterFishing"] = true,
    ["TradeSkillMaster_AppHelper"] = true,
    ["BlizzMove"] = true,
    ["OPie"] = true,
    ["DBM-Affixes"] = true,
    ["DBM-Party-Legion"] = true,
    ["DBM-Test-WarWithin"] = true,
    ["DBM-Core"] = true,
    ["DBM-Raids-BrokenIsles"] = true,
    ["DBM-Delves-WarWithin"] = true,
    ["Quester"] = true,
    ["ElvUI_Libraries"] = true,
    ["MountJournalEnhanced"] = true,
    ["DBM-Party-Shadowlands"] = true,
    ["ZygorGuidesViewer"] = true,
    ["DBM-Raids-MoP"] = true,
    ["LibButtonGlow-1.0"] = true,
    ["Krowi_AchievementFilter"] = true,
    ["TymeUI_GuildFriends"] = true,
    ["DBM-PvP"] = true,
    ["TradeSkillMaster"] = true,
    ["Postal"] = true,
    ["SimpleAddonManager"] = true,
    ["Bagnon_GuildBank"] = true,
    ["Syndicator"] = true,
    ["TomTom"] = true,
    ["DBM-Raids-Vanilla"] = true,
    ["Rematch"] = true,
    ["TymeUI"] = true,
    ["DBM-Party-Cataclysm"] = true,
    ["EditModeExpanded"] = true,              
}

local countKeys = function(table)
    local count = 0
    for _ in pairs(table) do
        count = count + 1
    end
    return count
end

function module:LoadProfile()

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
            TYMEUI:PrintMessage(module.Name..' => Profile Loaded')
            -- We are done, hooray!
			self.Initialized = true
        end
    else
        TYMEUI:PrintMessage(module.Name..' => Can not load profile')
    end
end

PF:RegisterProfile(module)