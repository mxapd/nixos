{
  programs.nixvim = {
    plugins.obsidian = {
      enable = true;
      settings = {
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
	
	notes_subdir = "Inbox";

        note_id_func.__raw = ''
          function(title)
            return os.date("%Y%m%dT%H%M%S")
          end
        '';

	frontmatter_func.__raw = ''
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
       # --- Note creation and daily notes ---
       {
         mode = "n";
         key = "<leader>on";
         action = "<cmd>ObsidianNew<CR>";
         options.desc = "Create new Obsidian note";
       }
       {
         mode = "n";
         key = "<leader>ot";
         action = "<cmd>ObsidianToday<CR>";
         options.desc = "Open today's note";
       }
       {
         mode = "n";
         key = "<leader>oy";
         action = "<cmd>ObsidianYesterday<CR>";
         options.desc = "Open yesterday's note";
       }
       {
         mode = "n";
         key = "<leader>oa";
         action = "<cmd>ObsidianTodayInsertLink<CR>";
         options.desc = "Insert link to today's note";
       }
    
       # --- Searching and navigation ---
       {
         mode = "n";
         key = "<leader>os";
         action = "<cmd>ObsidianSearch<CR>";
         options.desc = "Global search across notes";
       }
       {
         mode = "n";
         key = "<leader>of";
         action = "<cmd>ObsidianQuickSwitch<CR>";
         options.desc = "Fuzzy switch to note by title";
       }
       {
         mode = "n";
         key = "<leader>ob";
         action = "<cmd>ObsidianBacklinks<CR>";
         options.desc = "Show backlinks for current note";
       }
    
       # --- Linking and relationships ---
       {
         mode = "n";
         key = "<leader>oi";
         action = "<cmd>ObsidianLink<CR>";
         options.desc = "Insert link to existing note";
       }
       {
         mode = "n";
         key = "<leader>ol";
         action = "<cmd>ObsidianLinkNew<CR>";
         options.desc = "Create and link a new note";
       }
    
       # --- Integration with Obsidian app ---
       {
         mode = "n";
         key = "<leader>om";
         action = "<cmd>ObsidianOpen<CR>";
         options.desc = "Open current note in Obsidian GUI";
       }
       {
         mode = "n";
         key = "<leader>og";
         action = "<cmd>ObsidianGraph<CR>";
         options.desc = "Show Obsidian graph view";
       }
     ];
  };
}

