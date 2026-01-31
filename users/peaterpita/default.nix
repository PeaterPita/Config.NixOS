{
  pkgs,
  ...
}:
{

  config = {
    userSettings = {
      gitName = "PeaterPita";
      gitEmail = "90217572+PeaterPita@users.noreply.github.com";
    };

    modules = {
      zsh.enable = true;
      syncthing.enable = true;
      nixvim.enable = true;
      discord.enable = true;
      mpv.enable = true;
      direnv.enable = true;
      firefox.enable = true;
      qute.enable = false;
      # packetTrace.enable = true;
      git.enable = true;
      kitty.enable = true;
      obsidian.enable = true;
      # office.enable = true;
      zellij.enable = true;

      # quickshell.enable = true;
      # malware.enable = true;

    };

    programs.zathura = {
      enable = true;
      options = {
        selection-clipboard = "clipboard";
      };
    };

    home.packages = with pkgs; [
      tree
      btop
    ];
  };

}
