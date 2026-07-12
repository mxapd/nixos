{ ... }: {
  flake.nixosModules.ssh-access-hearth = { ... }: {
    sops.secrets."access-hearth" = {
      sopsFile = ../../secrets/ssh-keys.yaml;
      path = "/home/xam/.ssh/access";
      owner = "xam";
      mode = "0600";
    };
  };
}
