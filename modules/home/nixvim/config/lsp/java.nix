{ ... }:
{

  autoCmd = [
    {
      event = [ "FileType" ];
      pattern = "java";
      callback.__raw = ''
        function()
            vim.keymap.set('n', '<leader>ji', function()
                require('jdtls').organize_imports()
            end, { buffer = true })

            vim.keymap.set('n', '<leader>jv', function()
                require('jdtls').extract_variable()
            end, {buffer = true})
        end
      '';
    }
  ];

  plugins.jdtls = {
    enable = true;
    settings = {
      cmd = [ "jdtls" ];
      root_dir.__raw = ''
        vim.fs.dirname(vim.fs.find({'gradle.properties', 'gradlew', '.git', 'mvnw', 'pom.xml'}, {upward = true})[1])
      '';

      handlers.__raw = ''
        {
          ["window/logMessage"] = function(err, result, ctx, config)
            if result and result.type <= 1 then
              vim.lsp.handlers["window/logMessage"](err, result, ctx, config)
            end
          end,
        }
      '';

      ############################################################################################################################
      #                         Not sure if this is actually doing anything. But something to look into                          #
      # https://github.com/eclipse-jdtls/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request #
      ############################################################################################################################
      settings.java = {
        signatureHelp.enabled = true;
        cleanup = {
          actionsOnSave = [
            "invertEquals"
          ];
        };

        compiler.problemSeverity = {
          "unusedLocal" = "warning";
          "unusedParam" = "info";
          "unusedPrivateMember" = "warning";
          "redundantSuperinterface" = "warning";
          "possibleAccidentalBooleanAssignment" = "warning";
          "unnecessaryElse" = "warning";
          "unnecessaryTypeCheck" = "warning";
          "compareWithNull" = "warning";
          "redundantNullCheck" = "warning";
          "missingOverrideAnnotation" = "warning";
          "missingDeprecatedAnnotation" = "warning";
        };
      };
    };
  };

}
