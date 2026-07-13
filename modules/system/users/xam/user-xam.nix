{ pkgs, ... }:

{
  flake.nixosModules.user-xam = { pkgs, config, lib, ... }: {
    users.users.xam = {
      isNormalUser = true;
      description = "Xam)";
      home = "/home/xam";

      extraGroups = [
        "wheel"
        "networkmanager"
        "wireshark"
      ];
    };
  };
}
