```mermaid
flowchart TB
    subgraph Flake["flake.nix"]
        Inputs
        FP["flake-parts.lib.mkFlake"]
        IT["import-tree ./modules"]
    end

    subgraph Inputs["Inputs"]
        NK["nixpkgs"]
        HM["home-manager"]
        HP["hyprland"]
        ST["stylix"]
        NV["nixvim"]
        AG["agenix"]
        HA["hermes-agent"]
    end

    subgraph Modules["modules/"]
        direction TB
        
        subgraph HomeManager["home-manager/"]
            SH["shell.nix<br/>flake.homeModules.shell"]
            ZS["zsh.nix<br/>flake.homeModules.zsh"]
            GT["git.nix<br/>flake.homeModules.git"]
            
            subgraph Editors["editors/"]
                NVX["nixvim.nix<br/>flake.homeModules.editors.nixvim"]
            end
            
            subgraph Desktops["desktops/"]
                HY["hyprland/hyprland.nix<br/>flake.homeModules.desktops.hyprland"]
            end
            
            OLD1["desktop.nix<br/>(OLD - unused)"]
            OLD2["editor.nix<br/>(OLD - unused)"]
        end
        
        subgraph Hosts["hosts/ (per-host directories)"]
            DT["desktop/desktop.nix<br/>+ hardware-configuration.nix"]
            LP["laptop/laptop.nix<br/>+ hardware-configuration.nix"]
            AN["ancient/ancient.nix<br/>+ hardware-configuration.nix"]
            HR["hermes/hermes.nix<br/>+ hardware-configuration.nix"]
        end
        
        subgraph NixOS["nixosModules/"]
            NB["base"]
            US["users"]
            SD["shell"]
            HYPR["hyprland<br/>(display/)"]
            GM["gaming"]
            NV["nvidia<br/>(hardware/)"]
            BT["bluetooth"]
            etc[...]
        end
    end

    subgraph Outputs["Outputs"]
        NixOS["nixosConfigurations<br/>desktop, laptop, ancient, hermes"]
        HomeConf["homeConfigurations<br/>desktop, laptop"]
        HomeMod["homeModules<br/>shell, zsh, git, editors.nixvim, desktops.hyprland"]
    end

    Inputs --> Flake
    IT --> Modules
    FP --> Outputs
    
    HM -.->|provides lib.homeManagerConfiguration| HomeConf
```

## Architecture Diagram

### Current Structure

```
┌─────────────────────────────────────────────────────────────────┐
│                         flake.nix                                │
│  ┌──────────────┐    ┌─────────────────────┐                  │
│  │   inputs     │───▶│  flake-parts.mkFlake  │                  │
│  │              │    │  + import-tree       │                  │
│  └──────────────┘    └──────────┬──────────┘                  │
│                                  │                              │
│  nixpkgs                        ▼                              │
│  home-manager          ┌─────────────────┐                     │
│  hyprland              │    modules/     │                     │
│  stylix                │                 │                     │
│  nixvim                │  ┌───────────┐  │                     │
│  agenix               │  │home-manager│  │                     │
│  hermes-agent         │  │  shell.nix │  │                     │
│                       │  │  zsh.nix  │  │                     │
│                       │  │  git.nix  │  │                     │
│                       │  │  editors/ │  │                     │
│                       │  │  desktops/│  │                     │
│                       │  └───────────┘  │                     │
│                       │                 │                     │
│                       │  ┌───────────┐  │                     │
│                       │  │  display/ │  │                     │
│                       │  │  hyprland │  │                     │
│                       │  ├───────────┤  │                     │
│                       │  │  gaming/  │  │                     │
│                       │  ├───────────┤  │                     │
│                       │  │  hardware/│  │                     │
│                       │  │  nvidia   │  │                     │
│                       │  │  bluetooth│  │                     │
│                       │  ├───────────┤  │                     │
│                       │  │   hosts/  │  │                     │
│                       │  │ desktop/  │  │                     │
│                       │  │  ├─ hw.nix │  │                     │
│                       │  │  └─ cfg.nix│  │                     │
│                       │  │ laptop/   │  │                     │
│                       │  │ ancient/  │  │                     │
│                       │  │ hermes/   │  │                     │
│                       │  └───────────┘  │                     │
│                       └─────────────────┘                     │
│                                  │                              │
└──────────────────────────────────┼──────────────────────────────┘
                                   ▼
                    ┌──────────────────────────────┐
                    │        Outputs              │
                    │  nixosConfigurations.*     │
                    │  homeConfigurations.*      │
                    │  homeModules.*              │
                    └──────────────────────────────┘
```

### Module Dependency Flow

```mermaid
flowchart LR
    subgraph Hosts["Host Configs (desktop.nix, laptop.nix)"]
        direction TB
        Base["Inline base config<br/>(home, packages, programs)"]
        HM_ZSH["self.homeModules.zsh"]
        HM_GT["self.homeModules.git"]
        HM_NV["self.homeModules.editors.nixvim"]
        HM_HY["self.homeModules.desktops.hyprland"]
    end
    
    subgraph HomeModules["flake.homeModules.*"]
        SH[".shell"]
        ZS[".zsh"]
        GT[".git"]
        NV[".editors.nixvim"]
        HY[".desktops.hyprland"]
    end
    
    Base -->|duplicates| SH
    HM_ZSH --> ZS
    HM_GT --> GT
    HM_NV --> NV
    HM_HY --> HY
    
    style Base fill:#ffcccc
    style SH fill:#ccffcc
```

### Resolved Issues

✅ **DRY Principle Applied**: Hosts now import `self.homeModules.shell` instead of duplicating inline config.

```mermaid
flowchart LR
    subgraph "Current State (Clean)"
        A["modules/home-manager/shell.nix<br/>Defines: home, packages, programs"]
        B["modules/hosts/desktop/desktop.nix<br/>Imports: shell module"]
    end
    
    A -->|used by| B
    B -->|defines| C["homeConfigurations.desktop"]
```

### Architecture Summary

| File | Purpose | Status |
|------|---------|--------|
| `modules/home-manager/shell.nix` | Base home config (username, packages, programs) | ✅ Used by all hosts |
| `modules/hosts/desktop/desktop.nix` | Desktop host config + home setup | ✅ Clean, imports shell |
| `modules/hosts/laptop/laptop.nix` | Laptop host config (KDE) | ✅ Clean, imports shell |
| `modules/home-manager/desktops/hyprland/` | Modular Hyprland (waybar, mako, config) | ✅ Active |
| `modules/home-manager/editors/nixvim.nix` | Nixvim editor config | ✅ Active |

### What Works vs What Doesn't

```
✅ WORKS:
  - NixOS configurations build correctly
  - flake.homeModules.* exports exist
  - import-tree auto-discovers modules
  - hosts can import self.homeModules.*

❌ DOESN'T WORK:
  - shell.nix module not used (duplicated inline)
  - homeConfigurations shows as "unknown" (Nix version)
  - "Self-enabling" pattern (each module imports base) fails
```
