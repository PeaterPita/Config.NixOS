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
      dolphin.enable = true;
      direnv.enable = true;
      firefox.enable = true;
      git.enable = true;
      kitty.enable = true;
      fuzzel.enable = true;
      obsidian.enable = true;
      office.enable = true;

    };

    home.packages = with pkgs; [
      fastfetch
      tree
      btop
    ];
  };

}
