local TYMEUI, F, E, I, V, P, G = unpack((select(2, ...)))
local _G = _G
local pairs = pairs
local xpcall = xpcall

TYMEUI.Title = I.Strings.Branding.Title
TYMEUI.RegisteredModules = {}

local function errorhandler(err)
	return _G.geterrorhandler()(err)
end

function TYMEUI:RegisterModule(name)
	if not self.RegisteredModules[name] then table.insert(self.RegisteredModules, name) end
end

function TYMEUI:ModulePreInitialize(module)
	module.isEnabled = false
	F.Log.InjectLogger(module)
end

function TYMEUI:InitializeModules()
	-- Update cooldown text settings
	E:UpdateCooldownSettings("all")
	F.Chat('chat', 'Core/Core.lua => Initializing Modules')

	-- All other modules that are registered the normal way
	for _, moduleName in pairs(self.RegisteredModules) do
		local module = self:GetModule(moduleName)
		self:ModulePreInitialize(module)
		if module.Initialize then xpcall(module.Initialize, errorhandler, module) end
	end
	
  
	-- Init Popups
	self:LoadStaticPopups()
  
	-- Init commands
	self:LoadCommands()
end