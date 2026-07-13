{ ... }: {
  flake.nixosModules.ssh = { ... }: {
    services.openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "no";
        KbdInteractiveAuthentication = false;
        MaxAuthTries = 3;
      };
    };
  };
}
