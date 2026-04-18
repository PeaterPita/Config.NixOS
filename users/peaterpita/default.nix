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
      git.enable = true;

    };

    home.packages = with pkgs; [
      tree
      btop
    ];
  };

}
