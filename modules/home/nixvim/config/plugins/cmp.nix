{

  plugins.cmp = {
    enable = true;
    autoEnableSources = true;
    settings = {
            sources = [
                { name = "nvim_lsp"; }
                { name = "path"; }
                { name = "buffer"; }
                { name = "cmdline"; }
                { name = "luasnip"; }
                { name = "vimtex"; }
            ];

    mapping = {
        "<C-p>" = "cmp.mapping.select_prev_item()";
        "<C-n>" = "cmp.mapping.select_next_item()";
        "<C-Space>" = "cmp.mapping.complete()";
        "<C-e>" = "cmp.mapping.abort()";
        "<tab>" = "cmp.mapping.confirm({ select = true })";

        };

        };
  };

}
