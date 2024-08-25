local TYMEUI, F, I, E = unpack(TymeUI)
local LSM = E.Libs.LSM
local format, ipairs, type, pcall = format, ipairs, type, pcall

TYMEUI.Media = {
	Fonts = {},
	Sounds = {},
	Arrows = {},
	MailIcons = {},
	RestIcons = {},
	ChatEmojis = {},
	ChatLogos = {},
	Textures = {},
}

local MediaKey = {
	font	= 'Fonts',
	sound	= 'Sounds',
	arrow	= 'Arrows',
	mail	= 'MailIcons',
	resting = 'RestIcons',
	emoji	= 'ChatEmojis',
	logo	= 'ChatLogos',
	texture	= 'Textures'
}

local MediaPath = {
	font	= [[Interface\AddOns\TymeUI\Media\Fonts\]],
	sound	= [[Interface\AddOns\TymeUI\Media\Sounds\]],
	arrow	= [[Interface\AddOns\TymeUI\Media\Arrows\]],
	mail	= [[Interface\AddOns\TymeUI\Media\MailIcons\]],
	resting = [[Interface\AddOns\TymeUI\Media\RestIcons\]],
	emoji	= [[Interface\AddOns\TymeUI\Media\ChatEmojis\]],
	logo	= [[Interface\AddOns\TymeUI\Media\ChatLogos\]],
	texture	= [[Interface\AddOns\TymeUI\Media\Textures\]]
}

local function AddMedia(Type, File, Name, CustomType, Mask)
	local path = MediaPath[Type]
	if path then
		local key = File:gsub('%.%w-$','')
		local file = path .. File

		local pathKey = MediaKey[Type]
		if pathKey then TYMEUI.Media[pathKey][key] = file end

		if Name then -- Register to LSM
			local nameKey = (Name == true and key) or Name
			if type(CustomType) == 'table' then
				for _, name in ipairs(CustomType) do
					LSM:Register(name, nameKey, file, Mask)
				end
			else
				LSM:Register(CustomType or Type, nameKey, file, Mask)
			end
		end
	end
end

AddMedia('sound', 'CashRegister.mp3', 'cashRegister');
AddMedia('sound', 'choo.mp3', 'choo');
AddMedia('sound', 'dirty.mp3', 'dirty');
AddMedia('sound', 'doublehit.mp3', 'doublehit');
AddMedia('sound', 'dullhit.mp3', 'dullhit');
AddMedia('sound', 'gasp.mp3', 'gasp');
AddMedia('sound', 'heart.mp3', 'heart');
AddMedia('sound', 'himetal.mp3', 'himetal');
AddMedia('sound', 'hit.mp3', 'hit');
AddMedia('sound', 'kachink.mp3', 'kachink');
AddMedia('sound', 'link.mp3', 'link');
AddMedia('sound', 'pop1.mp3', 'pop1');
AddMedia('sound', 'pop2.mp3', 'pop2');
AddMedia('sound', 'shaker.mp3', 'shaker');
AddMedia('sound', 'switchy.mp3', 'switchy');
AddMedia('sound', 'text1.mp3', 'text1');
AddMedia('sound', 'text2.mp3', 'text2');
AddMedia('sound', 'Popup.ogg', 'alert');
