{
  packages = with pkgs; [
    obsidian       
  ];

  programs.nixvim = {
    plugins.obsidian = {
      enable = true;
      settings = {
	disable_frontmatter = true;
	completion = {
	  min_chars = 2;
	  nvim_cmp = true;
	};

	workspaces = [
	  {
	    name = "personal";
	    path = "~/Documents/obsidian/";
	  }
	];
      };
    };
  };
}

