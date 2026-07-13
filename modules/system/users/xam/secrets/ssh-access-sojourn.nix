{ ... }: {
  flake.nixosModules.ssh-access-sojourn = { ... }: {
    sops.secrets."access-sojourn" = {
      sopsFile = ../../../../../secrets/ssh-keys.yaml;
      path = "/home/xam/.ssh/access-sojourn";
      owner = "xam";
      mode = "0600";
    };

    home-manager.users.xam.programs.ssh.matchBlocks."ancient hermes desktop laptop" = {
      user = "xam";
      identityFile = "/home/xam/.ssh/access-sojourn";
      identitiesOnly = true;
    };
  };
}
