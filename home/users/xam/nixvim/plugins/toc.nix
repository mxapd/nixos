{ programs.nixvim = {
  extraConfigLua = ''
    -- ========================================
    -- Markdown Table of Contents Generator
    -- :toc create  — insert TOC after frontmatter
    -- :toc update  — refresh existing TOC in place
    -- ========================================

    local M = {}

    -- Generate a GitHub-style anchor slug from heading text
    -- Rules: lowercase → strip most punctuation → spaces to hyphens → collapse hyphens
    local function github_slug(text)
      -- Strip inline code backticks: `code` → code
      text = text:gsub("`([^`]+)`", "%1")
      -- Strip link syntax: [text](url) → text
      text = text:gsub("%[(.-)%]%([^)]+%)", "%1")
      -- Strip trailing # (ATX-style closing: ## Heading ##)
      text = text:gsub("%s*#+%s*$", "")
      -- Lowercase
      local slug = text:lower()
      -- Remove anything not alphanumeric, space, hyphen, or underscore
      slug = slug:gsub("[^%w%s%-]", "")
      -- Spaces to hyphens
      slug = slug:gsub("%s+", "-")
      -- Collapse consecutive hyphens
      slug = slug:gsub("-+", "-")
      -- Trim leading/trailing hyphens
      slug = slug:gsub("^%-", "")
      slug = slug:gsub("%-$", "")
      return slug
    end

    -- Find YAML frontmatter end (0-indexed). Returns -1 if none found.
    local function find_frontmatter_end(lines)
      if #lines == 0 or lines[1] ~= "---" then
        return -1
      end
      for i = 2, #lines do
        if lines[i] == "---" then
          return i - 1
        end
      end
      return -1
    end

    -- Parse markdown headings, skipping fenced code blocks.
    -- Returns list of { level, text, slug }.
    -- Deduplicates slugs GitHub-style (appends -1, -2, etc.)
    local function parse_headings(lines)
      local headings = {}
      local slug_counts = {}
      local in_code = false

      for _, line in ipairs(lines) do
        if line:match("^```") then
          in_code = not in_code
        elseif not in_code then
          local hashes, text = line:match("^(#+)%s+(.+)")
          if hashes and #hashes <= 6 then
            local level = #hashes
            local slug = github_slug(text)
            -- Deduplicate slugs: first gets no suffix, second gets -1, etc.
            slug_counts[slug] = (slug_counts[slug] or 0) + 1
            if slug_counts[slug] > 1 then
              slug = slug .. "-" .. (slug_counts[slug] - 1)
            end
            table.insert(headings, {
              level = level,
              text = text,
              slug = slug,
            })
          end
        end
      end

      return headings
    end

    -- Build TOC lines from parsed headings (indented bullet list)
    local function generate_toc(headings)
      local lines = {}
      for _, h in ipairs(headings) do
        local indent = string.rep("  ", h.level - 1)
        table.insert(lines, indent .. "- [" .. h.text .. "](#" .. h.slug .. ")")
      end
      return lines
    end

    -- Find existing TOC markers. Returns start, end (0-indexed, inclusive).
    -- Returns nil, nil if not found.
    local function find_toc_range(lines)
      local start_line = nil
      for i, line in ipairs(lines) do
        if line:match("^%s*<!%-%-%s*toc%s*%-%-%>") then
          start_line = i - 1
        elseif line:match("^%s*<!%-%-%s*/toc%s*%-%-%>") then
          if start_line then
            return start_line, i - 1
          end
        end
      end
      return nil, nil
    end

    -- :toc create — insert new TOC after YAML frontmatter (or at top)
    function M.create()
      local buf = vim.api.nvim_get_current_buf()
      local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

      -- Refuse if TOC already exists
      local existing_start, _ = find_toc_range(lines)
      if existing_start then
        vim.notify("TOC already exists. Use :Toc update to refresh it.", vim.log.levels.ERROR)
        return
      end

      -- Parse headings and generate TOC
      local headings = parse_headings(lines)
      local toc_lines = generate_toc(headings)

      -- Build the full TOC block
      local block = { "<!-- toc -->" }
      for _, line in ipairs(toc_lines) do
        table.insert(block, line)
      end
      table.insert(block, "<!-- /toc -->")

      -- Determine insert position
      local insert_pos = 0
      local fm_end = find_frontmatter_end(lines)
      if fm_end >= 0 then
        insert_pos = fm_end + 1
        table.insert(block, 1, "")  -- blank line between frontmatter and TOC
      end
      table.insert(block, "")  -- blank line after TOC

      vim.api.nvim_buf_set_lines(buf, insert_pos, insert_pos, false, block)
      vim.notify("TOC created (" .. #headings .. " headings).", vim.log.levels.INFO)
    end

    -- :toc update — replace existing TOC with fresh one
    function M.update()
      local buf = vim.api.nvim_get_current_buf()
      local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

      -- Find existing TOC
      local toc_start, toc_end = find_toc_range(lines)
      if not toc_start then
        vim.notify("No TOC found. Use :Toc create to add one.", vim.log.levels.ERROR)
        return
      end

      -- Parse headings from current buffer
      local headings = parse_headings(lines)
      local toc_lines = generate_toc(headings)

      -- Build new TOC content
      local new_toc = { "<!-- toc -->" }
      for _, line in ipairs(toc_lines) do
        table.insert(new_toc, line)
      end
      table.insert(new_toc, "<!-- /toc -->")

      -- Replace old TOC range (end is exclusive in nvim_buf_set_lines)
      vim.api.nvim_buf_set_lines(buf, toc_start, toc_end + 1, false, new_toc)
      vim.notify("TOC updated (" .. #headings .. " headings).", vim.log.levels.INFO)
    end

    -- Register :toc user command with subcommand completion
    vim.api.nvim_create_user_command("Toc", function(opts)
      local subcmd = opts.args:match("^%s*(.-)%s*$")
      if subcmd == "create" then
        M.create()
      elseif subcmd == "update" then
        M.update()
      else
        vim.notify("Usage: :Toc create | :Toc update", vim.log.levels.WARN)
      end
    end, {
      nargs = 1,
      desc = "Markdown TOC: Toc create | Toc update",
      complete = function(arg_lead, _, _)
        local cmds = { "create", "update" }
        if arg_lead == "" then return cmds end
        return vim.tbl_filter(function(c)
          return c:find(arg_lead) == 1
        end, cmds)
      end,
    })
  '';
}; }
