local TYMEUI, F, I, E = unpack(TymeUI)
local PF = TYMEUI:NewModule("Profiles", "AceHook-3.0")

PF.db = {}

function TYMEUI:HandleResetProfileCommand(msg)
  self.db.ProfileHasBeenSet = false
  TYMEUI:StaticPopup_ReloadUI()
end

function PF:Initialize()
  -- Don't init second time
  if self.Initialized then return end
  F.Chat('chat', 'Profiles:Initialize()');
  PF.db = TYMEUI.db.profile.profileModule
  
  local profileSet = self.db.ProfileHasBeenSet
  if profileSet == nil or profileSet == false then
    self:MergeElvUIProfile()
    self.db.ProfileHasBeenSet = true
    TYMEUI:StaticPopup_ReloadUI()
  end
  
  TYMEUI:RegisterChatCommand("resetprofile", "HandleResetProfileCommand")

  -- We are done, hooray!
  self.Initialized = true
end

TYMEUI:RegisterModule(PF:GetName())
