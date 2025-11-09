{  pkgs, ...}:

{
  # --NETWORKING--
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "client";
  };
  
  networking = {
    hosts = {
      "10.42.0.89" = ["nextcloud.yggdrasil.com" "firefly.yggdrasil.com" "importer.yggdrasil.com" "gitea.yggdrasil.com"];
    };

    networkmanager.enable = true;
  };

  # --TIME--
  time.timeZone = "Europe/Stockholm";
  
  # internationalisation
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "sv_SE.UTF-8";
      LC_IDENTIFICATION = "sv_SE.UTF-8";
      LC_MEASUREMENT = "sv_SE.UTF-8";
      LC_MONETARY = "sv_SE.UTF-8";
      LC_NAME = "sv_SE.UTF-8";
      LC_NUMERIC = "sv_SE.UTF-8";
      LC_PAPER = "sv_SE.UTF-8";
      LC_TELEPHONE = "sv_SE.UTF-8";
      LC_TIME = "sv_SE.UTF-8";
    };
  };

  # --NIX--
  system.stateVersion = "24.05"; 
  nix.settings.experimental-features = [ "nix-command" "flakes"];
  nixpkgs.config.allowUnfree = true;


  # --PROGRAMS--
  environment.systemPackages = with pkgs; [
    vim
    git
    tmux
    htop
    wget
  ];
  programs.zsh.enable = true;
}
