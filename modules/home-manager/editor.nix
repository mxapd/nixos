# modules/home-manager/editor.nix
# Nixvim (Neovim) configuration with all plugins

{ self, inputs, lib, pkgs, ... }:

{
  flake.homeModules.editor = { config, pkgs, lib, ... }:
    let
      treesitter = {
        programs.nixvim.plugins.treesitter = {
          enable = true;
          settings = {
            ensureInstalled = [ "bash" "c" "diff" "html" "lua" "luadoc" "markdown" "markdown_inline" "query" "vim" "vimdoc" "python" ];
            highlight.enable = true;
            additional_vim_regex_highlighting = true;
            indent.enable = true;
          };
        };
      };
      
      nvim-cmp = {
        programs.nixvim.plugins.cmp = {
          enable = true;
          settings = {
            snippet.expand = ''function(args) require('luasnip').lsp_expand(args.body) end'';
            completion.completeopt = "menu,menuone,noinsert";
            mapping = {
              "<C-n>" = "cmp.mapping.select_next_item()";
              "<C-p>" = "cmp.mapping.select_prev_item()";
              "<C-b>" = "cmp.mapping.scroll_docs(-4)";
              "<C-f>" = "cmp.mapping.scroll_docs(4)";
              "<C-y>" = "cmp.mapping.confirm { select = true }";
              "<C-Space>" = "cmp.mapping.complete {}";
              "<C-l>" = ''cmp.mapping(function() if luasnip.expand_or_locally_jumpable() then luasnip.expand_or_jump() end end, { 'i', 's' })'';
              "<C-h>" = ''cmp.mapping(function() if luasnip.locally_jumpable(-1) then luasnip.jump(-1) end end, { 'i', 's' })'';
            };
            sources = [ { name = "luasnip"; } { name = "nvim_lsp"; } { name = "path"; } ];
          };
        };
      };
      
      gitsigns = {
        programs.nixvim.plugins.gitsigns = {
          enable = true;
          settings.signs = {
            add = { text = "+"; };
            change = { text = "~"; };
            delete = { text = "_"; };
            topdelete = { text = "‾"; };
            changedelete = { text = "~"; };
          };
        };
      };
      
      telescope = {
        programs.nixvim.plugins.telescope = {
          enable = true;
          extensions.fzf-native.enable = true;
          extensions.ui-select.enable = true;
          settings.defaults.layout_strategy = "vertical";
        };
        programs.nixvim.keymaps = [
          { mode = "n"; key = "<leader>/"; action.__raw = ''function() require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown { winblend = 10, previewer = false }) end''; options.desc = "[/] Fuzzily search"; }
        ];
      };
      
      lsp = {
        programs.nixvim.plugins.none-ls = { enable = true; };
        programs.nixvim.plugins.lsp = {
          enable = true;
          servers = {
            ccls.enable = true;
            rust_analyzer.enable = true;
            jdtls.enable = true;
            lua_ls.enable = true;
            pylsp.enable = true;
          };
        };
      };
      
      obsidian = {
        programs.nixvim.plugins.obsidian = {
          enable = true;
          settings = {
            legacy_commands = false;
            frontmatter.enabled = true;
            workspaces = [ { name = "personal"; path = "~/Documents/obsidian/"; } ];
            notes_subdir = "Inbox";
          };
        };
      };
      
      neo-tree = {
        programs.nixvim.plugins.neo-tree.enable = true;
      };
      
      wrapping = {
        programs.nixvim.plugins.wrapping = { enable = true; };
      };
      
      conform = {
        programs.nixvim.extraPackages = with pkgs; [ pkgs.stylua pkgs.google-java-format ];
        programs.nixvim.plugins.conform-nvim = {
          enable = true;
          settings.formatters_by_ft = {
            lua = [ "stylua" ];
            java = [ "google-java-format" ];
          };
        };
      };
    in
    {
      imports = [ treesitter nvim-cmp gitsigns telescope lsp obsidian neo-tree wrapping conform ];
      
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
        autoGroups.kickstart-highlight-yank.clear = true;
        keymaps = [
          { mode = "n"; key = "<C-f>"; action = "<cmd>silent !tmux neww tmux-sessionizer<CR>"; options.silent = true; }
          { mode = "n"; key = "<leader>9s"; action = "<cmd>lua require(\"99\").search()<CR>"; options.desc = "99 search"; }
          { mode = "v"; key = "<leader>9v"; action = "<cmd>lua require(\"99\").visual()<CR>"; options.desc = "99 visual"; }
          { mode = "n"; key = "<leader>9g"; action = "<cmd>lua require(\"99\").vibe()<CR>"; options.desc = "99 vibe"; }
        ];
      };
    };
}
