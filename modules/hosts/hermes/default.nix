# modules/hosts/hermes/default.nix
# Hermes host configuration - dendritic feature enablement

{ config, pkgs, inputs, ... }:

{
  imports = [
    # Enable features for hermes (aarch64 server)
    inputs.self.nixosModules.features-base
    inputs.self.nixosModules.features-users
  ];

  # Hermes-specific configuration
}
