{ ... }: {
  flake.nixosModules.steam = { pkgs, ... }: {
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      protontricks.enable = true;
      
      extraPackages = [ pkgs.mangohud ];
      extraCompatPackages = [ pkgs.steamtinkerlaunch ]; 
    };

    environment.systemPackages = with pkgs; [
      steamtinkerlaunch
    ];

    programs.gamemode.enable = true;
    programs.gamescope.enable = true;
  };
}
