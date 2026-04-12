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
        
        subgraph Hosts["hosts/"]
            DT["desktop.nix<br/>nixosConfigurations.desktop<br/>homeConfigurations.desktop"]
            LP["laptop.nix<br/>nixosConfigurations.laptop<br/>homeConfigurations.laptop"]
            AN["ancient.nix"]
            HR["hermes.nix"]
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
│                       │  │ desktop.nix│  │                     │
│                       │  │ laptop.nix│  │                     │
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

### Current Issue: Duplication

```mermaid
flowchart LR
    subgraph "Current State (Hybrid)"
        A["modules/home-manager/shell.nix<br/>Defines: home, packages, programs"]
        B["modules/hosts/desktop.nix<br/>Duplicates: home, packages, programs"]
    end
    
    A -.->|not used| B
    B -->|uses instead| C["homeConfigurations.desktop"]
```

### The Problem Summary

| File | Purpose | Issue |
|------|---------|-------|
| `modules/home-manager/shell.nix` | Dendritic module for base config | Defined but NOT used in hosts |
| `modules/hosts/desktop.nix` | Host config | Has DUPLICATE inline base config |
| `modules/home-manager/desktop.nix` | Old monolithic | Should be deleted |
| `modules/home-manager/editor.nix` | Old nixvim | Should be deleted |

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
