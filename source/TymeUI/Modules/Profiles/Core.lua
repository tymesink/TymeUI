local TYMEUI, F, I, E = unpack(TymeUI)
local PF = TYMEUI:NewModule("Profiles", "AceHook-3.0")
local _G = _G

PF.db = {}

function TYMEUI:HandleResetProfileCommand(msg)
  TYMEUI:StaticPopup_ResetProfile()
end

function TYMEUI:HandleResetElvUIProfileCommand(msg)
  TYMEUI:StaticPopup_ResetElvUIProfile()
end

--PF:DetailsResetProfile()
function TYMEUI:HandleResetDetailsProfileCommand(msg)
  PF:DetailsResetProfile()
  TYMEUI:StaticPopup_ReloadUI()
end

function PF:Initialize()
  -- Don't init second time
  if self.Initialized then return end
  TYMEUI:RegisterChatCommand("resetprofile", "HandleResetProfileCommand")
  TYMEUI:RegisterChatCommand("resetelv", "HandleResetElvUIProfileCommand")
  TYMEUI:RegisterChatCommand("resetdetails", "HandleResetDetailsProfileCommand")

  PF.db = TYMEUI.db.profile.profileModule

  -- Check if the install NOT completed
  if not E.private.install_complete then
    F.Chat('chat', 'Profiles:ElvUI install not complete, skipping profile setup');
    return
  end

  local reloadui = false;
  local profileSet = self.db.ProfileHasBeenSet
  if profileSet == nil or profileSet == false then
    F.Chat('chat', 'Setting profiles...');

    if F.IsAddOnEnabled('Details') then
      self:LoadDetailsProfile()
    end

    if F.IsAddOnEnabled('Narcissus') then
      self:LoadNarcissusProfile()
    end
    
    if F.IsAddOnEnabled('EditModeExpanded') then
      self:LoadEditModeExpandedProfile()
    end

    if F.IsAddOnEnabled('Masque') then
      self:LoadMasqueProfile()
    end

    self.db.ProfileHasBeenSet = true
    reloadui = true;
  end

  local elvuiProfileHasBeenSet = self.db.ElvUIProfileHasBeenSet
  if elvuiProfileHasBeenSet == nil or elvuiProfileHasBeenSet == false then
    F.Chat('chat', 'Setting profiles...');

    if F.IsAddOnEnabled('ElvUI') then
      self:LoadElvUIProfile()
    end

    self.db.ElvUIProfileHasBeenSet = true
    reloadui = true;
  end

  if reloadui then
    TYMEUI:StaticPopup_ReloadUI()
  end

  -- We are done, hooray!
  F.Chat('chat', 'Profiles:Initialized()');
  self.Initialized = true
end

TYMEUI:RegisterModule(PF:GetName())
