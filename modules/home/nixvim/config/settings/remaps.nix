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

    # move by line VISUALLY rather than logically
    {
      mode = [
        "n"
        "v"
      ];
      key = "<Up>";
      action = "gk";
      options.silent = true;
    }

    {
      mode = [
        "n"
        "v"
      ];
      key = "<Down>";
      action = "gj";
      options.silent = true;
    }

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
      action = ":m '<-2<CR>gv=gv";
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

    # Open all folds in file
    {
      mode = [ "n" ];
      key = "<leader>zo";
      action = "zR";
    }

    # Close all folds in file
    {
      mode = [ "n" ];
      key = "<leader>zc";
      action = "zM";
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
      ## Paste from system ##
      mode = [
        "n"
        "v"
      ];
      key = "<leader>p";
      action = "\"+p";
    }

  ];

}
