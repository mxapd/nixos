# modules/hosts/desktop.nix
# Desktop host configuration - complete system definition

{ self, inputs, pkgs, lib, ... }:

{
  flake.nixosConfigurations.desktop = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = { inherit inputs self pkgs lib; };
    modules = [
      # Hardware configuration
      ({ config, lib, pkgs, modulesPath, ... }: {
        imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

        boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
        boot.initrd.kernelModules = [ ];
        boot.kernelModules = [ "kvm-amd" ];
        boot.extraModulePackages = [ ];

        fileSystems."/" = {
          device = "/dev/disk/by-uuid/64bfd218-e0b4-4558-bf90-5cb9ddb617be";
          fsType = "ext4";
        };

        fileSystems."/boot" = {
          device = "/dev/disk/by-uuid/92B2-E445";
          fsType = "vfat";
          options = [ "fmask=0077" "dmask=0077" ];
        };

        swapDevices = [ ];
        networking.useDHCP = lib.mkDefault true;
        nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
        hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
      })

      # Bootloader and system config
      ({ config, pkgs, ... }: {
        boot.loader.systemd-boot.enable = true;
        boot.loader.efi.canTouchEfiVariables = true;
        boot.kernelParams = [ "kvm.enable_virt_at_load=0" ];

        networking.hostName = "desktop";
        networking.nameservers = [ "8.8.8.8" "100.42.0.1" ];

        programs.direnv.enable = true;
        programs.firefox.enable = true;

        services.flatpak.enable = true;
        services.mysql.enable = true;
        services.mysql.package = pkgs.mariadb;
        services.printing.enable = true;
        
        services.syncthing = {
          enable = true;
          user = "xam";
          group = "users";
          dataDir = "/home/xam/Documents/";
          configDir = "/home/xam/.syncthing/";
          guiAddress = "0.0.0.0:8384";
        };

        services.tailscale = {
          enable = true;
          useRoutingFeatures = "client";
        };

        virtualisation.virtualbox.host.enable = true;
        virtualisation.virtualbox.host.enableExtensionPack = true;
        users.extraGroups.vboxusers.members = [ "xam" ];

        environment.systemPackages = with pkgs; [
          inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default
          (pkgs.callPackage ../../custom-pkgs/nixos-warnings.nix { })
          kitty wofi font-awesome gnome-calendar hyprshot playerctl nautilus pavucontrol piper gotop
          qbittorrent prismlauncher fastfetch slack gamescope spotify libreoffice syncthing ripgrep-all
          tmux zoxide teamspeak3 wl-clipboard discord-canary htop mariadb jdk21 gradle vlc blueman fzf bun
          grim slurp libnotify wasm-bindgen-cli cargo-leptos rustc pkg-config cargo-generate lsof rustlings
          tldr runelite zip rar rustup clang libgcc zig nodejs_22 gnumake unzip git python3
        ];
      })

      # Import legacy modules
      ../../modules/_legacy/postgresql.nix
      ../../modules/_legacy/torzu.nix

      # External flake modules
      inputs.stylix.nixosModules.stylix

      # Dendritic feature modules
      self.nixosModules.base
      self.nixosModules.users
      self.nixosModules.stylix
      self.nixosModules.fonts
      self.nixosModules.tailscale
      self.nixosModules.ssh
      self.nixosModules.audio
      self.nixosModules.desktop
      self.nixosModules.gaming
      self.nixosModules.hardware
      self.nixosModules.shell
      self.nixosModules.dev
      self.nixosModules.editor
    ];
  };

  # Home Manager configuration for desktop
  flake.homeConfigurations.desktop = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
    modules = [
      # User home config with sessionVariables
      {
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

          # User packages
          packages = with pkgs; [
            #teamspeak3
            ollama
            oh-my-zsh
            git-credential-manager
            zoxide
            wiremix
            bun
            calcurse
            (python3.withPackages (ppkgs: [
              ppkgs.matplotlib
              ppkgs.pytest
            ]))

            bubblewrap
          ];
        };

        # Programs config
        programs.zoxide.enable = true;
        programs.zoxide.enableZshIntegration = true;
        programs.tmux.enable = true;
        programs.kitty.enable = true;
        programs.kitty.extraConfig = "confirm_os_window_close 0\n";
      }

      # Shell: zsh with full config
      {
        programs.zsh = {
          enable = true;
          syntaxHighlighting.enable = true;

          shellAliases = {
            mount-ancient = "sudo mount -t cifs //192.168.1.204/video /mnt/ancient_share/video -o username=xam,uid=1000,gid=100,rw && \
              sudo mount -t cifs //192.168.1.204/books /mnt/ancient_share/books -o username=xam,uid=1000,gid=100,rw";
            nd = "nix develop";
            ns = "nix shell";
            check = "nix flake check --impure";
            pai = "bun ~/.opencode/PAI/Tools/pai.ts";
          };

          initContent = ''
            # setting up and binding tmux sessionizer
            
            tmux_sessionizer_widget() {
              zle -I                     
              tmux-sessionizer          
            }

            zle -N tmux_sessionizer_widget
            bindkey '^f' tmux_sessionizer_widget
            
            
            # loading ssh keys
            
            if [ -z "$SSH_AUTH_SOCK" ]; then
              eval "$(ssh-agent -s)" > /dev/null
              ssh-add ~/.ssh/lnu_ed25519 2>/dev/null
            fi
            
            # automatically start a tmux session when opening an shell if apropriate
            
            if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
              exec tmux
            fi
            
            PROMPT='[%1~] •%f '
            RPROMPT='$(git_prompt_info) %T'	
          '';

          oh-my-zsh = {
            enable = true;
            plugins = [ "git" ];
            theme = "wedisagree";
          };
        };
      }

      # Git
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
      }

      # Editor: nixvim (simplified - full config in modules/home-manager/editor.nix)
      {
        programs.nixvim = {
          enable = true;
          globals = {
            mapleader = " ";
            maplocalleader = " ";
          };
          opts = {
            number = true;
            relativenumber = true;
            shiftwidth = 2;
            clipboard = "unnamedplus";
            conceallevel = 2;
          };
          extraPlugins = [
            (pkgs.vimUtils.buildVimPlugin {
              name = "99-nvim";
              nvimSkipModules = [ "99.editor.lsp" ];
              src = /home/xam/Projects/99;
            })
          ];
          extraConfigLua = ''
            require("99").setup({
              provider = require("99.providers").OllamaProvider,
              model = "qwen2.5-coder:7b",
              tmp_dir = "/home/xam/.99/tmp",
            })
          '';
          plugins = {
            web-devicons.enable = true;
            bufferline.enable = true;
            lualine.enable = true;
            luasnip.enable = true;
            which-key.enable = true;
            neoscroll.enable = true;
            render-markdown.enable = true;
            friendly-snippets.enable = true;
            nvim-surround.enable = true;
            trouble.enable = true;
          };
          keymaps = [
            { mode = "n"; key = "<C-f>"; action = "<cmd>silent !tmux neww tmux-sessionizer<CR>"; options.silent = true; }
            { mode = "n"; key = "<leader>9s"; action = "<cmd>lua require(\"99\").search()<CR>"; options.desc = "99 search"; }
            { mode = "v"; key = "<leader>9v"; action = "<cmd>lua require(\"99\").visual()<CR>"; options.desc = "99 visual"; }
            { mode = "n"; key = "<leader>9g"; action = "<cmd>lua require(\"99\").vibe()<CR>"; options.desc = "99 vibe"; }
            { mode = "n"; key = "<leader>9x"; action = "<cmd>lua require(\"99\").stop_all_requests()<CR>"; options.desc = "99 stop requests"; }
          ];
        };
      }

      # Desktop: hyprland, waybar, mako (full config in modules/home-manager/desktop.nix)
      {
        programs.waybar = {
          enable = true;
          settings = [
            {
              layer = "top";
              position = "bottom";
              modules-left = [ "hyprland/workspaces" ];
              modules-center = [ "hyprland/window" ];
              modules-right = [
                "custom/nixos-warnings"
                "disk"
                "network"
                "pulseaudio"
                "tray"
                "clock"
              ];
              "disk" = { path = "/"; interval = "30"; format = " | {free} free |"; unit = "GB"; };
              "hyprland/workspaces" = {
                format = "{name}";
                format-icons = { default = " "; active = " "; urgent = " "; };
                on-scroll-up = "hyprctl dispatch workspace e+1";
                on-scroll-down = "hyprctl dispatch workspace e-1";
              };
              "hyprland/window" = { max-length = 22; separate-outputs = false; rewrite = { "" = " No Window? "; }; };
              "clock" = { format = "{:%H:%M %A%e %b}"; tooltip-format = "<big>{:%Y %B}</big>\n<tt><big>{calendar}</big></tt>"; today-format = "<b>{}</b>"; on-click = "calcure"; };
              "tray" = { spacing = 12; };
              "network" = { interval = "5"; format-icons = [ "󰤯" "󰤟" "󰤢" "󰤥" "󰤨" ]; format-wifi = "{icon} {signalStrength}%"; format-disconnected = "󰤮"; };
              "pulseaudio" = { format = "{volume}% |"; on-click = "wiremix"; };
              "custom/nixos-warnings" = { exec = "echo '⚠ '$(nixos-warnings count)' warnings'"; interval = 5; tooltip = true; };
            }
          ];
        };

        services.mako = {
          enable = true;
          settings = {
            default-timeout = 7000;
            border-radius = 5;
          };
        };

        wayland.windowManager.hyprland = {
          enable = true;
          xwayland.enable = true;
          
          settings = {
            input = { kb_variant = "altgr-intl"; };
            general = { border_size = 1; gaps_out = 8; };
            decoration = { rounding = 3; };
            animations = { enabled = false; };
            "$mod" = "SUPER";
            
            bind = [
              "$mod,Return,exec, kitty"
              "$mod,d,exec, wofi --show drun"
              "$mod,w,exec,firefox"
              "$modSHIFT,M,exec, hyprctl dispatch exit"
              "$mod,E,exec, dolphin"
              "$mod, PRINT, exec, hyprshot -m window"
              ", PRINT, exec, hyprshot -m output"
              "$modSHIFT, PRINT, exec, hyprshot -m region"
              "$modSHIFT,Q,killactive"
              "$mod,F,fullscreen"
              "$mod,left,movefocus,l"
              "$mod,right,movefocus,r"
              "$mod,up,movefocus,u"
              "$mod,down,movefocus,d"
              "$mod,K,movefocus,u"
              "$mod,J,movefocus,d"
              "$mod,H,movefocus,l"
              "$mod,L,movefocus,r"
              "$mod,1,workspace,1"
              "$mod,2,workspace,2"
              "$mod,3,workspace,3"
              "$mod,4,workspace,4"
              "$mod,5,workspace,5"
              "$mod,6,workspace,6"
              "$mod,7,workspace,7"
              "$mod,8,workspace,8"
              "$mod,9,workspace,9"
              "$modSHIFT,1,movetoworkspacesilent,1"
              "$modSHIFT,2,movetoworkspacesilent,2"
              "$modSHIFT,3,movetoworkspacesilent,3"
              "$modSHIFT,4,movetoworkspacesilent,4"
              "$modSHIFT,5,movetoworkspacesilent,5"
              "$modSHIFT,6,movetoworkspacesilent,6"
              "$modSHIFT,7,movetoworkspacesilent,7"
              "$modSHIFT,8,movetoworkspacesilent,8"
              "$modSHIFT,9,movetoworkspacesilent,9"
              "$modSHIFT,right,movewindow,r"
              "$modSHIFT,left,movewindow,l"
              "$modSHIFT,up,movewindow,u"
              "$modSHIFT,down,movewindow,d"
              "$modSHIFT,F,togglefloating,active"
              "$mod,O, exec, kitty --class tmux-notes -e tmux_toggle_notes"
            ];

            bindm = [
              "$mod, mouse:272, movewindow"
              "$mod, mouse:273, resizewindow"
              "$mod ALT, mouse:272, resizewindow"
            ];

            bindel = [
              ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
              ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
            ];

            bindl = [
              ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
              ", XF86AudioPlay, exec, playerctl play-pause"
              ", XF86AudioPrev, exec, playerctl previous"
              ", XF86AudioNext, exec, playerctl next"
            ];

            monitor = [
              "DP-1, 2560x1440@180.00Hz, 0x0,1"
              "DP-3,1920x1080@144.00Hz,-1920x0,1"
            ];
          };

          extraConfig = ''
            exec-once = waybar
            exec-once = mako
          '';
        };

        home.sessionVariables.NIXOS_OZONE_WL = "1";
      }
    ];
  };
}
