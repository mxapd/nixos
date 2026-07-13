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
      openFirewall = true;
      user = "jellyfin";
    };
  };
}
