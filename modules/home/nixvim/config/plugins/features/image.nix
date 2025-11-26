{
  plugins.image = {
    enable = true;
    settings = {
      backend = "kitty";
      integrations = {
        markdown = {
          enable = true;
          download_remote_images = true;
          filetypes = [ "markdown" ];
        };
      };
      window_overlap_Clear_ft_ignore = [
        "cmp_menu"
        "find_files"
      ];
    };
    # lazyLoad = {
    #   enable = true;
    #   settings.ft = [
    #     ".png"
    #     ".jpg"
    #     ".webp"
    #     ".jpeg"
    #   ];
    #
    # };
  };

}
