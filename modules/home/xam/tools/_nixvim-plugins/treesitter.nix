{
  programs.nixvim = {
    plugins.treesitter = {
      enable = true;

      settings = {
        ensureInstalled = [
          "bash"
          "c"
          "diff"
          "html"
          "lua"
          "luadoc"
          "markdown"
          "markdown_inline"
          "query"
          "vim"
          "vimdoc"
	  "python"
        ];

        highlight = {
          enable = true;
          additional_vim_regex_highlighting = true;
        };

        indent = {
          enable = true;
        };
      };
    };
  };
}
