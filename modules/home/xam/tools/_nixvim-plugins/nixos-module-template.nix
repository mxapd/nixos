{ ... }:
{
  programs.nixvim.extraConfigLua = ''
    vim.api.nvim_create_autocmd({ "BufNewFile", "BufReadPost" }, {
      pattern = { "*/nixos/modules/*.nix", "*/nixos/modules/**/*.nix" },
      callback = function(args)
	local line_count = vim.api.nvim_buf_line_count(args.buf)
	local first_line = vim.api.nvim_buf_get_lines(args.buf, 0, 1, false)[1] or ""
	if line_count > 1 or first_line ~= "" then
	  return
	end

	local name = vim.fn.fnamemodify(args.file, ":t:r")
	local lines = {
	  "{ ... }:",
	  "{",
	  "  flake.nixosModules." .. name .. " = { ... }: {",
	  "",
	  "  };",
	  "}",
	}
	vim.api.nvim_buf_set_lines(args.buf, 0, -1, false, lines)
	vim.api.nvim_win_set_cursor(0, { 4, 4 })
      end,
    })
  '';
}
