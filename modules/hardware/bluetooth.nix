# modules/hardware/bluetooth.nix
# Bluetooth hardware enablement (NixOS system level)

{ self, inputs, ... }:

{
  flake.nixosModules.bluetooth = { config, pkgs, ... }:
  {
    # Bluetooth
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings = {
        General = {
          Enable = "Source,Sink,Media,Socket";
          Experimental = true;
        };
      };
    };

    # Bluetooth manager
    services.blueman.enable = true;

    # Bluetooth tools
    environment.systemPackages = with pkgs; [
      bluez
    ];
  };
}
