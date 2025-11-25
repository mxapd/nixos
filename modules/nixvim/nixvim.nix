{ pkgs, inputs, ... }: 

{
  imports = [
    ./plugins/treesitter.nix
    ./plugins/nvim-cmp.nix
    ./plugins/gitsigns.nix
    ./plugins/telescope.nix
    ./plugins/lsp.nix
    ./plugins/obsidian.nix
    ./plugins/alpha-nvim.nix
    ./plugins/neo-tree.nix
    ./plugins/wrapping.nix
    ./plugins/conform.nix
    #./plugins/dashboard.nix
  ];

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
      #colorcolumn = "79";
      conceallevel = 2;
    };

    plugins = {
      web-devicons.enable = true;
      bufferline.enable = true;
      lualine.enable = true;
      luasnip.enable = true;
      which-key.enable = true;
      neoscroll.enable = true;
      #render-markdown.enable = true;
      friendly-snippets.enable = true;
      friendly-snippets.autoLoad= true;
      nvim-surround.enable = true;
      trouble.enable = true;
    };

    keymaps = [
  {
    mode = "n";
    key = "<C-f>";
    action = "<cmd>silent !tmux neww tmux-sessionizer<CR>";
    options.silent = true;
  }    ];

    autoGroups = {
      kickstart-highlight-yank = {
	clear = true;
      };
    };


    autoCmd = [
      # Highlight when yanking (copying) text
      #  Try it with `yap` in normal mode
      #  See `:help vim.highlight.on_yank()`
      {
	event = ["TextYankPost"];
	desc = "Highlight when yanking (copying) text";
	group = "kickstart-highlight-yank";
	callback.__raw = ''
	  function()
	    vim.highlight.on_yank()
	  end
	  '';
      }
      {
	event = ["VimEnter"];
	desc = "Set custom Visual highlight";
	command = "highlight Visual guibg=#555555 guifg=NONE";
      }
    ];    
  };
}
