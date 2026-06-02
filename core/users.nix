{ inputs, pkgs, config, ... }:
{
  users.users.xam = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" "wireshark" "docker"];
    shell = pkgs.zsh;
  };
}
