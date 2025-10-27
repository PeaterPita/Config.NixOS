{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.modules.virt;
in
{
  options = {
    modules.virt.enable = lib.mkEnableOption "virt";
  };

  config = lib.mkIf cfg.enable {

    environment.systemPackages = with pkgs; [
      virt-manager
      virt-viewer
      spice
      spice-gtk
      spice-protocol
      win-virtio
      win-spice
      adwaita-icon-theme
    ];

    virtualisation.libvirtd = {
      enable = true;

      qemu.swtpm.enable = true;
      qemu.ovmf = {
        enable = true;
        packages = [ pkgs.OVMFFull.fd ];
      };
    };
    programs.virt-manager.enable = true;
  };
}
