{

  plugins.neotest = {
    enable = true;
    adapters = {
      plenary.enable = true;
      python = {
        enable = true;
        settings.runner = "pytest";
      };
      rust.enable = true;
    };
    settings = {
      output = {
        enabled = true;
        open_on_run = false;
      };
      output_panel = {
        enabled = true;
        open = "botright vsplit | vertical resize 80";
      };
      default_statergy = "integrated";
    };
  };

  keymaps = [

    {
      options.desc = "[T]est [A]ll";
      mode = "n";
      key = "<leader>ta";
      action.__raw = ''
        function() 
            local neotest = require("neotest")
            neotest.output_panel.clear()
            neotest.run.run({suite = true})
        end 
      '';
    }
    {
      options.desc = "[T]est [N]earest";
      mode = "n";
      key = "<leader>tn";
      action = "<cmd>lua require('neotest').run.run()<CR>";
    }

    {
      options.desc = "[T]est [F]ile";
      mode = "n";
      key = "<leader>tf";
      action = "<cmd>lua require('neotest').run.run(vim.fn.expand('%')) <CR>";
    }

    {
      options.desc = "[T]est [S]ummary";
      mode = "n";
      key = "<leader>ts";
      action = "<cmd>lua require('neotest').summary.toggle() <CR>";
    }

    {
      mode = "n";
      key = "<leader>tk";
      action = "<cmd>lua require('neotest').output.open() <CR>";
    }

    {
      options.desc = "[T]est [O]output";
      mode = "n";
      key = "<leader>to";
      action = "<cmd>lua require('neotest').output_panel.toggle()<CR>";
    }

  ];
}
