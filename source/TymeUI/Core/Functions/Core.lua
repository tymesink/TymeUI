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

function F.GetClassColor()
	local className = select(2, UnitClass("player"))
    local classColor = RAID_CLASS_COLORS[className] or C.white
    local colorStr = classColor.colorStr
    return colorStr
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
	if addSpace ~= nil and addSpace == true then
		return UnitName("player").." - "..GetRealmName();
	else
		return UnitName("player").."-"..GetRealmName();
	end
end

function F.Chat(msg, colors)
	local valR, valG, valB;
	
	if (type(msg) ~= 'string') then return nil; end
	if msg == nil then return nil; end
	if (colors == nil) then colors = I.Constants.ColorsRGB.yellow; end
	
	if (type(colors) == 'table') then
		valR, valG, valB = F.Table.splitTable(colors);
	elseif (type(colors) == 'string' and F.Table.findTable(colors, I.Constants.ColorHex)) then
		_, valR,valG,valB = F.String.HexToRGBA(colors);
	elseif (F.Table.findTable(colors, I.Constants.ColorsRGB)) then
		local colorTable = F.Table.getTable(colors, I.Constants.ColorsRGB);
		valR,valG,valB = F.Table.splitTable(colorTable);
	else
		valR, valG, valB = F.Table.splitTable(I.Constants.ColorsRGB.yellow);
	end

	if DEFAULT_CHAT_FRAME then
		DEFAULT_CHAT_FRAME:AddMessage(msg, valR, valG, valB)
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
		if (TYMEUI.DebugMode) then F.Chat("Frame error", "red") end
	end
end

function F.Deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[F.Deepcopy(orig_key)] = F.Deepcopy(orig_value)
        end
        setmetatable(copy, F.Deepcopy(getmetatable(orig)))
    else -- for numbers, strings, booleans, etc
        copy = orig
    end
    return copy
end