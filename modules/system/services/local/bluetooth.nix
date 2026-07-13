{ ... }: {
  flake.nixosModules.bluetooth = { pkgs, ... }: {

    environment.systemPackages = with pkgs; [
      blueman
    ];

    hardware = {
      bluetooth.enable = true;
      bluetooth.powerOnBoot = true;
    };
  };
}
