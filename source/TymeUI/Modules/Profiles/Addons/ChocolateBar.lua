local TYMEUI, F, I, E = unpack(TymeUI)
local Profiles = TYMEUI:GetModule("Profiles")
local module = TYMEUI:NewModule("ChocolateBarProfile", "AceHook-3.0")
local profileAddonName = 'ChocolateBar'
local profileDb = ChocolateBarDB
module.Enabled = true;
module.Initialized = false;
local crushFnc = TYMEUI.DevRelease and F.Table.CrushDebug or F.Table.Crush

local default = {
    ["fixedStrata"] = true,
    ["objSettings"] = {
        ["|cffffb366Ara|r Reputations"] = {
            ["index"] = 4,
            ["isNew"] = false,
            ["barName"] = "ChocolateBar1",
        },
        ["ClickCastHelper"] = {
            ["index"] = 1,
            ["align"] = "right",
            ["isNew"] = false,
            ["showText"] = false,
            ["barName"] = "ChocolateBar1",
        },
        ["WIM"] = {
            ["index"] = 5,
            ["isNew"] = false,
            ["barName"] = "ChocolateBar1",
        },
        ["Narcissus"] = {
            ["index"] = 9,
            ["align"] = "right",
            ["isNew"] = false,
            ["showText"] = false,
            ["barName"] = "ChocolateBar1",
        },
        ["|cFFFFB366Tyme|r-Fps"] = {
            ["index"] = 2,
            ["align"] = "center",
            ["isNew"] = false,
            ["barName"] = "ChocolateBar1",
        },
        ["SavedInstances"] = {
            ["index"] = 7,
            ["align"] = "right",
            ["isNew"] = false,
            ["showText"] = false,
            ["barName"] = "ChocolateBar1",
        },
        ["Time Played"] = {
            ["index"] = 3,
            ["isNew"] = false,
            ["barName"] = "ChocolateBar1",
        },
        ["Details"] = {
            ["index"] = 12,
            ["align"] = "right",
            ["isNew"] = false,
            ["barName"] = "ChocolateBar1",
        },
        ["TradeSkillMaster"] = {
            ["index"] = 8,
            ["align"] = "right",
            ["isNew"] = false,
            ["showText"] = false,
            ["barName"] = "ChocolateBar1",
        },
        ["Masque"] = {
            ["index"] = 10,
            ["align"] = "right",
            ["isNew"] = false,
            ["showText"] = false,
            ["barName"] = "ChocolateBar1",
        },
        ["SimpleAddonManager"] = {
            ["index"] = 6,
            ["align"] = "right",
            ["isNew"] = false,
            ["showText"] = false,
            ["barName"] = "ChocolateBar1",
        },
        ["|cFFFFB366Tyme|r-Latency"] = {
            ["index"] = 1,
            ["align"] = "center",
            ["isNew"] = false,
            ["barName"] = "ChocolateBar1",
        },
        ["DBM"] = {
            ["index"] = 11,
            ["align"] = "right",
            ["isNew"] = false,
            ["showText"] = false,
            ["barName"] = "ChocolateBar1",
        },
        ["|cFFFFB366TymeUI|r-Friends"] = {
            ["index"] = 2,
            ["isNew"] = false,
            ["barName"] = "ChocolateBar1",
        },
        ["TinyPad"] = {
            ["index"] = 2,
            ["align"] = "right",
            ["isNew"] = false,
            ["showText"] = false,
            ["barName"] = "ChocolateBar1",
        },
        ["Krowi_AchievementFilterLDB"] = {
            ["index"] = 4,
            ["align"] = "right",
            ["isNew"] = false,
            ["showText"] = false,
            ["barName"] = "ChocolateBar1",
        },
        ["Rematch"] = {
            ["index"] = 3,
            ["align"] = "right",
            ["isNew"] = false,
            ["showText"] = false,
            ["barName"] = "ChocolateBar1",
        },
        ["BagnonLauncher"] = {
            ["index"] = 5,
            ["align"] = "right",
            ["isNew"] = false,
            ["showText"] = false,
            ["barName"] = "ChocolateBar1",
        },
        ["|cFFFFB366TymeUI|r-Guild"] = {
            ["index"] = 1,
            ["isNew"] = false,
            ["barName"] = "ChocolateBar1",
        },
    }
}

function module:LoadProfile()
    local defaultProfile = profileDb.profiles['Default']
    if not defaultProfile then
        F.Chat('chat', 'Default profile not found in ChocolateBarDB.')
        return
    end
    local defaultProfile = profileDb.profiles['Default'];
    crushFnc(defaultProfile, default) -- Merge Tables
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