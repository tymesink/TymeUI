local addon, ns = ...
-- --------------------------------------
-- enable wow mouse
-- --------------------------------------
local enableWoWMouse = function()
	ns.chat('chat','enableWoWMouse');
	SetCVar("enableWoWMouse", 1);
	DetectWowMouse();
end

-- --------------------------------------
-- zygor frame fix
-- --------------------------------------
local zygorFrameFix = function()
	if ZygorGuidesViewerFrameMaster ~= nil then
		ns.chat('chat','zygorFrameFix');
		ZygorGuidesViewerFrameMaster:SetFrameStrata('LOW');
	end
end

-- --------------------------------------
-- AuctionHouseNotication
-- --------------------------------------
local function ahNotify(self, event, ...)
	local arg1, arg2 = ...;
	
	local yourAuctionOfWildCardSold = string.gsub(ERR_AUCTION_SOLD_S, "(%%s)", ".+");

	--auction house item sold
	if string.match(arg1, yourAuctionOfWildCardSold) ~= nil then
		local addonfolder = 'tymeui';
		local path = '_retail_\\interface\\addons\\'..addonfolder..'\\media\\sounds\\';
		PlaySoundFile(path..'CashRegister.mp3');
	end
end

-- --------------------------------------
-- FRAME EVENTS
-- --------------------------------------
local frameOnEvent = function(self, event, ...)
	local arg1, arg2, arg3, arg4, arg5 = ...;
	if(event == "PLAYER_ENTERING_WORLD") then
		--zygorFrameFix();

		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	elseif(event == "ADDON_LOADED") then
		ns.chat('chat','Addon Loaded');
		--enableWoWMouse();
		
		self:UnregisterEvent('ADDON_LOADED')
	elseif(event == "CHAT_MSG_SYSTEM") then
		ahNotify(self, event, ...);
	end
end
ns.frameOnEvent = frameOnEvent;