{ ... }: {
  flake.nixosModules.steam = { ... }: { 
    programs.steam = { 
      enable = true;
      remotePlay.openFirewall = true;
    };

    programs.gamemode.enable = true;
  }; 
}
