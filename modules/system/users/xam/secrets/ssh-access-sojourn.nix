{ ... }: {
  flake.nixosModules.ssh-access-sojourn = { ... }: {
    sops.secrets."access-sojourn" = {
      sopsFile = ../../../../../secrets/ssh-keys.yaml;
      path = "/home/xam/.ssh/access-sojourn";
      owner = "xam";
      mode = "0600";
    };

    home-manager.users.xam.programs.ssh.settings."ancient hermes hearth sojourn" = {
      User = "xam";
      IdentityFile = "/home/xam/.ssh/access-sojourn";
      IdentitiesOnly = "yes";
    };
  };
}
