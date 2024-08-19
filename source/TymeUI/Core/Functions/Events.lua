local TYMEUI, F, E, I, V, P, G = unpack((select(2, ...)))

local CreateFrame = CreateFrame
local InCombatLockdown = InCombatLockdown
local IsAddOnLoaded = (C_AddOns and C_AddOns.IsAddOnLoaded) or IsAddOnLoaded
local next = next
local pairs = pairs
local rawset = rawset
local securecallfunction = securecallfunction
local secureexecuterange = secureexecuterange
local select = select
local type = type
local unpack = unpack
local C_Timer_After = C_Timer.After

F.Event = {}


