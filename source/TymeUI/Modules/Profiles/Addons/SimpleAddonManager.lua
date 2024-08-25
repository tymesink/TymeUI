local TYMEUI, F, I, E = unpack(TymeUI)
local Profiles = TYMEUI:GetModule("Profiles")
local module = TYMEUI:NewModule("SimpleAddonManagerProfile", "AceHook-3.0")
local profileAddonName = 'SimpleAddonManager'
local profileDb = SimpleAddonManagerDB
module.Enabled = true;
module.Initialized = false;

local crushFnc = TYMEUI.DevRelease and F.Table.CrushDebug or F.Table.Crush
local default = {
    categories = {},
    config = {
        hideIcons = false,
        localizeCategoryName = true,
        searchBy = {
            author = false,
            name = true,
            title = true,
        },
        showVersions = false,
        minimap = {
            hide = true,
        },
        hookMenuButton = true,
        sorting = "smart",
        showSecureAddons = false,
        addonListStyle = "list",
        showMemoryInBrokerTtp = true,
        memoryUpdate = 0,
    },
    autoProfile = {},
    collapsedAddons = {},
    sets = {
        ["Default-Addons"] = {
            subSets = {},
            addonsCount = 36,
            addons = {
                ["Ara_Broker_Reputations"] = true,
                ["Auctionator"] = true,
                ["BagBrother"] = true,
                ["Bagnon"] = true,
                ["Bagnon_Config"] = true,
                ["Bagnon_GuildBank"] = true,
                ["Bagnon_Masque"] = true,
                ["Bagnon_VoidStorage"] = true,
                ["BetterFishing"] = true,
                ["BetterWardrobe"] = true,
                ["BetterWardrobe_SourceData"] = true,
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
                ["Masque"] = true,
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
                ["TinyPad"] = true,
                ["TomTom"] = true,
                ["TradeSkillMaster"] = true,
                ["TradeSkillMaster_AppHelper"] = true,
                ["TymeUI"] = true,
                ["TymeUI_GuildFriends"] = true,
                ["WIM"] = true,
                ["ZygorGuidesViewer"] = true,                
            },
        },
    }
}

function module:LoadProfile()
    crushFnc(profileDb, default) -- Merge Tables
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