{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.displayManager.sddm.lingSDDM;
  themeName = "default";
  pkg = pkgs.callPackage ./package.nix { };
in
{
  options.services.displayManager.sddm.lingSDDM = {
    enable = mkEnableOption "lingSDDM SDDM theme";
  };

  config = mkIf cfg.enable {
    services.displayManager.sddm = {
      enable = true;
      theme = themeName;
      extraPackages = [
        pkgs.kdePackages.qtmultimedia
        pkgs.kdePackages.qtsvg
        pkgs.kdePackages.qtvirtualkeyboard
        pkgs.kdePackages.qt5compat
        pkgs.kdePackages.qtquick3d
        # Video support
        pkgs.gst_all_1.gstreamer
        pkgs.gst_all_1.gst-plugins-base
        pkgs.gst_all_1.gst-plugins-good
        pkgs.gst_all_1.gst-plugins-bad
        pkgs.gst_all_1.gst-libav
      ];
    };

    environment.systemPackages = [
      pkg
    ];
  };
}
