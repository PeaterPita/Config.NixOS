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
      zathura.enable = true;
      mpv.enable = true;
      direnv.enable = true;
      firefox.enable = true;
      git.enable = true;
      kitty.enable = true;
      obsidian.enable = true;
      office.enable = true;
      zellij.enable = true;

    };

    home.packages = with pkgs; [
      tree
      btop
      feishin
    ];
  };

}
