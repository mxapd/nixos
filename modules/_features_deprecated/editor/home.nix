# modules/features/editor/home.nix
# Editor configuration (home-manager)

{ config, pkgs, inputs, ... }:

{
  # Nixvim configuration
  # The actual nixvim config is complex and imports many plugin files
  # For now, we reference the existing config from home/users/xam/nixvim/
  # In a full migration, this would be self-contained

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

    # Basic plugins that are always enabled
    plugins = {
      # Treesitter for syntax highlighting
      treesitter.enable = true;
      treesitter.settings.highlight.enable = true;

      # Telescope for fuzzy finding
      telescope.enable = true;

      # LSP configuration
      lsp.enable = true;

      # Git integration
      gitsigns.enable = true;
    };

    # Custom 99.nvim plugin (if source is available)
    # Note: This references /home/xam/Projects/99 which is machine-specific
    # In full dendritic setup, this should be a flake input or package
  };

  # Make nvim the default editor
  home.sessionVariables.EDITOR = "nvim";

  # Kitty terminal integration (if using kitty)
  programs.kitty = {
    enable = true;
    extraConfig = ''
      confirm_os_window_close 0
    '';
  };
}
