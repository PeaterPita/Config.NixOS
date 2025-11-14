{
  globals.mapleader = " ";

  keymaps = [
    #################
    # File Commands #
    #################
    {
      ## chmod Execute to current file
      mode = [ "n" ];
      key = "<leader>x";
      action = "<cmd>!chmod +x %<CR>";
      options.silent = true;
    }
    {
      # Swap currently selected with
      mode = [ "n" ];
      key = "<leader>s";
      action = ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left>";
    }
    #####################
    # Movement Commands #
    #####################
    {
      # Move block down
      mode = [ "v" ];
      key = "J";
      action = ":m '>+1<CR>gv=gv";
    }

    {
      # Move block up
      mode = [ "v" ];
      key = "K";
      action = ":m <-2<CR>gv=gv";
    }

    {
      # Indent block left
      mode = [ "v" ];
      key = "<";
      action = "<gv";
    }

    {
      # Indent block right
      mode = [ "v" ];
      key = ">";
      action = ">gv";
    }

    ###################
    # System Commands #
    ###################
    {
      ## Yank to system ##
      mode = [
        "n"
        "v"
      ];
      key = "<leader>y";
      action = "\"+y";
    }

    {
      ## Paste to system ##
      mode = [
        "n"
        "v"
      ];
      key = "<leader>p";
      action = "\"+p";
    }

    {
      ## Exit keybind ##
      mode =  "n" ;
      key = "<leader>pv";
      action = ":Ex<CR>";
      options = {
            noremap = true;
            silent = true;

            };
    }

  ];

}
