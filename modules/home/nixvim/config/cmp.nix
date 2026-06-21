{

  plugins.blink-cmp = {
    enable = true;
    settings = {
      keymap.preset = "enter";

      completion = {
        documentation.auto_show = true;
        ghost_text.enabled = true;

        menu = {
          auto_show = true;
          draw.columns = [
            {
              __unkeyed-1 = "label";
              __unkeyed-2 = "label_description";
              gap = 1;
            }

            {
              __unkeyed-1 = "kind_icon";
              __unkeyed-2 = "kind";
            }
          ];
        };
      };
      snippets.preset = "luasnip";
      signature.enabled = true;

      fuzzy = {
        implementation = "rust";
        prebuilt_binaries.download = false;
      };

      sources.default = [
        "lsp"
        "path"
        "snippets"
        "buffer"
      ];
    };
  };
}
