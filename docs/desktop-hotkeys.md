# Desktop hotkeys

## Scope and verification

- Machines: `hearth` (main desktop) and `sputnik` (main laptop), confirmed by the user.
- Repository: https://github.com/mxapd/nixos
- Inspected revision: `6f948c79dcb1d25619e9f2e5b65165b72030c5cb`.
- Documentation reviewed: 2026-10-20.
- Status: configuration-derived draft; running configurations and shortcut behavior have not been verified.
- User-confirmed mouse mapping: `272` = Mouse 1; `273` = Mouse 2.
- No shortcut is marked runtime-tested merely because its definition or helper exists.

### Evidence states

| State | Meaning |
|---|---|
| Declared | Present in an inspected configuration file |
| Included | Import path traced into a host configuration; not a build or deployment verification |
| User-confirmed | A specific fact explicitly confirmed by the user |
| Runtime-tested | Behavior verified on the named machine |
| Unknown | Not established yet |

## Configuration paths

```text
hearth → hyprmoon → hyprland
sputnik → hyprmoon-laptop → hyprmoon → hyprland

hearth / sputnik → hm-xam → custom helper modules
```

- Shared modifier declaration: `$mod = SUPER`.
- The laptop module adds brightness bindings.
- Tables below describe source declarations, not a captured effective configuration.

### Notation caveat

The source uses `$modSHIFT` in many bindings. This document presents those as
`Super + Shift` for readability, reflecting the apparent intended combination.
The generated configuration and runtime interpretation have not been checked.
Do not treat that presentation as proof that the bindings resolve correctly.

`Print` denotes the configured `PRINT` key symbol. Media and brightness rows retain
the exact configured key symbols; physical-key behavior has not been checked.

## Applications and dedicated workspaces

Shared declarations in [Hyprland configuration][hyprland].

| Shortcut | Configured action |
|---|---|
| `Super + Enter` | Run `kitty -e tmux` |
| `Super + D` | Run `wofi --show drun` |
| `Super + W` | Launch `firefox` |
| `Super + E` | Launch `dolphin` |
| `Super + O` | Run `kitty --class tmux-notes -e /etc/profiles/per-user/xam/bin/tmux-notes` |
| `Super + G` | Run `kitty --class tmux-goose -e /etc/profiles/per-user/xam/bin/tmux-goose` |
| `Super + U` | Run `open-clipboard-link` |
| `Super + Shift + U` | Run `search-clipboard` |

### Custom helpers

Definitions are included through [hm-xam][profile]. Execution has not been tested.

| Helper | Behavior established from its definition | Source |
|---|---|---|
| `tmux-notes` | If session `notes` is absent, create it in `$OBSIDIAN_VAULT` and start `nvim`; then attach to `notes` | [Definition][notes] |
| `tmux-goose` | If session `goose` is absent, create it in `$HOME` and start `goose`; then attach to `goose` | [Definition][goose] |
| `open-clipboard-link` | Read the clipboard, extract the first HTTP/HTTPS URL, and open it in a Firefox tab | [Definition][clipboard-url] |
| `search-clipboard` | Read clipboard text, normalize/encode it as a DuckDuckGo query, and open it in a Firefox tab | [Definition][clipboard-search] |

The existing tmux sessions are attached without restarting their original commands.
The configured vault path is `/home/xam/Documents/obsidian/`.
Helper dependency availability, failure paths, and environment propagation remain unverified.

## Windows, workspaces, and session

Shared declarations in [Hyprland configuration][hyprland].

| Shortcut | Configured action / dispatcher |
|---|---|
| `Super + Left` / `Super + H` | `movefocus,l` |
| `Super + Down` / `Super + J` | `movefocus,d` |
| `Super + Up` / `Super + K` | `movefocus,u` |
| `Super + Right` / `Super + L` | `movefocus,r` |
| `Super + Shift + Left` | `movewindow,l` |
| `Super + Shift + Down` | `movewindow,d` |
| `Super + Shift + Up` | `movewindow,u` |
| `Super + Shift + Right` | `movewindow,r` |
| `Super + F` | `fullscreen` |
| `Super + Shift + F` | `togglefloating,active` |
| `Super + Shift + Q` | `killactive` |
| `Super + 1–9` | `workspace,N`, with one declared binding for each digit 1 through 9 |
| `Super + Shift + 1–9` | `movetoworkspacesilent,N`, with one declared binding for each digit 1 through 9 |
| `Super + Shift + M` | Run `hyprctl dispatch exit` (exit the Hyprland session) |

## Mouse bindings

Declared under `bindm` in [Hyprland configuration][hyprland].
The user confirmed button-code labels on 2026-10-20. Actions remain runtime-unverified.

| Input | Raw input code | Configured action / dispatcher |
|---|---|---|
| `Super + Mouse 1` | `$mod, mouse:272` | Move window: `movewindow` |
| `Super + Mouse 2` | `$mod, mouse:273` | Resize window: `resizewindow` |
| `Super + Alt + Mouse 1` | `$mod ALT, mouse:272` | Resize window: `resizewindow` |

## Screenshots

Shared declarations in [Hyprland configuration][hyprland].

| Shortcut | Configured command | Capture mode |
|---|---|---|
| `Print` | `hyprshot -m output` | Output/monitor |
| `Super + Print` | `hyprshot -m window` | Window |
| `Super + Shift + Print` | `hyprshot -m region` | Region |

Configured output directory: `/home/xam/Pictures/Screenshots`.
Both `programs.hyprshot.saveLocation` and `HYPRSHOT_DIR` identify this location.
Actual file creation has not been verified.

## Audio and media

Shared declarations in [Hyprland configuration][hyprland].

| Key symbol | Binding list | Configured command |
|---|---|---|
| `XF86AudioRaiseVolume` | `bindel` | `wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+` |
| `XF86AudioLowerVolume` | `bindel` | `wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-` |
| `XF86AudioMute` | `bindl` | `wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle` |
| `XF86AudioPlay` | `bindl` | `playerctl play-pause` |
| `XF86AudioPrev` | `bindl` | `playerctl previous` |
| `XF86AudioNext` | `bindl` | `playerctl next` |

Binding-list names are retained without asserting tested repeat or lock-screen behavior.

## Laptop brightness

Additions declared in [hyprmoon-laptop][laptop].

| Key symbol | Binding list | Configured command |
|---|---|---|
| `XF86MonBrightnessUp` | `bindel` | `brightnessctl set +5%` |
| `XF86MonBrightnessDown` | `bindel` | `brightnessctl set 5%-` |

## Verification checklist

### Repository inspection completed

- [x] Inspect both host definitions.
- [x] Trace shared desktop composition and laptop additions.
- [x] Inspect shared `bind`, `bindm`, `bindel`, and `bindl` declarations.
- [x] Inspect custom notes, Goose, clipboard-URL, and clipboard-search helpers.
- [x] Verify helper imports in the shared profile.
- [x] Inspect Waybar configuration for separately documented interactions.
- [x] Record user-confirmed Mouse 1 / Mouse 2 code mapping.

### Still open

- [ ] Record the deployed revision on each machine and any uncommitted/local additions.
- [ ] Inspect the generated/effective Hyprland bindings, including `$modSHIFT` handling.
- [ ] Test shortcut behavior separately on `hearth` and `sputnik`.
- [ ] Verify custom helper paths, dependencies, and runtime environment.
- [ ] Verify screenshot creation and location.
- [ ] Confirm media, brightness, and Print key behavior on the actual keyboards.
- [ ] Confirm mouse move/resize behavior on each machine.
- [ ] Check for runtime-loaded configuration or overrides outside the inspected files.

### Runtime results

No shortcut results recorded yet. Add rows as tests are performed.

| Host | Shortcut / group | Result | Test date | Notes |
|---|---|---|---|---|
| — | — | Not yet tested | — | — |

## Coverage boundary

This section inventories the explicit Hyprland shortcut declarations found in the
inspected desktop modules. It does not claim a complete inventory of effective
runtime bindings, upstream defaults, or application shortcuts.

Document separately:

- Waybar click and scroll actions (including clock, audio, and workspace interactions).
- Kitty shortcuts.
- tmux bindings.
- Zsh widgets and aliases.
- Neovim keymaps and plugin mappings.
- Application-specific shortcuts.

## Source files

All links below are pinned to the inspected revision rather than a moving branch.

- [Desktop host][hearth]
- [Laptop host][sputnik]
- [Shared desktop composition][hyprmoon]
- [Shared Hyprland configuration][hyprland]
- [Laptop desktop additions][laptop]
- [Shared personal profile][profile]
- [Notes launcher][notes]
- [Goose launcher][goose]
- [Clipboard URL helper][clipboard-url]
- [Clipboard search helper][clipboard-search]
- [Shared Waybar configuration][waybar]

[hearth]: https://github.com/mxapd/nixos/blob/6f948c79dcb1d25619e9f2e5b65165b72030c5cb/modules/hosts/hearth/hearth.nix
[sputnik]: https://github.com/mxapd/nixos/blob/6f948c79dcb1d25619e9f2e5b65165b72030c5cb/modules/hosts/sputnik/sputnik.nix
[hyprmoon]: https://github.com/mxapd/nixos/blob/6f948c79dcb1d25619e9f2e5b65165b72030c5cb/modules/home/xam/desktops/hyprmoon.nix
[hyprland]: https://github.com/mxapd/nixos/blob/6f948c79dcb1d25619e9f2e5b65165b72030c5cb/modules/home/xam/desktops/hyprland.nix
[laptop]: https://github.com/mxapd/nixos/blob/6f948c79dcb1d25619e9f2e5b65165b72030c5cb/modules/home/xam/desktops/hyprmoon-laptop.nix
[profile]: https://github.com/mxapd/nixos/blob/6f948c79dcb1d25619e9f2e5b65165b72030c5cb/modules/home/xam/xam.nix
[notes]: https://github.com/mxapd/nixos/blob/6f948c79dcb1d25619e9f2e5b65165b72030c5cb/modules/home/xam/tools/tmux-notes.nix
[goose]: https://github.com/mxapd/nixos/blob/6f948c79dcb1d25619e9f2e5b65165b72030c5cb/modules/home/xam/tools/tmux-goose.nix
[clipboard-url]: https://github.com/mxapd/nixos/blob/6f948c79dcb1d25619e9f2e5b65165b72030c5cb/modules/home/xam/tools/open-clipboard-link.nix
[clipboard-search]: https://github.com/mxapd/nixos/blob/6f948c79dcb1d25619e9f2e5b65165b72030c5cb/modules/home/xam/tools/search-clipboard.nix
[waybar]: https://github.com/mxapd/nixos/blob/6f948c79dcb1d25619e9f2e5b65165b72030c5cb/modules/home/xam/desktops/waybar.nix
