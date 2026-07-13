{ ... }:

{
  flake.nixosModules.goose = { pkgs, ... }: {
    home-manager.users.xam = {
      home.packages = with pkgs;[
        goose-cli
      ];
      programs.zsh.initContent = ''
        	eval "$(goose term init zsh)"
      '';
    };
  };
}
