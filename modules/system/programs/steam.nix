{ ... }: {
  flake.nixosModules.steam = { ... }: {
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      protontricks.enable = true;
    };

    programs.gamemode.enable = true;
  };
}
