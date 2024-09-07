local TYMEUI, F, I, E = unpack(TymeUI)
local PF = TYMEUI:GetModule("Profiles")
local module = TYMEUI:NewModule("HekiliProfile", "AceHook-3.0")

module.Enabled = true
module.Initialized = false
module.ReloadUI = false
module.Name = 'Hekili'

local profileDb = HekiliDB

local profileDbDefault = {
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
    if defaultProfile then
        F.Table.Crush(defaultProfile, profileDbDefault) -- Merge Tables
        return true
    else
        TYMEUI:PrintMessage('Default profile not found in '..module.Name);
        return false
    end
   
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
    end
end

PF:RegisterProfile(module)