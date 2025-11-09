{
  programs.nixvim = {
    plugins.none-ls = {
      enable = true;
      sources.diagnostics.checkstyle.enable = true;
      sources.diagnostics.checkstyle.settings = {
	filetypes = [
	  "java"
	];
	extra_args = [
	  "-c"
	  "/google_checks.xml"
	];
      };
    };

    #    plugins.jdtls = {
    #      enable = true;
    #      settings = {
    #        cmd = [
    #        (lib.getExe pkgs.jdt-language-server)
    #          "-data" "/home/xam/.cache/jdtls/workspace/data"
    #        ];
    #      };
    #    };


    plugins.lsp = {
      enable = true;
      servers = {
	ccls.enable = true;
	rust-analyzer.enable = true;
	jdtls.enable = true;
	lua_ls.enable = true;

	pylsp = {
	  enable = true;
	  settings.plugins = {
	    flake8.enabled = true;
	    flake8.ignore = ["E501"];
	    pycodestyle.enabled = false;
	  };
	};
      };
      # Diagnostic keymaps
      keymaps = {
	diagnostic = {
	  "<leader>q" = {
	    #mode = "n";
	    action = "setloclist";
	    desc = "Open diagnostic [Q]uickfix list";
	  };
	};

	extra = [
	  # Jump to the definition of the word under your cusor.
	  #  This is where a variable was first declared, or where a function is defined, etc.
	  #  To jump back, press <C-t>.
	  {
	    mode = "n";
	    key = "gd";
	    action.__raw = "require('telescope.builtin').lsp_definitions";
	    options = {
	      desc = "LSP: [G]oto [D]efinition";
	    };
	  }
	  # Find references for the word under your cursor.
	  {
	    mode = "n";
	    key = "gr";
	    action.__raw = "require('telescope.builtin').lsp_references";
	    options = {
	      desc = "LSP: [G]oto [R]eferences";
	    };
	  }
	  # Jump to the implementation of the word under your cursor.
	  #  Useful when your language has ways of declaring types without an actual implementation.
	  {
	    mode = "n";
	    key = "gI";
	    action.__raw = "require('telescope.builtin').lsp_implementations";
	    options = {
	      desc = "LSP: [G]oto [I]mplementation";
	    };
	  }
	  # Jump to the type of the word under your cursor.
	  #  Useful when you're not sure what type a variable is and you want to see
	  #  the definition of its *type*, not where it was *defined*.
	  {
	    mode = "n";
	    key = "<leader>D";
	    action.__raw = "require('telescope.builtin').lsp_type_definitions";
	    options = {
	      desc = "LSP: Type [D]efinition";
	    };
	  }
	  # Fuzzy find all the symbols in your current document.
	  #  Symbols are things like variables, functions, types, etc.
	  {
	    mode = "n";
	    key = "<leader>ds";
	    action.__raw = "require('telescope.builtin').lsp_document_symbols";
	    options = {
	      desc = "LSP: [D]ocument [S]ymbols";
	    };
	  }
	  # Fuzzy find all the symbols in your current workspace.
	  #  Similar to document symbols, except searches over your entire project.
	  {
	    mode = "n";
	    key = "<leader>ws";
	    action.__raw = "require('telescope.builtin').lsp_dynamic_workspace_symbols";
	    options = {
	      desc = "LSP: [W]orkspace [S]ymbols";
	    };
	  }
	];
      };
    };
  };
}
