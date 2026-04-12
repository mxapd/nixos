# modules/features/dev/home.nix
# Development tools (home-manager)

{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "xam";
    userEmail = "m.porseryd@gmail.com";
    extraConfig = {
      credential = {
        helper = "manager";
        "https://gitlab.lnu.se".username = "Max Porseryd";
        "https://gitlab.lnu.se".email = "mp224hv@student.lnu.se";
        "https://github.com".username = "mxapd";
        credentialStore = "cache";
      };
    };
  };

  # GPG for commit signing (if needed)
  programs.gpg.enable = true;

  # SSH agent configuration
  services.ssh-agent.enable = true;
}
