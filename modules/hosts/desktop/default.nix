# modules/hosts/desktop/default.nix
# Desktop host configuration - dendritic feature enablement

{ config, pkgs, inputs, ... }:

{
  imports = [
    # Enable features for desktop
    inputs.self.nixosModules.features-base
    inputs.self.nixosModules.features-users
    inputs.self.nixosModules.features-stylix
  ];

  # Desktop-specific configuration
  # Most config remains in hosts/desktop/configuration.nix during migration
}
