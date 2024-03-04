local addon, ns = ...

local DEBUGMODE = true; ns.DEBUGMODE = DEBUGMODE;

local settings = {
	["initialized"] = false,
	["guildXpBonusPercent"] = 10,
	["gearXpBonusPercent"] = 0
}
ns.settings = settings;

local baseColors = {
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
ns.baseColors = baseColors;

local availColors = {
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
ns.availColors = availColors;

local htmlColors = {
	["orange"] = "|cFFFF8000",
	["purple"] = "|cFFA335EE",
	["brightblue"] = "|cFF0070DE",
	["brightgreen"] = "|cFF1EFF00",
	["white"] = "|cFFFFFFFF",
	["close"] = "|r"
}
ns.htmlColors = htmlColors;

-- --------------------------------------
-- Core Lib Functions
-- --------------------------------------
local getCharName = function(lowercase)
	if lowercase == true then
		return string.lower(UnitName("player"))
	else
		return UnitName("player")
	end
end
ns.getCharName = getCharName;

local getDBCharName = function(addSpace)
	if(addSpace == true) then
		return UnitName("player").." - "..GetRealmName();
	else
		return UnitName("player").."-"..GetRealmName();
	end
end
ns.getDBCharName = getDBCharName;

-- Returns the value of the RGB color requested
local getColor = function(arg)
	local result;
	if (arg) then
		if (findTable(arg, lib.Colors)) then
			result = getTable(arg, colors);
		end
	end
	return result;
end
ns.getColor = getColor;

-- Returns the value in a table
local getTable = function(what, where)
	if (type(where) == "table") then
		for index,value in pairs(where) do
			if (what == index) then
				return value;
			elseif (what == value) then
				return index;
			elseif (type(value) == "table") then
				for index2,value2 in pairs(value) do
					if (what == index2) then
						return value2;
					elseif (what == value2) then
						return index2;
						end
				end
			end
		end
	else
		if (DEBUGMODE) then chat("No table for GetTable", "chat", "pvptimerlib") end
		return nil;
	end
end
ns.getTable = getTable

-- Returns if a value is found in a table
local findTable = function(what, where)
	local isFound = false;
	if (type(where) == "table") then
		for index,value in pairs(where) do
			if (value == what) then
				isFound=true;
			elseif (index == what) then
				isFound=true;
			end
		end
		for index,value in pairs(where) do
			if (type(value) == "table") then
				for index2,value2 in pairs(value) do
					if (value2 == what) then
						isFound = true;
					elseif (index2 == what) then
						isFound=true;
					end
				end
			end
		end
	else
		if (DEBUGMODE) then chat("No table for FindTable","chat","pvptimerlib") end
		return nil;
	end
	return isFound;
end
ns.findTable = findTable;

-- Splits a RGB table into WoW values
local splitTable = function (arg)
	local val1, val2, val3;
	if (type(arg) == "table") then
		for index,value in pairs(arg) do
			if (index == 1) then
				val1 = tonumber(value/255);
			elseif (index == 2) then
				val2 = tonumber(value/255);
			elseif (index == 3) then
				val3 = tonumber(value/255);
			end
		end
	end
	return val1, val2, val3;
end
ns.splitTable = splitTable;

-- Clears an array (table)
local clearTable = function (arg)
	arg = table.wipe(arg);
end
ns.clearTable = clearTable;

-- Copies a table for safe resetting or other uses
local copyTable = function (arg)
	local newTable;
	if (type(arg) == "table") then
		newTable = {};
		for index,value in pairs(arg) do
			newTable[index] = value;
		end
	end
	return newTable;
end
ns.copyTable = copyTable;

-- Makes sure settings are in one array from another array
local mergeTable = function(arrayTo, arrayFrom)
	local newArray;
	
	if (type(arrayTo) ~= "table") or (type(arrayFrom) ~= "table") then
		return nil;
	else
		newArray = copyTable(arrayTo);
	end

	for index,value in pairs(arrayFrom) do
		local isThere = findTable(index, newArray);
		if (not isThere) then
			newArray[index]=value;
		end
	end

	return newArray;
end
ns.mergeTable = mergeTable;

-- Prints to chat with the appropriate mods message
local chat = function(msgType, msg, colors)
	local from = "TymeUI";
	local fromColor = "|cff0062ffTyme|r|cff0DEB11UI: |r";
	local valR, valG, valB;
	
	if (type(msg) ~= "string") then return nil; end
	if msg == nil then return nil; end

	if (type(colors) == "table") then
		valR, valG, valB = splitTable(colors);
	elseif (findTable(colors, baseColors)) then
		valR,valG,valB = splitTable(getTable(colors, baseColors));
	else
		valR, valG, valB = splitTable(baseColors.yellow);
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
 ns.chat = chat;
 
 -- frame toggler
local toggleFrame = function(fname, action)
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
		if (DEBUGMODE) then ns.Chat("chat", "Frame error", "red") end
	end
end
ns.toggleFrame = toggleFrame;