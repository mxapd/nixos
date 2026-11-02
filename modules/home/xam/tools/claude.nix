{ ... }:
{
  flake.nixosModules.claude = { pkgs, ... }: {
    programs.claude-code = {
      enable = true;
      package = pkgs.claude-code; 
      settings = {
        # model = "claude-3-5-sonnet-20241022";
        theme = "dark";
        includeCoAuthoredBy = false;
        permissions = {
          defaultMode = "acceptEdits";
          # deny = [ "WebFetch" "curl" "secrets" ];
        };
      };
      context = ''
        # Global Claude Code Context
        - Use Nix flakes for new projects.
      '';
    };
  };
}
