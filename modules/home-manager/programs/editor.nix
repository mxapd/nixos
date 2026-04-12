# modules/home-manager/programs/editor.nix
# Nixvim (Neovim) configuration for home-manager

{ self, inputs, ... }:

{
  flake.homeManagerModules.programs.editor = { config, pkgs, lib, ... }:
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

      #extraPlugins = [ ];

      extraConfigLua = ''
        -- Additional neovim config can go here
      '';
    
      plugins = {
        web-devicons.enable = true;
        bufferline.enable = true;
        lualine.enable = true;
        luasnip.enable = true;
        which-key.enable = true;
        neoscroll.enable = true;
        render-markdown.enable = true;
      };
    };
  };
}