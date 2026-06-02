{ pkgs, ... }:
{
  programs.ssh = {
    enable = true;
    addKeysToAgent = "yes";   # auto-add to agent on first use

    matchBlocks = {
      "github.com" = {
        user = "git";
        identityFile = "/home/xam/.ssh/github_mxapd";
        identitiesOnly = true;
      };

      "gitlab.lnu.se" = {
        identityFile = "/home/xam/.ssh/gitlab_lnu";
        identitiesOnly = true;
      };
    };
  };
};
