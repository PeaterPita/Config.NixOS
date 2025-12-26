{
  pkgs,
  ...
}:
{

  config = {
    userSettings = {
      gitName = "PeaterPita";
      gitEmail = "[REDACTED_EMAIL]";
    };

    modules = {
      zsh.enable = true;
      syncthing.enable = true;
      nixvim.enable = true;
      discord.enable = true;
      mpv.enable = true;
      direnv.enable = true;
      firefox.enable = true;
      qute.enable = true;
      thunderbird.enable = true;
      git.enable = true;
      kitty.enable = true;
      obsidian.enable = true;
      office.enable = true;

      quickshell.enable = true;
      malware.enable = true;

    };

    home.packages = with pkgs; [
      asunder
      tree
      btop
    ];
  };

}
