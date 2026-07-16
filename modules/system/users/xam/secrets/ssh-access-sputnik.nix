{ ... }: {
  flake.nixosModules.ssh-access-sputnik = { ... }: {
    sops.secrets."access-sputnik" = {
      sopsFile = ../../../../../secrets/ssh-keys.yaml;
      path = "/home/xam/.ssh/access-sputnik";
      owner = "xam";
      mode = "0600";
    };

    home-manager.users.xam.programs.ssh.settings."ancient hermes hearth sputnik" = {
      User = "xam";
      IdentityFile = "/home/xam/.ssh/access-sputnik";
      IdentitiesOnly = "yes";
    };
  };
}
