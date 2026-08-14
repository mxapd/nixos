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

      # Served behind Caddy at https://ancient/jellyfin
      config.BaseURL = "/jellyfin";
    };
  };
}
