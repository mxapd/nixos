{ ... }: {
  flake.nixosModules.docker = { ... }: {
    virtualisation.docker.enable = true;

    users.extraGroups.docker.members = [ "xam" ];
  };
}
