{ inputs, ... }:

{
  flake.nixosConfigurations.hearth =
    inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      modules = [
        inputs.self.nixosModules.hearth-hardware
	inputs.self.nixosModules.user-xam
	
	inputs.self.nixosModules.nvidia

	inputs.self.nixosModules.home-manager
	inputs.self.nixosModules.hm-xam
	
	inputs.self.nixosModules.hyprland
	inputs.self.nixosModules.hyprmoon
	inputs.self.nixosModules.hyprland-core
	inputs.self.nixosModules.stylix
	
	inputs.self.nixosModules.nixvim
	inputs.nixvim.nixosModules.nixvim

	inputs.self.nixosModules.tailscale-communal

	inputs.self.nixosModules.sops
	inputs.self.nixosModules.ssh-access
	inputs.self.nixosModules.git-access

	inputs.self.nixosModules.steam

        ({ pkgs, lib, config, ... }: {
          networking.hostName = "hearth";

	  programs.firefox.enable = true;

          services.openssh.enable = true;

	  boot.loader.systemd-boot.enable = true;
	  boot.loader.efi.canTouchEfiVariables = true;

          security.sudo.enable = true;

	  networking = {
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
      	 system.stateVersion = "25.11"; 
      	 nix.settings.experimental-features = [ "nix-command" "flakes"];
      	 nixpkgs.config.allowUnfree = true;
      	 
      	 # --PROGRAMS--
      	 environment.systemPackages = with pkgs; [
	   
	   opencode
      	   discord-canary
	   wl-clipboard
	   tree
	   btop
      	   vim
      	   tree
      	   git
      	   tmux
      	   htop
      	   wget
      	   parted
      	   feh
      	   ripgrep
      	   file
      	   fzf
      	   zoxide
      	   fastfetch
      	 ];
      	  
      	 ## unsafe, need to find out what package relies on this lib and update
      	 nixpkgs.config.permittedInsecurePackages = [
      	   "qtwebengine-5.15.19"
      	 ];
      	 
      	 # --FONTS-- 
      	 fonts = {
      	   fontconfig.enable = true;
      	 
      	   # JetBrainsMono Nerd Font: primary monospace (terminal, editor, prompt)
      	   # symbols-only: glyph fallback for waybar / prompt / nixvim
      	   # font-awesome + DejaVu: referenced by the waybar CSS
      	   # Noto + emoji: general text + emoji coverage
      	   packages = with pkgs; [
      	     nerd-fonts.jetbrains-mono
      	     nerd-fonts.symbols-only
      	     font-awesome
      	     dejavu_fonts
      	     noto-fonts
      	     noto-fonts-color-emoji
      	   ];
      	 
      	   fontconfig.defaultFonts = {
      	     monospace = [ "JetBrainsMono Nerd Font" "DejaVu Sans Mono" ];
      	     sansSerif = [ "Noto Sans" "DejaVu Sans" ];
      	     serif     = [ "Noto Serif" "DejaVu Serif" ];
      	     emoji     = [ "Noto Color Emoji" ];
      	   };
      	 };

      	})

      ];
  };
}
