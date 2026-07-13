{ ... }:
{
  flake.nixosModules.tmux = { pkgs,... }: {
    home-manager.users.xam.programs.tmux = {
      enable = true;
      mouse = true;
      plugins = with pkgs.tmuxPlugins; [
	sensible
	yank
      ];
    };
  };
}
