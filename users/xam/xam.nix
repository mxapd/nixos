{ inputs, pkgs, config, ... }:
{
  users.users.xam = {
    isNormalUser = true;
    # description = "xam";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;

    packages = with pkgs; [
         
    ];
  };
}
