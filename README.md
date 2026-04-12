# NixOS Configuration

True dendritic NixOS system using [import-tree](https://github.com/vic/import-tree) for auto-discovery and [flake-parts](https://github.com/hercules-ci/flake-parts) for modular composition.

## Architecture

```
flake.nix              # Entry point - wires everything together
modules/
├── core/              # Base system (base, users, audio, ssh, stylix, tailscale, fonts)
├── display/           # Display/compositor (hyprland)
├── gaming/            # Gaming setup (steam, gamemode, gamescope)
├── hardware/          # Hardware enablement (nvidia, bluetooth)
├── home-manager/      # User-space configurations
│   ├── desktops/      # Desktop environments (hyprland with waybar, mako, config)
│   ├── editors/       # Editor configs (nixvim)
│   ├── shell.nix      # Base home config (username, packages, programs)
│   ├── zsh.nix        # Shell configuration
│   └── git.nix        # Git credentials
├── hosts/             # Host definitions (4 flat configs)
├── server/            # Server services (gitea, syncthing, samba, media)
├── user/              # User applications (dev, editor, shell)
└── _legacy/           # Imports from old structure (3 files)
```

## Key Principle

**Auto-discovery via import-tree:**
- Add `.nix` file to `modules/` → automatically available as `self.nixosModules.<name>`
- No manual registration required in `flake.nix`
- Hosts compose features by listing imports: `modules = [ self.nixosModules.feature ];`

**DRY Home Manager:**
- `modules/home-manager/shell.nix` provides base config (username, packages, programs)
- All hosts import `self.homeModules.shell` instead of duplicating inline
- Desktop-specific configs in `modules/home-manager/desktops/`

## Hosts

| Host | System | Description |
|------|--------|-------------|
| `desktop` | x86_64-linux | Gaming desktop with NVIDIA + Hyprland |
| `laptop` | x86_64-linux | Portable work machine with KDE Plasma |
| `ancient` | x86_64-linux | RAID server (Jellyfin, Gitea, Samba, Syncthing) |
| `hermes` | aarch64-linux | Rock 4 SE ARM board (minimal) |

## Usage

```bash
# Build a host
nix build .#nixosConfigurations.desktop.config.system.build.toplevel

# Switch (requires root)
sudo nixos-rebuild switch --flake .#desktop

# Update flake inputs
nix flake update
```

## Module Categories

### NixOS System Modules
- **Core:** `modules/core/` - Base system (users, audio, ssh, stylix, tailscale, fonts)
- **Display:** `modules/display/` - Hyprland Wayland compositor (system-level)
- **Gaming:** `modules/gaming/` - Steam, gamemode, gamescope, gaming packages
- **Hardware:** `modules/hardware/` - NVIDIA drivers, Bluetooth enablement
- **Server:** `modules/server/` - Gitea, Syncthing, Samba, Media (Jellyfin)
- **User:** `modules/user/` - Dev tools, editor configs, shell enhancements

### Home Manager Modules
- **Base:** `modules/home-manager/shell.nix` - Username, home dir, base packages, programs
- **Shell:** `modules/home-manager/zsh.nix` - Zsh configuration and plugins
- **Editor:** `modules/home-manager/editors/nixvim.nix` - Neovim with plugins
- **Desktop:** `modules/home-manager/desktops/hyprland/` - Modular Hyprland setup
  - `hyprland.nix` - Aggregator (imports all submodules)
  - `waybar.nix` - Status bar configuration
  - `mako.nix` - Notification daemon
  - `config.nix` - Hyprland settings and keybindings

### Host Configurations
- **Flat structure:** `modules/hosts/*.nix` - Each file defines both NixOS and home-manager configs
- Hardware configuration is inline (not separated to avoid import-tree issues)
- Hosts import feature modules from `self.nixosModules.*` and `self.homeModules.*`

## Adding Features

### NixOS System Feature

1. Create `modules/category/feature.nix`:
```nix
{ self, inputs, ... }:
{
  flake.nixosModules.myfeature = { config, pkgs, ... }: {
    # Your NixOS configuration
  };
}
```

2. Import in host config:
```nix
modules = [ 
  self.nixosModules.myfeature 
  # ... other modules
];
```

### Home Manager Feature

1. Create `modules/home-manager/feature.nix`:
```nix
{ self, inputs, ... }:
{
  flake.homeModules.myfeature = { config, pkgs, lib, ... }: {
    # Your home-manager configuration
  };
}
```

2. Import in host's home configuration:
```nix
flake.homeConfigurations.myhost = inputs.home-manager.lib.homeManagerConfiguration {
  modules = [
    self.homeModules.shell    # Base config
    self.homeModules.myfeature # Your feature
  ];
};
```

That's it. Auto-discovery handles module registration.

## Dependencies

- NixOS unstable
- flake-parts (flake composition)
- import-tree (auto-discovery)
- stylix (system-wide theming)
- agenix (secret management)
- hyprland (Wayland compositor)
- home-manager (user configurations)

## Migration Notes

This configuration migrated from a monolithic structure to a true dendritic architecture:

- ✅ Modular home-manager with DRY base config
- ✅ Separated concerns (display/, gaming/, hardware/)
- ✅ Flat host structure with inline hardware (avoids import-tree recursion)
- ✅ Deleted obsolete monolithic files (desktop.nix, editor.nix)
- ✅ All hosts use `self.homeModules.shell` instead of duplicating base config

See `docs/architecture.md` for detailed diagrams and migration history.
