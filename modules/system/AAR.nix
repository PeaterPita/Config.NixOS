{
  config,
  lib,
  pkgs,
  ...
}:
let
  Bold = "\\033[1m";
  Reset = "\\033[0m";

  userColors = [
    "\\033[1;35m" # Magenta
    "\\033[1;32m" # Green
    "\\033[1;33m" # Yellow
    "\\033[1;34m" # Blue
  ];

  sysPkgs = map lib.getName config.environment.systemPackages;
  sysPkgsCount = builtins.length sysPkgs;
  sysPkgsStr = builtins.concatStringsSep ", " sysPkgs;

  hmUsers = builtins.attrNames config.home-manager.users;

  userRows = lib.concatStringsSep "\n" (
    lib.imap0 (
      i: user:
      let
        # color = builtins.elemAt userColors (builtins.mod i (builtins.length userColors));
        color = builtins.elemAt userColors i;

        userConfig = config.home-manager.users.${user};
        userPkgs = map lib.getName userConfig.home.packages;
        userPkgsCount = builtins.length userPkgs;
        userPkgsStr = builtins.concatStringsSep ", " userPkgs;

      in
      " ${color}[${user}]${Reset} | ${color}${userPkgsStr}${Reset} | ${color}${toString userPkgsCount}${Reset}"

    ) hmUsers
  );

in

{
  environment.systemPackages = [ pkgs.util-linux ];
  system.activationScripts.afterActionReport = {

    text = ''
       echo ""
       echo -e "${Bold}============================================== ${Reset}"
       echo -e "${Bold}              Nixos Rebuild Successful ${Reset}"
       echo -e "${Bold}============================================== ${Reset}"
       echo -e " Build Time: $(date)"
       echo -e " System Version: ${config.system.nixos.label}"
       echo -e "${Bold}============================================== ${Reset}"
       echo -e ""


      TMP_TABLE=$(mktemp)

      echo -e "${Bold}SCOPE|ENABLED Packages | Count${Reset}" >> $TMP_TABLE
      echo -e "-------------------|----------------|------" >> $TMP_TABLE

      echo -e " [SYSTEM] | ${sysPkgsStr}${Reset} | ${toString sysPkgsCount}${Reset} " >> $TMP_TABLE

      echo -e "${userRows}" >> $TMP_TABLE

      column -t -s '|' $TMP_TABLE

      rm $TMP_TABLE
    '';
  };
}
