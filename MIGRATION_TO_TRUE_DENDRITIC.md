# Migration Guide: Move Toward True Dendritic (Like Your Friend's)

## Goal

Transform your current manual-export dendritic system into a **true dendritic** system like your friend BMSwahn's, using `import-tree` for auto-discovery.

## Current State vs Target State

### Current (feat/dendritic-migration)

```
flake.nix (171 lines)
├── Manual exports of 17 features + 4 hosts
└── nixosConfigurations import hosts-XXX modules

modules/
├── features/              # Nested by category
│   ├── core/
│   ├── desktop/
│   ├── user/
│   └── server/
└── hosts/                 # Orchestrators only
    ├── desktop/
    ├── laptop/
    ├── ancient/
    └── hermes/

hosts/                     # Hardware configs separate
├── desktop/
├── laptop/
├── ancient/
└── hermes/
```

### Target (Like BMSwahn's True Dendritic)

```
flake.nix (10 lines)
└── import-tree ./modules  # Auto-discovers everything

modules/                   # Flat structure
├── core/                  # Was features/core
│   ├── base.nix
│   ├── users.nix
│   └── ...
├── desktop/               # Was features/desktop
│   ├── desktop.nix
│   ├── gaming.nix
│   └── ...
├── user/                  # Was features/user
├── server/                # Was features/server
├── hosts/                 # Host definitions (moved from hosts/)
│   ├── desktop.nix        # Includes hardware + orchestration
│   ├── laptop.nix
│   ├── ancient.nix
│   └── hermes.nix
└── home/                  # Home-manager (optional)
```

---

## Step-by-Step Migration Plan

### Phase 1: Add import-tree Input

**File: flake.nix**

```nix
{
  description = "NixOS configuration with true dendritic architecture";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    # ADD THIS:
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
      systems = [ "x86_64-linux" "aarch64-linux" ];
    } (
      # REPLACE manual exports with auto-discovery:
      import-tree ./modules
    );
}
```

**What this does:**
- Adds import-tree as an input
- Replaces ~70 lines of manual exports with 1 line of auto-discovery
- import-tree finds and loads ALL .nix files in modules/

---

### Phase 2: Flatten Module Structure

**Current structure:**
```
modules/
├── features/core/base/default.nix
├── features/desktop/desktop/default.nix
└── hosts/desktop/default.nix
```

**Target structure (like BMSwahn's):**
```
modules/
├── core/base.nix              # Renamed from features/core/base/default.nix
├── desktop/desktop.nix        # Renamed from features/desktop/desktop/default.nix
└── hosts/desktop.nix          # Combined from hosts/desktop/ + hardware
```

**Commands to execute:**

```bash
# 1. Move features/core/* to modules/core/
cd ~/nixos/modules
mkdir -p core desktop user server
mv features/core/base/default.nix core/base.nix
mv features/core/users/default.nix core/users.nix
mv features/core/stylix/default.nix core/stylix.nix
mv features/core/tailscale/default.nix core/tailscale.nix
mv features/core/fonts/default.nix core/fonts.nix
mv features/core/ssh/default.nix core/ssh.nix
mv features/core/audio/default.nix core/audio.nix

# 2. Move features/desktop/* to modules/desktop/
mv features/desktop/desktop/default.nix desktop/desktop.nix
mv features/desktop/gaming/default.nix desktop/gaming.nix
mv features/desktop/hardware/default.nix desktop/hardware.nix

# 3. Move features/user/* to modules/user/
mv features/user/shell/default.nix user/shell.nix
mv features/user/dev/default.nix user/dev.nix
mv features/user/editor/default.nix user/editor.nix

# 4. Move features/server/* to modules/server/
mv features/server/gitea/default.nix server/gitea.nix
mv features/server/syncthing/default.nix server/syncthing.nix
mv features/server/samba/default.nix server/samba.nix
mv features/server/media/default.nix server/media.nix

# 5. Remove old features/ directory
rm -rf features/

# 6. Update module files to export correctly (see Phase 3)
```

---

### Phase 3: Update Module Files to Export Correctly

**Current (manual export pattern):**
```nix
# modules/features/ssh/default.nix
{ config, pkgs, ... }:

{
  services.openssh = {
    enable = true;
    # ...
  };
}
```

**Target (auto-discovery pattern):**
```nix
# modules/core/ssh.nix
{ self, inputs, ... }:

{
  # Export as nixosModules.ssh
  flake.nixosModules.ssh = { config, pkgs, ... }: {
    services.openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "no";
      };
    };
  };
}
```

**Key change:** Each module now exports itself via `flake.nixosModules.XXX` instead of being imported in flake.nix.

**Template for all feature modules:**

```nix
# modules/<category>/<feature>.nix
{ self, inputs, ... }:

{
  # Export the feature
  flake.nixosModules.<feature> = { config, pkgs, lib, ... }:
    let
      cfg = config.features.<feature>;
    in
    {
      # Optional: Add enable option for flexibility
      options.features.<feature> = {
        enable = lib.mkEnableOption "<feature> configuration";
      };

      config = lib.mkIf cfg.enable {
        # Your feature configuration here
      };
    };
}
```

---

### Phase 4: Combine Host Files (Like BMSwahn's Pattern)

**Current (split approach):**
```
modules/hosts/desktop/default.nix    # Orchestrator only
hosts/desktop/configuration.nix      # Hardware config
hosts/desktop/hardware-configuration.nix  # Auto-generated
```

**Target (combined approach):**
```
modules/hosts/desktop.nix            # Everything in one file
```

**Example: modules/hosts/desktop.nix**

```nix
{ self, inputs, ... }:

{
  # Export the desktop host configuration
  flake.nixosConfigurations.desktop = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = { inherit inputs; };
    modules = [
      # Hardware (was in hosts/desktop/hardware-configuration.nix)
      ({ config, lib, pkgs, modulesPath, ... }: {
        imports = [
          (modulesPath + "/installer/scan/not-detected.nix")
        ];
        
        boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
        boot.initrd.kernelModules = [ ];
        boot.kernelModules = [ "kvm-intel" ];
        boot.extraModulePackages = [ ];
        
        fileSystems."/" = {
          device = "/dev/disk/by-uuid/xxx";
          fsType = "ext4";
        };
        
        # ... rest of hardware config
      })
      
      # Feature composition (was in modules/hosts/desktop/default.nix)
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
      
      # External modules
      inputs.home-manager.nixosModules.home-manager
      inputs.agenix.nixosModules.default
      inputs.stylix.nixosModules.stylix
      
      # Home-manager configuration
      {
        home-manager.backupFileExtension = "backup";
        home-manager.users.xam = import ../../home/users/xam/xam.nix;
        home-manager.sharedModules = [
          inputs.nixvim.homeModules.nixvim
        ];
      }
      
      # Host-specific config (was in hosts/desktop/configuration.nix)
      ({ config, pkgs, ... }: {
        networking.hostName = "desktop";
        networking.nameservers = [ "8.8.8.8" "100.42.0.1" ];
        
        programs.direnv.enable = true;
        
        services.flatpak.enable = true;
        services.mysql.enable = true;
        services.mysql.package = pkgs.mariadb;
        services.printing.enable = true;
        
        # ... rest of host-specific config
      })
    ];
  };
}
```

**Note:** This combines hardware, orchestration, and host-specific config into ONE file, like BMSwahn's pattern.

---

### Phase 5: Clean Up Old Directory Structure

```bash
# Remove old hosts/ directory (now in modules/hosts/)
cd ~/nixos
rm -rf hosts/

# Remove old modules/features/ (flattened)
rm -rf modules/features/
rm -rf modules/hosts/  # Old orchestrators

# Verify new structure
find modules/ -name "*.nix" | head -20
```

**Target structure should be:**
```
modules/
├── core/
│   ├── base.nix
│   ├── users.nix
│   ├── stylix.nix
│   ├── tailscale.nix
│   ├── fonts.nix
│   ├── ssh.nix
│   └── audio.nix
├── desktop/
│   ├── desktop.nix
│   ├── gaming.nix
│   └── hardware.nix
├── user/
│   ├── shell.nix
│   ├── dev.nix
│   └── editor.nix
├── server/
│   ├── gitea.nix
│   ├── syncthing.nix
│   ├── samba.nix
│   └── media.nix
└── hosts/
    ├── desktop.nix      # Combined host config
    ├── laptop.nix
    ├── ancient.nix
    └── hermes.nix
```

---

### Phase 6: Test the Migration

```bash
# 1. Update flake.lock with new import-tree
nix flake update

# 2. Check flake structure
nix flake check --no-build --impure

# 3. Dry-build desktop
nixos-rebuild dry-build --flake .#desktop

# 4. If successful, test switch
sudo nixos-rebuild switch --flake .#desktop
```

---

## Complete Example: Before vs After

### Before (Current Manual Export)

**flake.nix:**
```nix
{
  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      nixosModules = {
        features-ssh = import ./modules/features/ssh/default.nix;
        features-desktop = import ./modules/features/desktop/default.nix;
        hosts-desktop = import ./modules/hosts/desktop/default.nix;
      };
      
      nixosConfigurations.desktop = inputs.nixpkgs.lib.nixosSystem {
        modules = [
          ./hosts/desktop/configuration.nix
          ./hosts/desktop/hardware-configuration.nix
          inputs.self.nixosModules.hosts-desktop
        ];
      };
    };
}
```

### After (True Dendritic with import-tree)

**flake.nix:**
```nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";
    # ... other inputs
  };

  outputs = inputs@{ flake-parts, import-tree, ... }:
    flake-parts.lib.mkFlake { 
      inherit inputs;
      systems = [ "x86_64-linux" "aarch64-linux" ];
    } (
      import-tree ./modules
    );
}
```

**modules/core/ssh.nix:**
```nix
{ self, ... }:

{
  flake.nixosModules.ssh = { config, pkgs, ... }: {
    services.openssh = {
      enable = true;
      settings.PasswordAuthentication = false;
    };
  };
}
```

**modules/hosts/desktop.nix:**
```nix
{ self, inputs, ... }:

{
  flake.nixosConfigurations.desktop = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      # Hardware
      ({ ... }: { imports = [ ./hardware.nix ]; })  # Or inline
      
      # Features
      self.nixosModules.ssh
      self.nixosModules.desktop
      self.nixosModules.gaming
      # ...
      
      # Host-specific
      ({ ... }: {
        networking.hostName = "desktop";
      })
    ];
  };
}
```

---

## Benefits of This Migration

1. **Zero registration**: Add a file → it's automatically available
2. **Minimal flake.nix**: 10 lines instead of 171
3. **Community standard**: Same pattern as BMSwahn, Vic, etc.
4. **File freedom**: Move files without updating imports
5. **Scalability**: Easier to add features and hosts

## Trade-offs

1. **More complex**: Need to understand import-tree
2. **Harder debugging**: Auto-discovery makes tracing harder
3. **Magic vs explicit**: Less clear what's loaded
4. **Migration effort**: Significant refactoring required

## Recommendation

**Short term**: Stay with your current working implementation

**Long term**: Gradually migrate to true dendritic:
1. Start with one host (desktop)
2. Test thoroughly
3. Migrate remaining hosts one by one
4. Keep the old branch as backup

**Alternative**: Keep current structure but add import-tree gradually:
```nix
# Hybrid approach
outputs = inputs@{ flake-parts, import-tree, ... }:
  flake-parts.lib.mkFlake { 
    inherit inputs;
    systems = [ "x86_64-linux" "aarch64-linux" ];
  } (
    {
      # Keep manual exports for now
      nixosModules = { ... };
    }
    # Add new modules via import-tree
    // (import-tree ./modules/new-features)
  );
```

---

## Next Steps

Would you like me to:
1. **Execute this migration** on your current branch?
2. **Create a test branch** with the new structure?
3. **Start with a hybrid approach** (gradual transition)?
4. **Focus on specific parts** (e.g., just add import-tree first)?
