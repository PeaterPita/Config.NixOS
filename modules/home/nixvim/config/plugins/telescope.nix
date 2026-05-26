{ pkgs, ... }:
{
  plugins.web-devicons.enable = true;

  plugins.telescope = {
    enable = true;

    keymaps = {
      "<leader>pf" = {
        action = "find_files";
        options = {
          desc = "Find project files";
        };
      };
      "<leader>pa" = {
        action = "find_files no_ignore=true hidden=true";
        options = {
          desc = "All Search";
        };
      };
      "<leader>ps" = {
        action = "live_grep";
        options = {
          desc = "Project Search";
        };
      };
      "<leader>pb" = {
        action = "buffers";
        options.desc = "Project Buffers";
      };
      "<leader>gc".action = "git_commits";
      "<leader>gb".action = "git_branches";

    };

  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>gt";
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
      options.desc = "Gradle Tasks";
    }
  ];

}
