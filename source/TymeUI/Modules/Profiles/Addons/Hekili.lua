local TYMEUI, F, I, E = unpack(TymeUI)
local Profiles = TYMEUI:GetModule("Profiles")
local module = TYMEUI:NewModule("HekiliProfile", "AceHook-3.0")
local profileAddonName = 'Hekili'
local profileDb = HekiliDB
local crushFnc = TYMEUI.DevRelease and F.Table.CrushDebug or F.Table.Crush

module.Enabled = true;
module.Initialized = false;

local default = {
    displays = {
        ["Interrupts"] = {
            ["primaryWidth"] = 36,
            ["rel"] = "CENTER",
            ["queue"] = {
                ["direction"] = "LEFT",
                ["width"] = 30,
                ["anchor"] = "LEFT",
            },
            ["y"] = -429.998291015625,
            ["x"] = -277.4994812011719,
            ["primaryHeight"] = 36,
        },
        ["Cooldowns"] = {
            ["primaryWidth"] = 36,
            ["rel"] = "CENTER",
            ["elvuiCooldown"] = true,
            ["queue"] = {
                ["direction"] = "LEFT",
                ["width"] = 30,
                ["anchor"] = "LEFT",
            },
            ["y"] = -409.1660766601563,
            ["x"] = -317.4996032714844,
            ["primaryHeight"] = 36,
        },
        ["Primary"] = {
            ["elvuiCooldown"] = true,
            ["primaryWidth"] = 42,
            ["rel"] = "CENTER",
            ["queue"] = {
                ["direction"] = "LEFT",
                ["width"] = 36,
                ["elvuiCooldown"] = true,
                ["anchor"] = "LEFT",
                ["height"] = 36,
            },
            ["y"] = -343.3323059082031,
            ["x"] = -194.9996185302734,
            ["primaryHeight"] = 42,
        },
        ["AOE"] = {
            ["primaryWidth"] = 40,
            ["rel"] = "CENTER",
            ["queue"] = {
                ["direction"] = "LEFT",
                ["width"] = 36,
                ["elvuiCooldown"] = true,
                ["anchor"] = "LEFT",
                ["height"] = 36,
            },
            ["y"] = -299.166015625,
            ["x"] = -195.8328247070313,
            ["primaryHeight"] = 42,
        },
        ["Defensives"] = {
            ["primaryWidth"] = 36,
            ["rel"] = "CENTER",
            ["queue"] = {
                ["direction"] = "LEFT",
                ["width"] = 30,
                ["anchor"] = "LEFT",
            },
            ["y"] = -388.3323059082031,
            ["x"] = -278.3330688476563,
            ["primaryHeight"] = 36,
        },
    },
    minimapIcon = true,
    runOnce = {},
    specs = {},
    packs = {}
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