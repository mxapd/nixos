{ inputs, pkgs, config, ... }:
{
  users.users.xam = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
  };
}
