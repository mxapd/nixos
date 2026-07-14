{ ... }:
{

  flake.nixosModules.hm-ssh = { pkgs, ... }:
    {
      home-manager.users.xam.programs.ssh = {
        enable = true;
        enableDefaultConfig = false; # silence default-values deprecation warning

        settings = {
          "*" = {
            AddKeysToAgent = "yes";
            AddressFamily = "inet";
            ServerAliveCountMax = 3;
            ServerAliveInterval = 600;
          };

          "100.64.0.14" = {
            User = "git";
            IdentityFile = "/home/xam/.ssh/github_mxapd";
            IdentitiesOnly = "yes";
          };

          "github.com" = {
            User = "git";
            IdentityFile = "/home/xam/.ssh/github_mxapd";
            IdentitiesOnly = "yes";
          };

          "gitlab.lnu.se" = {
            IdentityFile = "/home/xam/.ssh/gitlab_lnu";
            IdentitiesOnly = "yes";
          };
        };
      };
    };
}
