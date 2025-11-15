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
    {
      mode = [ "v" ];
      key = "<leader>b";
      options.silent = true;
      action.__raw = ''
        function()
                local s, e = vim.fn.getpos("'<")[2], vim.fn.getpos("'>")[2]
                if s > e then s,e = e,s end
                local lines = vim.api.nvim_buf_get_lines(0, s-1, e, false)
                local max = 0
                for _,l in ipairs(lines) do max = math.max(max, #l) end
                local border = string.rep("#", max + 4)
                for i,l in ipairs(lines) do
                    local pad = max - #l
                    local left = math.floor(pad/2)
                    local right = pad - left
                    lines[i] = "# " .. string.rep(" ", left) .. l .. string.rep(" ", right) .. " #"
                end
                vim.api.nvim_buf_set_lines(0, s-1, e, false, vim.list_extend({border}, vim.list_extend(lines, {border})))
                end
      '';
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
      mode = "n";
      key = "<leader>pv";
      action = ":Ex<CR>";
      options = {
        noremap = true;
        silent = true;

      };
    }

  ];

}
