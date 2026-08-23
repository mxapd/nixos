{ ... }: {
  flake.nixosModules.steam = { pkgs, ... }: {
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      protontricks.enable = true;
    };

    environment.systemPackages = with pkgs; [
      steamtinkerlaunch
    ];

    programs.gamemode.enable = true;
    programs.gamescope.enable = true;
  };
}
