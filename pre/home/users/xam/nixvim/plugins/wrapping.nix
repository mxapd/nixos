{
  programs.nixvim = {
    plugins.wrapping = {
      enable = true;
      settings = {
	auto_set_mode_heuristacally = true;
	auto_set_mode_filetype_allowlist = [
	  "asciidoc"
	  "gitcommit"
	  "help"
	  "latex"
	  "mail"
	  "markdown"
	  "rst"
	  "tex"
	  "text"
	  "typst"
	];      
      };
    };
  };
}
