{ ... }:

{
  flake.nixosModules.user-xam =
  { config, lib, ... }:
  
  {
    users.users.xam = {
      isNormalUser = true;
      description = "Max (xam)";
      home = "/home/xam";
  
      extraGroups = [
        "wheel"
        "networkmanager"
        "wireshark"
      ];
    };
  };
}
