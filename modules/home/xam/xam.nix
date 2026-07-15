{ inputs, ... }:

{
  flake.nixosModules.hm-xam = { pkgs, ... }: {
    imports = [
      inputs.self.nixosModules.hm-xam-zsh
      inputs.self.nixosModules.hm-ssh
      inputs.self.nixosModules.hm-git
      inputs.self.nixosModules.nixvim
      inputs.self.nixosModules.tmux-notes
      inputs.self.nixosModules.tmux-goose
      inputs.self.nixosModules.tmux-sessionizer
      inputs.self.nixosModules.rebuild
      inputs.self.nixosModules.goose
      inputs.self.nixosModules.hm-yazi
      inputs.self.nixosModules.tmux
      inputs.self.nixosModules.zoxide
      inputs.self.nixosModules.rust-dev
      inputs.self.nixosModules.kitty
      inputs.self.nixosModules.opencode
      inputs.self.nixosModules.mako
      inputs.self.nixosModules.thunderbird
      inputs.self.nixosModules.spellbook
    ];

    home-manager.users.xam = {
      home = {
        username = "xam";
        homeDirectory = "/home/xam";
        stateVersion = "26.05";

        sessionVariables = {
          OBSIDIAN_VAULT = "/home/xam/Documents/obsidian/";
          EDITOR = "nvim";
          BROWSER = "firefox";
          PATH = "$HOME/.local/bin:$PATH";
	  SOPS_AGE_KEY_FILE = "/home/xam/.age/sops_admin"; 
	};

        packages = with pkgs; [
          kdePackages.dolphin # TODO add keybind to open in hyprland
          kdePackages.dolphin-plugins

          prismlauncher
	  spotify

          vlc
          qbittorrent

          btop
          gotop
        ];
      };
    };
  };
}
