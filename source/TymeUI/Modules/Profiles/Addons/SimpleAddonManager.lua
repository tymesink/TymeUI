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
    ["DragonRider"] = true,
    ["EditModeExpanded"] = true,
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

local function runProfileCommand()
    local chatMessage = "/sam profile Default-Addons ignore"
    local editbox = DEFAULT_CHAT_FRAME and ChatEdit_ChooseBoxForSend(DEFAULT_CHAT_FRAME)

    -- Chat frame globals aren't always ready this early, retry shortly.
    if not editbox or not ChatEdit_ActivateChat or (not ChatEdit_OnEnterPressed and not ChatEdit_SendText) then
        module.RetryCount = (module.RetryCount or 0) + 1
        if module.RetryCount <= 20 then
            C_Timer.After(0.5, runProfileCommand)
        else
            TYMEUI:PrintMessage(module.Name .. ' => Chat UI never became ready, could not run profile command')
        end
        return
    end
    module.RetryCount = nil

    ChatEdit_ActivateChat(editbox)
    editbox:SetText(chatMessage)
    if ChatEdit_SendText then
        ChatEdit_SendText(editbox, 0)
    else
        ChatEdit_OnEnterPressed(editbox)
    end

    module.Initialized = true
    PF:MarkModuleLoaded(module.Name, true)
    TYMEUI:PrintMessage(module.Name .. ' => Profile Loaded', I.Constants.ColorHex.brightblue)
    TYMEUI:StaticPopup_ReloadUI()
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

    -- SimpleAddonManager runs its own PLAYER_LOGIN init in the same event dispatch as ours,
    -- so running its slash command synchronously here can race ahead of that init and crash
    -- inside SAM itself. Defer so SAM's own PLAYER_LOGIN handler finishes first; completion
    -- (module.Initialized / reload prompt) is handled by runProfileCommand once it actually runs.
    C_Timer.After(2, runProfileCommand)
    return false
end

function module:Initialize()
     -- Don't init second time
     if self.Initialized then return end

    if PF:CanLoadProfileForAddon(module.Name, profileDb) then
        self:LoadProfile()
    else
        TYMEUI:PrintMessage(module.Name..' => Can not load profile')
    end
end

PF:RegisterProfile(module)