{ pkgs, ... }:

{
  extraPlugins = [ pkgs.vimPlugins.base16-nvim ];

  extraConfigLua = ''
    local function transparent()
      for _, group in ipairs({
        "Normal", "NormalNC", "NormalFloat", "FloatBorder",
        "SignColumn", "LineNr", "FoldColumn", "EndOfBuffer", "MsgArea",
        "TelescopeNormal", "TelescopeBorder",
        "TelescopePromptNormal", "TelescopePromptBorder",
      }) do
        vim.api.nvim_set_hl(0, group, { bg = "none" })
      end
    end

    local function loop_override_colors() 
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

    local function apply()
        package.loaded["matugen"] = nil
        local ok, matugen = pcall(require, "matugen")
        if ok and matugen and matugen.setup then
            matugen.setup()
        end
        transparent()
        loop_override_colors()
    end

    apply()

    local lua_dir = vim.fn.stdpath("config") .. "/lua"
    local watcher = vim.uv.new_fs_event()
    if watcher then
      watcher:start(lua_dir, {}, vim.schedule_wrap(function(err, filename)
        if err or filename ~= "matugen.lua" then
          return
        end
        apply()
      end))
    end
  '';
}
