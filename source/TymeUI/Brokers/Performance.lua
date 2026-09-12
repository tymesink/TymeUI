--[[
	Two LibDataBroker readouts:

		Tyme-Fps      framerate (and optionally latency), with a tooltip listing
		              per-addon memory use; clicking forces a garbage collection
		Tyme-Latency  home and world latency, with a bandwidth tooltip

	Both refresh on a timer rather than every frame.
]]

local ADDON, TymeUI = ...

-- Configuration ------------------------------------------------------------

-- Seconds between refreshes of the FPS readout and its tooltip. Going below 2
-- costs noticeable performance for no visible benefit.
local UPDATE_PERIOD = 2

-- The server only publishes new latency figures every 30 seconds, so polling it
-- faster just redraws the same numbers.
local LATENCY_PERIOD = 22

-- Addons using less than this many kb are collapsed into a single summary line.
local MEMORY_THRESHOLD = 50

-- Most addons to list in the memory tooltip. With alphabetical sorting this
-- cuts the list off partway through the alphabet; raise it if that matters.
local MAX_ADDONS_LISTED = 50

local SORT_ALPHABETICALLY = false -- false sorts by memory use, descending
local COLOR_ADDON_NAMES = false -- true tints addon names as well as their sizes
local SHOW_LATENCY_ON_FPS = true -- show ms alongside fps in the FPS readout

-- Locals -------------------------------------------------------------------

local C_AddOns = C_AddOns
local C_Timer = C_Timer
local GameTooltip = GameTooltip
local GetAddOnMemoryUsage = GetAddOnMemoryUsage
local GetFramerate = GetFramerate
local GetNetStats = GetNetStats
local UIParent = UIParent
local UpdateAddOnMemoryUsage = UpdateAddOnMemoryUsage
local collectgarbage = collectgarbage
local format = string.format
local ipairs = ipairs
local modf = math.modf
local select = select
local sort = table.sort
local wipe = wipe

local LDB = LibStub("LibDataBroker-1.1")

local previousMemory = collectgarbage("count")
local fpsTooltipOwner, latencyTooltipOwner

-- Helpers ------------------------------------------------------------------

--- Blends across three colours by percentage. (Originally by Tekkub.)
local function ColorGradient(perc, r1, g1, b1, r2, g2, b2, r3, g3, b3)
	if perc >= 1 then
		return r3, g3, b3
	elseif perc <= 0 then
		return r1, g1, b1
	end

	local segment, relperc = modf(perc * 2)
	if segment == 1 then
		r1, g1, b1, r2, g2, b2 = r2, g2, b2, r3, g3, b3
	end

	return r1 + (r2 - r1) * relperc, g1 + (g2 - g1) * relperc, b1 + (b2 - b1) * relperc
end

--- Formats a kb figure, promoting to mb past 1024. `colored` tints the unit.
local function FormatMemory(kb, colored)
	local unit, value = "kb", kb
	if kb > 1024 then
		unit, value = "mb", kb / 1024
	end

	if colored then
		return format(unit == "mb" and "%.2f |cffE8D200%s|r" or "%.1f |cffE8D200%s|r", value, unit)
	end

	return format(unit == "mb" and "%.2f %s" or "%.1f %s", value, unit)
end

--- Picks tooltip anchor points so it opens away from the nearest screen edge.
local function GetTipAnchor(frame)
	local x, y = frame:GetCenter()
	if not x or not y then return "TOPLEFT", "BOTTOMLEFT" end

	local horizontal = (x > UIParent:GetWidth() * 2 / 3 and "RIGHT")
		or (x < UIParent:GetWidth() / 3 and "LEFT")
		or ""
	local vertical = (y > UIParent:GetHeight() / 2) and "TOP" or "BOTTOM"

	return vertical .. horizontal, frame, (vertical == "TOP" and "BOTTOM" or "TOP") .. horizontal
end

local function OpenTooltip(owner)
	GameTooltip:SetOwner(owner, "ANCHOR_NONE")
	GameTooltip:SetPoint(GetTipAnchor(owner))
	GameTooltip:ClearLines()
end

-- Loaded addon list --------------------------------------------------------

local loadedAddOns = {}

--- Rebuilds the list of currently loaded addons.
-- Done on each mouseover rather than once at login: it costs a single pass over
-- ~100 addons only while the tooltip is opening, and in exchange the list needs
-- no event subscription to stay correct, picks up load-on-demand addons for
-- free, and cannot end up silently empty because one event was missed.
local function RefreshAddOnList()
	wipe(loadedAddOns)

	for i = 1, C_AddOns.GetNumAddOns() do
		if C_AddOns.IsAddOnLoaded(i) then
			-- Parenthesised so only the name (the first return) is inserted.
			loadedAddOns[#loadedAddOns + 1] = (C_AddOns.GetAddOnInfo(i))
		end
	end
end

-- Brokers ------------------------------------------------------------------

local fps = LDB:NewDataObject("|cFFFFB366Tyme|r-Fps", {
	type = "data source",
	text = "Initializing...fps",
	icon = TymeUI.mediaPath .. "fpsicon",
})

local latency = LDB:NewDataObject("|cFFFFB366Tyme|r-Latency", {
	type = "data source",
	text = "Initializing...ms",
	icon = TymeUI.mediaPath .. "msicon",
})

-- FPS readout --------------------------------------------------------------

local function UpdateFps()
	local framerate = GetFramerate()
	local r, g, b = ColorGradient(framerate / 75, 1, 0, 0, 1, 1, 0, 0, 1, 0)

	if SHOW_LATENCY_ON_FPS then
		local _, _, home, world = GetNetStats()
		local lr, lg, lb = ColorGradient(((home + world) / 2) / 1000, 0, 1, 0, 1, 1, 0, 1, 0, 0)
		fps.text = format(
			"|cff%02x%02x%02x%.0f|r |cffE8D200fps|r |cff%02x%02x%02x%.0f|r |cffE8D200ms|r",
			r * 255, g * 255, b * 255, framerate,
			lr * 255, lg * 255, lb * 255, world
		)
	else
		fps.text = format("|cff%02x%02x%02x%.0f|r |cffE8D200fps|r", r * 255, g * 255, b * 255, framerate)
	end
end

function fps.OnEnter(self)
	fpsTooltipOwner = self
	OpenTooltip(self)

	GameTooltip:AddLine("|cff0DEB11Performance|r")
	GameTooltip:AddLine(SHOW_LATENCY_ON_FPS and "[Memory/Latency]" or "[Memory]")
	GameTooltip:AddLine(format(
		"|cffc3771aDataBroker|r based addon to show your addon memory\nand fps updated every |cff06DDFA%s second(s)|r!\n",
		UPDATE_PERIOD
	))
	GameTooltip:AddDoubleLine(" ", " ")
	GameTooltip:AddDoubleLine("Addon name", format("Memory above (|cff06ddfa%s kb|r)", MEMORY_THRESHOLD))
	GameTooltip:AddDoubleLine("|cffffffff------------|r", "|cffffffff------------|r")

	-- Refresh the list and the figures before sorting on them, otherwise the
	-- ordering is one mouseover out of date.
	RefreshAddOnList()
	UpdateAddOnMemoryUsage()
	if SORT_ALPHABETICALLY then
		sort(loadedAddOns, function(a, b) return a:lower() < b:lower() end)
	else
		sort(loadedAddOns, function(a, b) return GetAddOnMemoryUsage(a) > GetAddOnMemoryUsage(b) end)
	end

	local listed, totalMemory, listedMemory = 0, 0, 0

	for _, name in ipairs(loadedAddOns) do
		local memory = GetAddOnMemoryUsage(name)
		totalMemory = totalMemory + memory

		if memory > MEMORY_THRESHOLD and listed < MAX_ADDONS_LISTED then
			listed = listed + 1
			listedMemory = listedMemory + memory

			local r, g, b = ColorGradient((memory - MEMORY_THRESHOLD) / 2000, 0, 1, 0, 1, 1, 0, 1, 0, 0)
			local title = select(2, C_AddOns.GetAddOnInfo(name))
			-- Single-digit entries get a leading space so the numbers line up.
			local label = format(listed < 10 and "  |cffDAB024%.0f)|r %s" or "|cffDAB024%.0f)|r %s", listed, title)

			if COLOR_ADDON_NAMES then
				GameTooltip:AddDoubleLine(label, FormatMemory(memory), r, g, b, r, g, b)
			else
				GameTooltip:AddDoubleLine(label, FormatMemory(memory), 1, 1, 1, r, g, b)
			end
		end
	end

	if totalMemory - listedMemory > 0 then
		GameTooltip:AddDoubleLine(format(
			"|cff06DDFA... [%d] hidden addons|r (usage less than %d kb)",
			#loadedAddOns - listed, MEMORY_THRESHOLD
		), " ")
	end

	local memory = collectgarbage("count")
	local churn = memory - previousMemory
	previousMemory = memory

	GameTooltip:AddDoubleLine(" ", "|cffffffff------------|r")
	GameTooltip:AddDoubleLine(" ", format("|cffC3771ATOTAL USER ADDON|r |cffffffffmemory usage:|r  |cff06ddfa%s|r", FormatMemory(totalMemory)))
	GameTooltip:AddDoubleLine(" ", format("|cffC3771ADefault Blizzard UI|r |cffffffffmemory usage:|r  |cff06ddfa%s|r", FormatMemory(memory - totalMemory)))
	GameTooltip:AddDoubleLine(" ", " ")

	if SHOW_LATENCY_ON_FPS then
		local _, _, home, world = GetNetStats()
		local hr, hg, hb = ColorGradient(home / 1000, 0, 1, 0, 1, 1, 0, 1, 0, 0)
		local wr, wg, wb = ColorGradient(world / 1000, 0, 1, 0, 1, 1, 0, 1, 0, 0)

		GameTooltip:AddDoubleLine(" ", format("|cff42AAFFHOME|r |cffFFFFFFRealm (latency)|r:  %.0f ms", home), nil, nil, nil, hr, hg, hb)
		GameTooltip:AddDoubleLine(" ", format("|cffDCFF42WORLD|r |cffFFFFFFServer (latency)|r:  %.0f ms", world), nil, nil, nil, wr, wg, wb)
		GameTooltip:AddDoubleLine(" ", " ")
	end

	local cr, cg, cb = ColorGradient(churn / 15, 0, 1, 0, 1, 1, 0, 1, 0, 0)
	GameTooltip:AddDoubleLine("|cffc3771aGarbage|r churn", format("%.2f kb/sec", churn), nil, nil, nil, cr, cg, cb)
	GameTooltip:AddLine("*Click to force |cffc3771agarbage|r collection and to |cff06ddfaupdate|r tooltip*")

	GameTooltip:Show()
end

function fps.OnLeave()
	fpsTooltipOwner = nil
	GameTooltip:SetClampedToScreen(true)
	GameTooltip:Hide()
end

function fps.OnClick(self)
	-- Redraw before collecting, so the tooltip reports the churn that built up
	-- since the last refresh rather than the drop this click is about to cause.
	fps.OnEnter(self)

	local before = collectgarbage("count")
	collectgarbage("collect")
	UpdateAddOnMemoryUsage()

	TymeUI:Print(format(
		"|cffC3771AGarbage|r collected: |cff06ddfa%s|r",
		FormatMemory(before - collectgarbage("count"), true)
	))
end

-- Latency readout ----------------------------------------------------------

local function UpdateLatency()
	local _, _, home, world = GetNetStats()
	local r, g, b = ColorGradient(((home + world) / 2) / 1000, 0, 1, 0, 1, 1, 0, 1, 0, 0)
	latency.text = format("|cff%02x%02x%02x%.0f/%.0f(w)|r |cffE8D200ms|r", r * 255, g * 255, b * 255, home, world)
end

function latency.OnEnter(self)
	latencyTooltipOwner = self
	OpenTooltip(self)

	GameTooltip:AddLine("|cff0DEB11Latency|r")
	GameTooltip:AddLine("[Bandwidth/Latency]")
	GameTooltip:AddLine(format(
		"|cffc3771aDataBroker|r based addon to show your network latency (ms)\nupdated every |cff06DDFA%s second(s)|r!\n",
		LATENCY_PERIOD
	))

	local bandwidthIn, bandwidthOut, home, world = GetNetStats()
	local ir, ig, ib = ColorGradient(bandwidthIn / 20, 0, 1, 0, 1, 1, 0, 1, 0, 0)
	local outR, outG, outB = ColorGradient(bandwidthOut / 5, 0, 1, 0, 1, 1, 0, 1, 0, 0)
	local r, g, b = ColorGradient(((home + world) / 2) / 1000, 0, 1, 0, 1, 1, 0, 1, 0, 0)

	GameTooltip:AddDoubleLine("|cff42AAFFHOME|r |cffFFFFFFRealm|r |cff0deb11(latency)|r:", format("%.0f ms", home), nil, nil, nil, r, g, b)
	GameTooltip:AddDoubleLine("|cffDCFF42WORLD|r |cffFFFFFFServer|r |cff0deb11(latency)|r:", format("%.0f ms", world), nil, nil, nil, r, g, b)
	GameTooltip:AddLine(" ")
	GameTooltip:AddDoubleLine("|cff06ddfaIncoming bandwidth|r |cff0deb11(download)|r usage:", format("%.2f kb/sec", bandwidthIn), nil, nil, nil, ir, ig, ib)
	GameTooltip:AddDoubleLine("|cff06ddfaOutgoing bandwidth|r |cff0deb11(upload)|r usage:", format("%.2f kb/sec", bandwidthOut), nil, nil, nil, outR, outG, outB)

	GameTooltip:Show()
end

function latency.OnLeave()
	latencyTooltipOwner = nil
	GameTooltip:SetClampedToScreen(true)
	GameTooltip:Hide()
end

-- Refresh loops ------------------------------------------------------------
-- An open tooltip is redrawn on the same tick as its readout, so the numbers in
-- it keep moving while the cursor rests on the broker.

UpdateFps()
UpdateLatency()

C_Timer.NewTicker(UPDATE_PERIOD, function()
	UpdateFps()
	if fpsTooltipOwner then fps.OnEnter(fpsTooltipOwner) end
end)

C_Timer.NewTicker(LATENCY_PERIOD, function()
	UpdateLatency()
	if latencyTooltipOwner then latency.OnEnter(latencyTooltipOwner) end
end)
