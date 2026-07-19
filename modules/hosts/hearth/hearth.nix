{ inputs, self, ... }:

{
  flake.nixosConfigurations.hearth =
    inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };

      modules = with self.nixosModules; [
        boot
        hearth-hardware
        user-xam

        audio
        bluetooth
        networking
        fonts
        locale
        sops
        nix-maintenance
        ssh
        sudo
        nvidia
        stylix
        unfree

        home-manager
        hm-xam
        hyprmoon

        ssh-authorized-keys
        ssh-access-hearth
        git-access

        syncthing
        tailscale

        virtualbox
        torzu
        flatpak
        steam
        firefox

        ({ pkgs, ... }: {

          networking.hostName = "hearth";
          system.stateVersion = "26.05";

          services.printing.enable = true;
          security.polkit.enable = true;

          services.ratbagd.enable = true;

          nix.settings.extra-platforms = [ "aarch64-linux" ];
          # --NIX--

          nix.settings.experimental-features = [ "nix-command" "flakes" ];

	  # --PROGRAMS--
          environment.systemPackages = with pkgs; [
            discord-canary
            wl-clipboard
            tree
            btop
            vim
            git
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
        })
      ];
    };
}
