{
  programs.nixvim = {
    plugins.obsidian = {
      enable = true;
      settings = {
	legacy_commands = false;
	
	frontmatter = {
	  enabled = true;
	};

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
	
	# Where I create new notes (Mimir extracted notes)
	notes_subdir = "Inbox/Mimir";
	
	# Daily notes configuration
	daily_notes = {
	  folder = "Daily";
	  date_format = "%Y-%m-%d";
	  alias_format = "%B %-d, %Y";
	  default_tags = [ "daily-note" ];
	  template = null;
	};

        note_id_func.__raw = ''
          function(title)
            return title
          end
        '';

	frontmatter.func.__raw = ''
	  function(note)
	    if note.title then
	      note:add_alias(note.title)
	    end
	    
	    local out = {
	      id = note.id,
	      title = note.title or note.id,
	      tags = note.tags or {},
	      date = os.date("%Y-%m-%d %H:%M"),
	      aliases = note.aliases
	    }
	
	    if note.metadata and not vim.tbl_isempty(note.metadata) then
	      for k, v in pairs(note.metadata) do
	        out[k] = v
	      end
	    end
	
	    return out
	  end
	'';

	luaConfig.pre = ''
	  -- Only enable "auto-editable scratch note buffer" if running in tmux session named "notes"
	  vim.api.nvim_create_autocmd("VimEnter", {
	    callback = function()
	      local tmux_env = vim.env.TMUX
	      if tmux_env then
	        local handle = io.popen("tmux display-message -p '#S' 2>/dev/null")
	        local sess = handle and handle:read("*a"):gsub("%s+$", "")
	        if handle then handle:close() end
	
	        if sess == "notes" then
	          if vim.fn.expand("%") == "" then
	            if not vim.bo.modifiable or vim.bo.readonly then
	              vim.cmd("enew")
	            end
	            local vault = vim.env.OBSIDIAN_VAULT or "~/Documents/obsidian"
	            vim.cmd("lcd " .. vault)
	            vim.bo.filetype = "markdown"
	          end
	        end
	      end
	    end,
	  })
	'';
      };
    };

    keymaps = [
       {
         mode = "n";
         key = "<leader>on";
         action = "<cmd>Obsidian new<CR>";
         options.desc = "New note";
       }
       {
         mode = "n";
         key = "<leader>ot";
         action = "<cmd>Obsidian today<CR>";
         options.desc = "Open today's note";
       }
       {
         mode = "n";
         key = "<leader>oy";
         action = "<cmd>Obsidian yesterday<CR>";
         options.desc = "Open yesterday's note";
       }
       {
         mode = "n";
         key = "<leader>os";
         action = "<cmd>Obsidian search<CR>";
         options.desc = "Search across notes";
       }
       {
         mode = "n";
         key = "<leader>of";
         action = "<cmd>Obsidian quick_switch<CR>";
         options.desc = "Find note by title";
       }
       {
         mode = "n";
         key = "<leader>ob";
         action = "<cmd>Obsidian backlinks<CR>";
         options.desc = "Show backlinks for current note";
       }
       {
         mode = "n";
         key = "<leader>oi";
         action = "<cmd>e ~/Documents/obsidian/Inbox/<CR>";
         options.desc = "Open Inbox folder";
       }
       {
         mode = "n";
         key = "<leader>om";
         action = "<cmd>e ~/Documents/obsidian/Inbox/Mimir/<CR>";
         options.desc = "Open Mimir folder";
       }
       {
         mode = "n";
         key = "<leader>od";
         action = "<cmd>e ~/Documents/obsidian/Daily/<CR>";
         options.desc = "Open Daily notes folder";
       }
     ];
  };
}

