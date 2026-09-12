{ pkgs, ... }:

{

  extraPlugins = [ pkgs.vimPlugins.base16-nvim ];

  extraConfigLua = ''
    local function source() 
        local matugen_path = vim.fn.stdpath("config") .. "/lua/matugen_test.lua"
        
        local ok, _ = pcall(dofile, matugen_path)

        if not ok then 
            vim.cmd("colorscheme base16-catppuccin-mocha")
            vim.notify("Matugen file was not found", vim.log.levels.WARN)
        end

        local c = require("base16-colorscheme").colors 
           for _, g in ipairs({
            "@punctuation.delimiter", "@punctuation.bracket", "@punctuation.special",
            "@tag.delimiter", "@markup.list",
            "Delimiter", "SpecialChar",
            "TSPunctDelimiter", "TSPunctSpecial", "TSTagDelimiter",
          }) do
            vim.api.nvim_set_hl(0, g, { fg = c.base05 })
          end
          vim.api.nvim_set_hl(0, "@string.special.path", { link = "@string" })

          local heads = {
            "#ff6b6b", "#ff9e64", "#ffd866", "#9ece6a", "#7dcfff", "#bb9af7",
          }
          for i, color in ipairs(heads) do
            vim.api.nvim_set_hl(0, "@markup.heading." .. i .. ".markdown", { fg = color, bold = true })
          end
    end

    source()

    vim.api.nvim_create_autocmd("Signal", {
        pattern = "SIGUSR1",
        callback = source,
    })
  '';
}
