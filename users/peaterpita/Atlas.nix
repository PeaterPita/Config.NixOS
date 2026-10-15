{
  pkgs,
  inputs,
  ...
}:
{

  home.packages = with pkgs; [
    parsec-bin
    typescript
    jetbrains.idea
    obsidian
    inkscape
    inputs.aperture.packages.${pkgs.stdenv.hostPlatform.system}.default

  ];

  modules = {
    mango.enable = true;

    zsh.enable = true;
    nixvim.enable = true;
    foot.enable = true;
    feishin.enable = true;
    direnv.enable = true;
    syncthing.enable = true;
    discord.enable = true;
    zathura.enable = true;
    mpv.enable = true;
    firefox.enable = true;
    zen.enable = true;
    office.enable = true;
    scrcpy.enable = true;
    dolphin.enable = true;

    gaming = {
      enable = true;
      prism.enable = true;
      vintagestory.enable = true;
    };

    # misc = {
    #   videoediting.enable = true;
    # art.enable = true;
    #   research.enable = true;
    # };
  };
}
