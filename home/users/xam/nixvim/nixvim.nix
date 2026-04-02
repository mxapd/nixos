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
    
    #------------------------------

    plugins = {
      web-devicons.enable = true;
      bufferline.enable = true;
      lualine.enable = true;
      luasnip.enable = true;
      which-key.enable = true;
      neoscroll.enable = true;
      render-markdown.enable = true;
      friendly-snippets.enable = true;
      friendly-snippets.autoLoad= true;
      nvim-surround.enable = true;
      trouble.enable = true;
    };

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


    keymaps = [
      {
        mode = "n";
        key = "<C-f>";
        action = "<cmd>silent !tmux neww tmux-sessionizer<CR>";
        options.silent = true;
      }
      {
        mode = "n";
        key = "<leader>9s";
        action = "<cmd>lua require(\"99\").search()<CR>";
        options.desc = "99 search";
      }
      {
        mode = "v";
        key = "<leader>9v";
        action = "<cmd>lua require(\"99\").visual()<CR>";
        options.desc = "99 visual";
      }
      {
        mode = "n";
        key = "<leader>9g";
        action = "<cmd>lua require(\"99\").vibe()<CR>";
        options.desc = "99 vibe";
      }
      {
        mode = "n";
        key = "<leader>9x";
        action = "<cmd>lua require(\"99\").stop_all_requests()<CR>";
        options.desc = "99 stop requests";
      }
    ];
  };
}
