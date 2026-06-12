# rc_admin_tags

Overhead staff tags for **ESX (Legacy) & QBCore** FiveM servers.

Shows a configurable floating label (e.g. `OWNER`, `DEVELOPER`, `MODERATOR`) above staff members' heads, toggled with a command.

## Features

- Per-group labels mapped from the framework: ESX groups (`xPlayer.getGroup()`) or QBCore permission levels.
- **Identifier overrides** — force a specific tag for a player by identifier, ignoring their framework group. Required for txAdmin superadmins, whose group ESX forcibly sets to `admin` (logged as *"Superadmin detected, setting group to admin"*), making a custom tag like `DEVELOPER` impossible through the group system alone.
- Distance-based rendering with configurable draw distance, text size, and height offset.
- Optional auto-enable on join, and an option to see your own tag.
- Late-join / resource-restart safe (clients re-sync state on load).

## Install

1. Copy the `rc_admin_tags` folder into your server's `resources` directory.
2. Add to `server.cfg` (after your framework is ensured):
   ```cfg
   ensure rc_admin_tags
   ```
3. Restart the server (or `refresh` + `ensure rc_admin_tags`).

## Usage

In-game, type `/admintag` to toggle your tag on/off.

Each `/admintag` prints the player's `identifier`, `group`, and resolved label to the server console — use this to copy the exact identifier string for `Config.IdentifierOverrides`.

## Configuration

All settings live in `config.lua`:

| Setting | Description |
| --- | --- |
| `Config.Framework` | `auto` (default), `esx`, or `qb`. |
| `Config.Command` | Command to toggle the tag (default `admintag`). |
| `Config.AutoEnableOnJoin` | Auto-show staff tags on join. |
| `Config.SeeOwnTag` | Whether you see your own tag. |
| `Config.DrawDistance` | Max distance (m) a tag is visible. |
| `Config.TextScale` | Tag text size. |
| `Config.HeightOffset` | Height above the player to draw the tag. |
| `Config.GroupLabels` | Framework group/permission → label string. |
| `Config.IdentifierOverrides` | Identifier → label string (wins over group). |

Color codes: `~r~` red, `~g~` green, `~b~` blue, `~y~` yellow, `~o~` orange, `~p~` purple, `~w~` white.

## Requirements

- [es_extended](https://github.com/esx-framework/esx_core) (ESX Legacy) **or** [qb-core](https://github.com/qbcore-framework/qb-core) — auto-detected; set `Config.Framework` to force one.
