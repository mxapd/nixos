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
  ];

  # Laptop-specific configuration
}
