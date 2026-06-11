{ ... }:

{
  programs.nixvim = {
    extraConfigLua = ''
      local function parse_headings(lines)
        local headings = {}
        local slug_counts = {}

        local in_fence = false
        local fence_char = nil
        local fence_len = 0

        for _, line in ipairs(lines) do
          local indent, fence = line:match("^(%s*)([`~][`~][`~]+)")
          if indent and #indent <= 3 then
            local ch = fence:sub(1, 1)

            if not in_fence then
              if fence:match("^" .. vim.pesc(ch) .. "+$") and #fence >= 3 then
                in_fence = true
                fence_char = ch
                fence_len = #fence
                goto continue
              end
            else
              if ch == fence_char
                and fence:match("^" .. vim.pesc(fence_char) .. "+$")
                and #fence >= fence_len then
                in_fence = false
                fence_char = nil
                fence_len = 0
                goto continue
              end
            end
          end

          if not in_fence then
            local indent2, hashes, text = line:match("^(%s*)(#+)%s+(.+)")
            if indent2 and #indent2 <= 3 and hashes and #hashes <= 6 then
              local level = #hashes
              local slug = github_slug(text)

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

          ::continue::
        end

        return headings
      end
    '';
  };
}
