{ ... }: {
  flake.nixosModules.sudo = { pkgs, ... }: {
    security.sudo-rs = {
      enable = true;
      execWheelOnly = true;
    };
  };
}

