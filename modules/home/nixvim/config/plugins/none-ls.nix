{

  plugins.none-ls = {
    enable = true;
    sources = {
      diagnostics.statix.enable = true;
      code_actions.statix.enable = true;
      diagnostics.deadnix.enable = true;
    };
  };
}
