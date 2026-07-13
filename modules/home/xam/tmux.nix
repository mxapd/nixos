{ ... }:
{
  flake.nixosModules.tmux = { ... }: {
    home-manager.users.xam.programs.tmux = {
      enable = true;
    };
  };
}
