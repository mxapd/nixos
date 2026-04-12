# modules/hosts/desktop/default.nix
# Desktop host configuration - dendritic feature enablement

{ config, pkgs, inputs, ... }:

{
  imports = [
    # Enable features for desktop
    inputs.self.nixosModules.features-base
    inputs.self.nixosModules.features-users
    inputs.self.nixosModules.features-stylix
    inputs.self.nixosModules.features-fonts
    inputs.self.nixosModules.features-tailscale
    inputs.self.nixosModules.features-ssh
    inputs.self.nixosModules.features-audio

    # Phase 3: Desktop environment
    inputs.self.nixosModules.features-desktop
    inputs.self.nixosModules.features-gaming
    inputs.self.nixosModules.features-hardware
  ];

  # Desktop-specific configuration
  # Most config remains in hosts/desktop/configuration.nix during migration
}
