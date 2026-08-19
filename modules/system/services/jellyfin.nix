{ ... }:
{
  flake.nixosModules.jellyfin = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      ffmpeg-full
      jellyfin-web
      jellyfin-ffmpeg
    ];

    services.jellyfin = {
      enable = true;
      openFirewall = false;
      user = "jellyfin";
    };

    # TODO: After first run, set Jellyfin's BaseURL to /jellyfin
    # (Dashboard -> Networking -> Base URL), then it will work at https://ancient/jellyfin
  };
}
