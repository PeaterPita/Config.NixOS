{
  plugins.comment-box = {
    enable = true;

    settings = {
      outer_blank_lines_above = true;
      borders = {
        top = "#";
        bottom = "#";
        left = "#";
        right = "#";
        top_left = "#";
        top_right = "#";
        bottom_left = "#";
        bottom_right = "#";

      };

    };
  };

  keymaps = [

    {
      mode = [
        "v"
        "n"
      ];
      key = "<leader>cb";
      action = "<cmd>CBlcbox<cr>";
      options.silent = true;

    }
  ];

}
