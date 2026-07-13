{ ... }:
{
  flake.nixosModules.zoxide = { ... }: {
    home-manager.users.xam.programs.zoxide = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
