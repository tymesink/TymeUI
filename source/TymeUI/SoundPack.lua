--[[
	Publishes the bundled sound pack so other addons (DBM, WeakAuras, ...) can
	pick these sounds from their own dropdowns.
]]

local ADDON, TymeUI = ...

local pairs = pairs

-- LibSharedMedia is genuinely optional. Without it the sounds simply are not
-- offered to other addons, which is not worth reporting as an error.
local LSM = LibStub and LibStub("LibSharedMedia-3.0", true)

-- The keys are the names other addons show in their menus and store in their
-- own saved settings, so they must stay exactly as they are: renaming one
-- silently resets whatever had it selected. The values are the file names as
-- they appear on disk under Media\Sounds\.
local SOUNDS = {
	cashRegister = "CashRegister.mp3",
	choo = "Choo.mp3",
	dirty = "Dirty.mp3",
	doublehit = "DoubleHit.mp3",
	dullhit = "Dullhit.mp3",
	gasp = "Gasp.mp3",
	heart = "Heart.mp3",
	himetal = "HiMetal.mp3",
	hit = "Hit.mp3",
	kachink = "Kachink.mp3",
	link = "Link.mp3",
	pop1 = "Pop1.mp3",
	pop2 = "Pop2.mp3",
	shaker = "Shaker.mp3",
	switchy = "Switchy.mp3",
	text1 = "Text1.mp3",
	text2 = "Text2.mp3",
}

--- Full path to one of the bundled sounds, or nil if the name is not one.
function TymeUI:SoundFile(name)
	local file = SOUNDS[name]
	return file and (self.soundPath .. file)
end

if LSM then
	for name, file in pairs(SOUNDS) do
		LSM:Register(LSM.MediaType.SOUND, name, TymeUI.soundPath .. file)
	end
end
