# modules/user/dev.nix
# Development tools (NixOS system level)

{ self, inputs, ... }:

{
  flake.nixosModules.dev = { config, pkgs, ... }:
  {
    # Git is already enabled at system level in features-base
    # Additional system-wide dev tools can go here

    environment.systemPackages = with pkgs; [
      # Git credential manager for authentication
      git-credential-manager

      # Basic dev tools
      git
      gnupg  # For signing commits
    ];
  };
}
