# modules/user/editor.nix
# Editor configuration (NixOS system level)

{ self, inputs, ... }:

{
  flake.nixosModules.editor = { config, pkgs, ... }:
  {
    # Neovim system-wide
    programs.neovim = {
      enable = true;
      defaultEditor = true;
      vimAlias = true;
      viAlias = true;
    };

    # Editor-related system packages
    environment.systemPackages = with pkgs; [
      # Language servers and tools
      lua-language-server
      nil  # Nix LSP
      stylua  # Lua formatter
      nixpkgs-fmt  # Nix formatter
    ];
  };
}
