local TYMEUI, F, I, E = unpack(TymeUI)

local next = next
local pairs = pairs
local rawset = rawset
local select = select
local setmetatable = setmetatable
local tinsert = table.insert
local tsort = table.sort
local type = type
local unpack = unpack
local assert = assert
local print = print
local string = string

F.Table = {}

function F.Table.SetMetatables(tbl, mt)
	for k, v in pairs(tbl) do
		if type(v) == "table" then tbl[k] = F.Table.SetMetatables(v, mt) end
	end

	return setmetatable(tbl, mt)
end

function F.Table.IsEmpty(tbl)
	return next(tbl) == nil
end

function F.Table.HasAnyEntries(tbl)
	return not F.Table.IsEmpty(tbl)
end

function F.Table.GetOrCreate(tbl, ...)
	local currentTable = tbl

	for i = 1, select("#", ...) do
		local key = (select(i, ...))
		if type(currentTable[key]) ~= "table" then currentTable[key] = {} end
		currentTable = currentTable[key]
	end

	return currentTable
end

function F.Table.RemoveEmpty(tbl)
	for k, v in pairs(tbl) do
		if type(v) == "table" then
			if next(v) == nil then
				tbl[k] = nil
			else
				tbl[k] = F.Table.RemoveEmpty(v)
			end
		end
	end

	return tbl
end

function F.Table.Join(...)
	local ret = {}

	for i = 1, select("#", ...) do
		local t = select(i, ...)
		if t then
			for k, v in pairs(t) do
				if type(k) == "number" then
					tinsert(ret, v)
				else
					ret[k] = v
				end
			end
		end
	end

	return ret
end

function F.Table.Crush(ret, ...)
	for i = 1, select("#", ...) do
		local t = select(i, ...)
		if t then
			for k, v in pairs(t) do
				if type(v) == "table" and type(ret[k] or false) == "table" then
					F.Table.Crush(ret[k], v)
				else
					rawset(ret, k, v)
				end
			end
		end
	end
end

function F.Table.CrushDebug(ret, ...)
	for i = 1, select("#", ...) do
		local t = select(i, ...)
		if t then
			for k, v in pairs(t) do
				if type(v) == "table" and type(ret[k] or false) == "table" then
					F.Table.CrushDebug(ret[k], v)
				else
					if ret[k] == nil and k ~= "customTexts" and k ~= "infoPanel" and k ~= "customTexture" and k ~= "movers" and k ~= "uiScaleInformed" and k ~= "convertPages" then
						TYMEUI:LogDebug("Setting new k,v", k, v)
					end

					rawset(ret, k, v)
				end
			end
		end
	end
end

function F.Table.If(cond, thenTable, orTable)
	if not cond then return orTable or {} end
	return thenTable or {}
end

function F.Table.RGB(r, g, b, a)
	local ret = {
		r = r,
		g = g,
		b = b,
	}

	if a then ret.a = a end

	return ret
end
  
  function F.Table.HexToRGB(hex)
	local r, g, b, a = F.String.HexToRGB(hex)
	return F.Table.RGB(r, g, b, a)
  end

function F.Table.CurrentClassColor()
	local color = E:ClassColor(E.myclass, true)

	return F.Table.RGB(color.r, color.g, color.b)
end

function F.Table.Sort(t, f)
	local keys = {}

	for k in pairs(t) do
		keys[#keys + 1] = k
	end

	tsort(keys, f)

	local i = 0
	return function()
		i = i + 1
		return keys[i], t[keys[i]]
	end
end

function F.Table.SafePack(...)
	return { n = select("#", ...), ... }
end

function F.Table.SafeUnpack(tbl)
	return unpack(tbl, 1, tbl.n)
end

function F.Table.getTable(what, where)
	if (type(where) == "table") then
		for index, value in pairs(where) do
			if (what == index) then
				return value;
			elseif (what == value) then
				return index;
			elseif (type(value) == "table") then
				for index2, value2 in pairs(value) do
					if (what == index2) then
						return value2;
					elseif (what == value2) then
						return index2;
					end
				end
			end
		end
	else
		if (TYMEUI.DebugMode) then TYMEUI.LogWarning('No table for GetTable') end
		return nil;
	end
end

function F.Table.findTable(what, where)
	local isFound = false;
	if (type(where) == "table") then
		for index, value in pairs(where) do
			if (value == what) then
				isFound = true;
			elseif (index == what) then
				isFound = true;
			end
		end
		for index, value in pairs(where) do
			if (type(value) == "table") then
				for index2, value2 in pairs(value) do
					if (value2 == what) then
						isFound = true;
					elseif (index2 == what) then
						isFound = true;
					end
				end
			end
		end
	else
		print('F.Table.findTable DEBUG => No table for FindTable')
		return nil;
	end
	return isFound;
end

function F.Table.splitTable(arg)
	local val1, val2, val3;
	if (type(arg) == "table") then
		for index, value in pairs(arg) do
			if (index == 1) then
				val1 = tonumber(value / 255);
			elseif (index == 2) then
				val2 = tonumber(value / 255);
			elseif (index == 3) then
				val3 = tonumber(value / 255);
			end
		end
	end
	return val1, val2, val3;
end

function F.Table.Dump(t, indent)
	assert(type(t) == "table", "F.Table.Dump() called for non-table!")

	-- Set default indent to 0 if not provided or not a number
	if type(indent) ~= "number" then
		indent = 0
	end

	local indentString = string.rep("  ", indent)

	for k, v in pairs(t) do
		if type(v) ~= "table" then
			if type(v) == "string" then
				F.Log.Print(indentString, k, "=", v)
			end
		else
			F.Log.Print(indentString .. k .. " =")
			F.Log.Print(indentString .. "  {")
			F.Table.Dump(v, indent + 2)
			F.Log.Print(indentString .. "  }")
		end
	end
end
