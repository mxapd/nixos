{ ... }: {
  flake.nixosModules.audio = { pkgs, ... }: {

    environment.systemPackages = with pkgs; [
      wiremix
      playerctl
    ];

    services.playerctld.enable = true;

    security.rtkit.enable = true;

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };
}
