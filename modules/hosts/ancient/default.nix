# modules/hosts/ancient/default.nix
# Ancient host configuration - dendritic feature enablement

{ config, pkgs, inputs, ... }:

{
  imports = [
    # Enable features for ancient (minimal server)
    inputs.self.nixosModules.features-base
    inputs.self.nixosModules.features-users
    inputs.self.nixosModules.features-tailscale
    inputs.self.nixosModules.features-ssh
  ];

  # Ancient-specific configuration
}
