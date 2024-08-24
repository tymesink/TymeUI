local TYMEUI, F, I, E = unpack(TymeUI)
local PF = TYMEUI:NewModule("Profiles", "AceHook-3.0")

PF.db = {}

function TYMEUI:HandleResetProfileCommand(msg)
  TYMEUI:StaticPopup_ResetProfile()
end

function PF:Initialize()
  -- Don't init second time
  if self.Initialized then return end
  TYMEUI:RegisterChatCommand("resetprofile", "HandleResetProfileCommand")

  PF.db = TYMEUI.db.profile.profileModule
  local profileSet = self.db.ProfileHasBeenSet
  if profileSet == nil or profileSet == false then
    F.Chat('chat', 'Setting profiles...');
    
    
    if F.IsAddOnEnabled('ElvUI') then
      self:LoadElvUIProfile()
    end

    if F.IsAddOnEnabled('Details') then
      self:LoadDetailsProfile()
    end

    if F.IsAddOnEnabled('Narcissus') then
      self:LoadNarcissusProfile()
    end
    
    if F.IsAddOnEnabled('EditModeExpanded') then
      self:LoadEditModeExpandedProfile()
    end

    self.db.ProfileHasBeenSet = true
    TYMEUI:StaticPopup_ReloadUI()
  end

  -- We are done, hooray!
  F.Chat('chat', 'Profiles:Initialized()');
  self.Initialized = true
end

TYMEUI:RegisterModule(PF:GetName())
