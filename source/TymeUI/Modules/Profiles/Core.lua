local TYMEUI, F, E, I, V, P, G = unpack((select(2, ...)))
local PF = TYMEUI:NewModule("Profiles", "AceHook-3.0")

function PF:MergeElvUIProfile()
  F.Chat('chat', 'Profiles:MergeElvUIProfile()');
  local pf = self:BuildProfile()

  -- Use Debug output in development mode
  local crushFnc = TYMEUI.DevRelease and F.Table.CrushDebug or F.Table.Crush
  
  -- Merge Tables
  crushFnc(E.db, pf)

  -- Set Globals
  crushFnc(E.global, {
    uiScaleInformed = true,

    general = {
      commandBarSetting = "DISABLED",
      --UIScale = F.PixelPerfect(),
    },
  })
end

-- Initialization
function PF:Initialize()
  -- Don't init second time
  if self.Initialized then return end
  F.Chat('chat', 'Profiles:Initialize()');

  self:MergeElvUIProfile()
  self:ElvUIProfilePrivate()
  self:ElvUIProfileGlobal()
  E:UpdateDB()
  -- We actually don't need todo anything, everything is handled by the installer

  -- We are done, hooray!
  self.Initialized = true
end

TYMEUI:RegisterModule(PF:GetName())
