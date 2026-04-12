# modules/features/users/default.nix
# NixOS user configuration

{ inputs, pkgs, config, ... }:

{
  users.users.xam = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
  };
}
