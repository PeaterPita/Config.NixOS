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

      "print_sidebar_row \"${user}\" \"${color}\" \"${toString userPkgsCount}\" \"${userPkgsStr}\""
      # ${color}[${user}]${Reset} | ${color}${userPkgsStr}${Reset} | ${color}${toString userPkgsCount}${Reset}

    ) hmUsers
  );

in

{
  environment.systemPackages = [
    pkgs.coreutils
    pkgs.gawk
  ];
  system.activationScripts.afterActionReport = {

    text = ''
       print_sidebar_row() {
       local title="$1"
       local color="$2"
       local count="$3"
       local items="$4"


       echo "$items" | fold -s -w 65 | ${pkgs.gawk}/bin/awk -v t="$title" -v c="$color" -v r="${Reset}" -v cnt="$count" '
       BEGIN {
        title_fmt = substr(toupper(t), 1, 12)
       }

        NR==1 { printf "%s%-12s%s | %s%s%s\n", c, title_fmt, r, c, $0, r}

        NR>1 { printf "%-12s | %s%s%s\n", "", c, $0, r}

        END {

            if (NR==0) { printf "%s%-12s%s | %s(0 Packages)%s\n", c, title_fmt, r, c, r}
            else { printf "%-12s | %s(%d packages)%s\n", "", c, cnt, r}
            printf "%-12s |\n", ""
        }
        '
       }

      echo ""
      echo -e "${Bold}============================================== ${Reset}"
      echo -e "${Bold}              Nixos Rebuild Successful ${Reset}"
      echo -e "${Bold}============================================== ${Reset}"
      echo -e " Build Time: $(date)"
      echo -e " System Version: ${config.system.nixos.label}"
      echo -e "${Bold}============================================== ${Reset}"
      echo -e ""

      print_sidebar_row "SYSTEM" "${Bold}" "${toString sysPkgsCount}" "${sysPkgsStr}"

      ${userRows}

      echo -e "${Bold}============================================== ${Reset}"
      echo ""

    '';
  };
}

# TMP_TABLE=$(mktemp)
#
# echo -e "${Bold}SCOPE|ENABLED Packages | Count${Reset}" >> $TMP_TABLE
# echo -e "-------------------|----------------|------" >> $TMP_TABLE
#
# echo -e " [SYSTEM] | ${sysPkgsStr}${Reset} | ${toString sysPkgsCount}${Reset} " >> $TMP_TABLE
#
# echo -e "${userRows}" >> $TMP_TABLE
#
# column -t -s '|' $TMP_TABLE
#
# rm $TMP_TABLE
