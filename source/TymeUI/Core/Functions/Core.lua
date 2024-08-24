local TYMEUI, F, I, E = unpack(TymeUI)
local LSM = E.Libs.LSM

local _G = _G
local abs = math.abs
local COVENANT_COLORS = COVENANT_COLORS
local CreateFrame = CreateFrame
local error = error
local format = string.format
local GetAddOnEnableState = (C_AddOns and C_AddOns.GetAddOnEnableState) or GetAddOnEnableState
local GetTime = GetTime
local ipairs = ipairs
local IsAddOnLoaded = (C_AddOns and C_AddOns.IsAddOnLoaded) or IsAddOnLoaded
local max = math.max
local min = math.min
local modf = math.modf
local next = next
local pairs = pairs
local pcall = pcall
local select = select
local setmetatable = setmetatable
local tcontains = tContains
local tinsert = table.insert
local tremove = table.remove
local type = type
local unpack = unpack
local xpcall = xpcall

F.baseColors = {
	["red"] = {143, 10, 13},
	["blue"] = {10, 12, 150},
	["cyan"] = {16, 211, 255},
	["teal"] = {0, 150, 89},
	["green"] = {20, 150, 10},
	["grassgreen"] = {50,150,50},
	["darkgreen"] = {5,107,0},
	["yellow"] = {255, 255, 0},
	["white"] = {255, 255, 255},
	["black"] = {0, 0, 0}
}

F.availColors = {
	[1] = "red",
	[2] = "blue",
	[3] = "cyan",
	[4] = "teal",
	[5] = "green",
	[6] = "grassgreen",
	[7] = "yellow",
	[8] = "white",
	[9] = "black"
}

F.htmlColors = {
	["orange"] = "|cFFFF8000",
	["purple"] = "|cFFA335EE",
	["brightblue"] = "|cFF0070DE",
	["brightgreen"] = "|cFF1EFF00",
	["white"] = "|cFFFFFFFF",
	["close"] = "|r"
}

function F.Enum(tbl)
	local length = #tbl
	for i = 1, length do
	  local v = tbl[i]
	  tbl[v] = i
	end
  
	return tbl
end

function F.Round(n, q)
	q = q or 1

	local int, frac = modf(n / q)
	if n == abs(n) and frac >= 0.5 then
		return (int + 1) * q
	elseif frac <= -0.5 then
		return (int - 1) * q
	end

	return int * q
end

function F.AlmostEqual(a, b)
	if not a or not b then return false end

	return abs(a - b) <= 0.001
end

function F.PerfectScale(n)
	local m = E.mult
	return (m == 1 or n == 0) and n or (n * m)
end

function F.PixelPerfect()
	-- local perfectScale = 768 / E.physicalHeight
	-- if E.physicalHeight > 1440 then perfectScale = 0.65 end

	-- return perfectScale
	local perfectScale = 0.6
    return perfectScale
end

local baseScale = 768 / 1440 -- 0,5333333333333333
local baseMulti = 0.64 / baseScale -- 1.2
local perfectScale = baseScale / F.PixelPerfect()
local perfectMulti = baseMulti * perfectScale


function F.Dpi(value, frac)
	return F.Round(value * perfectMulti, frac)
end

function F.DpiRaw(value)
	return value * perfectMulti
end

function F.Position(anchor1, parent, anchor2, x, y)
	return format("%s,%s,%s,%d,%d", anchor1, parent, anchor2, x, y)
end

function F.Clamp(value, s, b)
	return min(max(value, s), b)
end

function F.ClampTo01(value)
	return F.Clamp(value, 0, 1)
end

function F.ClampToHSL(h, s, l)
	return h % 360, F.ClampTo01(s), F.ClampTo01(l)
end

function F.ConvertFromHue(m1, m2, h)
	if h < 0 then h = h + 1 end
	if h > 1 then h = h - 1 end

	if h * 6 < 1 then
		return m1 + (m2 - m1) * h * 6
	elseif h * 2 < 1 then
		return m2
	elseif h * 3 < 2 then
		return m1 + (m2 - m1) * (2 / 3 - h) * 6
	else
		return m1
	end
end

function F.IsAddOnEnabled(addon)
	return (C_AddOns and GetAddOnEnableState(addon, E.myname) or GetAddOnEnableState(E.myname, addon)) == 2 and IsAddOnLoaded(addon)
end

function F.IsAddOnLoaded(addon)
	return IsAddOnLoaded(addon)
end

function F.ConvertToRGB(h, s, l)
	h = h / 360
  
	local m2 = l <= 0.5 and l * (s + 1) or l + s - l * s
	local m1 = l * 2 - m2
  
	return F.ConvertFromHue(m1, m2, h + 1 / 3), F.ConvertFromHue(m1, m2, h), F.ConvertFromHue(m1, m2, h - 1 / 3)
end

function F.ConvertToHSL(r, g, b)
	r = r or 0
	g = g or 0
	b = b or 0

	local minColor = min(r, g, b)
	local maxColor = max(r, g, b)
	local colorDelta = maxColor - minColor

	local h, s, l = 0, 0, (minColor + maxColor) / 2

	if l > 0 and l < 0.5 then s = colorDelta / (maxColor + minColor) end
	if l >= 0.5 and l < 1 then s = colorDelta / (2 - maxColor - minColor) end

	if colorDelta > 0 then
		if maxColor == r and maxColor ~= g then h = h + (g - b) / colorDelta end
		if maxColor == g and maxColor ~= b then h = h + 2 + (b - r) / colorDelta end
		if maxColor == b and maxColor ~= r then h = h + 4 + (r - g) / colorDelta end
		h = h / 6
	end

	if h < 0 then h = h + 1 end
	if h > 1 then h = h - 1 end

	return h * 360, s, l
end

function F.CalculateMultiplierColor(multi, r, g, b)
	local h, s, l = F.ConvertToHSL(r, g, b)
	return F.ConvertToRGB(F.ClampToHSL(h, s, l * multi))
end

function F.CalculateMultiplierColorArray(multi, colors)
	local r, g, b

	if colors.r then
		r, g, b = colors.r, colors.g, colors.b
	else
		r, g, b = colors[1], colors[2], colors[3]
	end

	return F.CalculateMultiplierColor(multi, r, g, b)
end

function F.SlowColorGradient(perc, ...)
	if perc >= 1 then
		return select(select("#", ...) - 2, ...)
	elseif perc <= 0 then
		return ...
	end

	local num = select("#", ...) / 3
	local segment, relperc = modf(perc * (num - 1))
	local r1, g1, b1, r2, g2, b2 = select((segment * 3) + 1, ...)

	return F.FastColorGradient(relperc, r1, g1, b1, r2, g2, b2)
end

function F.FastColorGradient(perc, r1, g1, b1, r2, g2, b2)
	if perc >= 1 then
		return r2, g2, b2
	elseif perc <= 0 then
		return r1, g1, b1
	end

	return (r2 * perc) + (r1 * (1 - perc)), (g2 * perc) + (g1 * (1 - perc)), (b2 * perc) + (b1 * (1 - perc))
end

function F.RemoveFontTemplate(fs)
	E.texts[fs] = nil
end

function F.GetFontColorFromDB(db, prefix)
	-- Vars
	if prefix == nil then prefix = "" end
	local fontColor
	local useDB = (db and prefix) and true or false
	local colorSwitch = (useDB and db[prefix .. "FontColor"]) or I.General.DefaultFontColor

	-- Switch
	if colorSwitch == "CUSTOM" then
		fontColor = (useDB and db[prefix .. "FontCustomColor"]) or I.General.DefaultFontCustomColor
	elseif colorSwitch == "TYMEUI" then
		fontColor = I.Strings.Branding.ColorRGBA
	elseif colorSwitch == "CLASS" then
		local classColor = E:ClassColor(E.myclass, true)
		fontColor = {
		r = classColor.r,
		g = classColor.g,
		b = classColor.b,
		a = 1,
		}
	elseif colorSwitch == "VALUE" then
		fontColor = {
		r = E.media.rgbvaluecolor[1],
		g = E.media.rgbvaluecolor[2],
		b = E.media.rgbvaluecolor[3],
		a = 1,
		}
	elseif colorSwitch == "COVENANT" then
		local covenantColor = COVENANT_COLORS[F.GetCachedCovenant()] or I.Strings.Branding.ColorRGBA
		fontColor = {
		r = covenantColor.r,
		g = covenantColor.g,
		b = covenantColor.b,
		a = 1,
		}
	else
		fontColor = {
		r = 1,
		g = 1,
		b = 1,
		a = 1,
		}
	end

	return fontColor
end

function F.SetFontColorFromDB(db, prefix, fs)
	local fontColor = F.GetFontColorFromDB(db, prefix)
	F.RemoveFontTemplate(fs)
	fs:SetTextColor(fontColor.r, fontColor.g, fontColor.b, fontColor.a)
end

function F.SetFontScaledFromDB(db, prefix, fs, color, fontOverwrite)
	F.SetFontFromDB(db, prefix, fs, color, fontOverwrite, true)
end

function F.GetFontPath(font)
	font = font or I.General.DefaultFont

	local lsmFont = LSM:Fetch("font", F.FontOverride(font))
	if not lsmFont then lsmFont = LSM:Fetch("font", font) end -- backup to non-override font
	if not lsmFont then lsmFont = LSM:Fetch("font", I.General.DefaultFont) end -- backup to normal font if not found
	if not lsmFont then lsmFont = E.media.normFont end -- backup to elvui font if not found

	return lsmFont
end

function F.SetFontFromDB(db, prefix, fs, color, fontOverwrite, useScaling)
	local useDB = (db and prefix) and true or false
	local font = (useDB and db[prefix .. "Font"]) or I.General.DefaultFont
	local size = (useDB and db[prefix .. "FontSize"]) or I.General.DefaultFontSize
	local outline = (useDB and db[prefix .. "FontOutline"]) or I.General.DefaultFontOutline
	local shadow = (useDB and db[prefix .. "FontShadow"] ~= nil) and db[prefix .. "FontShadow"]
	if shadow == nil then shadow = I.General.DefaultFontShadow end

	if fontOverwrite then font = fontOverwrite end
	local lsmFont = F.GetFontPath(font)

	shadow = F.GetFontShadowOverride(font, shadow)
	outline = F.FontStyleOverride(font, outline)

	if outline == "NONE" then outline = "" end

	F.RemoveFontTemplate(fs)
	fs:SetFont(lsmFont, useScaling and F.FontSizeScaled(size) or size, (not shadow and outline) or "")

	if shadow then
		fs:SetShadowOffset(1, -0.5)
		fs:SetShadowColor(0, 0, 0, 1)
	else
		fs:SetShadowOffset(0, 0)
		fs:SetShadowColor(0, 0, 0, 0)
	end

	if (color == nil) or (color == true) then F.SetFontColorFromDB(db, prefix, fs) end
end

do
	local throttleNamespaces = {}

	function F.CreateThrottleWrapper(namespace, throttle, func)
	  return function(...)
		local currentTime = GetTime()
		if throttleNamespaces[namespace] and ((currentTime - throttleNamespaces[namespace]) <= throttle) then return end
		throttleNamespaces[namespace] = currentTime
		return func(...)
	  end
	end
end

do
	local protected_call = {}

	function protected_call._error_handler(err)
		TYMEUI:LogWarning(err)
	end

	function protected_call._handle_result(success, ...)
	  if success then return ... end
	end

	local do_pcall
	if not select(2, xpcall(function(a) return a end, error, true)) then
		do_pcall = function(func, ...)
			local args = { ... }
			return protected_call._handle_result(xpcall(function() return func(unpack(args)) end, protected_call._error_handler))
	  	end
	else
		do_pcall = function(func, ...)
			return protected_call._handle_result(xpcall(func, protected_call._error_handler, ...))
		end
	end

	function protected_call.call(func, ...)
	  return do_pcall(func, ...)
	end

	local pcall_mt = {}
	function pcall_mt:__call(...)
		return do_pcall(...)
	end

	F.ProtectedCall = setmetatable(protected_call, pcall_mt)
end

do
	local eventManagerFrame, eventManagerTable, eventManagerDelayed = CreateFrame("Frame"), {}, {}

	eventManagerFrame:SetScript("OnUpdate", function()
	  for _, func in ipairs(eventManagerDelayed) do
		F.ProtectedCall(unpack(func))
	  end
	  eventManagerDelayed = {}
	end)

	function F.EventManagerDelayed(func, ...)
	  tinsert(eventManagerDelayed, { func, ... })
	end

	eventManagerFrame:SetScript("OnEvent", function(_, event, ...)
	  local namespaces = eventManagerTable[event]
	  if namespaces then
		for _, funcs in pairs(namespaces) do
		  for _, func in ipairs(funcs) do
			func(event, ...)
		  end
		end
	  end
	end)

	function F.EventManagerRegister(namespace, event, func)
	  local namespaces = eventManagerTable[event]
  
	  if not namespaces then
		eventManagerTable[event] = {}
		namespaces = eventManagerTable[event]
		pcall(eventManagerFrame.RegisterEvent, eventManagerFrame, event)
	  end
  
	  local funcs = namespaces[namespace]
  
	  if not funcs then
		namespaces[namespace] = { func }
	  elseif not tcontains(funcs, func) then
		tinsert(funcs, func)
	  end
	end

	function F.EventManagerUnregisterAll(namespace)
	  for event in pairs(eventManagerTable) do
		local namespaces = eventManagerTable[event]
		local funcs = namespaces and namespaces[namespace]
		if funcs ~= nil then F.EventManagerUnregister(namespace, event) end
	  end
	end

	function F.EventManagerUnregister(namespace, event, func)
	  local namespaces = eventManagerTable[event]
	  local funcs = namespaces and namespaces[namespace]
  
	  if funcs then
		for index, fnc in ipairs(funcs) do
		  if not func or (func == fnc) then
			tremove(funcs, index)
			break
		  end
		end
  
		if #funcs == 0 then namespaces[namespace] = nil end
  
		if not next(funcs) then
		  eventManagerFrame:UnregisterEvent(event)
		  eventManagerTable[event] = nil
		end
	  end
	end
end

function F.GetCharName(lowercase)
	if lowercase == true then
		return string.lower(UnitName("player"))
	else
		return UnitName("player")
	end
end

function F.GetDBCharName(addSpace)
	if(addSpace == true) then
		return UnitName("player").." - "..GetRealmName();
	else
		return UnitName("player").."-"..GetRealmName();
	end
end

function F.Chat(msgType, msg, colors)
	local from = "TymeUI";
	local fromColor = "|cff0062ffTyme|r|cff0DEB11UI: |r";
	local valR, valG, valB;
	
	if (type(msg) ~= "string") then return nil; end
	if msg == nil then return nil; end

	if (type(colors) == "table") then
		valR, valG, valB = F.Table.splitTable(colors);
	elseif (F.Table.findTable(colors, F.baseColors)) then
		valR,valG,valB = F.Table.splitTable(F.Table.getTable(colors, F.baseColors));
	else
		valR, valG, valB = F.Table.splitTable(F.baseColors.yellow);
	end

	if msgType == "error" then
		UIErrorsFrame:AddMessage("<"..from.."> "..msg, valR, valG, valB, 1, 10)
	end

	if msgType == "chat" then
		if DEFAULT_CHAT_FRAME then
			DEFAULT_CHAT_FRAME:AddMessage(fromColor..msg, valR, valG, valB)
		end
	end

	if msgType == "plainerror" then
		UIErrorsFrame:AddMessage("<"..from.."> "..msg, valR, valG, valB, 1, 10)
	end
end
 
function F.ToggleFrame(fname, action)
	if (type(fname) == "string") then
		local frame = getglobal(fname)
		if (frame) then
			if (action == nil) then
				if (frame:IsVisible()) then
					frame:Hide()
					return "hide";
				else
					frame:Show()
					return "show";
				end
				return nil;
			else
				if (action == "show") then
					frame:Show()
					return "show";
				else
					frame:Hide()
					return "hide";
				end
			end
		end
	else
		if (TYMEUI.DebugMode) then F.Chat("chat", "Frame error", "red") end
	end
end