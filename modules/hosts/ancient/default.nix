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

    # Server doesn't need desktop, but needs editor and dev tools
    inputs.self.nixosModules.features-dev
    inputs.self.nixosModules.features-editor
  ];

  # Ancient-specific configuration
}
