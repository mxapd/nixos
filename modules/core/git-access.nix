{ inputs, pkgs, ... }:
{
  flake.nixosModules.git-access = { config, pkgs, ... }: {

    sops.secrets."github_mxapd" = {
      sopsFile = ../../secrets/ssh-keys.yaml;
      path = "/home/xam/.ssh/github_mxapd";
      owner = "xam";
      mode = "0600";
    };
  
    sops.secrets."gitlab_lnu" = {
      sopsFile = ../../secrets/ssh-keys.yaml;
      path = "/home/xam/.ssh/gitlab_lnu";
      owner = "xam";
      mode = "0600";
    };
  
    sops.secrets."gitea" = {
      sopsFile = ../../secrets/ssh-keys.yaml;
      path = "/home/xam/.ssh/gitea";
      owner = "xam";
      mode = "0600";
    };
  };
}
