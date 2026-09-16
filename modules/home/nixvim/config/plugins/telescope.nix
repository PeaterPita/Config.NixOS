{
  plugins.web-devicons.enable = true;

  plugins.telescope = {
    enable = true;

    settings.pickers.git_commits.git_command = [
      "git"
      "log"
      "--pretty=oneline"
      "--format=%h %ar  %s"
      "--abbrev-commit"
    ];

    keymaps = {
      "<leader>ht" = {
        action = "help_tags";
        options.desc = "[H]elp [T]ags";
      };

      "<leader>hk" = {
        action = "keymaps";
        options.desc = "[H]elp [K]eymappings";
      };

      "<leader>pf" = {
        action = "find_files";
        options.desc = "Find [P]roject [F]iles";
      };
      "<leader>pa" = {
        action = "find_files no_ignore=true hidden=true";
        options.desc = "[P]roject [A]ll Search";
      };
      "<leader>ps" = {
        action = "live_grep";
        options.desc = "[P]roject [S]earch";
      };
      "<leader>pb" = {
        action = "buffers";
        options.desc = "[P]roject [B]uffers";
      };

      "<leader>gc" = {
        action = "git_commits";
        options.desc = "[G]it [C]ommits";
      };
      "<leader>gb" = {
        action = "git_branches";
        options.desc = "[G]it [B]rances";
      };

      "<leader>gd" = {
        action = "lsp_definitions";
        options.desc = "[G]oto [D]efinitions";
      };

      "<leader>gi" = {
        action = "lsp_implementations";
        options.desc = "[G]oto [I]mplementations";
      };

      "<leader>gr" = {
        action = "lsp_references";
        options.desc = "[G]oto [R]eferences";
      };

      "<leader>ws" = {
        action = "lsp_dynamic_workspace_symbols";
        options.desc = "[W]orkspace [S]ymbols";
      };
    };

  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>gt";
      options.desc = "[G]radle [T]asks";
      action.__raw = ''
        function()
          local pickers = require("telescope.pickers")
          local finders = require("telescope.finders")
          local actions = require("telescope.actions")
          local action_state = require("telescope.actions.state")
          local entry_display = require("telescope.pickers.entry_display")
          local conf = require("telescope.config").values

          local gradle = vim.fn.executable("gradle") == 1 and "gradle"
            or vim.fn.filereadable("./gradlew") == 1 and "./gradlew"
            or nil
          if not gradle then
            vim.notify("No gradle or ./gradlew found", vim.log.levels.ERROR)
            return
          end

          local output = vim.fn.system(gradle .. " tasks --all --quiet")

          local tasks = {}
          for line in output:gmatch("[^\n]+") do
            local name, desc = line:match("^(%S+) %- (.+)")
            if name then
              table.insert(tasks, { name = name, desc = desc })
            end
          end

          local displayer = entry_display.create({
            separator = " - ",
            items = {
              { width = 30 },
              { remaining = true },
            },
          })

          pickers.new({}, {
            prompt_title = "Gradle Tasks",
            finder = finders.new_table({
              results = tasks,
              entry_maker = function(entry)
                return {
                  value = entry,
                  display = function(e)
                    return displayer({
                      { e.value.name, "TelescopeResultsIdentifier" },
                      { e.value.desc, "TelescopeResultsComment" },
                    })
                  end,
                  ordinal = entry.name .. " " .. entry.desc,
                }
              end,
            }),
            sorter = conf.generic_sorter({}),
            attach_mappings = function(buf, map)
              actions.select_default:replace(function()
                actions.close(buf)
                local entry = action_state.get_selected_entry()
                vim.cmd("terminal " .. gradle .. " " .. entry.value.name)
                vim.cmd("startinsert")
              end)
              return true
            end,
          }):find()
        end
      '';
    }
  ];

}
