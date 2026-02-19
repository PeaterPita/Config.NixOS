{
  pkgs,
  ...
}:

{

  home.packages = with pkgs.unstable; [
    element-desktop
  ];

  modules = {
    spotify.enable = true;
    kdeConnect.enable = true;
    scrcpy.enable = true;
    quickshell.enable = true;

    gaming = {
      enable = true;
      prism.enable = true;
    };
  };
}
