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
    {
      mode = [
        "v"
        "n"
      ];
      key = "ca";
      action = "<cmd>CodeSnapASCII<cr>";
      options.desc = "Generate ASCII codesnap to clipboard";
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
