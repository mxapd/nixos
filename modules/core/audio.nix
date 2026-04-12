# modules/core/audio.nix
# PipeWire audio system configuration

{ self, inputs, ... }:

{
  flake.nixosModules.audio = { config, pkgs, ... }:
  {
    # Enable PipeWire for audio
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    # Realtime scheduling for audio
    security.rtkit.enable = true;
  };
}
