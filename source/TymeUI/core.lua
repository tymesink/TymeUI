local addon, ns = ...
local frame = CreateFrame('Frame')

-- --------------------------------------
-- slash handler commands
-- --------------------------------------
local slashHandler = function (args)
	local command = strtrim(strlower(args or ""))
	local arg1, arg2, arg3, arg4 = strsplit(" ", command);
	
	if arg1 == "test" then
		ns.chat("chat", "Slash Handler Test!");

		local addonNum = GetNumAddOns();
		ns.chat("chat", "Addon number: "..addonNum);
		local name, title, notes, loadable, reason, security, newVersion = GetAddOnInfo(1);
		ns.chat("chat", "Addon Name: "..name);

		for i = 1, GetNumAddOns(), 1 do
			local name, title, notes, loadable, reason, security, newVersion = GetAddOnInfo(i);
			ns.chat("chat", "Addon Name: "..name.. " Index: "..i);
		end
	end
end


-- --------------------------------------
-- slash commands
-- --------------------------------------
local slashcmds = function()
	SLASH_TYME1 = "/tyme";
	SlashCmdList["TYME"] = function(args)
		slashHandler(args);
	end
	
	-------------------------------------
	SLASH_TYMERELOADUI1 = "/rl"
	SlashCmdList["TYMERELOADUI"] = function() ReloadUI(); end
	
	-------------------------------------
	SLASH_TYMEALARM1, SLASH_TYMEALARM2 = "/alarm", "/alarms"
	SlashCmdList["TYMEALARM"] = function() ToggleTimeManager(); end

	-------------------------------------
	SLASH_TYMEADDONMANAGER1, SLASH_TYMEADDONMANAGER2, SLASH_TYMEADDONMANAGER3, SLASH_TYMEADDONMANAGER4 = "/addon", "/addons"
	SlashCmdList["TYMEADDONMANAGER"] = function() 
		if IsAddOnLoaded("ACP") then
			ACP:ToggleUI();
		elseif IsAddOnLoaded("stAddonManager") then
			local stAMFunc = SlashCmdList["STADDONMANAGER"];
			stAMFunc();
		else
			ns.toggleFrame("AddonList");
		end		
	end
	
	-------------------------------------
	SLASH_FRAME1 = "/frame"
	SlashCmdList["FRAME"] = function(arg)
		if arg ~= "" then
			arg = _G[arg]
		else
			arg = GetMouseFocus()
		end
		if arg ~= nil then FRAME = arg end --Set the global variable FRAME to = whatever we are mousing over to simplify messing with frames that have no name.
		if arg ~= nil and arg:GetName() ~= nil then
			local point, relativeTo, relativePoint, xOfs, yOfs = arg:GetPoint()
			ChatFrame1:AddMessage("|cffCC0000----------------------------")
			ChatFrame1:AddMessage("Name: |cffFFD100"..arg:GetName())
			if arg:GetParent() and arg:GetParent():GetName() then
				ChatFrame1:AddMessage("Parent: |cffFFD100"..arg:GetParent():GetName())
			end
	 
			ChatFrame1:AddMessage("Width: |cffFFD100"..format("%.2f",arg:GetWidth()))
			ChatFrame1:AddMessage("Height: |cffFFD100"..format("%.2f",arg:GetHeight()))
			ChatFrame1:AddMessage("Strata: |cffFFD100"..arg:GetFrameStrata())
			ChatFrame1:AddMessage("Level: |cffFFD100"..arg:GetFrameLevel())
	 
			if xOfs then
				ChatFrame1:AddMessage("X: |cffFFD100"..format("%.2f",xOfs))
			end
			if yOfs then
				ChatFrame1:AddMessage("Y: |cffFFD100"..format("%.2f",yOfs))
			end
			if relativeTo and relativeTo:GetName() then
				ChatFrame1:AddMessage("Point: |cffFFD100"..point.."|r anchored to "..relativeTo:GetName().."'s |cffFFD100"..relativePoint)
			end
			ChatFrame1:AddMessage("|cffCC0000----------------------------")
		elseif arg == nil then
			ChatFrame1:AddMessage("Invalid frame name")
		else
			ChatFrame1:AddMessage("Could not find frame info")
		end
	end
	
	---------------------------------------
	SLASH_TYMEEDITMODE1 = "/edit"
	SlashCmdList["TYMEEDITMODE"] = function() 
		ns.toggleFrame("EditModeManagerFrame");	
	end
end

-- --------------------------------------
-- OnLoad Functions
-- --------------------------------------
frame.OnLoad = function(self)
	if ns.settings["initialized"] == false then
		ns.settings["initialized"] = true;
		slashcmds();
		self:SetScript("OnEvent", ns.frameOnEvent);

		--
		-- Register for Events here
		--
		self:RegisterEvent("PLAYER_ENTERING_WORLD");
		self:RegisterEvent("ADDON_LOADED");
		self:RegisterEvent("CHAT_MSG_SYSTEM");
	end
end

-- --------------------------------------
-- Starts Addon
-- --------------------------------------
frame.OnLoad(frame);