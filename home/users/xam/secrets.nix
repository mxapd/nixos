{ config, ... }:

{
  age.secrets.github-ssh-key = {
    file = ../../../secrets/github_ssh_mxapd.age;
    path = "/home/xam/.ssh/github_mxapd";
    owner = "xam";
    mode = "600";
  };

  age.secrets.gitlab-ssh-key = {
    file = ../../../secrets/gitlab_ssh_lnu.age;
    path = "/home/xam/.ssh/gitlab_lnu";
    owner = "xam";
    mode = "600";
  };
}
