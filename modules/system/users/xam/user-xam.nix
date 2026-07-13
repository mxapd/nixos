{ pkgs, ... }:

{
  flake.nixosModules.user-xam = { pkgs, config, lib, ... }: {
    users.users.xam = {
      isNormalUser = true;
      description = "Xam)";
      home = "/home/xam";

      shell = pkgs.zsh;

      extraGroups = [
        "wheel"
        "networkmanager"
        "wireshark"
      ];
    };

    programs.zsh.enable = true;
  };
}
