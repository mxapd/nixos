{ ... }: {
  flake.nixosModules.bluetooth = { ... }: { 
    hardware = {

    bluetooth.enable = true;
    bluetooth.powerOnBoot = true;
  };
  }; 
}
