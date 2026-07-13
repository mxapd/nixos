{ pkgs, ... }:

{
  flake.nixosModules.user-xam = { ... }: {
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
