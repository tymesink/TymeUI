--[[
	Plays a cash-register sound when one of your auctions sells.
]]

local ADDON, TymeUI = ...

local PlaySoundFile = PlaySoundFile
local type = type

-- ERR_AUCTION_SOLD_S is the localised "Your auction of %s sold!" string. Turn
-- it into a Lua pattern that matches any item name: escape the characters Lua
-- treats as pattern syntax, then swap the %s placeholder for a wildcard. It is
-- anchored so a player cannot trigger it by quoting the text back at you.
local SOLD_PATTERN
do
	local escaped = ERR_AUCTION_SOLD_S:gsub("([%^%$%(%)%.%[%]%*%+%-%?])", "%%%1")
	SOLD_PATTERN = "^" .. escaped:gsub("%%s", ".+") .. "$"
end

TymeUI:On("CHAT_MSG_SYSTEM", function(message)
	if type(message) ~= "string" or not message:match(SOLD_PATTERN) then return end

	-- "Master" rather than the default SFX channel, so the notification is still
	-- audible with sound effects turned down.
	PlaySoundFile(TymeUI:SoundFile("cashRegister"), "Master")
end)
