{ inputs, ... }:

{
  flake.nixosModules.hm-xam = { pkgs, ... }: {
    imports = [ 
      inputs.self.nixosModules.hm-xam-zsh
      inputs.self.nixosModules.hm-ssh
      inputs.self.nixosModules.hm-git
      inputs.self.nixosModules.nixvim
      inputs.self.nixosModules.tmux-notes
      inputs.self.nixosModules.tmux-sessionizer
      inputs.self.nixosModules.rebuild
      inputs.self.nixosModules.goose
    ]; 

    home-manager.users.xam = {
      home = {
        username = "xam";
        homeDirectory = "/home/xam";
        stateVersion = "25.11";

        sessionVariables = {
          OBSIDIAN_VAULT = "/home/xam/Documents/obsidian/";
          EDITOR = "nvim";
          BROWSER = "firefox";
          PATH = "$HOME/.local/bin:$PATH";
        };

        packages = with pkgs; [
          git-credential-manager
          zoxide
          
	  wiremix
          
	  calcurse

          (python3.withPackages (ppkgs: [
            ppkgs.matplotlib
            ppkgs.pytest
          ]))

          bun # for pai

          bubblewrap
          (writeShellScriptBin "opencode" ''
          exec ${pkgs.bubblewrap}/bin/bwrap \
            --ro-bind /nix/store /nix/store \
            --ro-bind /run/current-system /run/current-system \
            --ro-bind /etc /etc \
            --proc /proc \
            --dev-bind /dev /dev \
            --tmpfs /tmp \
            --tmpfs /home/xam \
            --bind ''${HOME}/Projects ''${HOME}/Projects \
            --ro-bind ''${HOME}/nixos ''${HOME}/nixos \
            --bind ''${HOME}/.config/opencode ''${HOME}/.config/opencode \
            --bind ''${HOME}/.local/state/opencode ''${HOME}/.local/state/opencode \
            --bind ''${HOME}/.local/share/opencode ''${HOME}/.local/share/opencode \
            --setenv HOME /home/xam \
            --unshare-ipc \
            --unshare-uts \
            --die-with-parent \
            ${pkgs.opencode}/bin/opencode "$@"
          '')

          # (writeShellApplication {
          #   name = "tmux-sessionizer";
          #   runtimeInputs = with pkgs; [ tmux fzf findutils procps ];
          #   text = builtins.readFile ../../../scripts/tmux-sessionizer.sh;
          # })

          # (writeShellApplication {
          #   name = "tmux_toggle_notes";
          #   runtimeInputs = with pkgs; [ tmux ];
          #   text = builtins.readFile ../../../scripts/tmux_notes_toggle.sh;
          # })

          # (writeShellApplication {
          #   name = "rebuild";
          #   runtimeInputs = with pkgs; [ git util-linux ];
          #   text = builtins.imread ../../../scripts/rebuild.sh;
          # })

          # (writeShellScriptBin "nixos-warnings" (builtins.readFile ../../../scripts/nixos-warnings.sh))
        ];
      };

      programs = {
        zoxide.enable = true;
        zoxide.enableZshIntegration = true;

        tmux = {
          enable = true;
        };

        kitty = {
          enable = true;
          extraConfig = ''
           confirm_os_window_close 0
          '';
        };
      };
    };
  };
}
