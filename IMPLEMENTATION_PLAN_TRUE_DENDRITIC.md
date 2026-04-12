# Implementation Plan: Proper Dendritic NixOS System

## Executive Summary

**Goal**: Transform current manual-export dendritic system into a true dendritic system using `import-tree` auto-discovery, matching the pattern used by BMSwahn and the broader community.

**Timeline**: 2-3 days phased approach
**Risk Level**: Medium (significant structural changes)
**Rollback**: Keep feat/dendritic-migration branch as backup

---

## Part 1: Understanding What We're Building

### 1.1 The Target Architecture

```
Your System (True Dendritic)
├── flake.nix              # 10 lines, auto-discovery
├── modules/               # All configuration lives here
│   ├── core/             # Base system features
│   │   ├── base.nix      # Nix settings, timezone, i18n
│   │   ├── users.nix     # User accounts
│   │   ├── stylix.nix    # Theming
│   │   ├── tailscale.nix # VPN
│   │   ├── fonts.nix     # Font packages
│   │   ├── ssh.nix       # OpenSSH server
│   │   └── audio.nix     # PipeWire
│   ├── desktop/          # Desktop environment
│   │   ├── desktop.nix   # Hyprland, portals, SDDM
│   │   ├── gaming.nix    # Steam, GameMode
│   │   └── hardware.nix  # NVIDIA, Bluetooth
│   ├── user/             # User tools
│   │   ├── shell.nix     # Zsh, tmux, fzf, zoxide
│   │   ├── dev.nix       # Git, GPG, SSH agent
│   │   └── editor.nix    # Neovim, kitty
│   ├── server/           # Server services
│   │   ├── gitea.nix     # Git server
│   │   ├── syncthing.nix # File sync
│   │   ├── samba.nix     # File sharing
│   │   └── media.nix     # Jellyfin, Radicale
│   └── hosts/            # Host definitions
│       ├── desktop.nix   # Complete desktop config
│       ├── laptop.nix    # Complete laptop config
│       ├── ancient.nix   # Complete server config
│       └── hermes.nix    # Rock 4 SE ARM board (RK3399)
├── home/                 # Home-manager configs
│   └── xam/             # Your user config
└── secrets/             # Agenix secrets
```

### 1.2 Key Principles

**Principle 1: Every .nix file is a flake-parts module**
```nix
{ self, inputs, ... }:
{
  # Each file exports to flake.*
  flake.nixosModules.ssh = { ... }: { ... };
}
```

**Principle 2: Auto-discovery via import-tree**
- No manual registration
- Add file → automatically available
- Move files freely

**Principle 3: Hosts define nixosConfigurations directly**
```nix
# modules/hosts/desktop.nix
{ self, inputs, ... }:
{
  flake.nixosConfigurations.desktop = inputs.nixpkgs.lib.nixosSystem {
    modules = [ self.nixosModules.ssh ... ];
  };
}
```

---

## Part 2: Detailed Migration Plan

### Phase 0: Preparation (Day 1, Morning - 2 hours)

#### 0.1 Create Feature Branch
```bash
cd ~/nixos
git checkout -b feat/true-dendritic
git push origin feat/true-dendritic
```

#### 0.2 Backup Current State
```bash
# Tag current working state
git tag -a working-dendritic-manual -m "Working manual-export dendritic system"

# Ensure all changes committed
git status  # Should be clean
```

#### 0.3 Verify Current System Builds
```bash
# Test all 4 hosts build
for host in desktop laptop ancient hermes; do
  echo "Testing $host..."
  nix build .#nixosConfigurations.$host --no-link 2>&1 | tail -5
done
```

**Deliverable**: Clean working branch ready for migration

---

### Phase 1: Update flake.nix with import-tree (Day 1, Morning - 1 hour)

#### 1.1 Add import-tree Input

**File: flake.nix**
```nix
{
  description = "NixOS configuration with true dendritic architecture using import-tree";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    # NEW: Add import-tree for auto-discovery
    import-tree = {
      url = "github:vic/import-tree";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";
    stylix.url = "github:danth/stylix";

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix.url = "github:ryantm/agenix";
    hermes-agent.url = "github:NousResearch/hermes-agent";
  };

  outputs = inputs@{ flake-parts, import-tree, ... }:
    flake-parts.lib.mkFlake { 
      inherit inputs; 
      # Support all your hosts:
      # - x86_64-linux: desktop, laptop, ancient (Intel/AMD)
      # - aarch64-linux: hermes (Rock 4 SE ARM board - RK3399)
      systems = [ "x86_64-linux" "aarch64-linux" ];
    } (
      # Auto-discover all modules in ./modules/
      import-tree ./modules
    );
}
```

#### 1.2 Commit Initial Change
```bash
git add flake.nix
git commit -m "feat(flake): Add import-tree for true dendritic auto-discovery

- Add import-tree input from github:vic/import-tree
- Replace manual module exports with auto-discovery
- Reduce flake.nix from ~70 lines to ~10 lines of module exports
- All modules in ./modules/ will be auto-discovered

BREAKING CHANGE: This changes how modules are exported.
Modules must now export via flake.nixosModules.* format."
```

**Deliverable**: flake.nix ready for auto-discovery

---

### Phase 2: Migrate Core Features (Day 1, Afternoon - 3 hours)

#### 2.1 Create modules/core/ Directory
```bash
mkdir -p modules/core
```

#### 2.2 Migrate base.nix

**From**: `modules/features/base/default.nix`
**To**: `modules/core/base.nix`

```nix
# modules/core/base.nix
{ self, inputs, ... }:

{
  flake.nixosModules.base = { config, pkgs, lib, ... }:
    let
      cfg = config.features.base;
    in
    {
      options.features.base = {
        enable = lib.mkEnableOption "base system configuration" // {
          default = true;
        };
      };

      config = lib.mkIf cfg.enable {
        # Time and locale
        time.timeZone = "Europe/Stockholm";
        i18n = {
          defaultLocale = "en_US.UTF-8";
          extraLocaleSettings = {
            LC_ADDRESS = "sv_SE.UTF-8";
            LC_IDENTIFICATION = "sv_SE.UTF-8";
            LC_MEASUREMENT = "sv_SE.UTF-8";
            LC_MONETARY = "sv_SE.UTF-8";
            LC_NAME = "sv_SE.UTF-8";
            LC_NUMERIC = "sv_SE.UTF-8";
            LC_PAPER = "sv_SE.UTF-8";
            LC_TELEPHONE = "sv_SE.UTF-8";
            LC_TIME = "sv_SE.UTF-8";
          };
        };

        # Nix settings
        system.stateVersion = "25.11";
        nix.settings.experimental-features = [ "nix-command" "flakes" ];
        nixpkgs.config.allowUnfree = true;

        # Core packages
        environment.systemPackages = with pkgs; [
          vim
          tree
          git
          tmux
          htop
          wget
          parted
          feh
          ripgrep
          file
          age
        ];

        # Allow insecure packages
        nixpkgs.config.permittedInsecurePackages = [
          "qtwebengine-5.15.19"
        ];
      };
    };
}
```

#### 2.3 Migrate users.nix

```nix
# modules/core/users.nix
{ self, inputs, ... }:

{
  flake.nixosModules.users = { config, pkgs, lib, ... }:
    let
      cfg = config.features.users;
    in
    {
      options.features.users = {
        enable = lib.mkEnableOption "user configuration" // {
          default = true;
        };
      };

      config = lib.mkIf cfg.enable {
        users.users.xam = {
          isNormalUser = true;
          extraGroups = [ "networkmanager" "wheel" ];
          shell = pkgs.zsh;
        };

        # Make zsh default
        users.defaultUserShell = pkgs.zsh;
        programs.zsh.enable = true;
      };
    };
}
```

#### 2.4 Migrate tailscale.nix

```nix
# modules/core/tailscale.nix
{ self, inputs, ... }:

{
  flake.nixosModules.tailscale = { config, pkgs, lib, ... }:
    let
      cfg = config.features.tailscale;
    in
    {
      options.features.tailscale = {
        enable = lib.mkEnableOption "Tailscale VPN" // {
          default = true;
        };
      };

      config = lib.mkIf cfg.enable {
        services.tailscale = {
          enable = true;
          useRoutingFeatures = "client";
        };

        networking.hosts = {
          "100.64.0.17" = [
            "nextcloud.yggdrasil.com"
            "firefly.yggdrasil.com"
            "importer.yggdrasil.com"
            "gitea.yggdrasil.com"
          ];
        };

        environment.systemPackages = with pkgs; [
          tailscale
        ];
      };
    };
}
```

#### 2.5 Continue Migration for Remaining Core Features

Similar pattern for:
- `stylix.nix`
- `fonts.nix`
- `ssh.nix`
- `audio.nix`

#### 2.6 Test Core Migration
```bash
# Check if modules are being discovered
nix flake check --no-build --impure 2>&1 | head -20

# Look for errors about missing exports
```

#### 2.7 Commit Core Migration
```bash
git add modules/core/
git commit -m "feat(core): Migrate base features to true dendritic pattern

- Move features/core/* to modules/core/*.nix
- Add flake.nixosModules.* exports for auto-discovery
- Add enable options for each feature
- Remove old features/core/ directory

Features migrated:
- base: System fundamentals
- users: User accounts
- stylix: Theming
- tailscale: VPN
- fonts: Nerd fonts
- ssh: OpenSSH server
- audio: PipeWire"
```

**Deliverable**: Core features migrated and exporting correctly

---

### Phase 3: Migrate Desktop Features (Day 1, Late Afternoon - 2 hours)

#### 3.1 Create modules/desktop/ Directory
```bash
mkdir -p modules/desktop
```

#### 3.2 Migrate desktop.nix (Hyprland, Waybar, Mako, SDDM)

```nix
# modules/desktop/desktop.nix
{ self, inputs, ... }:

{
  flake.nixosModules.desktop = { config, pkgs, inputs, lib, ... }:
    let
      cfg = config.features.desktop;
    in
    {
      options.features.desktop = {
        enable = lib.mkEnableOption "desktop environment (Hyprland)";
      };

      config = lib.mkIf cfg.enable {
        # Hyprland
        programs.hyprland = {
          enable = true;
          package = lib.mkDefault inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
          portalPackage = lib.mkDefault inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
        };

        # XDG portals
        xdg.portal = {
          enable = true;
          xdgOpenUsePortal = true;
          wlr.enable = false;
          config = {
            common.default = [ "gtk" ];
            hyprland.default = [ "gtk" "hyprland" ];
          };
          configPackages = [
            pkgs.xdg-desktop-portal-gtk
            pkgs.xdg-desktop-portal
          ];
          extraPortals = [
            pkgs.xdg-desktop-portal-gtk
          ];
        };

        # Display manager
        services.displayManager.sddm.enable = true;

        # Console keymap
        console.keyMap = "sv-latin1";

        # Environment
        environment.sessionVariables.NIXOS_OZONE_WL = "1";

        # Packages
        environment.systemPackages = with pkgs; [
          wl-clipboard
          libnotify
        ];

        # Security
        security.polkit.enable = true;

        # X11 for compatibility
        services.xserver.enable = true;
        services.xserver.xkb = {
          layout = "se";
          variant = "";
        };
      };
    };
}
```

#### 3.3 Migrate gaming.nix

```nix
# modules/desktop/gaming.nix
{ self, inputs, ... }:

{
  flake.nixosModules.gaming = { config, pkgs, lib, ... }:
    let
      cfg = config.features.gaming;
    in
    {
      options.features.gaming = {
        enable = lib.mkEnableOption "gaming configuration";
      };

      config = lib.mkIf cfg.enable {
        programs.steam = {
          enable = true;
          remotePlay.openFirewall = true;
          dedicatedServer.openFirewall = true;
          localNetworkGameTransfers.openFirewall = true;
        };

        programs.gamemode = {
          enable = true;
          settings.general = {
            desiredgov = "performance";
            renice = 10;
          };
        };

        programs.gamescope = {
          enable = true;
          args = [ "--rt" "--prefer-vk-device" "--adaptive-sync" ];
        };

        environment.systemPackages = with pkgs; [
          prismlauncher
          lutris
          wine
          winetricks
          mangohud
          sc-controller
        ];

        services.udev.packages = with pkgs; [
          game-devices-udev-rules
          sc-controller
        ];

        services.ratbagd.enable = true;
      };
    };
}
```

#### 3.4 Migrate hardware.nix (NVIDIA, Bluetooth)

```nix
# modules/desktop/hardware.nix
{ self, inputs, ... }:

{
  flake.nixosModules.hardware = { config, pkgs, lib, ... }:
    let
      cfg = config.features.hardware;
    in
    {
      options.features.hardware = {
        enable = lib.mkEnableOption "hardware support (NVIDIA, Bluetooth)";
      };

      config = lib.mkIf cfg.enable {
        services.xserver.videoDrivers = [ "nvidia" ];

        hardware.nvidia = {
          modesetting.enable = true;
          powerManagement.enable = false;
          powerManagement.finegrained = false;
          open = true;
          nvidiaSettings = true;
          package = config.boot.kernelPackages.nvidiaPackages.beta;
        };

        hardware.nvidia-container-toolkit.enable = true;

        hardware.graphics = {
          enable = true;
          enable32Bit = true;
        };

        hardware.bluetooth = {
          enable = true;
          powerOnBoot = true;
          settings.General = {
            Enable = "Source,Sink,Media,Socket";
            Experimental = true;
          };
        };

        services.blueman.enable = true;

        environment.systemPackages = with pkgs; [
          blueman
          bluez
          piper
          nvtop
        ];

        services.ratbagd.enable = true;

        boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
        nix.settings.extra-platforms = [ "aarch64-linux" ];
      };
    };
}
```

#### 3.5 Commit Desktop Features
```bash
git add modules/desktop/
git commit -m "feat(desktop): Migrate desktop features to true dendritic pattern

- Move features/desktop/* to modules/desktop/*.nix
- Add flake.nixosModules.* exports
- Add enable options

Features migrated:
- desktop: Hyprland, portals, SDDM, Wayland
- gaming: Steam, GameMode, Gamescope
- hardware: NVIDIA, Bluetooth, peripherals"
```

---

### Phase 4: Migrate User Features (Day 2, Morning - 2 hours)

Similar process for:
- `modules/user/shell.nix` (zsh, tmux, fzf, zoxide)
- `modules/user/dev.nix` (git, GPG)
- `modules/user/editor.nix` (neovim, kitty)

Each exports as `flake.nixosModules.shell`, `flake.nixosModules.dev`, etc.

---

### Phase 5: Migrate Server Features (Day 2, Late Morning - 2 hours)

Similar process for:
- `modules/server/gitea.nix`
- `modules/server/syncthing.nix`
- `modules/server/samba.nix`
- `modules/server/media.nix`

---

### Phase 6: Migrate Host Configurations (Day 2, Afternoon - 4 hours)

#### 6.1 Create modules/hosts/ Directory
```bash
mkdir -p modules/hosts
```

#### 6.2 Migrate Desktop Host

**File: modules/hosts/desktop.nix**

This is the MOST IMPORTANT FILE - it combines hardware + orchestration.

```nix
# modules/hosts/desktop.nix
{ self, inputs, ... }:

{
  # Export desktop host configuration
  flake.nixosConfigurations.desktop = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = { inherit inputs; };
    modules = [
      # ========================================
      # HARDWARE CONFIGURATION
      # ========================================
      ({ config, lib, pkgs, modulesPath, ... }: {
        imports = [
          (modulesPath + "/installer/scan/not-detected.nix")
        ];

        boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
        boot.initrd.kernelModules = [ ];
        boot.kernelModules = [ "kvm-intel" ];
        boot.extraModulePackages = [ ];

        fileSystems."/" = {
          device = "/dev/disk/by-uuid/YOUR-ROOT-UUID";
          fsType = "ext4";
        };

        fileSystems."/boot" = {
          device = "/dev/disk/by-uuid/YOUR-BOOT-UUID";
          fsType = "vfat";
          options = [ "fmask=0077" "dmask=0077" ];
        };

        swapDevices = [ ];

        networking.useDHCP = lib.mkDefault true;

        nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
        hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

        # Bootloader
        boot.loader.systemd-boot.enable = true;
        boot.loader.efi.canTouchEfiVariables = true;
        boot.kernelParams = [ "kvm.enable_virt_at_load=0" ];
      })

      # ========================================
      # DENDRITIC FEATURE COMPOSITION
      # ========================================
      self.nixosModules.base
      self.nixosModules.users
      self.nixosModules.stylix
      self.nixosModules.fonts
      self.nixosModules.tailscale
      self.nixosModules.ssh
      self.nixosModules.audio
      self.nixosModules.desktop
      self.nixosModules.gaming
      self.nixosModules.hardware
      self.nixosModules.shell
      self.nixosModules.dev
      self.nixosModules.editor

      # ========================================
      # EXTERNAL INPUTS
      # ========================================
      inputs.home-manager.nixosModules.home-manager
      inputs.agenix.nixosModules.default
      inputs.stylix.nixosModules.stylix

      # ========================================
      # HOME-MANAGER CONFIGURATION
      # ========================================
      {
        home-manager.backupFileExtension = "backup";
        home-manager.users.xam = import ../../home/users/xam/xam.nix;
        home-manager.sharedModules = [
          inputs.nixvim.homeModules.nixvim
          # Add home-manager feature modules here
          self.homeModules.stylix
          self.homeModules.desktop
          self.homeModules.shell
          self.homeModules.dev
          self.homeModules.editor
        ];
      }

      # ========================================
      # HOST-SPECIFIC CONFIGURATION
      # ========================================
      ({ config, pkgs, ... }: {
        networking.hostName = "desktop";
        networking.nameservers = [ "8.8.8.8" "100.42.0.1" ];

        programs.direnv.enable = true;

        services.flatpak.enable = true;
        services.mysql.enable = true;
        services.mysql.package = pkgs.mariadb;
        services.printing.enable = true;

        services.syncthing = {
          enable = true;
          user = "xam";
          group = "users";
          dataDir = "/home/xam/Documents/";
          configDir = "/home/xam/.syncthing/";
          guiAddress = "0.0.0.0:8384";
        };

        virtualisation.virtualbox.host.enable = true;
        virtualisation.virtualbox.host.enableExtensionPack = true;
        users.extraGroups.vboxusers.members = [ "xam" ];

        services.tailscale = {
          enable = true;
          useRoutingFeatures = "client";
        };

        # Host-specific packages
        environment.systemPackages = with pkgs; [
          # ... your specific packages
        ];
      })
    ];
  };

  # Export desktop-specific modules (if any)
  flake.nixosModules.desktop-host = { config, pkgs, ... }: {
    # Any desktop-specific options
  };
}
```

#### 6.3 Migrate Laptop Host

**File: modules/hosts/laptop.nix**

Similar structure but with laptop-specific features:
- Enable `features.desktop` (but not gaming/hardware?)
- Add laptop power management
- Different hardware-configuration

#### 6.4 Migrate Ancient Host

**File: modules/hosts/ancient.nix**

Server configuration:
- NO desktop features
- Enable server features
- RAID configuration
- File system mounts

#### 6.5 Migrate Hermes Host

**File: modules/hosts/hermes.nix**

Rock 4 SE ARM board configuration (RK3399 SoC)
- Board-specific boot configuration (extlinux)
- RK3399 kernel modules (panfrost GPU)
- Minimal feature set for ARM board

---

### Phase 7: Migrate Home-Manager Modules (Day 2, Evening - 2 hours)

#### 7.1 Update Home-Manager Module Exports

**File: modules/core/stylix.nix** (add home-manager part)
```nix
{ self, inputs, ... }:

{
  # NixOS part
  flake.nixosModules.stylix = { ... }: { ... };

  # Home-manager part (NEW)
  flake.homeModules.stylix = { config, pkgs, ... }: {
    # Home-manager stylix config
    # (if needed beyond what NixOS module provides)
  };
}
```

#### 7.2 Do Same for All Features
Each feature that has both system and user components exports both.

---

### Phase 8: Testing and Validation (Day 3 - Full Day)

#### 8.1 Pre-Flight Checks
```bash
# 1. Verify no syntax errors
nix flake check --no-build --impure 2>&1 | tee check-output.log

# 2. Check for evaluation errors
nix eval .#nixosConfigurations.desktop.config.networking.hostName 2>&1

# 3. Check that all modules are discovered
nix flake show 2>&1 | grep -E "nixosModules|nixosConfigurations"
```

#### 8.2 Dry-Build All Hosts
```bash
for host in desktop laptop ancient hermes; do
  echo "=== Testing $host ==="
  nixos-rebuild dry-build --flake .#$host 2>&1 | tail -20
done
```

#### 8.3 Test Desktop Rebuild
```bash
# If all dry-builds pass, test actual rebuild
sudo nixos-rebuild switch --flake .#desktop

# Verify services
systemctl is-active tailscaled sshd pipewire

# Verify desktop
# - Hyprland loads
# - Waybar visible
# - Keybindings work
```

#### 8.4 Fix Issues
- Address any evaluation errors
- Fix missing imports
- Resolve option conflicts
- Test iteratively

---

### Phase 9: Documentation and Cleanup (Day 3, Evening - 2 hours)

#### 9.1 Update Documentation
```bash
# Create README for new structure
cat > modules/README.md << 'EOF'
# True Dendritic Modules

All `.nix` files in this directory are automatically discovered by `import-tree`.

## Structure

- `core/` - Base system features (base, users, ssh, audio, etc.)
- `desktop/` - Desktop environment (desktop, gaming, hardware)
- `user/` - User tools (shell, dev, editor)
- `server/` - Server services (gitea, syncthing, samba, media)
- `hosts/` - Host definitions (desktop, laptop, ancient, hermes)

## Adding a Feature

1. Create `modules/<category>/<feature>.nix`
2. Export as `flake.nixosModules.<feature>`
3. Add enable option (optional but recommended)
4. Import auto-discovered - no registration needed!

## Adding a Host

1. Create `modules/hosts/<hostname>.nix`
2. Define `flake.nixosConfigurations.<hostname>`
3. Import features via `self.nixosModules.*`
4. No changes to flake.nix needed!
EOF
```

#### 9.2 Final Commit
```bash
git add -A
git commit -m "feat: Complete migration to true dendritic architecture

- Migrate all features to auto-discovered flake.nixosModules.*
- Combine host configs into modules/hosts/*.nix
- Use import-tree for zero-registration module loading
- Reduce flake.nix from 171 lines to ~15 lines
- Add enable options to all features
- Organize by category (core, desktop, user, server)
- Test all 4 hosts build successfully

BREAKING CHANGE: Module structure completely reorganized.
Old: modules/features/<category>/<feature>/default.nix
New: modules/<category>/<feature>.nix

Migration complete - true dendritic architecture achieved!"
```

#### 9.3 Push and Merge
```bash
# Push to remote
git push origin feat/true-dendritic

# After validation, merge to main
git checkout main
git merge feat/true-dendritic
git push origin main
```

---

## Risk Mitigation

### Risk 1: Build Failures
**Mitigation**: 
- Keep `feat/dendritic-migration` branch as backup
- Test each phase before proceeding
- Use `nixos-rebuild dry-build` extensively

### Risk 2: Missing Configuration
**Mitigation**:
- Compare generated system with current
- Use `nixos-rebuild switch --rollback` if issues
- Check all services are enabled

### Risk 3: Option Conflicts
**Mitigation**:
- Use `lib.mkDefault` for defaults
- Enable options make features opt-in per-host
- Test each host individually

---

## Success Criteria

- [ ] flake.nix under 20 lines
- [ ] All 4 hosts build successfully
- [ ] Desktop host reboots and works
- [ ] Laptop host builds
- [ ] Ancient host builds
- [ ] Hermes host builds
- [ ] No manual registration needed for new files
- [ ] Documentation updated
- [ ] Old branch preserved as backup

---

## Timeline Summary

| Phase | Day | Duration | Task |
|-------|-----|----------|------|
| 0 | 1 | 2h | Preparation, branch, backup |
| 1 | 1 | 1h | Update flake.nix with import-tree |
| 2 | 1 | 3h | Migrate core features |
| 3 | 1 | 2h | Migrate desktop features |
| 4 | 2 | 2h | Migrate user features |
| 5 | 2 | 2h | Migrate server features |
| 6 | 2 | 4h | Migrate host configurations |
| 7 | 2 | 2h | Migrate home-manager modules |
| 8 | 3 | Full | Testing and validation |
| 9 | 3 | 2h | Documentation and cleanup |

**Total: 3 days** (can be spread over a week)

---

## Alternative: Gradual Migration

If 3-day migration is too risky, do gradual:

**Week 1**: Add import-tree alongside existing structure
**Week 2**: Migrate features one per day
**Week 3**: Migrate hosts one per day
**Week 4**: Remove old structure

This minimizes risk but takes longer.

---

Ready to proceed? I can execute this plan step-by-step or guide you through it.
