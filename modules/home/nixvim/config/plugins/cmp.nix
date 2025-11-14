{

  plugins.cmp = {
    enable = true;
    autoEnableSources = true;
    settings = {
      sources = [
        { name = "nvim_lsp"; }
        { name = "path"; }
        { name = "buffer"; }
        # { name = "cmdline"; }
        { name = "luasnip"; }
        { name = "vimtex"; }
      ];

      mapping = {
        "<Up>" = "cmp.mapping.select_prev_item()";
        "<Down>" = "cmp.mapping.select_next_item()";
        "<esc>" = "cmp.mapping.abort()";
        "<CR>" = "cmp.mapping.confirm({ select = true })";
        "<S-Tab>" = "cmp.mapping.select_prev_item()";
        "<Tab>" = "cmp.mapping.select_next_item()";

      };

    };
  };

}
