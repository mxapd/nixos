{
  programs.nixvim = {
    plugins.alpha = {
      enable = true;
      layout = [
	{
	  type = "padding";
	  val = 2;
	}
	{
	  opts = {
	    hl = "Type";
	    position = "center";
	  };
	  type = "text";
	  val = [
	    "███╗   ██╗██╗██╗  ██╗██╗   ██╗██╗███╗   ███╗"
	    "████╗  ██║██║╚██╗██╔╝██║   ██║██║████╗ ████║"
	    "██╔██╗ ██║██║ ╚███╔╝ ██║   ██║██║██╔████╔██║"
	    "██║╚██╗██║██║ ██╔██╗ ╚██╗ ██╔╝██║██║╚██╔╝██║"
	    "██║ ╚████║██║██╔╝ ██╗ ╚████╔╝ ██║██║ ╚═╝ ██║"
	    "╚═╝  ╚═══╝╚═╝╚═╝  ╚═╝  ╚═══╝  ╚═╝╚═╝     ╚═╝"
	  ];
	}
	{
	  type = "padding";
	  val = 2;
	}
	{
	  type = "padding";
	  val = 2;
	}
	{
	  opts = {
	    hl = "Keyword";
	    position = "center";
	  };
	  type = "text";
	  val = "You suck.";
	}
      ];
    };
  };
}
