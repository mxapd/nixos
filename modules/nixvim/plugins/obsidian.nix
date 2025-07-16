{
  programs.nixvim = {
    plugins.obsidian = {
      enable = true;
      settings = {
	disable_frontmatter = true;
	completion = {
	  min_chars = 2;
	  nvim_cmp = true;
	};
	
	new_notes_location = "notes_subdir";
	notes_subdir = "Inbox";
	daily_notes.folder = "dailies";

	workspaces = [
	  {
	    name = "personal";
	    path = "~/Documents/syncvault/";
	  }
	];
      };
    };
  };
}

