local TYMEUI, F, E, I, V, P, G = unpack((select(2, ...)))
local AH = TYMEUI:NewModule("AuctionHouse", "AceHook-3.0")

-- --------------------------------------
-- AuctionHouseNotication
-- --------------------------------------
local SoldNotify = function(self, event, ...)
	local arg1, arg2 = ...;
	
	local yourAuctionOfWildCardSold = string.gsub(ERR_AUCTION_SOLD_S, "(%%s)", ".+");

	--auction house item sold
	if string.match(arg1, yourAuctionOfWildCardSold) ~= nil then
		local addonfolder = 'tymeui';
		local path = '_retail_\\interface\\addons\\'..addonfolder..'\\media\\sounds\\';
		PlaySoundFile(path..'CashRegister.mp3');
	end
end


-- Initialization
function AH:Initialize()
    -- Don't init second time
    if self.Initialized then return end
    F.Chat('chat','AuctionHouse:Initialize()');
    self:RegisterEvent("CHAT_MSG_SYSTEM", SoldNotify);

    -- We are done, hooray!
    self.Initialized = true
end

TYMEUI:RegisterModule(AH:GetName())
