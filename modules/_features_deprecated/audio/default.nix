# modules/features/audio/default.nix
# PipeWire audio system configuration

{ config, pkgs, ... }:

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
}
