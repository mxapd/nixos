{ inputs, pkgs, config, ... }:
{
  users.users.xam = {
    isNormalUser = true;
    # description = "xam";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;

    packages = with pkgs; [
      #zulu25
      tailscale
      cargo
      openssl
      wasm-bindgen-cli
      cargo-leptos
      rustc
      pkg-config
      cargo-generate
      openssl
      lsof
      rustlings
      pgadmin4-desktopmode
      tldr
      tree
      runelite
      nautilus
      pavucontrol
      calibre
      rustup
      clang
      ollama-cuda
      piper
      zip
      gotop
      rar
      qbittorrent
      #egl-wayland
      git
      python3
      prismlauncher
      obsidian
      kitty
      fastfetch
      slack
      gamescope
      spotify
      vscodium
      libreoffice
      #syncthing
      ripgrep-all
      zoxide
      tmux
      libgcc
      zig
      nodejs_22
      gnumake
      unzip
      lunarvim
      teamspeak3
      wl-clipboard
      discord-canary
      htop
      mariadb
      jdk21
      gradle
      vlc
      blueman
      fzf
    ];
  };
}
