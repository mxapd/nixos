# modules/hosts/laptop/default.nix
# Laptop host configuration - dendritic feature enablement

{ config, pkgs, inputs, ... }:

{
  imports = [
    # Enable features for laptop
    inputs.self.nixosModules.features-base
    inputs.self.nixosModules.features-users
    inputs.self.nixosModules.features-stylix
    inputs.self.nixosModules.features-fonts
    inputs.self.nixosModules.features-tailscale
    inputs.self.nixosModules.features-ssh
    inputs.self.nixosModules.features-audio

    # Phase 3: Desktop environment (laptop has different hardware)
    inputs.self.nixosModules.features-desktop
    # Note: Laptop doesn't use features-gaming or features-hardware (NVIDIA-specific)
    # Gaming and hardware configs stay in hosts/laptop/configuration.nix for now
  ];

  # Laptop-specific configuration
}
