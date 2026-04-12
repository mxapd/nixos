# How Dendritic Works in YOUR System - Practical Guide

## The Big Picture (Simple Version)

Think of it like building with LEGO blocks:

**Traditional Approach:**
- You have a big box of mixed LEGO
- For each house you build, you dump out pieces and assemble from scratch
- House 1 and House 2 both use red bricks, but you find them separately each time

**Dendritic Approach:**
- You organize LEGO by type first: all red bricks together, all blue bricks together
- When building a house, you say "give me red bricks and blue bricks"
- The red bricks are already organized, you just use them

In NixOS terms:
- **Features** = Organized LEGO sets (SSH, Desktop, Gaming, etc.)
- **Hosts** = Houses that combine LEGO sets
- **flake.nix** = The storage system that makes LEGO sets available

---

## Step-by-Step: How Your System Actually Works

### Step 1: flake.nix - The "Store"

```nix
# flake.nix
{
  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      flake = {
        # This section is like a store shelf
        # Each item is a "feature pack" you can use
        nixosModules = {
          # Feature packs for system (NixOS)
          features-ssh = import ./modules/features/ssh/default.nix;      # ← SSH pack
          features-desktop = import ./modules/features/desktop/default.nix;  # ← Desktop pack
          features-gaming = import ./modules/features/gaming/default.nix;    # ← Gaming pack
          # ... etc
          
          # Host packs (orchestrators)
          hosts-desktop = import ./modules/hosts/desktop/default.nix;  # ← Desktop host recipe
        };
      };
    };
}
```

**What this does:**
- Takes files from `modules/features/ssh/default.nix` and makes them available as `features-ssh`
- It's like putting a product on a store shelf with a label

---

### Step 2: Feature Module - The "LEGO Set"

```nix
# modules/features/ssh/default.nix
{ config, pkgs, ... }:

{
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };
}
```

**What this is:**
- A complete SSH configuration in ONE file
- It "knows" everything about SSH for your system
- It's a self-contained LEGO set

---

### Step 3: Host Orchestrator - The "Recipe"

```nix
# modules/hosts/desktop/default.nix
{ config, pkgs, inputs, ... }:

{
  imports = [
    # "Give me these feature packs from the store"
    inputs.self.nixosModules.features-ssh        # ← Uses SSH pack
    inputs.self.nixosModules.features-desktop    # ← Uses Desktop pack
    inputs.self.nixosModules.features-gaming     # ← Uses Gaming pack
    # ... etc
  ];
}
```

**What this does:**
- Says "for desktop host, I want SSH + Desktop + Gaming + ..."
- It's like a shopping list from the store
- Doesn't define SSH config, just says "use the SSH pack"

**Breakdown of `inputs.self.nixosModules.features-ssh`:**
- `inputs` = all your flake inputs (nixpkgs, home-manager, etc.)
- `inputs.self` = your own flake (this flake.nix)
- `inputs.self.nixosModules` = the `nixosModules` section we defined
- `inputs.self.nixosModules.features-ssh` = the SSH feature pack

---

### Step 4: Host Definition - The "Build Site"

```nix
# hosts/desktop/configuration.nix (what you have now - minimal)
{ config, pkgs, inputs, ... }:

{
  # Hardware-specific stuff only
  boot.loader.systemd-boot.enable = true;
  networking.hostName = "desktop";
  
  # Some host-specific packages
  environment.systemPackages = with pkgs; [
    firefox
    discord
  ];
}
```

**What this is:**
- The ACTUAL location of your host config
- Has ONLY things unique to desktop
- Does NOT have SSH, Desktop, Gaming config (those come from dendritic modules)

---

### Step 5: The Final Assembly - nixosConfigurations

```nix
# From flake.nix
nixosConfigurations = {
  desktop = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      # Layer 1: Hardware (traditional)
      ./hosts/desktop/configuration.nix          # ← Host-specific stuff
      ./hosts/desktop/hardware-configuration.nix  # ← Auto-generated hardware
      
      # Layer 2: External inputs
      inputs.home-manager.nixosModules.home-manager  # ← Home-manager module
      inputs.agenix.nixosModules.default            # ← Agenix secrets
      inputs.stylix.nixosModules.stylix             # ← Stylix theming
      
      # Layer 3: DENDRITIC - Feature composition
      inputs.self.nixosModules.hosts-desktop        # ← THIS IS THE MAGIC
    ];
  };
}
```

**What happens when you run `nixos-rebuild`:**

1. Nix reads `nixosConfigurations.desktop`
2. It loads ALL modules in order:
   - First: `configuration.nix` (hardware-specific)
   - Second: `hardware-configuration.nix` (auto-generated)
   - Third: `home-manager` module
   - Fourth: `agenix`, `stylix` modules
   - **Fifth: `hosts-desktop` (our orchestrator)**
3. The orchestrator says "I need features-ssh, features-desktop, etc."
4. Those features are loaded and merged
5. Final system is built

---

## Visual Flow Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                        flake.nix                             │
│                                                              │
│  ┌─────────────────┐  ┌─────────────────┐  ┌──────────────┐  │
│  │ features-ssh    │  │ features-desktop│  │ hosts-desktop│  │
│  │   (SSH pack)    │  │  (Desktop pack) │  │  (Recipe)    │  │
│  └────────┬────────┘  └────────┬────────┘  └──────┬───────┘  │
└───────────┼────────────────────┼──────────────────┼──────────┘
            │                    │                  │
            │                    │                  │
            └────────────────────┴──────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────┐
│                    modules/hosts/desktop/                    │
│                                                              │
│  imports = [                                                   │
│    inputs.self.nixosModules.features-ssh,      ← Uses SSH    │
│    inputs.self.nixosModules.features-desktop,  ← Uses Desktop│
│    inputs.self.nixosModules.features-gaming,  ← Uses Gaming│
│    ...                                                       │
│  ];                                                          │
└──────────────────────────────┬────────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────┐
│              modules/features/ssh/default.nix                │
│                                                              │
│  services.openssh = {                                        │
│    enable = true;                                            │
│    settings.PasswordAuthentication = false;                 │
│  };                                                          │
└──────────────────────────────┬────────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────┐
│                    nixos-rebuild switch                     │
│                                                              │
│  Merges all modules together:                                │
│  1. Hardware config (from hosts/desktop/)                   │
│  2. Dendritic features (from modules/features/)              │
│  3. Home-manager (from inputs)                             │
│  4. Stylix (from inputs)                                     │
│                                                              │
│  Result: Complete NixOS system                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Real Example: Adding SSH to a New Host

### Traditional Way (what you had before):

```nix
# hosts/newhost/configuration.nix
{ config, pkgs, ... }:

{
  # Copy SSH config from desktop (DUPLICATION!)
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };
  
  # Copy more config from desktop...
  # ... 200 lines of duplication
}
```

**Problem**: SSH config exists in 2+ places. Change it? Edit multiple files.

---

### Dendritic Way (what you have now):

```nix
# Step 1: Create orchestrator
# modules/hosts/newhost/default.nix
{ config, pkgs, inputs, ... }:

{
  imports = [
    inputs.self.nixosModules.features-ssh        # ← Just import it!
    inputs.self.nixosModules.features-base
    # ... whatever else you need
  ];
}

# Step 2: Add to flake.nix
{
  nixosModules = {
    # ... existing features ...
    hosts-newhost = import ./modules/hosts/newhost/default.nix;
  };
  
  nixosConfigurations = {
    newhost = inputs.nixpkgs.lib.nixosSystem {
      modules = [
        ./hosts/newhost/configuration.nix
        ./hosts/newhost/hardware-configuration.nix
        inputs.self.nixosModules.hosts-newhost  # ← Uses dendritic
      ];
    };
  };
}
```

**Benefit**: SSH config is in ONE place (`features-ssh`). New host just imports it.

---

## Key Insight: Three Layers

Your system has 3 distinct layers:

### Layer 1: Hardware/Host-Specific (Traditional)
- Location: `hosts/desktop/configuration.nix`
- Contains: Bootloader, hostname, unique packages
- Example: `boot.loader.systemd-boot.enable = true;`

### Layer 2: Dendritic Features (The Magic)
- Location: `modules/features/*/default.nix`
- Contains: Reusable config (SSH, Desktop, Gaming)
- Example: `features-ssh` defines SSH for ALL hosts

### Layer 3: Host Orchestrators (The Glue)
- Location: `modules/hosts/*/default.nix`
- Contains: Which features each host uses
- Example: `hosts-desktop` imports 16 features

**The flow**: 
1. `nixosConfigurations.desktop` loads orchestrator
2. Orchestrator imports features
3. Features provide actual config
4. Host config adds hardware-specific stuff

---

## Common Confusion Points

### "Why do we have both `hosts/desktop/configuration.nix` AND `modules/hosts/desktop/default.nix`?"

**Great question!** They serve different purposes:

```
hosts/desktop/configuration.nix          (Layer 1 - Hardware)
├─ Bootloader settings
├─ Hostname
├─ Unique packages (firefox, discord)
└─ Hardware-specific stuff

modules/hosts/desktop/default.nix        (Layer 3 - Orchestrator)
├─ Just imports! No actual config here
├─ Says "use SSH feature"
├─ Says "use Desktop feature"
└─ Acts as a "recipe card"
```

**Analogy:**
- `hosts/desktop/configuration.nix` = The actual construction site with foundation
- `modules/hosts/desktop/default.nix` = The recipe card saying "use brick type A, wood type B"
- `modules/features/ssh/` = The pre-made brick type A

### "What is `inputs.self.nixosModules`?"

Break it down:
- `inputs` = all flake inputs (nixpkgs, home-manager, your flake, etc.)
- `inputs.self` = YOUR flake (the flake.nix we're in)
- `inputs.self.nixosModules` = the `nixosModules` attribute we defined
- `inputs.self.nixosModules.features-ssh` = the SSH module

It's like saying "from my own flake, get the SSH feature I defined"

### "Why not put everything in flake.nix?"

You could! But then:
- flake.nix would be 1000+ lines
- Hard to find things
- No separation of concerns
- Can't reuse features easily

Dendritic pattern splits it up so:
- Each feature is a small file (easy to understand)
- Hosts compose features (easy to configure)
- flake.nix just exports them (minimal)

---

## Testing Your Understanding

**Q1**: If you want to change SSH port for ALL hosts, where do you edit?
**A1**: `modules/features/ssh/default.nix` (ONE file, affects ALL hosts)

**Q2**: If you want to add Gaming to laptop, what do you do?
**A2**: Edit `modules/hosts/laptop/default.nix`, add `features-gaming` to imports

**Q3**: Where is the actual SSH config defined?
**A3**: `modules/features/ssh/default.nix` - that's the source of truth

**Q4**: What does `hosts-desktop` actually do?
**A4**: It's just a list! It says "for desktop, import these features"

**Q5**: Why can we move features between hosts easily?
**A5**: Because features are self-contained. Just change the imports list.

---

## Summary: The "Aha!" Moment

**Traditional thinking:**
> "I need to configure a desktop, so I'll write all the config for it"

**Dendritic thinking:**
> "I need to enable the SSH feature, Desktop feature, and Gaming feature on this host"

The difference:
- Traditional: **Host defines what it has** (leads to duplication)
- Dendritic: **Features define what they provide** (leads to reuse)

**Your system now:**
- ✅ SSH is defined ONCE in `features-ssh`
- ✅ Desktop imports SSH (reuses it)
- ✅ Laptop imports SSH (reuses it)
- ✅ Ancient imports SSH (reuses it)
- ✅ Change SSH in 1 place, all hosts get it

That's the power of dendritic architecture! 🌳
