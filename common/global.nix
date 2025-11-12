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
  system.stateVersion = "25.05"; 
  nix.settings.experimental-features = [ "nix-command" "flakes"];
  nixpkgs.config.allowUnfree = true;

  ## unsafe, need to find out what package relies on this lib and update
  nixpkgs.config.permittedInsecurePackages = [
    "qtwebengine-5.15.19"
  ];

  # --PROGRAMS--
  environment.systemPackages = with pkgs; [
    neovim
    vim
    git
    tmux
    htop
    wget
    tailscale
    parted
  ];
  programs.zsh.enable = true;
}
