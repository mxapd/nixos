{ ... }:

{
  flake.nixosModules.user-xam =
  { config, lib, pkgs, ... }:
  
  {
    users.users.xam = {
      isNormalUser = true;
      description = "Max (xam)";
      home = "/home/xam";
      shell = pkgs.zsh;        # or pkgs.bashInteractive, fish, etc.
  
      extraGroups = [
        "wheel"
        "networkmanager"
        "wireshark"
      ];
    };
  }
}
