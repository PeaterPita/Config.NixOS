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
    home.sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };

    modules = {
      zsh.enable = true;
      nixvim.enable = true;
      kitty.enable = true;
      zellij.enable = true;
      direnv.enable = true;
      git.enable = true;

    };

    home.packages = with pkgs; [
      tree
      btop
    ];
  };

}
