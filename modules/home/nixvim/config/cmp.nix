{

  plugins.cmp = {
    enable = true;
    autoEnableSources = true;
    settings = {
      sources = [
        { name = "nvim_lsp"; }
        { name = "luasnip"; }
        { name = "path"; }
        { name = "git"; }
        { name = "vimtex"; }
        { name = "buffer"; }
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
