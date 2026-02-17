{
  keymaps = [
    {
      mode = [
        "v"
        "n"
      ];
      key = "cs";
      action = "<cmd>CodeSnapSave<cr>";
      options.desc = "Save the current selction to file";
    }
    {
      mode = [
        "v"
        "n"
      ];
      key = "cc";
      action = "<cmd>CodeSnap<cr>";
      options.desc = "Save the current selction to clipboard";
    }
  ];
  plugins.codesnap = {
    enable = true;
    settings = {
      save_path = "~/Pictures";
      has_breadcrumbs = true;
      watermark = "";
      bg_padding = 0;

    };
  };

}
