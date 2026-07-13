{ ... }: {
  flake.nixosModules.ssh-access-hearth = { ... }: {
    sops.secrets."access-hearth" = {
      sopsFile = ../../../../../secrets/ssh-keys.yaml;
      path = "/home/xam/.ssh/access-hearth";
      owner = "xam";
      mode = "0600";
    };

    home-manager.users.xam.programs.ssh.settings."ancient hermes hearth sojourn" = {
      User = "xam";
      IdentityFile = "/home/xam/.ssh/access-hearth";
      IdentitiesOnly = "yes";
    };
  };
}
