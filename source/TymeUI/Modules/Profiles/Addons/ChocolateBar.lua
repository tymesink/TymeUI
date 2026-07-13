local TYMEUI, F = unpack(TymeUI)
local PF = TYMEUI:GetModule("Profiles")

local profileDbDefault = {
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
        ["TinyPad"] = {
            ["index"] = 2,
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
        ["Rematch"] = {
            ["index"] = 3,
            ["align"] = "right",
            ["isNew"] = false,
            ["showText"] = false,
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
        ["Krowi_AchievementFilterLDB"] = {
            ["index"] = 4,
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
    },
}

PF:NewProfileModule('ChocolateBar', function() return ChocolateBarDB end, function(profileDb)
	local defaultProfile = profileDb.profiles['Default']
	if not defaultProfile then
		TYMEUI:PrintMessage('Default profile not found in ChocolateBarDB.')
		return false
	end

	F.Table.Crush(defaultProfile, profileDbDefault) -- Merge Tables
	return true
end)