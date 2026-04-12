# modules/core/users.nix
# NixOS user configuration

{ self, inputs, ... }:

{
  flake.nixosModules.users = { config, pkgs, ... }:
  {
    users.users.xam = {
      isNormalUser = true;
      extraGroups = [ "networkmanager" "wheel" ];
      shell = pkgs.zsh;
    };
  };
}
