{

  plugins.lualine = {
    enable = true;
    settings = {
      options = {
        theme = "auto";
        section_separators = "";
        component_separators = "";
      };

      sections = {
        lualine_a = [ "mode" ];
        lualine_b = [
          "branch"
          "diff"
          "diagnostics"
        ];
        lualine_c = [ "filename" ];
        lualine_x = [
          "encoding"
          "filetype"
          "lsp_status"
        ];

        lualine_z = [

          {
            __unkeyed = {
              __raw = ''
                function() 
                    return "Words: " .. vim.fn.wordcount().words
                end
              '';
            };
          }
        ];
      };

    };
  };

}
