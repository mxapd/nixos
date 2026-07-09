{ inputs, pkgs, ... }:
{
  flake.nixosModules.ssh-access = { config, pkgs, ... }: {

    imports = [ inputs.nixosModules.sops ];

    sops.secrets."github_private_key" = {
      sopsFile = ../../secrets/ssh-keys.yaml;
      path = "/home/xam/.ssh/github_mxapd";
      owner = "xam";
      mode = "0600";
    };
  
    sops.secrets."gitlab_lnu_private_key" = {
      sopsFile = ../../secrets/ssh-keys.yaml;
      path = "/home/xam/.ssh/gitlab_lnu";
      owner = "xam";
      mode = "0600";
    };
  
    sops.secrets."gitea_private_key" = {
      sopsFile = ../../secrets/ssh-keys.yaml;
      path = "/home/xam/.ssh/gitea";
      owner = "xam";
      mode = "0600";
    };
  };
}
