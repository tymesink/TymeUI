# TymeUI AI Guide

Personal World of Warcraft addon (Retail, Interface 120100). Standalone: no
Ace3, no ElvUI. The only libraries are LibStub, CallbackHandler and
LibDataBroker, all bundled under `source/TymeUI/Libraries`.

## Structure

Everything loads in the order [source/TymeUI/TymeUI.toc](source/TymeUI/TymeUI.toc)
lists it. There are no `Load.xml` files and no module registry.

- [Core.lua](source/TymeUI/Core.lua) — the shared namespace. Defines
  `TymeUI:Print(message)`, `TymeUI:On(event, handler)`, and the `prefix` /
  `mediaPath` / `soundPath` fields.
- [Commands.lua](source/TymeUI/Commands.lua) — slash commands: `/rl`,
  `/addon`+`/addons`, `/edit`, `/opt`+`/option`+`/options`.
- [Features/](source/TymeUI/Features) — one file per behaviour.
  `AuctionSounds.lua` plays a sound on auction-sold system messages.
- [Brokers/](source/TymeUI/Brokers) — one file per LibDataBroker object.
  `Performance.lua` publishes the FPS and latency readouts; `ClickCastHelper.lua`
  publishes a launcher.

## Conventions

- Every file begins `local ADDON, TymeUI = ...` and puts nothing in the global
  namespace. Do not create new globals; add to the `TymeUI` table instead.
- Subscribe to events with `TymeUI:On(event, handler)` rather than creating a
  frame. Handlers receive the event's own arguments and run under `xpcall`, so
  one that errors does not stop the others.
- Localise hot globals at the top of a file (`local format = string.format`),
  matching the existing files.
- Prefer the modern `C_AddOns.*` namespace. Do not add the old
  `(C_AddOns and C_AddOns.X) or X` fallback pattern; this addon is Retail-only.
- LibDataBroker object names are part of other addons. saved settings. Renaming
  one silently resets whatever had it selected, so treat them as fixed.
- The shared sound pack lives in the sibling addon TymeUI_ChatNotify, which
  registers it with LibSharedMedia. Do not re-register those sounds here.
- There are no saved variables. If a feature needs to persist state, add
  `## SavedVariables` to the toc deliberately rather than assuming one exists.

## Adding a feature

Create a file under `Features/`, list it in the toc below `Core.lua`, and
subscribe to what you need:

```lua
local ADDON, TymeUI = ...

TymeUI:On("PLAYER_ENTERING_WORLD", function(isInitialLogin)
	TymeUI:Print("hello")
end)
```

## Verifying

- Syntax-check touched files before testing in-game (the Lua language server in
  VS Code, or `get_errors`).
- Deploy with the **Deploy TymeUI** VS Code task, which runs
  [build/deploy.cmd](build/deploy.cmd). It mirrors with `robocopy /MIR`, so
  files removed from source are removed from the game folder too. Close WoW
  first to avoid file locks.
- In game: `/console scriptErrors 1`, then `/rl`, then exercise the slash
  commands and hover both brokers.
