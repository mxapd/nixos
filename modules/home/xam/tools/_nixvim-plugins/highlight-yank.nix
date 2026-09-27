{ ... }:
{
  programs.nixvim = {
    autoGroups = {
      highlight-yank = {
	clear = true;
      };
    };

    # Highlight when yanking (copying) text
    #  Try it with `yap` in normal mode
    #  See `:help vim.highlight.on_yank()`
    autoCmd = [
      {
	event = [ "TextYankPost" ];
	desc = "Highlight when yanking (copying) text";
	group = "highlight-yank";
	callback.__raw = ''
	  function()
	    vim.highlight.on_yank()
	  end
	  '';
      }

    ];
  };
}
