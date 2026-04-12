# NixOS Configuration

True dendritic NixOS system using [import-tree](https://github.com/vic/import-tree) for auto-discovery.

## Architecture

```
flake.nix              # 43 lines - entry point
modules/
├── core/              # Base system (7 modules)
├── desktop/           # Desktop environment (3 modules)
├── user/              # User tools (3 modules)
├── server/            # Services (4 modules)
├── hosts/             # Host definitions (4 configs)
└── _legacy/           # Imports (3 files)
```

## Key Principle

**Auto-discovery via import-tree:**
- Add `.nix` file to `modules/` → automatically available
- No manual registration required
- Each file exports `flake.nixosModules.<name>` or `flake.nixosConfigurations.<host>`

## Hosts

| Host | System | Description |
|------|--------|-------------|
| `desktop` | x86_64-linux | Gaming desktop with NVIDIA |
| `laptop` | x86_64-linux | Portable work machine |
| `ancient` | x86_64-linux | RAID server (Jellyfin, Gitea, Samba) |
| `hermes` | aarch64-linux | Rock 4 SE ARM board |

## Usage

```bash
# Build a host
nix build .#nixosConfigurations.desktop.config.system.build.toplevel

# Switch (requires root)
sudo nixos-rebuild switch --flake .#desktop
```

## Structure

- **Core modules:** `modules/core/` - Base system features
- **Desktop modules:** `modules/desktop/` - Hyprland, gaming, hardware
- **User modules:** `modules/user/` - Shell, dev tools, editor
- **Server modules:** `modules/server/` - Gitea, Syncthing, Samba, Media
- **Hosts:** `modules/hosts/*.nix` - Complete system definitions per host
- **Legacy:** `modules/_legacy/` - PostgreSQL, Torzu, Hermes-agent (imported directly)

## Adding Features

1. Create `modules/category/feature.nix`:
```nix
{ self, inputs, ... }:
{
  flake.nixosModules.myfeature = { config, pkgs, ... }: {
    # Your configuration
  };
}
```

2. Import in host config:
```nix
modules = [ self.nixosModules.myfeature ];
```

That's it. Auto-discovery handles the rest.

## Dependencies

- NixOS unstable
- flake-parts
- import-tree (auto-discovery)
- stylix (theming)
- agenix (secrets)
- hyprland (desktop)
- home-manager (user configs)
