{ pkgs, ... }:
{
  users.users.xam = {
    isNormalUser = true;
    # description = "xam";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
  };
}
