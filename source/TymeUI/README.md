# TymeUI

Personal quality-of-life addon. Standalone: no Ace3, no ElvUI, no external
libraries beyond the three bundled in `Libraries/`.

## What it does

**Slash commands** — `Commands.lua`

| Command | Effect |
| --- | --- |
| `/rl` | Reload the UI |
| `/addon`, `/addons` | Open SimpleAddonManager |
| `/edit` | Toggle Blizzard's Edit Mode |
| `/opt`, `/option`, `/options` | Open Settings on the AddOns tab |

**Data brokers** — `Brokers/`, surfaced by a display addon such as ChocolateBar

- `Tyme-Fps` — framerate and latency; the tooltip lists per-addon memory use and
  clicking forces a garbage collection
- `Tyme-Latency` — home and world latency, with incoming/outgoing bandwidth
- `ClickCastHelper` — launcher that toggles Blizzard's click-binding frame

**Sound pack** — `SoundPack.lua`

Registers the bundled sounds with LibSharedMedia so other addons (DBM,
WeakAuras, ...) can select them. Optional: without LibSharedMedia loaded the
addon works fine, the sounds are just not offered elsewhere.

**Auction sound** — `Features/AuctionSounds.lua`

Plays a cash-register sound when one of your auctions sells.

## Layout

```
TymeUI.toc            load order; every file is listed here explicitly
Core.lua              addon namespace, chat output, event dispatch
SoundPack.lua         sound registration + path lookup
Commands.lua          slash commands
Features/             one file per behaviour
Brokers/              one file per LibDataBroker object
Libraries/            LibStub, CallbackHandler, LibDataBroker
Media/                sounds and broker icons
```

Files are loaded in the order the `.toc` lists them. Each one receives the addon
name and a shared private table as its varargs:

```lua
local ADDON, TymeUI = ...
```

Nothing is written to the global namespace, so nothing here can collide with
another addon.

## Adding a feature

Drop a file in `Features/`, add it to the `.toc` below `Core.lua`, and subscribe
to whatever you need:

```lua
local ADDON, TymeUI = ...

TymeUI:On("PLAYER_ENTERING_WORLD", function(isInitialLogin)
	TymeUI:Print("hello")
end)
```

`TymeUI:On` handles frame creation and registration; handlers are isolated, so
one that errors does not stop the others.

## Building

`build/deploy.cmd <source> <target>` mirrors `source/TymeUI` into the game's
AddOns folder. The **Deploy TymeUI** task in `.vscode/tasks.json` runs it with
the paths already filled in.
