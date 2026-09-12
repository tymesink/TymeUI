--[[
	Shared plumbing for TymeUI: the addon namespace, chat output, and a single
	event dispatcher.

	Every other file in this addon starts with

		local ADDON, TymeUI = ...

	which is how WoW hands each file the addon's name and a private table shared
	between all of its files. Nothing here is written to the global namespace, so
	no other addon can see or collide with any of it.
]]

local ADDON, TymeUI = ...

local CreateFrame = CreateFrame
local DEFAULT_CHAT_FRAME = DEFAULT_CHAT_FRAME
local format = string.format
local geterrorhandler = geterrorhandler
local ipairs = ipairs
local tinsert = table.insert
local tostring = tostring
local xpcall = xpcall

TymeUI.prefix = "|cff0062ffTyme|r|cff0DEB11UI|r"
TymeUI.mediaPath = "Interface\\AddOns\\" .. ADDON .. "\\Media\\"
TymeUI.soundPath = TymeUI.mediaPath .. "Sounds\\"

--- Writes one line to the default chat frame, tagged with the addon name.
function TymeUI:Print(message)
	if DEFAULT_CHAT_FRAME then
		DEFAULT_CHAT_FRAME:AddMessage(format("%s: %s", self.prefix, tostring(message)))
	end
end

do
	-- One hidden frame fans every event out to any number of listeners, so a
	-- feature file can subscribe without creating a frame of its own. Handlers
	-- run under xpcall: a listener that errors reports through the normal error
	-- handler and the remaining listeners still run.
	local dispatcher = CreateFrame("Frame")
	local listeners = {}

	dispatcher:SetScript("OnEvent", function(_, event, ...)
		for _, handler in ipairs(listeners[event]) do
			xpcall(handler, geterrorhandler(), ...)
		end
	end)

	--- Runs `handler(...)` every time `event` fires, with the event's own
	--- arguments. Registering the first listener for an event subscribes to it.
	function TymeUI:On(event, handler)
		if not listeners[event] then
			listeners[event] = {}
			dispatcher:RegisterEvent(event)
		end

		tinsert(listeners[event], handler)
	end
end
