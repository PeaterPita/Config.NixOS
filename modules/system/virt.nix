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
    networking.firewall.trustedInterfaces = [ "virbr0" ];

    environment.systemPackages = with pkgs; [
      virt-viewer
      win-virtio
      win-spice
      adwaita-icon-theme
    ];

    virtualisation.libvirtd = {
      enable = true;
      allowedBridges = [ "virbr0" ];

      qemu.swtpm.enable = true;
      qemu.ovmf = {
        enable = true;
        packages = [ pkgs.OVMFFull.fd ];
      };
    };
    programs.virt-manager.enable = true;
  };
}
