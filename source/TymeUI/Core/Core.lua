local TYMEUI, F, I, E = unpack(TymeUI)
local _G = _G
local pairs = pairs
local xpcall = xpcall
local string = string
local tinsert = table.insert


TYMEUI.RegisteredModules = {}

local function errorhandler(err)
	return _G.geterrorhandler()(err)
end

function TYMEUI:PrintMessage(message, color)
    color = color or I.Constants.ColorsRGB.yellow
    local bracketColor = I.Constants.ColorHex.yellow
    local resetColor = I.Constants.ColorHex.close
    local formattedMessage = string.format("%s[%s%s%s]%s: %s", bracketColor, resetColor, I.Constants.ADDON_NAME_COLOR, bracketColor, resetColor, message)
    F.Chat(formattedMessage, color)
end

function TYMEUI:RegisterModule(name)
	if not self.RegisteredModules[name] then tinsert(self.RegisteredModules, name) end
end

function TYMEUI:ModulePreInitialize(module)
	module.isEnabled = false
	F.Log.InjectLogger(module)
end

function TYMEUI:InitializeModules()
	-- Update cooldown text settings
	E:UpdateCooldownSettings("all")
	self:PrintMessage('Core/Core.lua => Initializing Modules')

	-- All other modules that are registered the normal way
	for _, moduleName in pairs(self.RegisteredModules) do
		local module = self:GetModule(moduleName)
		self:ModulePreInitialize(module)
		if module.Initialize then xpcall(module.Initialize, errorhandler, module) end
	end
	
	-- Init commands
	self:LoadCommands()
end