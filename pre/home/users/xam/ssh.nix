{ pkgs, ... }:
{
  programs.ssh = {
    enable = true;
    addKeysToAgent = "yes"; # auto-add to agent on first use

    matchBlocks = {

      "ancient hermes desktop laptop" = {
        user = "xam";
        identityFile = "/home/xam/.ssh/access"; # <-- use this key for these hosts
        identitiesOnly = true; # <-- ONLY this key, don't try others
      };

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
}
